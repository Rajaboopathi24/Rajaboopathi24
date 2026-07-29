CREATE OR ALTER PROC usp_Savedetails 
    @Action CHAR(1),
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'C'
    BEGIN
        EXEC usp_SaveCustomerDetails @json = @json;
    END
    ELSE IF @Action = 'A'
    BEGIN
        EXEC usp_SaveAccountDetails @json = @json;
    END
    ELSE IF @Action = 'T'
    BEGIN
        EXEC usp_SaveTransactionDetails @json = @json;
    END
    ELSE IF @Action = 'L'
    BEGIN
        EXEC usp_SaveLoanDetails @json = @json;
    END
    ELSE
    BEGIN
        RAISERROR('Invalid Action Code. Please use C, A, T, or L.', 16, 1);
    END
END;
