from flask import Blueprint, jsonify, request, current_app
from app.utils.helpers import token_required, superadmin_required
from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower, generate_bcrypt_hash

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
    query = "SELECT id, first_name, last_name, email, created_at, zones.zone_name, users.zone_id FROM users inner join zones on zones.zone_id=users.zone_id WHERE role_id = 1 order by created_at desc"
    admins = query_db(query)

    if not admins:
        return jsonify([])

    return jsonify(admins)


@admin_bp.route('/admins', methods=['POST'])
@token_required
def add_user(current_user):

    data = request.get_json()

    hashed_pass = generate_bcrypt_hash(data['password'])
    query = "INSERT INTO users (email, password, role_id, first_name, last_name, employee_id, zone_id) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    args = (
        clean_and_lower(data['email']), 
        hashed_pass,
        data['role_id'], 
        clean_and_lower(data.get('first_name')), 
        clean_and_lower(data.get('last_name')), 
        clean_and_lower(data.get('emp_id')), 
        data['zone_id']
    )
    query_db(query, args, False, True)

    return jsonify({'message': 'Admin added successfully'}), 201

@admin_bp.route('/admins/<int:user_id>', methods=['DELETE'])
@token_required
def delete_user(current_user,user_id):
    query = "DELETE FROM users WHERE id = %s"
    args=(user_id,)
    query_db(query, args, False, True)

    return jsonify({'message': 'user deleted successfully'}), 200


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
