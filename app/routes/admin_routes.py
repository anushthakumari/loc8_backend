from flask import Blueprint, jsonify, request, current_app
from app.utils.helpers import token_required, superadmin_required
from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower, generate_bcrypt_hash
from app.constants.roles import roles
from app.services.users import update_planner

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admins', methods=['GET'])
@token_required
def get_all_admins(current_user):
    query = "SELECT id, first_name, last_name, email, employee_id, created_at, zones.zone_name, users.zone_id FROM users inner join zones on zones.zone_id=users.zone_id WHERE role_id = 2 order by created_at desc"
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
    u.employee_id,
    u.created_at,
    z.zone_name,
    s.state_name,
    c.city_name,
    u.zone_id,
    u.state_id,
    u.city_id,
    cu.email AS created_by_user_email
FROM 
    users AS u 
    
INNER JOIN 
    zones AS z 
ON 
    z.zone_id = u.zone_id 

INNER JOIN 
    states AS s 
ON 
    s.state_id = u.state_id

INNER JOIN 
    cities AS c
ON 
    c.city_id = u.city_id 

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
    
@admin_bp.route('/controllers', methods=['GET'])
@token_required
def get_all_controllers(current_user):
    query = "SELECT id, first_name, last_name, email, employee_id, created_at, zones.zone_name, users.zone_id FROM users inner join zones on zones.zone_id=users.zone_id WHERE role_id = 3 order by created_at desc"
    admins = query_db(query)

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
    
    if data['zone_id'] == None or data['zone_id'] == '':
            return jsonify({'message': 'zone Id is required!'}), 400

    if data['role_id'] == roles['PLANNER']:
        if data['state_id'] == None or data['state_id'] == '':
            return jsonify({'message': 'State Id is required!'}), 400
        
        if data['city_id'] == None or data['city_id'] == '':
            return jsonify({'message': 'city Id is required!'}), 400

    hashed_pass = generate_bcrypt_hash(data['password'])
    query = "INSERT INTO users (email, password, role_id, first_name, last_name, employee_id, zone_id, created_by_user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
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

    inserted_id = query_db(query, args, True, True)

    if data['role_id'] == roles['PLANNER']:
        planner_user_area_q = """
            INSERT INTO 
                user_areas( user_id, zone_id, state_id, city_id)
                values (%s, %s, %s, %s)
            """
        
        query_db(planner_user_area_q, (inserted_id, data['zone_id'], data['state_id'], data['city_id']), False, True)

    return jsonify({'message': 'User added successfully'}), 201

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

        if data['role_id'] == roles.get('PLANNER'):
            update_planner(data, user_id)
            return jsonify({'message': 'User updated successfully'}), 200
        
        else:
            user = query_db("SELECT * FROM users WHERE id = %s", (user_id,), one=True)
            if user is None:
                return jsonify({'error': 'User not found'}), 404

            if data['password'] == None or data['password'] == "":
                query = """
                    UPDATE users 
                    SET 
                        email = %s, 
                        first_name = %s, 
                        last_name = %s, 
                        employee_id = %s, 
                        zone_id = %s 
                    WHERE 
                        id = %s
                """
                args = (
                    clean_and_lower(data['email']),  
                    clean_and_lower(data.get('first_name')), 
                    clean_and_lower(data.get('last_name')), 
                    clean_and_lower(data.get('emp_id')), 
                    data['zone_id'], 
                    user_id
                )
                query_db(query, args, False, True)

                return jsonify({'message': 'User updated successfully'}), 200
            else:

                hashed_pass = generate_bcrypt_hash(data['password'])
                query = """
                    UPDATE users 
                    SET 
                        email = %s, 
                        first_name = %s, 
                        last_name = %s, 
                        employee_id = %s, 
                        zone_id = %s,
                        password = %s
                    WHERE 
                        id = %s
                """
                args = (
                    clean_and_lower(data['email']), 
                    clean_and_lower(data.get('first_name')), 
                    clean_and_lower(data.get('last_name')), 
                    clean_and_lower(data.get('emp_id')), 
                    data['zone_id'], 
                    hashed_pass,
                    user_id
                )
                query_db(query, args, False, True)

                return jsonify({'message': 'User updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
