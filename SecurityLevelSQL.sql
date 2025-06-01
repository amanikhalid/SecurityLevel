-- Step 1: Create the database
CREATE DATABASE CompanyDB;

-- Use the new database
USE CompanyDB

-- Create login and user for HR department
CREATE LOGIN hr_login WITH PASSWORD = 'Hr@2299';
CREATE USER hr_user FOR LOGIN hr_login;

