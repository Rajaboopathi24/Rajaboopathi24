CREATE OR ALTER PROC usp_GetTransactionDetails
    @Customerid INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Account_id INT;    

    SELECT @Account_id = Account_id 
    FROM Accounts 
    WHERE customer_id = @Customerid;

    IF @Account_id IS NULL
    BEGIN
        RAISERROR('No account found for the specified Customer ID.', 16, 1);
        RETURN;
    END

    SELECT 
        @Account_id AS Account_ID,
        -- Total Credits (Deposits)
        ISNULL(SUM(CASE 
            WHEN transaction_type IN ('Credit', 'Deposit') THEN amount 
            ELSE 0 
        END), 0.00) AS Total_Credit_Amount,
        
        -- Total Debits (Withdrawals)
        ISNULL(SUM(CASE 
            WHEN transaction_type IN ('Debit', 'Withdrawal') THEN amount 
            ELSE 0 
        END), 0.00) AS Total_Debit_Amount,

        -- Remaining Current Balance based on Transactions
        ISNULL(SUM(CASE 
            WHEN transaction_type IN ('Credit', 'Deposit') THEN amount 
            WHEN transaction_type IN ('Debit', 'Withdrawal') THEN -amount 
            ELSE 0 
        END), 0.00) AS Transaction_Net_Balance

    FROM Transactions
    WHERE account_id = @Account_id;
END;
