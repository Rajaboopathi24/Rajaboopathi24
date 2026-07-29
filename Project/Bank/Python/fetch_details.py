import database_connection
import save_details

def fetch_data(action, customer_id):
    """Runs 'Fetchdetails' and prints out tabular table results."""
    # 1. Open the connection
    conn = database_connection.get_connection()
    if conn is None:
        return
        
    cursor = conn.cursor()
    
    try:
        # 2. Execute the procedure using placeholders (?)
        fetch_query = "EXEC Fetchdetails @Action = ?, @Customerid = ?"
        cursor.execute(fetch_query, (action, customer_id))
        
        # 3. Collect all table row results
        rows = cursor.fetchall()
        
        print(f"\n--- Fetch Results for Action '{action}' ---")
        for row in rows:
            print(row)
            
    except Exception as e:
        print(f"Error while fetching data: {e}")
        
    finally:
        # 4. Clean up connection ports
        cursor.close()
        conn.close()


# ========================================================
# MAIN TESTING PROGRAM RUNNER
# ========================================================
if __name__ == "__main__":
    
    # Define alternative data payload template
    mock_customer = [
        {
            "customer_id": 999,
            "first_name": "Alice",
            "last_name": "Wonderland",
            "dob": "1988-11-23",
            "phone": "5551234567",
            "email": "alice.w@alt-email.com",
            "address": "Los Angeles",
        }
    ]
    
    print("Starting process pipeline...")
    
    # 1. Run the save operation from file 2
    save_details.save_data(action="C", python_data=mock_customer)
    
    # 2. Run the fetch operation inside file 3
    fetch_data(action="A", customer_id=999)
    
    print("\nProcess pipeline finished successfully.")
