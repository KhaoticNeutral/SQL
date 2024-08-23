CREATE TABLE profession (
    prof_id INT PRIMARY KEY,
    profession VARCHAR(100) UNIQUE
);

CREATE TABLE zip_code (
    zip_code VARCHAR(4) PRIMARY KEY CHECK (LENGTH(zip_code) = 4),
    city VARCHAR(100),
    province VARCHAR(100)
);

CREATE TABLE status (
    status_id INT PRIMARY KEY,
    status VARCHAR(100)
);

CREATE TABLE interests (
    interest_id INT PRIMARY KEY,
    interest VARCHAR(100)
);

CREATE TABLE seeking (
    seeking_id INT PRIMARY KEY,
    seeking VARCHAR(100)
);

CREATE TABLE my_contacts (
    contact_id INT PRIMARY KEY,
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    gender VARCHAR(10),
    birthday DATE,
    prof_id INT,
    zip_code VARCHAR(4),
    status_id INT,
    FOREIGN KEY (prof_id) REFERENCES profession(prof_id),
    FOREIGN KEY (zip_code) REFERENCES zip_code(zip_code),
    FOREIGN KEY (status_id) REFERENCES status(status_id)
);

CREATE TABLE contact_interest (
    contact_id INT,
    interest_id INT,
    PRIMARY KEY (contact_id, interest_id),
    FOREIGN KEY (contact_id) REFERENCES my_contacts(contact_id),
    FOREIGN KEY (interest_id) REFERENCES interests(interest_id)
);

CREATE TABLE contact_seeking (
    contact_id INT,
    seeking_id INT,
    PRIMARY KEY (contact_id, seeking_id),
    FOREIGN KEY (contact_id) REFERENCES my_contacts(contact_id),
    FOREIGN KEY (seeking_id) REFERENCES seeking(seeking_id)
);

INSERT INTO zip_code (zip_code, city, province)
VALUES 
('1001', 'CityA1', 'ProvinceA'),
('1002', 'CityA2', 'ProvinceA'),
('2001', 'CityB1', 'ProvinceB'),
('2002', 'CityB2', 'ProvinceB'),
('3001', 'CityC1', 'ProvinceC'),
('3002', 'CityC2', 'ProvinceC'),
('4001', 'CityD1', 'ProvinceD'),
('4002', 'CityD2', 'ProvinceD'),
('5001', 'CityE1', 'ProvinceE'),
('5002', 'CityE2', 'ProvinceE'),
('6001', 'CityF1', 'ProvinceF'),
('6002', 'CityF2', 'ProvinceF'),
('7001', 'CityG1', 'ProvinceG'),
('7002', 'CityG2', 'ProvinceG'),
('8001', 'CityH1', 'ProvinceH'),
('8002', 'CityH2', 'ProvinceH'),
('9001', 'CityI1', 'ProvinceI'),
('9002', 'CityI2', 'ProvinceI');

INSERT INTO profession (prof_id, profession) VALUES
(1, 'Engineer'), (2, 'Doctor'), (3, 'Artist'), (4, 'Teacher');

INSERT INTO status (status_id, status) VALUES
(1, 'Single'), (2, 'Married'), (3, 'Divorced'), (4, 'Widowed');

INSERT INTO interests (interest_id, interest) VALUES
(1, 'Hiking'), (2, 'Reading'), (3, 'Cooking'), (4, 'Traveling');

INSERT INTO seeking (seeking_id, seeking) VALUES
(1, 'Friendship'), (2, 'Relationship'), (3, 'Networking');

