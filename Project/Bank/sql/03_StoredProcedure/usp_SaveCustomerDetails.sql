CREATE OR ALTER PROC usp_SaveCustomerDetails 
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #Temp_Customers (
        customer_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        dob DATE,
        phone VARCHAR(15),
        email VARCHAR(100),
        address VARCHAR(255)
    );

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
END;
