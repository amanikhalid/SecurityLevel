 ## Enforcing Schema-Level Access in a Company Database
 ### Objectives:

 #### 1. Create SQL logins and map them to users inside the database.
 ```sql
-- Step 1: Create the database
CREATE DATABASE CompanyDB;

-- Use the new database
USE CompanyDB

-- Create login and user for HR department
CREATE LOGIN hr_login WITH PASSWORD = 'Hr@2299';
CREATE USER hr_user FOR LOGIN hr_login;

-- Create login and user for Sales department
CREATE LOGIN sales_login WITH PASSWORD = 'Sales@2299';
CREATE USER sales_user FOR LOGIN sales_login;
```

![CreatedCompanyDatabase Output](./image/CompanyDB.png)

![SQLLogins Output](./image/SQL_Logins.png)

![Logins_SS Output](./image/Logins.png)

------------------

#### 2. Create two schemas: HR and Sales
 ```sql
-- Create HR schema
CREATE SCHEMA HR;

-- Create Sales schema
CREATE SCHEMA Sales;
```
![HRandSalesSchema Output](./image/HRSalesSchemas.png)

------------------

#### 3. Create a few sample tables inside each schema.
 ```sql
-- HR.Employees table
CREATE TABLE HR.Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Position NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);

-- HR.Departments table
CREATE TABLE HR.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100),
    ManagerID INT
);

-- Sales.Customers table
CREATE TABLE Sales.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Email NVARCHAR(100),
    Region NVARCHAR(50)
);

-- Sales.Orders table
CREATE TABLE Sales.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Sales.Customers(CustomerID)
);
```
![CreatedTableInsideSchema Output](./image/TableInsideSchema.png)

--------------

### Assign schema-level permissions so:

- HR users cannot access Sales data.
```sql
-- Give HR user full access to HR schema
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::HR TO hr_user;

-- Prevent HR user from accessing Sales schema
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO hr_user;
```
![HR_Permissions Output](./image/HRPermissions.png)

- Sales users cannot access HR data.
```sql
-- Give Sales user full access to Sales schema
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO sales_user;

-- Prevent Sales user from accessing HR schema
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::HR TO sales_user;
```

![Sales_Permissions Output](./image/SalesPermissions.png)

-------------------

#### Task Output Checklist

#### Try to:

- Connect as hr_login and access HR.Employees
![AccessToHRTable Output](./image/AccessToHRTable.png)

- Try to access Sales.Customers
![CannotAccessToHRTable Output](./image/CannotAccessToHR.png)



#### 3. Write a short explanation:
**Why schema-level security is better than table-by-table permissions**
Despite table-by-table permissions require access to each table individually and apply permissions to the entire schema, schema-level security enables permission management at the schema level rather than individual tables.

**How this setup supports data segregation in real-world companies**
By limiting access to each department's data, this configuration guards against illegal access and preserves data integrity.  It makes it possible to clearly separate concerns, which is essential in settings like sales and human resources where sensitive data is handled.

-------------------
## Reflection Report Instructions

### Understanding SQL Security Levels and Real-World Risks
**1. Server-Level Login**
A server-level login connects a user or application to a SQL Server instance, allowing entry into the system using SQL or Windows Authentication.

**2. Database-Level User**
A database user, created using CREATE USER, is a server login that grants access to a specific database, allowing interaction with specific schemas and tables.

**3. Schema-Level Permissions**
A schema is a logical container for database objects, with schema-level permissions allowing or denying access to all within it, making it more efficient than assigning permissions to individual objects.

**4. Object-Level Permissions**
This method controls access to individual objects, such as tables or views, but is more granular and harder to maintain for large systems.


### Benefits of Applying Security Levels 
Layered security in SQL Server offers control, protection, and accountability within a database environment.

**1. Restrict Sensitive Data**
Sensitive data like employee salaries and financial transactions should be restricted to authorized roles through schema-level or object-level security.

**2. Prevent Unauthorized Changes**
Security levels restrict access to critical data, preventing unauthorized modifications. Junior developers are assigned read-only roles to view sales data without modification.

**3. Reduce Human Error**
The principle of least privilege ensures users have access to only what they need, reducing the risk of accidental data deletion or alteration.