CREATE TABLE Department (
    depart_id INT PRIMARY KEY,
    depart_name VARCHAR(100),
    depart_city VARCHAR(100)
);

CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role VARCHAR(100)
);

CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    salary_pa DECIMAL(10, 2)
);

CREATE TABLE Overtime_Hours (
    overtime_id INT PRIMARY KEY,
    overtime_hours INT
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    depart_id INT,
    role_id INT,
    salary_id INT,
    overtime_id INT,
    first_name VARCHAR(100),
    surname VARCHAR(100),
    gender VARCHAR(10),
    address VARCHAR(255),
    email VARCHAR(100),
    FOREIGN KEY (depart_id) REFERENCES Department(depart_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (salary_id) REFERENCES Salaries(salary_id),
    FOREIGN KEY (overtime_id) REFERENCES Overtime_Hours(overtime_id)
);

INSERT INTO Department (depart_id, depart_name, depart_city)
VALUES 
(1, 'Human Resources', 'New York'),
(2, 'IT', 'San Francisco');

INSERT INTO Roles (role_id, role)
VALUES 
(1, 'Manager'),
(2, 'Developer');

INSERT INTO Salaries (salary_id, salary_pa)
VALUES 
(1, 80000),
(2, 100000);

INSERT INTO Overtime_Hours (overtime_id, overtime_hours)
VALUES 
(1, 10),
(2, 15);

INSERT INTO Employees (emp_id, depart_id, role_id, salary_id, overtime_id, first_name, surname, gender, address, email)
VALUES 
(1, 1, 1, 1, 1, 'John', 'Doe', 'Male', '123 Main St', 'john.doe@example.com'),
(2, 2, 2, 2, 2, 'Jane', 'Smith', 'Female', '456 Elm St', 'jane.smith@example.com');

--shows it doesn't work

INSERT INTO Employees (emp_id, depart_id, role_id, salary_id, overtime_id, first_name, surname, gender, address, email)
VALUES (3, 3, 1, 1, 1, 'Alice', 'Brown', 'Female', '789 Oak St', 'alice.brown@example.com')

--showing tables

SELECT * FROM Employees;

SELECT * FROM department;

SELECT * FROM overtime_hours;

SELECT * FROM roles;

SELECT * FROM salaries;

