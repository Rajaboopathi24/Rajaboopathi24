CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    branch_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);