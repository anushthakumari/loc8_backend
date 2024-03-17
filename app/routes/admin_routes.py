from flask import Blueprint, jsonify, request, current_app
from app.utils.helpers import token_required, superadmin_required
from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower, generate_bcrypt_hash
from app.constants.roles import roles

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admins', methods=['GET'])
@token_required
def get_all_admins(current_user):
    query = "SELECT id, first_name, last_name, email, created_at, zones.zone_name, users.zone_id FROM users inner join zones on zones.zone_id=users.zone_id WHERE role_id = 2 order by created_at desc"
    admins = query_db(query)

    if not admins:
        return jsonify([])

    return jsonify(admins)

@admin_bp.route('/planners', methods=['GET'])
@token_required
def get_all_planners(current_user):

    user_id = current_user['id']
    user_role_id = current_user['role_id']

    if user_role_id == roles.get("SUPERADMIN"):
        query = """
            SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email AS user_email,
    u.created_at,
    z.zone_name,
    u.zone_id,
    cu.email AS created_by_user_email
FROM 
    users AS u 
INNER JOIN 
    zones AS z 
ON 
    z.zone_id = u.zone_id 
LEFT JOIN 
    users AS cu 
ON 
    cu.id = u.created_by_user_id 
WHERE 
    u.role_id = 1 
ORDER BY 
    u.created_at DESC;

        """
        admins = query_db(query)

        if not admins:
            return jsonify([])

        return jsonify(admins)
    
    else:
        query = """
            SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email AS user_email,
    u.created_at,
    z.zone_name,
    u.zone_id
FROM 
    users AS u 
INNER JOIN 
    zones AS z 
ON 
    z.zone_id = u.zone_id
WHERE 
    u.role_id = 1 
    AND 
    u.created_by_user_id=%s
ORDER BY 
    u.created_at DESC
        """
        admins = query_db(query, (user_id,))

        if not admins:
            return jsonify([])

        return jsonify(admins)


@admin_bp.route('/admins', methods=['POST'])
@token_required
def add_user(current_user):

    current_user_id = current_user['id']
    current_user_role_id = current_user['role_id']

    data = request.get_json()
    user_email = clean_and_lower(data['email'])
    user_emp_id = clean_and_lower(data.get('emp_id'))

    # check if email exists!
    check_email_q = """
        SELECT * FROM users WHERE email=%s
    """
    ext_email_user = query_db(check_email_q, (user_email,), True)

    if ext_email_user != None:
        return jsonify({'message': 'User with this email already exists!'}), 400
    
    # check if emp id exists!
    check_emp_id_q = """
        SELECT * FROM users WHERE employee_id=%s
    """
    ext_emp_id_user = query_db(check_emp_id_q, (user_emp_id,), True)

    if ext_emp_id_user != None:
        return jsonify({'message': 'User with this employee id already exists!'}), 400
    
    if current_user_role_id == roles.get("PLANNER"):
        return jsonify({'message': 'You dont have access!'}), 401

    hashed_pass = generate_bcrypt_hash(data['password'])
    query = "INSERT INTO users (email, password, role_id, first_name, last_name, employee_id, zone_id, created_by_user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    args = (
        user_email, 
        hashed_pass,
        data['role_id'], 
        clean_and_lower(data.get('first_name')), 
        clean_and_lower(data.get('last_name')), 
        user_emp_id, 
        data['zone_id'],
        current_user_id
    )
    query_db(query, args, False, True)

    return jsonify({'message': 'Admin added successfully'}), 201

@admin_bp.route('/admins/<int:user_id>', methods=['DELETE'])
@token_required
def delete_user(current_user,user_id):

    current_user_id = current_user['id']
    user_role_id = current_user['role_id']

    if user_role_id == roles.get("SUPERADMIN"):
        query = "DELETE FROM users WHERE id = %s"
        args=(user_id,)
        query_db(query, args, False, True)

        return jsonify({'message': 'user deleted successfully'}), 200
    
    if user_role_id == roles.get("ADMIN"):
        # check if email exists!
        user_q = """
            SELECT * FROM users WHERE id=%s
        """
        ext_user = query_db(user_q, (user_id,), True)

        if ext_user == None:
            return jsonify({'message': 'User does not exist!'}), 400

        if ext_user['created_by_user_id'] != current_user_id:
            return jsonify({'message': 'You cannot delete this user!'}), 400
        
        query = "DELETE FROM users WHERE id = %s"
        args=(user_id,)
        query_db(query, args, False, True)

        return jsonify({'message': 'user deleted successfully'}), 200
    
    return jsonify({'message': 'You dont have access!'}), 400



@admin_bp.route('/admins/<int:user_id>', methods=['PUT'])
@token_required
def update_user(current_user, user_id):
    try:
        data = request.get_json()

        user = query_db("SELECT * FROM users WHERE id = %s", (user_id,), one=True)
        if user is None:
            return jsonify({'error': 'User not found'}), 404

        query = """
            UPDATE users 
            SET 
                email = %s, 
                role_id = %s, 
                first_name = %s, 
                last_name = %s, 
                employee_id = %s, 
                zone_id = %s 
            WHERE 
                id = %s
        """
        args = (
            clean_and_lower(data['email']), 
            data['role_id'], 
            clean_and_lower(data.get('first_name')), 
            clean_and_lower(data.get('last_name')), 
            clean_and_lower(data.get('employee_id')), 
            data['zone_id'], 
            user_id
        )
        query_db(query, args, False, True)

        return jsonify({'message': 'User updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
