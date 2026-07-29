CREATE OR ALTER PROC Fetchdetails 
    @Action VARCHAR(5),
    @Customerid INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Local variable definition
    DECLARE @Account_id INT;
    
    -- Fetch Account ID based on Customer ID
    SELECT @Account_id = Account_id 
    FROM Accounts 
    WHERE customer_id = @Customerid;

    -- D - Dashboard
    IF @Action = 'D'
    BEGIN
        SELECT First_Name, Last_Name, Email, Address, Account_id, Account_type 
        FROM Accounts a 
        JOIN Customers b ON a.customer_id = b.customer_id 
        WHERE a.Account_id = @Account_id;
    END
    -- A - AccountDetails
    ELSE IF @Action = 'A'
    BEGIN
        SELECT account_id, customer_id, a.branch_id, account_type, balance, opened_date, branch_name, city, state
        FROM Accounts a 
        JOIN Branches b ON a.branch_id = b.branch_id  
        WHERE a.Account_id = @Account_id;
    END
    -- T - Transaction
    ELSE IF @Action = 'T'
    BEGIN
        SELECT a.account_id, transaction_id, transaction_type, amount, transaction_date
        FROM Accounts a 
        JOIN Transactions b ON a.account_id = b.account_id 
        WHERE a.Account_id = @Account_id;
    END
    -- Handle invalid action codes (e.g., 'F')
    ELSE
    BEGIN
        RAISERROR('Invalid Action Code. Please use D, A, or T.', 16, 1);
    END
END;
