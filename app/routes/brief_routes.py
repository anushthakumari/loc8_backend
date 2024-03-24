from flask import Blueprint, request, jsonify, current_app
from datetime import datetime
from werkzeug.utils import secure_filename
import os
import json

from app.utils.helpers import generate_jwt_token
from app.utils.db_helper import query_db
from app.utils.helpers import token_required, generate_uuid, clean_and_lower

brief_bp = Blueprint('brief', __name__)

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@brief_bp.route('/brief', methods=['POST'])
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
    start_date = clean_and_lower(data['start_date'])
    notes = data.get('notes')

    budgets = data.get("budgets")
    budgets = json.loads(budgets)

    if notes != None or notes != "":
        notes = clean_and_lower(notes) 

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

        query = """
            SELECT b.*, bb.budget_id, bb.zone_id, bb.state_id, bb.city_id, bb.budget
            FROM briefs b
            INNER JOIN brief_budgets bb ON b.brief_id = bb.brief_id
            WHERE b.created_by_user_id = %s
        """
        briefs_with_budgets = query_db(query, (user_id,))

        briefs_data = {}

        for row in briefs_with_budgets:
            brief_id = row['brief_id']
            if brief_id not in briefs_data:
                briefs_data[brief_id] = {
                    'brief_id': brief_id,
                    'category': row['category'],
                    'brand_name': row['brand_name'],
                    'brand_logo': row['brand_logo'],
                    'budgets': []
                }
            if row['budget_id'] is not None:
                budget_data = {
                    'budget_id': row['budget_id'],
                    'zone_id': row['zone_id'],
                    'state_id': row['state_id'],
                    'city_id': row['city_id'],
                    'budget': row['budget']
                }
                briefs_data[brief_id]['budgets'].append(budget_data)

        briefs_list = list(briefs_data.values())

        return jsonify({'briefs': briefs_list}), 200
    except Exception as e:
        return jsonify({'message': 'Something went wrong!'}), 500