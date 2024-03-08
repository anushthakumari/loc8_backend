
import os
from flask import Blueprint, request, jsonify
from app.utils.helpers import token_required
from config.config import AppConfig
from werkzeug.utils import secure_filename
from scripts.video_processing_script import video_processing
from app.utils.db_helper import query_db
from app.utils.helpers import generate_uuid

video_bp = Blueprint('videos', __name__)

@video_bp.route('/upload', methods=['POST',])
@token_required
def upload(current_user):
    video_file = request.files['video']
    zone_id = request.form['zone_id']
    state_id = request.form['state_id']
    city_id = request.form['city_id']

    if video_file is None or video_file.filename == "":
        return jsonify({"error": "no file"})

    dest = os.path.join(AppConfig.UPLOAD_FOLDER, secure_filename(video_file.filename))
    video_file.save(dest)

    vcd = video_processing(dest)
    vcd2 = str(vcd)
    vcd3 = vcd2[0:2]

    video_id = insert_video_data(zone_id, state_id, city_id, current_user['id'])
    insert_billboard_data(video_id, vcd)

    bill_q = "SELECT * FROM billborads WHERE video_id = %s";
    billboards = query_db(bill_q, (video_id,))
   
    video_q = "SELECT * FROM videofiles WHERE video_id = %s";
    video_details = query_db(video_q, (video_id,), True)

    os.remove(dest)

    return jsonify({"billboards":  billboards, "video_details": video_details}), 200


def insert_video_data(zone_id, state_id, city_id, created_by_user_id):
    video_query = """
        INSERT INTO videofiles (video_id, zone_id, state_id, city_id, created_by_user_id)
        VALUES (%s, %s, %s, %s, %s);
    """
    video_id = generate_uuid()
    video_args = (video_id, zone_id, state_id, city_id, created_by_user_id)
    query_db(video_query, video_args, False, True)
    return video_id

def insert_billboard_data(video_id, billboard_data):
    for serial, data in billboard_data.items():
        billboard_query = """
            INSERT INTO billboards (video_id, visibility_duration, distance_to_center, central_duration, near_p_duration, mid_p_duration, far_p_duration, 
                                    central_distance, near_p_distance, mid_p_distance, far_p_distance, average_areas, confidence, serial)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        billboard_args = (
            video_id,
            data['visibility_duration'],
            data['distance_to_center'],
            data['BillBoard_Region_Duration and Distance']['Central'],
            data['BillBoard_Region_Duration and Distance']['Near P'],
            data['BillBoard_Region_Duration and Distance']['Mid P'],
            data['BillBoard_Region_Duration and Distance']['Far P'],
            data['BillBoard_Region_Duration and Distance']['Central Dist'],
            data['BillBoard_Region_Duration and Distance']['Near P Dist'],
            data['BillBoard_Region_Duration and Distance']['Mid P Dist'],
            data['BillBoard_Region_Duration and Distance']['Far P Dist'],
            data['Average Areas'],
            data['Confidence'],
            serial
        )
        query_db(billboard_query, billboard_args, False, True)