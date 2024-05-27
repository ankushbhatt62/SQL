-- Day3(1)

select customerNumber, customerName, state, creditLimit
from customers
where state is not null and (creditLimit between 50000 and 100000)
order by creditLimit desc;

-- Day3(2)
select productLine
from productLines
where productLine like "%cars";

-- Day4(1)
select orderNumber, status, coalesce(comments, '-') comments
from orders;

-- Day4(2)
select employeeNumber, firstName, jobTitle,
case
when jobTitle = 'President' then 'P'
when jobTitle like '%Manager%' then 'SM'
when jobTitle = 'Sales Rep' then 'SR'
when jobTitle like 'VP%' then 'VP'
end as JobTitle_abbr
from employees
order by jobTitle;

-- Day5(1)
select * from payments;
select year(paymentDate) year, min(amount) min_amount
from payments
group by year
order by year;

-- Day5(2)

select * from orders;
select year(orderDate) year, concat('Q', quarter(orderDate)) Quarter, count(distinct customerNumber) Unique_customers, count(orderNumber) as Total_orders
from orders
group by year, Quarter;

-- Day5(3)
select * from payments;
select monthname(PaymentDate) Month, concat(round(sum(amount)/1000,0),"K") Formatted_amount
from payments
group by month
HAVING 
    SUM(amount) BETWEEN 500000 AND 1000000
order by Formatted_amount desc;

-- Day6(1)
create table journey (
Bus_ID int not null,
Bus_Name varchar(40) not null,
Source_Station varchar(50) not null,
Destination varchar(60) not null,
Email varchar(80) unique
);

-- Day6(2)
create table vendor(
vendor_ID int primary key,
Name varchar(50) not null,
email varchar(60) unique,
country varchar(50) default 'N/A'
);

-- Day6(3)
create table movies (
movie_ID int primary key,
name varchar(50) not null,
Release_year date default '_',
cast varchar(50) not null,
gender enum('male', 'female') not null,
no_of_shows int check(no_of_shows>=0)
);

-- Day6(4)

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

-- Day 7(1)
select * from employees;
select * from customers;
select e.employeeNumber, concat(e.firstName, " ", e.lastName) sales_Person, count(distinct customerNumber) unique_customer
from employees e
join customers c 
on e.employeeNumber = c.salesRepEmployeeNumber
group by employeeNumber
order by unique_customer desc;

-- Day7(2)

select c.customerNumber, c.customerName, p.productcode, p.productName, od.quantityOrdered as Ordered_Qty, p.quantityInStock as Total_Inventory,
(p.quantityInStock - od.quantityOrdered) left_Qty
from customers c
join orders o using (customerNumber)
join orderdetails od using (orderNumber)
join products p using (productCode);

-- Day7(3)

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

-- Day7(4)

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

-- Day8
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

-- Day9

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

-- Day10

create view product_status as 
select year(orderDate) as year, 
concat(SUM(quantityOrdered),'(',CONCAT(ROUND(SUM(quantityOrdered) / SUM(SUM(quantityOrdered)) over() * 100), '%') ,')') as value
from orders
join orderdetails using (orderNumber)
group by year
order by year desc;

-- Day11(1)
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

-- Day11 (2)

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


-- Day12(1)
select * from orders;

with cte as(
select
 year(orderDate) as year, monthname(orderDate) as month, count(*) as total_orders
from orders
group by year, month)

select year, month, total_orders, concat(round(((total_orders-laging)/laging)*100,0),"%") as "%YOY_Change"
from(
select year, month, total_orders,
lag(total_orders) over() as laging
from cte) as final;

-- Day12(2)

create table emp_udf(
Emp_ID int,
Name varchar(50),
DOB date
);
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), 
("Aman", "1992-08-15"), 
("Meena", "1998-07-28"), 
("Ketan", "2000-11-21"), 
("Sanjay", "1995-05-21");


DELIMITER //
CREATE FUNCTION calculate_age(birth_date DATE)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE years INT;
  DECLARE months INT;
  DECLARE age VARCHAR(50);

  SELECT
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS years,
    TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) % 12 AS months
  INTO years, months;

  SET age = CONCAT(years, ' years ', months, ' months');
  RETURN age;
END //
DELIMITER ;

SELECT 
    emp_id, Name, dob, CALCULATE_AGE(DOB) AS Age
FROM
    emp_udf;
    
-- Day13 (1)
SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM Orders);

-- Day13(2)

SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION

SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
FROM Orders o
LEFT JOIN Customers c ON c.customerNumber = o.customerNumber
WHERE c.customerNumber IS NULL
GROUP BY c.customerNumber, c.customerName;

-- Day 13(3)


SELECT
  OrderNumber,
  MAX(quantityOrdered) AS SecondHighestQuantity
FROM (
  SELECT
    OrderNumber,
    quantityOrdered,
    RANK() OVER (PARTITION BY OrderNumber ORDER BY quantityOrdered DESC) AS rnk
  FROM OrderDetails
) AS ranked_data
WHERE rnk = 2
GROUP BY OrderNumber;

-- Day13(4)
select max(m) as Max_Total,
min(m) as Min_Total
from
(select orderNumber, count(productCode) m from orderdetails group by ordernumber) as subquery;

-- Day13(5)

select productLine, count(buyPrice) as total
from products
where buyPrice > (select avg(buyPrice) from products)
group by productLine
order by total desc;

-- Day14

create table Emp_EH (
EmpID int primary key auto_increment,
EmpName varchar(50),
EmailAddress varchar(80)
);

Delimiter // 
create procedure emp_EH(in fname varchar(50))
begin 
declare exit handler for sqlexception
select "Error Occured" message;
insert into Emp_EH(EmpName) values(fname);
end //
Delimiter ;

-- Day 15
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


