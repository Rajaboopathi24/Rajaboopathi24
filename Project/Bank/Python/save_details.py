import json
import database_connection

def save_data(action, python_data):
    """Converts data to JSON text and runs 'usp_Savedetails'."""
    # 1. Open the connection
    conn = database_connection.get_connection()
    if conn is None:
        return
        
    cursor = conn.cursor()
    
    try:
        # 2. Convert Python dictionary/list to a JSON string text
        json_text = json.dumps(python_data)
        
        # 3. Execute the procedure using placeholders (?)
        sql_query = "EXEC usp_Savedetails @Action = ?, @json = ?"
        cursor.execute(sql_query, (action, json_text))
        
        # 4. Save changes permanently
        conn.commit()
        print(f"Action '{action}' data saved successfully!")
        
    except Exception as e:
        print(f"Error while saving data: {e}")
        
    finally:
        # 5. Clean up connection ports
        cursor.close()
        conn.close()
