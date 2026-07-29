import json
import pyodbc

# STEP 1: Tell Python how to log into your SQL Server database
# Note the 'r' before the string to make sure the backslash (\) works perfectly!
connection_string = (
    r"Driver={ODBC Driver 17 for SQL Server};"
    r"Server=172.23.0.116\sql2022;"
    r"Database=testsflcvgl;"
    r"Trusted_Connection=yes;"
)

# STEP 2: Open the connection to your database
connection = pyodbc.connect(connection_string)
cursor = connection.cursor()
print("Connected successfully to the database!")


# STEP 3: Create your data in Python (Dictionary / List)
customer_data = [
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

# STEP 4: Convert your Python data into a JSON string text
json_text = json.dumps(customer_data)


# STEP 5: Run your stored procedure 'usp_Savedetails'
sql_query = "EXEC usp_Savedetails @Action = ?, @json = ?"
cursor.execute(sql_query, ("C", json_text))


# STEP 6: Save the changes to the database permanently
connection.commit()
print("Data saved successfully in SQL Server!")


# ========================================================
# NEW STEP: Fetch details using 'Fetchdetails' procedure
# ========================================================
print("\nFetching data from database...")

# Setup the fetch command with placeholder '?' spots
fetch_query = "EXEC Fetchdetails @Action = ?, @Customerid = ?"

# Run the fetch procedure with action 'A' and Customer ID 999
cursor.execute(fetch_query, ("A", 999))

# Get all the rows returned by your SQL SELECT statement
rows = cursor.fetchall()

# Loop through and print each row of data
for row in rows:
    print(row)
# ========================================================


# STEP 7: Close everything when done to keep your computer clean
cursor.close()
connection.close()
print("\nConnection closed safely.")
