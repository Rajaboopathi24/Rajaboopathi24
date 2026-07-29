CREATE OR ALTER PROC Savedetails 
    @Action CHAR(1),
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- ========================================================
    -- ACTION 'C': CUSTOMERS
    -- ========================================================
    IF @Action = 'C'
    BEGIN
        -- 1. Create a local temp table matching Customer schema
        CREATE TABLE #Temp_Customers (
            customer_id INT,
            first_name VARCHAR(50),
            last_name VARCHAR(50),
            dob DATE,
            phone VARCHAR(15),
            email VARCHAR(100),
            address VARCHAR(255)
        );

        -- 2. Populate the temp table from JSON data
        INSERT INTO #Temp_Customers
        SELECT customer_id, first_name, last_name, dob, phone, email, address
        FROM OPENJSON(@json)
        WITH (
            customer_id INT '$.customer_id',
            first_name VARCHAR(50) '$.first_name',
            last_name VARCHAR(50) '$.last_name',
            dob DATE '$.dob',
            phone VARCHAR(15) '$.phone',
            email VARCHAR(100) '$.email',
            address VARCHAR(255) '$.address'
        );

        -- 3. Compare temp table with main table to Upsert
        MERGE Customers AS Target
        USING #Temp_Customers AS Source
        ON (Target.customer_id = Source.customer_id)
        WHEN MATCHED THEN
            UPDATE SET 
                Target.first_name = Source.first_name,
                Target.last_name = Source.last_name,
                Target.dob = Source.dob,
                Target.phone = Source.phone,
                Target.email = Source.email,
                Target.address = Source.address
        WHEN NOT MATCHED THEN
            INSERT (customer_id, first_name, last_name, dob, phone, email, address)
            VALUES (Source.customer_id, Source.first_name, Source.last_name, Source.dob, Source.phone, Source.email, Source.address);

        DROP TABLE #Temp_Customers;
    END

    -- ========================================================
    -- ACTION 'A': ACCOUNTS
    -- ========================================================
    ELSE IF @Action = 'A'
    BEGIN
        -- 1. Create a local temp table matching Account schema
        CREATE TABLE #Temp_Accounts (
            account_id INT,
            customer_id INT,
            branch_id INT,
            account_type VARCHAR(50),
            balance DECIMAL(18,2),
            opened_date DATE
        );

        -- 2. Populate the temp table from JSON data
        INSERT INTO #Temp_Accounts
        SELECT account_id, customer_id, branch_id, account_type, balance, opened_date
        FROM OPENJSON(@json)
        WITH (
            account_id INT '$.account_id',
            customer_id INT '$.customer_id',
            branch_id INT '$.branch_id',
            account_type VARCHAR(50) '$.account_type',
            balance DECIMAL(18,2) '$.balance',
            opened_date DATE '$.opened_date'
        );

        -- 3. Compare temp table with main table to Upsert
        MERGE Accounts AS Target
        USING #Temp_Accounts AS Source
        ON (Target.account_id = Source.account_id)
        WHEN MATCHED THEN
            UPDATE SET 
                Target.customer_id = Source.customer_id,
                Target.branch_id = Source.branch_id,
                Target.account_type = Source.account_type,
                Target.balance = Source.balance,
                Target.opened_date = Source.opened_date
        WHEN NOT MATCHED THEN
            INSERT (account_id, customer_id, branch_id, account_type, balance, opened_date)
            VALUES (Source.account_id, Source.customer_id, Source.branch_id, Source.account_type, Source.balance, Source.opened_date);

        DROP TABLE #Temp_Accounts;
    END

    -- ========================================================
    -- ACTION 'T': TRANSACTIONS
    -- ========================================================
    ELSE IF @Action = 'T'
    BEGIN
        -- 1. Create a local temp table matching Transaction schema
        CREATE TABLE #Temp_Transactions (
            transaction_id INT,
            account_id INT,
            transaction_type VARCHAR(20),
            amount DECIMAL(18,2),
            transaction_date DATETIME
        );

        -- 2. Populate the temp table from JSON data
        INSERT INTO #Temp_Transactions
        SELECT transaction_id, account_id, transaction_type, amount, transaction_date
        FROM OPENJSON(@json)
        WITH (
            transaction_id INT '$.transaction_id',
            account_id INT '$.account_id',
            transaction_type VARCHAR(20) '$.transaction_type',
            amount DECIMAL(18,2) '$.amount',
            transaction_date DATETIME '$.transaction_date'
        );

        -- 3. Compare temp table with main table to Upsert
        MERGE Transactions AS Target
        USING #Temp_Transactions AS Source
        ON (Target.transaction_id = Source.transaction_id)
        WHEN MATCHED THEN
            UPDATE SET 
                Target.account_id = Source.account_id,
                Target.transaction_type = Source.transaction_type,
                Target.amount = Source.amount,
                Target.transaction_date = Source.transaction_date
        WHEN NOT MATCHED THEN
            INSERT (transaction_id, account_id, transaction_type, amount, transaction_date)
            VALUES (Source.transaction_id, Source.account_id, Source.transaction_type, Source.amount, Source.transaction_date);

        DROP TABLE #Temp_Transactions;
    END

    -- ========================================================
    -- ACTION 'L': LOANS
    -- ========================================================
    ELSE IF @Action = 'L'
    BEGIN
        -- 1. Create a local temp table matching Loan schema
        CREATE TABLE #Temp_Loans (
            loan_id INT,
            customer_id INT,
            loan_amount DECIMAL(18,2),
            interest_rate DECIMAL(5,2),
            loan_type VARCHAR(50),
            loan_date DATE
        );

        -- 2. Populate the temp table from JSON data
        INSERT INTO #Temp_Loans
        SELECT loan_id, customer_id, loan_amount, interest_rate, loan_type, loan_date
        FROM OPENJSON(@json)
        WITH (
            loan_id INT '$.loan_id',
            customer_id INT '$.customer_id',
            loan_amount DECIMAL(18,2) '$.loan_amount',
            interest_rate DECIMAL(5,2) '$.interest_rate',
            loan_type VARCHAR(50) '$.loan_type',
            loan_date DATE '$.loan_date'
        );

        -- 3. Compare temp table with main table to Upsert
        MERGE Loans AS Target
        USING #Temp_Loans AS Source
        ON (Target.loan_id = Source.loan_id)
        WHEN MATCHED THEN
            UPDATE SET 
                Target.customer_id = Source.customer_id,
                Target.loan_amount = Source.loan_amount,
                Target.interest_rate = Source.interest_rate,
                Target.loan_type = Source.loan_type,
                Target.loan_date = Source.loan_date
        WHEN NOT MATCHED THEN
            INSERT (loan_id, customer_id, loan_amount, interest_rate, loan_type, loan_date)
            VALUES (Source.loan_id, Source.customer_id, Source.loan_amount, Source.interest_rate, Source.loan_type, Source.loan_date);

        DROP TABLE #Temp_Loans;
    END

    -- Handle unsupported action codes
    ELSE
    BEGIN
        RAISERROR('Invalid Action Code. Please use C, A, T, or L.', 16, 1);
    END
END;
