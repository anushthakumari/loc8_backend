from flask import Blueprint, jsonify, request, current_app
from app.utils.helpers import token_required, superadmin_required, admin_required
from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower, generate_bcrypt_hash, generate_uuid
from app.constants.roles import roles
from app.services.users import is_user_email_exits, is_emp_id_exits
from app.services.user_areas import insert_user_areas

plans_bp = Blueprint('plans', __name__)

@plans_bp.route('/plans', methods=['POST'])
@token_required
def add_plan(current_user):

    current_user_id = current_user['id']

    data = request.get_json()

    #data
    media_type = data['media_type']
    illumination = data['illumination']
    location = data['location']
    latitude = float(data['latitude'])
    longitude = float(data['longitude'])

    duration = float(data['duration'])
    imp_per_month =  float(data['imp_per_month'])
    mounting = int(data['mounting'])
    cost_for_duration = data['cost_for_duration']
    printing = int(data['printing'])
    rental_per_month = float(data['rental_per_month'])
    h = float(data['h'])
    qty = int(data['qty'])
    size = int(data['size'])
    w = int(data['w'])
    brief_id = data['brief_id']
    budget_id = data['budget_id']
    video_id = data['video_id']

    plan_id = generate_uuid()
    total = cost_for_duration + printing + mounting

    query = """
        INSERT INTO plans (
            plan_id, brief_id, budget_id, 
            user_id, video_id, location, 
            latitude, longitude, illumination, 
            media_type, w, h, 
            qty, size, duration, 
            imp_per_month, rental_per_month, cost_for_duration, 
            printing, mounting, total
        ) VALUES (
            %s, %s, %s,
            %s, %s, %s,
            %s, %s, %s,
            %s, %s, %s,
            %s, %s, %s,
            %s, %s, %s,
            %s, %s, %s
        )
    """

    args = (
        plan_id, brief_id, budget_id,
        current_user_id, video_id, location,
        latitude, longitude, illumination,
        media_type, w, h, 
        qty, size, duration, 
        imp_per_month, rental_per_month, cost_for_duration, 
        printing, mounting, total
    )

    query_db(query, args, True, True)

    return jsonify({'message': 'Plan added successfully'}), 201

      
# @plans_bp.route('plans/<budget_id>')
# @token_required
        
