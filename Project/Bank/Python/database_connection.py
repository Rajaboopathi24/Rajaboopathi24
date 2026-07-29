import pyodbc

def get_connection():
    """Opens and returns a connection to the SQL Server database."""
    connection_string = (
        r"Driver={ODBC Driver 17 for SQL Server};"
        r"Server=172.23.0.116\sql2022;"
        r"Database=testsflcvgl;"
        r"Trusted_Connection=yes;"
    )
    
    try:
        connection = pyodbc.connect(connection_string)
        return connection
    except Exception as e:
        print(f"Database Connection Error: {e}")
        return None
