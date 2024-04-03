from flask import Blueprint, request, jsonify, current_app
from datetime import datetime
from werkzeug.utils import secure_filename
import os
import json

from app.utils.db_helper import query_db
from app.utils.helpers import token_required, generate_uuid, clean_and_lower
from app.services.briefs import get_brief_details_by_brief_id, assign_brief_to_planners
from app.constants.roles import roles

brief_bp = Blueprint('brief', __name__)

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@brief_bp.route('/briefs', methods=['POST'])
@token_required
def createBrief(current_user):
    data = request.form

    current_user_id = current_user['id']

    if 'brand_logo' not in request.files:
        return jsonify({'message': 'Please provide brand logo'}), 400

    # assign data
    brief_id = generate_uuid();
    category = clean_and_lower(data['category'])
    brand_name = clean_and_lower(data['brand_name'])
    target_aud = clean_and_lower(data['target_aud'])
    camp_obj = clean_and_lower(data['camp_obj'])
    med_app = clean_and_lower(data['med_app'])
    is_immediate_camp = clean_and_lower(data['is_immediate_camp'])
    start_date = data.get("start_date")
    notes = data.get('notes')

    budgets = data.get("budgets")
    budgets = json.loads(budgets)

    if notes != None or notes != "":
        notes = clean_and_lower(notes) 

    if start_date != None or start_date != "":
        start_date = clean_and_lower(start_date) 

    file = request.files['brand_logo']

    # validate data
    if is_immediate_camp == 1 and not start_date:
        return jsonify({"message" : "Campaing is immdiate and we require start date!"}) , 400
    
    if file.filename == '':
        return jsonify({'message': 'No selected file'}), 400
    
    if start_date:
        start_date = datetime.strptime(start_date, "%Y-%m-%d")
        if start_date <= datetime.now():
            return jsonify({'message': 'Start date must be a future date'}), 400

    
    filename = brief_id + secure_filename(file.filename)
    file.save(os.path.join(current_app.config['UPLOAD_FOLDER'], filename))
    
    try:
        query_db("START TRANSACTION", ())

        brief_insert_q = """
                INSERT INTO `briefs`
                (
                    `brief_id`, `category`, `brand_name`, `brand_logo`, 
                    `target_audience`, `campaign_obj`, `media_approach`, `is_immediate_camp`, 
                    `start_date`, `notes`, `created_by_user_id`
                ) 
            VALUES (
                    %s, %s, %s, %s,
                    %s, %s, %s, %s,
                    %s, %s, %s
                )
        """

        query_db(brief_insert_q, (
            brief_id, category, brand_name, filename, 
            target_aud, camp_obj, med_app, is_immediate_camp,
            start_date, notes, current_user_id
        ))

        for budget in budgets:
            zone_id = budget.get("zone_id")
            state_id = budget.get("state_id")
            city_id = budget.get("city_id")
            budget_amt = budget.get("budget")
            budget_id = generate_uuid();

            budget_insert_q = """
                INSERT INTO `brief_budgets` (`budget_id`, `brief_id`, `zone_id`, `state_id`, `city_id`, `budget`)
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            query_db(budget_insert_q, (budget_id, brief_id, zone_id, state_id, city_id, budget_amt))
        
        current_app.mysql.connection.commit()

        assign_brief_to_planners(brief_id)
        
        return jsonify({'message': 'Created successfully'}), 201
    except Exception as e:
        current_app.mysql.connection.rollback()
        print(e)
        return jsonify({'message': 'Something went wrong!'}), 500

@brief_bp.route('/briefs', methods=['GET'])
@token_required
def getBriefs(current_user):
    try:
        user_id = current_user['id']

        query = ""
        args = ()

        if current_user['role_id'] == roles.get("SUPERADMIN"):
            query = """
            SELECT b.*, bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, zones.zone_name, states.state_name, cities.city_name, bb.budget
            FROM briefs b
            INNER JOIN brief_budgets bb ON b.brief_id = bb.brief_id
            INNER JOIN zones ON bb.zone_id = zones.zone_id
            INNER JOIN states ON bb.state_id = states.state_id
            INNER JOIN cities ON bb.city_id = cities.city_id
        """
            
        else:

            query = """
                SELECT b.*, bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, zones.zone_name, states.state_name, cities.city_name, bb.budget
                FROM briefs b
                INNER JOIN brief_budgets bb ON b.brief_id = bb.brief_id
                INNER JOIN zones ON bb.zone_id = zones.zone_id
                INNER JOIN states ON bb.state_id = states.state_id
                INNER JOIN cities ON bb.city_id = cities.city_id
                WHERE b.created_by_user_id = %s
            """

            args = (user_id,)
            
        briefs_with_budgets = query_db(query, args)

        if briefs_with_budgets == None: 
            return jsonify([]), 200

        briefs_data = {}

        for row in briefs_with_budgets:
            brief_id = row['brief_id']
            if brief_id not in briefs_data:
                briefs_data[brief_id] = {
                    'brief_id': brief_id,
                    'category': row['category'],
                    'brand_name': row['brand_name'],
                    'brand_logo': row['brand_logo'],
                    'campaign_obj': row['campaign_obj'],
                    'start_date': row['start_date'],
                    'status': row['status'],
                    'budgets': []
                }
            if row['budget_id'] is not None:
                budget_data = {
                    'budget_id': row['budget_id'],
                    'zone_id': row['zone_id'],
                    'state_id': row['state_id'],
                    'city_id': row['city_id'],
                    'zone_name': row['zone_name'],
                    'state_name': row['state_name'],
                    'city_name': row['city_name'],
                    'budget': row['budget']
                }
                briefs_data[brief_id]['budgets'].append(budget_data)

        briefs_list = list(briefs_data.values())

        return jsonify(briefs_list), 200
    except Exception as e:
        print(e)
        return jsonify({'message': 'Something went wrong!'}), 500
    
@brief_bp.route('/briefs/<brief_id>', methods=['DELETE'])
@token_required
def deleteBrief(current_user, brief_id):

    brief_data = get_brief_details_by_brief_id(brief_id)

    # only admin and owner of the brief can delete 
    if(brief_data['created_by_user_id'] != current_user['id'] and current_user['role_id'] != roles.get("SUPERADMIN")):
        return jsonify({
            'message': "You cannot delete this brief!",
        }), 401

    q = """
        DELETE FROM brief_budgets WHERE brief_id=%s
    """

    query_db(q, (brief_id,))

    q = """
        DELETE FROM briefs WHERE brief_id=%s
    """

    query_db(q, (brief_id,))

    current_app.mysql.connection.commit()

    os.remove(os.path.join(current_app.config['UPLOAD_FOLDER'], brief_data['brand_logo']))

    return jsonify({"message": "Deleted Successfully!"}), 200

@brief_bp.route('/briefs/<brief_id>', methods=['GET'])
@token_required
def editBrief(current_user, brief_id):

    brief_data = get_brief_details_by_brief_id(brief_id)

    # # only admin and owner of the brief can delete 
    # if(brief_data['created_by_user_id'] != current_user['id'] and current_user['role_id'] != roles.get("SUPERADMIN")):
    #     return jsonify({
    #         'message': "You cannot edit this brief!",
    #     }), 401

    
    query = """
            SELECT bb.*, zones.zone_name, states.state_name, cities.city_name
            FROM brief_budgets bb
            INNER JOIN zones ON bb.zone_id = zones.zone_id
            INNER JOIN states ON bb.state_id = states.state_id
            INNER JOIN cities ON bb.city_id = cities.city_id
            WHERE bb.brief_id = %s
        """
    
    budgets = query_db(query, (brief_id,))

    brief_data["budgets"] = budgets

    return jsonify(brief_data), 200


@brief_bp.route('/planner', methods=['GET'])
@token_required
def getPlannerBriefs(current_user):
    user_id = current_user['id']

    assigned_brief_q = """
        SELECT b.*, bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, zones.zone_name, states.state_name, cities.city_name, bb.budget FROM assigned_budgets ab
        INNER JOIN brief_budgets bb ON ab.budget_id = bb.budget_id
        INNER JOIN briefs b ON b.brief_id=bb.brief_id
        INNER JOIN zones ON bb.zone_id = zones.zone_id
        INNER JOIN states ON bb.state_id = states.state_id
        INNER JOIN cities ON bb.city_id = cities.city_id
        WHERE 
            ab.user_id=%s
    """
    assigned_brief_args = (user_id,)

    briefs_with_budgets = query_db(assigned_brief_q, assigned_brief_args)

    if briefs_with_budgets == None: 
        return jsonify([]), 200

    briefs_data = {}

    for row in briefs_with_budgets:
        brief_id = row['brief_id']
        if brief_id not in briefs_data:
            briefs_data[brief_id] = {
                'brief_id': brief_id,
                'category': row['category'],
                'brand_name': row['brand_name'],
                'brand_logo': row['brand_logo'],
                'campaign_obj': row['campaign_obj'],
                'start_date': row['start_date'],
                'status': row['status'],
                'budgets': []
            }
        if row['budget_id'] is not None:
            budget_data = {
                'budget_id': row['budget_id'],
                'zone_id': row['zone_id'],
                'state_id': row['state_id'],
                'city_id': row['city_id'],
                'zone_name': row['zone_name'],
                'state_name': row['state_name'],
                'city_name': row['city_name'],
                'budget': row['budget']
            }
            briefs_data[brief_id]['budgets'].append(budget_data)

    briefs_list = list(briefs_data.values())

    return jsonify(briefs_list), 200

@brief_bp.route('/budgets/<budget_id>', methods=['GET'])
@token_required
def getBriefBudgetDetailsByBudgetId(current_user, budget_id):

    query = """
            SELECT bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, zones.zone_name, states.state_name, cities.city_name, bb.budget FROM assigned_budgets ab
            INNER JOIN brief_budgets bb ON ab.budget_id = bb.budget_id
            INNER JOIN zones ON bb.zone_id = zones.zone_id
            INNER JOIN states ON bb.state_id = states.state_id
            INNER JOIN cities ON bb.city_id = cities.city_id
            WHERE ab.budget_id=%s
        """
    
    video_query = """
        SELECT * FROM videofiles
        WHERE zone_id=%s AND state_id=%s AND city_id=%s
    """
    
    budget = query_db(query, (budget_id,), True)

    if budget == None:
        return jsonify({}), 200


    videos = query_db(video_query, (budget['zone_id'], budget['state_id'], budget['city_id']))

    return jsonify({'budget':  budget, 'videos': videos }), 200

@brief_bp.route('/briefs/<brief_id>/planner', methods=['GET'])
@token_required
def getBriefDetailsForPlanner(current_user, brief_id):

    brief_data = get_brief_details_by_brief_id(brief_id)
    
    query = """
            SELECT bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, zones.zone_name, states.state_name, cities.city_name, bb.budget FROM assigned_budgets ab
            INNER JOIN brief_budgets bb ON ab.budget_id = bb.budget_id
            INNER JOIN zones ON bb.zone_id = zones.zone_id
            INNER JOIN states ON bb.state_id = states.state_id
            INNER JOIN cities ON bb.city_id = cities.city_id
            WHERE bb.brief_id=%s
        """
    
    budgets = query_db(query, (brief_id,))

    brief_data["budgets"] = budgets

    return jsonify(brief_data), 200
