from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower, generate_bcrypt_hash

def update_planner(data, user_id):
    if data['password'] == None or data['password'] == "":
        query = """
            UPDATE users 
            SET 
                email = %s, 
                first_name = %s, 
                last_name = %s, 
                employee_id = %s, 
                zone_id = %s,
                state_id = %s,
                city_id = %s
            WHERE 
                id = %s
        """
        args = (
            clean_and_lower(data['email']),  
            clean_and_lower(data.get('first_name')), 
            clean_and_lower(data.get('last_name')), 
            clean_and_lower(data.get('emp_id')), 
            data['zone_id'], 
            data['state_id'],
            data['city_id'],
            user_id
        )
        query_db(query, args, False, True)

        return True
    
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
                password = %s,
                zone_id = %s,
                state_id = %s,
                city_id = %s
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
            data['zone_id'], 
            data['state_id'],
            data['city_id'],
            user_id
        )
        query_db(query, args, False, True)

        return True