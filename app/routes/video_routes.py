from flask import Blueprint, request, jsonify
from app.utils.helpers import token_required
from config.config import AppConfig
from app.utils.helpers import token_required
import os

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
    
    video_file.save(os.path.join(AppConfig.UPLOAD_FOLDER, video_file.filename))

    print(zone_id, state_id,city_id)
    
    return jsonify({'message': 'Video uploaded successfully'}), 200