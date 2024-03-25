from app.utils.db_helper import query_db
from app.utils.helpers import clean_and_lower

def get_brief_details_by_brief_id (brief_id=""):
   q = """
        SELECT * FROM briefs WHERE brief_id=%s;
    """
   
   brief_data = query_db(q, (brief_id,), True)

   return brief_data