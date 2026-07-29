import json
import pyodbc

class BankDatabaseManager:
    """Master class to manage connection, saving, and fetching operations."""
    
    def __init__(self):
        # STEP 1: Centralized Connection Configuration
        # The 'r' handles backslashes safely in the instance name
        self.connection_string = (
            r"Driver={ODBC Driver 17 for SQL Server};"
            r"Server=172.23.0.116\sql2022;"
            r"Database=testsflcvgl;"
            r"Trusted_Connection=yes;"
        )
        self.connection = None
        self.cursor = None

    def connect(self):
        """Opens connection ports safely."""
        try:
            if self.connection is None or self.connection.closed:
                self.connection = pyodbc.connect(self.connection_string)
                self.cursor = self.connection.cursor()
                print("Database connected successfully!")
        except Exception as e:
            print(f"Connection Failed: {e}")

    def disconnect(self):
        """Closes connection ports to free computer memory resources."""
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        print("Database connection closed cleanly.")

    def save_details(self, action_code, python_data):
        """Converts data payloads to JSON string arrays and runs upserts."""
        self.connect()
        try:
            # Convert native python data maps to pure JSON text
            json_text = json.dumps(python_data)
            
            # Execute master wrapper tracking insert logic routing
            sql_query = "EXEC usp_Savedetails @Action = ?, @json = ?"
            self.cursor.execute(sql_query, (action_code, json_text))
            
            # Commit mutations to lock record states permanently
            self.connection.commit()
            print(f"Success: Action '{action_code}' records processed in database.")
            
        except Exception as e:
            print(f"Error while saving data matrix: {e}")
        finally:
            self.disconnect()

    def fetch_details(self, action_code, customer_id):
        """Executes targeted profiling checks and prints row sets cleanly."""
        self.connect()
        try:
            sql_query = "EXEC Fetchdetails @Action = ?, @Customerid = ?"
            self.cursor.execute(sql_query, (action_code, customer_id))
            
            # Download matched staging segments to python array frames
            rows = self.cursor.fetchall()
            
            print(f"\n================ FETCHING RESULTS [{action_code}] ================")
            
            if not rows:
                print("No data records matches found for query targets.")
                return

            # Loop layout filters results based on operational context flags
            for row in rows:
                if action_code == 'A':  # Account Verification Layout
                    print(f"Account: {row.account_id} | Type: {row.account_type} | Balance: ${row.balance:,.2f}")
                elif action_code == 'T':  # Transaction Listing Layout
                    print(f"TxID: {row.transaction_id} | Type: {row.transaction_type} | Amount: ${row.amount:,.2f} | Date: {row.transaction_date}")
                elif action_code == 'D':  # Profile Dashboard Layout
                    print(f"Customer Name: {row.First_Name} {row.Last_Name} | Contact Email: {row.Email}")
                else:
                    # Print raw layout if custom rules aren't specified 
                    print(row)
            print("==================================================\n")
            
        except Exception as e:
            print(f"Error encountered during table fetch sequence: {e}")
        finally:
            self.disconnect()


# =====================================================================
# OPERATOR PROGRAM CONTROL ROOM (RUNNING ACTIONS)
# =====================================================================
if __name__ == "__main__":
    
    # Initialize the Master Controller object 
    manager = BankDatabaseManager()
    
    # Mock operational test variables
    test_id = 999
    mock_customer = [
        {
            "customer_id": test_id,
            "first_name": "Alice",
            "last_name": "Wonderland",
            "dob": "1988-11-23",
            "phone": "5551234567",
            "email": "alice.w@alt-email.com",
            "address": "Los Angeles",
        }
    ]

    # RUN CONTROL PIPELINE:
    # 1. Fire save routines to upsert customer data
    manager.save_details(action_code="C", python_data=mock_customer)
    
    # 2. Fire profiling fetch routines to visually check table balances
    manager.fetch_details(action_code="A", customer_id=test_id)