INSERT INTO my_contacts (contact_id, last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
VALUES 
(1, 'Smith', 'John', '123-456-7890', 'john.smith@example.com', 'Male', '1980-01-15', 1, '1001', 1),
(2, 'Doe', 'Jane', '234-567-8901', 'jane.doe@example.com', 'Female', '1990-02-20', 2, '2001', 2),
(3, 'Johnson', 'Michael', '345-678-9012', 'michael.johnson@example.com', 'Male', '1985-03-12', 1, '3001', 1),
(4, 'Williams', 'Emily', '456-789-0123', 'emily.williams@example.com', 'Female', '1992-04-18', 3, '4002', 1),
(5, 'Brown', 'Christopher', '567-890-1234', 'christopher.brown@example.com', 'Male', '1987-05-25', 2, '5001', 2),
(6, 'Davis', 'Jessica', '678-901-2345', 'jessica.davis@example.com', 'Female', '1995-06-30', 4, '6002', 3),
(7, 'Miller', 'David', '789-012-3456', 'david.miller@example.com', 'Male', '1982-07-15', 1, '7001', 1),
(8, 'Wilson', 'Ashley', '890-123-4567', 'ashley.wilson@example.com', 'Female', '1993-08-22', 3, '8001', 4),
(9, 'Moore', 'Joshua', '901-234-5678', 'joshua.moore@example.com', 'Male', '1989-09-05', 2, '9002', 2),
(10, 'Taylor', 'Sarah', '012-345-6789', 'sarah.taylor@example.com', 'Female', '1996-10-10', 4, '1001', 1),
(11, 'Anderson', 'Daniel', '123-456-7890', 'daniel.anderson@example.com', 'Male', '1983-11-20', 1, '2001', 3),
(12, 'Thomas', 'Megan', '234-567-8901', 'megan.thomas@example.com', 'Female', '1991-12-12', 3, '3002', 1),
(13, 'Jackson', 'Matthew', '345-678-9012', 'matthew.jackson@example.com', 'Male', '1984-01-15', 2, '4001', 2),
(14, 'White', 'Olivia', '456-789-0123', 'olivia.white@example.com', 'Female', '1994-02-28', 4, '5002', 4),
(15, 'Harris', 'James', '567-890-1234', 'james.harris@example.com', 'Male', '1988-03-09', 1, '6001', 1);

INSERT INTO contact_interest (contact_id, interest_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 1), (3, 3), (3, 4),
(4, 2), (4, 3), (4, 1),
(5, 1), (5, 4), (5, 2),
(6, 2), (6, 3), (6, 4),
(7, 1), (7, 3), (7, 2),
(8, 2), (8, 4), (8, 1),
(9, 3), (9, 1), (9, 4),
(10, 1), (10, 2), (10, 3),
(11, 2), (11, 4), (11, 1),
(12, 3), (12, 4), (12, 1),
(13, 1), (13, 2), (13, 4),
(14, 2), (14, 3), (14, 4),
(15, 1), (15, 3), (15, 4);

INSERT INTO contact_seeking (contact_id, seeking_id) VALUES
(3, 1), (3, 3),
(4, 1), (4, 2),
(5, 2), (5, 3),
(6, 1), (6, 2),
(7, 2), (7, 3),
(8, 1), (8, 3),
(9, 1), (9, 2),
(10, 2), (10, 3),
(11, 1), (11, 2),
(12, 2), (12, 3),
(13, 1), (13, 3),
(14, 1), (14, 2),
(15, 2), (15, 3);

SELECT 
    mc.contact_id,
    mc.first_name,
    mc.last_name,
    mc.phone,
    mc.email,
    mc.gender,
    mc.birthday,
    p.profession,
    z.city,
    z.province,
    s.status,
    STRING_AGG(DISTINCT i.interest, ', ') AS interests,
    STRING_AGG(DISTINCT se.seeking, ', ') AS seeking
FROM 
    my_contacts mc
LEFT JOIN 
    profession p ON mc.prof_id = p.prof_id
LEFT JOIN 
    zip_code z ON mc.zip_code = z.zip_code
LEFT JOIN 
    status s ON mc.status_id = s.status_id
LEFT JOIN 
    contact_interest ci ON mc.contact_id = ci.contact_id
LEFT JOIN 
    interests i ON ci.interest_id = i.interest_id
LEFT JOIN 
    contact_seeking cs ON mc.contact_id = cs.contact_id
LEFT JOIN 
    seeking se ON cs.seeking_id = se.seeking_id
GROUP BY 
    mc.contact_id, mc.first_name, mc.last_name, mc.phone, mc.email, mc.gender, mc.birthday, p.profession, z.city, z.province, s.status
ORDER BY 
    mc.contact_id;