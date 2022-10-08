-------------------
-- Tuan (Tony) Tran
-- Sep 18 2022
-- porfolio database
--------------------
-- CLI: docker exec pg_container pg_dump my_blog > job_posting.sql
-- CLI: cat ./porfolio_project/job_posting.sql | docker exec -i pg_container psql
-------------------------------------------------------------

-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'job_posting' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS job_posting;
CREATE DATABASE job_posting;
-- connect via psql
\c job_posting

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE users (
    id SERIAL,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    created_date DATE DEFAULT CURRENT_DATE, -- ?
    user_type TEXT,

    PRIMARY KEY (id)
);


CREATE TABLE contacts (
    id SERIAL,
    name TEXT UNIQUE NOT NULL,
    email TEXT,
    address TEXT,
    phone TEXT,
    company TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_user 
        FOREIGN KEY (id)
            REFERENCES users(id)
);

CREATE TABLE socials (
    id SERIAL,
    facebook TEXT,
    instagram TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_contact 
        FOREIGN KEY (id)
            REFERENCES contacts(id)

);

CREATE TABLE jobposts (
    id SERIAL,
    title TEXT NOT NULL,
    created_date DATE DEFAULT CURRENT_DATE, -- ?
    benifit TEXT,
    liked BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT fk_user 
        FOREIGN KEY (id)
            REFERENCES users(id)
);


CREATE TABLE descriptions (
    id SERIAL,
    requirement TEXT,
    experience TEXT,
    work_time TEXT,
    customer_type TEXT,
    area TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_jobpost
        FOREIGN KEY (id)
            REFERENCES jobposts(id)
);

-- INSERT DATA INTO TABLES
INSERT INTO users (username, password, user_type)
VALUES
    ('jdoe', 123456, 'Job-Seeker' ),
    ('ana', 4567899, 'Employer');

INSERT INTO contacts (name, email, address, phone, company)
VALUES
    ('John Doe', 'jdoe@gmail.com', '1234 T street, CA 92133', '619-397-4855', 'Lucky Nails'),
    ('Ana Van', 'Ana@gmail.com', '6789 AT street, CA 92138', '858-397-4855', 'Beautiful Nails');


INSERT INTO socials ( facebook, instagram)
VALUES
    ('facebook.com/luckynails', 'instagram.com/luckynails'),
    ('facebook.com/beautifulnails', 'instagram.com/beautifulnails');



INSERT INTO jobposts ( title, benifit )
VALUES
    ('Can Tho Nail', '$50K/year'),
    ('Experience Nail Tech', '$60K/year and Health Benifit');

INSERT INTO descriptions ( requirement, experience, work_time, customer_type, area)
VALUES
    ('Mani and Pedi', '1 year', 'Full Time', 'High income', 'Delmar Height'),
    ('Artifical', '3 years', 'Part Time', 'Young', 'College');
