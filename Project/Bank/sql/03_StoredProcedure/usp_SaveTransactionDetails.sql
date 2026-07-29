CREATE OR ALTER PROC usp_SaveTransactionDetails 
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #Temp_Transactions (
        transaction_id INT,
        account_id INT,
        transaction_type VARCHAR(20),
        amount DECIMAL(18,2),
        transaction_date DATETIME
    );

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
END;
