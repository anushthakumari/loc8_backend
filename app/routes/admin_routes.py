from flask import Blueprint, jsonify, request, current_app
from app.utils.helpers import token_required, superadmin_required
from app.utils.db_helper import query_db

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admins', methods=['GET'])
@token_required
def get_all_admins(current_user):
    query = "SELECT first_name, last_name, email, created_at FROM users WHERE role_id = 2 order by created_at desc"
    admins = query_db(query)

    if not admins:
        return jsonify([])

    return jsonify(admins)
