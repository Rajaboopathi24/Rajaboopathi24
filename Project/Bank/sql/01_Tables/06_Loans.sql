CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    loan_type VARCHAR(50),
    loan_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);