from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower

def get_brief_details_by_brief_id (brief_id=""):
   q = """
        SELECT * FROM briefs WHERE brief_id=%s;
    """
   
   brief_data = query_db(q, (brief_id,), True)

   return brief_data


def assign_brief_to_planners(brief_id=""):
   budgets_q = """
        SELECT budget_id, zone_id, state_id, city_id FROM `brief_budgets` WHERE brief_id=%s
    """ 
   
   budgets  = query_db(budgets_q, (brief_id,))


   if budgets == None:
       return

   for budget in budgets:
        planner_q = """
            SELECT id FROM users WHERE zone_id=%s AND state_id=%s AND city_id=%s AND role_id=1
        """

        planners = query_db(planner_q, (
            budget['zone_id'], budget['state_id'], 
            budget['city_id']
        ))

        if planners == None:
            continue

        for planner in planners:
            assigned_user_q = """
                SELECT user_id FROM assigned_briefs WHERE brief_id=%s AND user_id=%s 
            """ 

            assigned_user = query_db(assigned_user_q, (brief_id, planner['id']))

            if assigned_user != None:
                continue

            insert_assign_q = """
                INSERT INTO `assigned_briefs`
                    (`id`, `user_id`, `brief_id`) 
                VALUES 
                    (%s, %s, %s)
            """
            query_db(insert_assign_q, (brief_id, planner['id'], brief_id), False, True)



