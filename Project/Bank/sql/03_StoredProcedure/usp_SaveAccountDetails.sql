CREATE OR ALTER PROC usp_SaveAccountDetails 
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #Temp_Accounts (
        account_id INT,
        customer_id INT,
        branch_id INT,
        account_type VARCHAR(50),
        balance DECIMAL(18,2),
        opened_date DATE
    );

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
END;
