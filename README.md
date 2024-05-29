1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

●	State should not contain null values
●	credit limit should be between 50000 and 100000

ans:
select customerNumber, customerName, state, creditLimit
from customers
where state is not null and (creditLimit between 50000 and 100000)
order by creditLimit desc;


2)	Show the unique productline values containing the word cars at the end from products table.

ans:
select productLine
from productLines
where productLine like "%cars";

3)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.

ans:
   select orderNumber, status, coalesce(comments, '-') comments
from orders;


4)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”

ans:
select employeeNumber, firstName, jobTitle,
case
when jobTitle = 'President' then 'P'
when jobTitle like '%Manager%' then 'SM'
when jobTitle = 'Sales Rep' then 'SR'
when jobTitle like 'VP%' then 'VP'
end as JobTitle_abbr
from employees
order by jobTitle;


5)	For every year, find the minimum amount value from payments table.

   ans:
   select year(paymentDate) year, min(amount) min_amount
from payments
group by year
order by year;


6)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.

ans:
select year(orderDate) year, concat('Q', quarter(orderDate)) Quarter, count(distinct customerNumber) Unique_customers, count(orderNumber) as Total_orders
from orders
group by year, Quarter;

7)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000.
   Sort the output by total amount in descending mode. [ Refer. Payments Table]

ans:
select monthname(PaymentDate) Month, concat(round(sum(amount)/1000,0),"K") Formatted_amount
from payments
group by month
HAVING 
    SUM(amount) BETWEEN 500000 AND 1000000
order by Formatted_amount desc;


8)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)

ans:
create table journey (
Bus_ID int not null,
Bus_Name varchar(40) not null,
Source_Station varchar(50) not null,
Destination varchar(60) not null,
Email varchar(80) unique
);


9)	Create vendor table with following fields and constraints.

●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)

ans:
create table vendor(
vendor_ID int primary key,
Name varchar(50) not null,
email varchar(60) unique,
country varchar(50) default 'N/A'
);


10)	Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)

ans:
create table movies (
movie_ID int primary key,
name varchar(50) not null,
Release_year date default '_',
cast varchar(50) not null,
gender enum('male', 'female') not null,
no_of_shows int check(no_of_shows>=0)
);


11)	Create the following tables. Use auto increment wherever applicable

a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock


ans:
-- a
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(500),
    supplier_id INT,
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id)
);

-- b
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    location VARCHAR(50)
);

-- c
CREATE TABLE stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    FOREIGN KEY (product_id)
        REFERENCES product (product_id),
    balance_stock INT
);


12)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers

ans:
select * from employees;
select * from customers;
select e.employeeNumber, concat(e.firstName, " ", e.lastName) sales_Person, count(distinct customerNumber) unique_customer
from employees e
join customers c 
on e.employeeNumber = c.salesRepEmployeeNumber
group by employeeNumber
order by unique_customer desc;


13) show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.

Tables: Customers, Orders, Orderdetails, Products


ans:
select c.customerNumber, c.customerName, p.productcode, p.productName, od.quantityOrdered as Ordered_Qty, p.quantityInStock as Total_Inventory,
(p.quantityInStock - od.quantityOrdered) left_Qty
from customers c
join orders o using (customerNumber)
join orderdetails od using (orderNumber)
join products p using (productCode);

14)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.

ans:
create table Laptop (
laptopName varchar(50)
);
insert into laptop values ('Dell'),('HP');

create table colours(
colourName varchar(50)
);
insert into colours values ('White'), ('Silver'), ('Black');

select laptopName , colourName
from laptop
cross join colours;


15)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.


ans:
create table project(
EmployeeID int ,
Name varchar(50),
Gender varchar(50),
ManagerID int 
);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select * from project;
select m.Name as ManagerName, e.Name as EmpName
from Project m
join Project e
on e.ManagerID = m.EmployeeID
order by ManagerName;


16) Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.


ans:
create table facility(
Facility_ID int,
Name varchar(50),
State varchar(50),
country varchar(50)
);
-- 1
alter table facility add constraint primary key auto_increment (Facility_ID);
-- 2
alter table facility add column city varchar(100) not null after Name;


17) Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.


ans:
create table university (
ID int ,
Name varchar(80)
);

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
              
set sql_Safe_Updates= 0;

UPDATE university 
SET 
    name = trim(REPLACE(name, '  ', ' '));

select * from university;


18)1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000

2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments

(1)
delimiter //
CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT)
BEGIN
  DECLARE customerCreditLimit DECIMAL(10, 2);

  SELECT creditLimit INTO customerCreditLimit
  FROM CustomersGetCustomerLevel
  WHERE customerNumber = customerNumber;

  IF customerCreditLimit > 100000 THEN
    SELECT 'Platinum' AS CustomerLevel;
  ELSEIF customerCreditLimit BETWEEN 25000 AND 100000 THEN
    SELECT 'Gold' AS CustomerLevel;
  ELSE
    SELECT 'Silver' AS CustomerLevel;
  END IF;

END //

DELIMITER ;

 (2)

DELIMITER //

CREATE PROCEDURE Get_country_payments(IN p_Year INT, IN p_Country VARCHAR(255))
BEGIN
  SELECT 
    YEAR(p.PaymentDate) AS Year,
    c.Country,
    CONCAT(FORMAT(SUM(p.Amount) / 1000, 0), 'K') AS TotalAmount
  FROM Payments p 
  JOIN Customers c ON P.customerNumber = C.customerNumber
  WHERE YEAR(p.PaymentDate) = p_Year AND c.Country = p_Country
  GROUP BY Year, c.Country;
END //

DELIMITER ;


19)Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.


ans:
CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
  IF NEW.Working_hours < 0 THEN
    SET NEW.Working_hours = -NEW.Working_hours;
  END IF;
END //

DELIMITER ;






