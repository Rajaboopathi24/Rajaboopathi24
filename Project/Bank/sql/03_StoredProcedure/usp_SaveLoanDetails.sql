CREATE OR ALTER PROC usp_SaveLoanDetails 
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;


    CREATE TABLE #Temp_Loans (
        loan_id INT,
        customer_id INT,
        loan_amount DECIMAL(18,2),
        interest_rate DECIMAL(5,2),
        loan_type VARCHAR(50),
        loan_date DATE
    );

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
END;
