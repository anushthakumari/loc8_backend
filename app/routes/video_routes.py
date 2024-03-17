import os
from flask import Blueprint, request, jsonify, send_from_directory,abort, send_file
from app.utils.helpers import token_required
from config.config import AppConfig
from werkzeug.utils import secure_filename
from scripts.video_processing_script import video_processing
from app.utils.db_helper import query_db
from app.utils.helpers import generate_uuid
from app.constants.roles import roles

video_bp = Blueprint('videos', __name__)

TARGET_VIDEO_PATH = f"./instance/"

@video_bp.route('/uploads/<filename>')
def stream_video(filename):

    UPLOAD_FOLDER = os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'instance'))
    video_path = os.path.join(UPLOAD_FOLDER, filename+".mp4")
    print(video_path)
    if not os.path.isfile(video_path):  # Prevent unauthorized access
        return abort(401)
    return send_file(video_path, mimetype='video/mp4', as_attachment=False) 


@video_bp.route('/', methods=['GET',])
@token_required
def get_all_videos(current_user):

    user_role_id = current_user['role_id']
    user_id = current_user['id']
    video_q = ""

    if user_role_id == roles.get('SUPERADMIN'):
         video_q = """
            SELECT 	billboards.*, 
                    videofiles.filename, videofiles.video_path, 
                    videofiles.created_at, videofiles.created_by_user_id,
                    states.state_name, cities.city_name, zones.zone_name
            FROM billboards
            JOIN videofiles ON billboards.video_id = videofiles.video_id
            JOIN states ON videofiles.state_id = states.state_id
            JOIN cities ON videofiles.city_id = cities.city_id
            JOIN zones ON videofiles.zone_id = zones.zone_id;
         """

         video_details = query_db(video_q, ())

         return jsonify(video_details), 200

    else: 
        video_q = """
        SELECT 	billboards.*, 
                    videofiles.filename, videofiles.video_path, 
                    videofiles.created_at, videofiles.created_by_user_id,
                    states.state_name, cities.city_name, zones.zone_name
            FROM billboards
            JOIN videofiles ON billboards.video_id = videofiles.video_id
            JOIN states ON videofiles.state_id = states.state_id
            JOIN cities ON videofiles.city_id = cities.city_id
            JOIN zones ON videofiles.zone_id = zones.zone_id
            WHERE videofiles.created_by_user_id = %s
        """
        video_details = query_db(video_q, (user_id,))

        return jsonify(video_details), 200

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
    filename = secure_filename(generate_uuid() + ".mp4")
    output_file_path = os.path.join(TARGET_VIDEO_PATH, filename)

    video_file.save(dest)

    vcd = video_processing(dest, output_file_path)
    vcd2 = str(vcd)
    vcd3 = vcd2[0:2]

    video_id = insert_video_data(output_file_path, filename, zone_id, state_id, city_id, current_user['id'])
    insert_billboard_data(video_id, current_user['id'], vcd)

    bill_q = "SELECT * FROM billboards WHERE video_id = %s";
    billboards = query_db(bill_q, (video_id,))
   
    video_q = "SELECT * FROM videofiles WHERE video_id = %s";
    video_details = query_db(video_q, (video_id,), True)

    os.remove(dest)

    return jsonify({"billboards":  billboards, "video_details": video_details}), 200


@video_bp.route('/output/<video_id>', methods=['GET',])
@token_required
def processed_output(current_user,video_id):
    bill_q = "SELECT * FROM billboards WHERE video_id = %s ORDER BY tracker_id ASC";
    billboards = query_db(bill_q, (video_id,))
   
    video_q = """
        SELECT  v.video_id, 
                v.filename,
                v.video_path, 
                z.zone_name, 
                s.state_name, 
                c.city_name, 
                v.created_at, 
                v.created_by_user_id
        FROM videofiles v
        JOIN zones z ON v.zone_id = z.zone_id
        JOIN states s ON v.state_id = s.state_id
        JOIN cities c ON v.city_id = c.city_id
        WHERE v.video_id = %s;
    """
    video_details = query_db(video_q, (video_id,), True)

    return jsonify({"billboards":  billboards, "video_details": video_details}), 200

@video_bp.route('/billboards/merge', methods=['POST'])
@token_required
def merge_billborads(current_user):
    data = request.get_json()
    billboard_ids = data.get('billboard_ids', [])
    user_id = current_user['id']

    if not billboard_ids:
        return jsonify({"error": "No billboard IDs provided"}), 400
    
    new_billboard_id = generate_uuid()

    query_merge_sum_average = f"""
        INSERT INTO billboards (id, video_id, visibility_duration, distance_to_center, central_duration, near_p_duration, 
                                mid_p_duration, far_p_duration, central_distance, near_p_distance, mid_p_distance, 
                                far_p_distance, average_areas, confidence, tracker_id, created_by_user_id)
        SELECT
            %s,
            video_id,
            SUM(visibility_duration) AS visibility_duration_sum,
            SUM(distance_to_center) AS distance_to_center_sum,
            SUM(central_duration) AS central_duration_sum,
            SUM(near_p_duration) AS near_p_duration_sum,
            SUM(mid_p_duration) AS mid_p_duration_sum,
            SUM(far_p_duration) AS far_p_duration_sum,
            SUM(central_distance) AS central_distance_sum,
            SUM(near_p_distance) AS near_p_distance_sum,
            SUM(mid_p_distance) AS mid_p_distance_sum,
            SUM(far_p_distance) AS far_p_distance_sum,
            AVG(average_areas) AS average_areas_avg,
            AVG(confidence) AS confidence_avg,
            MAX(tracker_id) AS tracker_id,
            created_by_user_id
        FROM billboards
        WHERE id IN ({','.join(['%s']*len(billboard_ids))})
        GROUP BY video_id
    """

    query_db(query_merge_sum_average, (new_billboard_id, *billboard_ids), False, True)

    query_delete_previous_rows = f"""
        DELETE FROM billboards
        WHERE id IN ({','.join(['%s']*len(billboard_ids))})
    """
    query_db(query_delete_previous_rows, tuple(billboard_ids), False, True)

    return jsonify({"message": "Merge successful"}), 200

def insert_video_data(output_file_path, filename, zone_id, state_id, city_id, created_by_user_id):
    video_query = """
        INSERT INTO videofiles (video_id, filename, video_path, zone_id, state_id, city_id, created_by_user_id)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """
    video_id = generate_uuid()
    video_args = (video_id, filename, output_file_path, zone_id, state_id, city_id, created_by_user_id)
    query_db(video_query, video_args, False, True)
    return video_id

def insert_billboard_data(video_id, user_id, billboard_data):
    for tracker_id, data in billboard_data.items():

        bill_id = generate_uuid();
        billboard_query = """
            INSERT INTO billboards (id, video_id, visibility_duration, distance_to_center, central_duration, near_p_duration, mid_p_duration, far_p_duration, 
                                    central_distance, near_p_distance, mid_p_distance, far_p_distance, average_areas, confidence, tracker_id, created_by_user_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        billboard_args = (
            bill_id,
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
            tracker_id,
            user_id
        )
        query_db(billboard_query, billboard_args, False, True)