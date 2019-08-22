-- Table1:: Admins
CREATE TABLE ADMINS 
(
Admin_Id int IDENTITY(1,1) PRIMARY KEY,
Admin_UserName varchar(50) NOT NULL,
Admin_Password varchar(50) NOT NULL,
Admin_joinningTimeAndDate datetime NOT NULL,
)

-- Table2:: Admins_Personal_Info
CREATE TABLE ADMINS_PERSONAL_INFO
(
Admin_PId int IDENTITY(1,1) PRIMARY KEY,
Admin_Id int NOT NULL FOREIGN KEY REFERENCES ADMINS (Admin_Id),
Admin_FirstName varchar(50) NOT NULL,
Admin_LastName varchar(50) NOT NULL,
Admin_Gender varchar(10) NOT NULL,
Admin_DOB datetime NOT  NULL,
)

-- Table3:: Admins_Contact_Info
CREATE TABLE ADMINS_CONTACT_INFO
(
Admin_CId int IDENTITY(1,1) PRIMARY KEY,
Admin_Id int NOT NULL FOREIGN KEY REFERENCES ADMINS (Admin_Id),
Admin_Phone varchar(20) NOT NULL,
Admin_Email varchar(100) NOT NULL,
Admin_Address varchar(150) NOT NULL,
)

-- Table4:: Supplier
CREATE TABLE SUPPLIER
(
Supplier_Id int IDENTITY(1,1) PRIMARY KEY,
Supplier_UserName varchar(50) NOT NULL,
Supplier_Password varchar(50) NOT NULL,
Supplier_joinningTimeAndDate datetime NOT NULL,
)

-- Table5:: Supplier_Personal_Info
CREATE TABLE SUPPLIER_PERSONAL_INFO
(
Supplier_PId int IDENTITY(1,1) PRIMARY KEY,
Supplier_Id int NOT NULL FOREIGN KEY REFERENCES SUPPLIER (Supplier_Id),
Supplier_FirstName varchar(50) NOT NULL,
Supplier_LastName varchar(50) NOT NULL,
Supplier_Gender varchar(10) NOT NULL,
Supplier_DOB datetime NOT  NULL,
)

-- Table6:: Supplier_Contact_Info
CREATE TABLE SUPPLIER_CONTACT_INFO
(
Supplier_CId int IDENTITY(1,1) PRIMARY KEY,
Supplier_Id int NOT NULL FOREIGN KEY REFERENCES SUPPLIER (Supplier_Id),
Supplier_Phone varchar(20) NOT NULL,
Supplier_Email varchar(100) NOT NULL,
Supplier_Address varchar(150) NOT NULL,
)

-- Table7:: Customer
CREATE TABLE CUSTOMER
(
Customer_Id int IDENTITY(1,1) PRIMARY KEY,
Customer_UserName varchar(50) NOT NULL,
Customer_Password varchar(50) NOT NULL,
Customer_joinningTimeAndDate datetime NOT NULL,
)

-- Table8:: Customer_Personal_Info
CREATE TABLE CUSTOMER_PERSONAL_INFO
(
Customer_PId int IDENTITY(1,1) PRIMARY KEY,
Customer_Id int NOT NULL FOREIGN KEY REFERENCES CUSTOMER (Customer_Id),
Customer_FirstName varchar(50) NOT NULL,
Customer_LastName varchar(50) NOT NULL,
Customer_Gender varchar(10) NOT NULL,
Customer_DOB datetime NOT  NULL,
)

-- Table9:: Customer_Contact_Info
CREATE TABLE CUSTOMER_CONTACT_INFO
(
Customer_CId int IDENTITY(1,1) PRIMARY KEY,
Customer_Id int NOT NULL FOREIGN KEY REFERENCES CUSTOMER (Customer_Id),
Customer_Phone varchar(20) NOT NULL,
Customer_Email varchar(100) NOT NULL,
Customer_Address varchar(150) NOT NULL,
)

-- Table10:: Product
CREATE TABLE PRODUCT
(
Product_Id int IDENTITY(1,1) PRIMARY KEY,
Product_Name varchar(50) NOT NULL,
Product_Image varchar(100) NOT NULL,
Product_Description varchar(250) NOT NULL,
Product_Price money NOT NULL,
Product_Quantity int NOT NULL,
)

-- Table11:: Supplies
CREATE TABLE SUPPLIES(
Supply_Id int IDENTITY(1,1) PRIMARY KEY,
Supplier_Id int NOT NULL FOREIGN KEY REFERENCES SUPPLIER (Supplier_Id),
Product_Id int NOT NULL FOREIGN KEY REFERENCES PRODUCT (Product_Id),
Product_Category varchar(20) NOT NULL,
Product_UploadTimeAndDate datetime NOT NULL,
)

-- Table12:: Orders
CREATE TABLE ORDERS
(
Order_Id int IDENTITY(1,1) PRIMARY KEY,
Order_Details varchar(250) NOT NULL,
)

-- Table13:: Chosen_For
CREATE TABLE CHOSEN_FOR
(
Chosen_Id int IDENTITY(1,1) PRIMARY KEY,
Product_Id int NOT NULL FOREIGN KEY REFERENCES PRODUCT (Product_Id),
Order_Id int NOT NULL FOREIGN KEY REFERENCES ORDERS (Order_Id),
Quantity int NOT NULL,
)

-- Table14:: Gives
CREATE TABLE GIVES
(
Give_Id int IDENTITY(1,1) PRIMARY KEY,
Customer_Id int NOT NULL FOREIGN KEY REFERENCES CUSTOMER (Customer_Id),
Order_Id int NOT NULL FOREIGN KEY REFERENCES ORDERS (Order_Id),
OrderTimeAndDate datetime NOT NULL,
Price money NOT NULL,
)

-- Table15:: Take_Care_Of
CREATE TABLE TAKE_CARE_OF
(
TakeCare_Id int IDENTITY(1,1) PRIMARY KEY,
Admin_Id int NOT NULL FOREIGN KEY REFERENCES ADMINS (Admin_Id),
Order_Id int NOT NULL FOREIGN KEY REFERENCES ORDERS (Order_Id),
Order_Status varchar(10) NOT NULL,
)





-- CUSTOMER

-- ?? See all the products of category cloths
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT WHERE Product_Id IN
(SELECT Product_Id FROM SUPPLIES WHERE Product_Category = 'cloth')

-- ?? Find the oneplus 6 mobile
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT WHERE Product_Name LIKE '%Oneplus 6%'

-- ?? List all the laptops price between 40000-60000
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT WHERE Product_Id IN 
(SELECT Product_Id FROM SUPPLIES WHERE Product_Category = 'laptop') AND Product_Price BETWEEN 40000 AND 60000

-- ?? Find the recent uploaded products
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT JOIN SUPPLIES ON PRODUCT.Product_Id = SUPPLIES.Product_Id ORDER BY Product_UploadTimeAndDate DESC

-- ?? Find the 10 top expensive mobile
SELECT TOP 10 Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT JOIN SUPPLIES ON PRODUCT.Product_Id = SUPPLIES.Product_Id WHERE Product_Category = 'mobile' ORDER BY Product_Price DESC

-- ?? Find the products of supplier named Karim Hasan
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT WHERE Product_Id IN 
(SELECT Product_Id FROM SUPPLIES WHERE Supplier_Id IN 
(SELECT Supplier_Id FROM SUPPLIER_PERSONAL_INFO WHERE Supplier_FirstName = 'Karim' AND Supplier_LastName = 'HASAN'))

-- ?? Find the phone number, email and address of the supplier who supplied the product which id is 7 and name is samsung galaxy s9
SELECT Supplier_Phone, Supplier_Email, Supplier_Address FROM SUPPLIER_CONTACT_INFO WHERE Supplier_Id IN
(SELECT Supplier_Id FROM SUPPLIES WHERE Product_Id IN (SELECT Product_Id FROM PRODUCT WHERE
Product_Id = 2 AND Product_Name = 'Samsung Galaxy S9'))

-- ?? Find the products of new supplier
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT JOIN SUPPLIES ON PRODUCT.Product_Id = SUPPLIES.Product_Id 
JOIN SUPPLIER ON SUPPLIES.Supplier_Id = SUPPLIER.Supplier_Id 
ORDER BY Supplier_joinningTimeAndDate DESC





-- SUPPLIER

-- ?? Delete the products you uploaded before 30/09/2017
DELETE FROM PRODUCT where Product_Id IN (SELECT Product_Id FROM SUPPLIES WHERE Product_UploadTimeAndDate < '2017-10-01')
-- ?? Update the quantity to 40 of iphone X
UPDATE PRODUCT set Product_Quantity=40 where Product_Name='iphone X'

-- ?? Show the name, phone, email, address of the customers who ordered the mac airbook 2
SELECT Customer_FirstName + Customer_LastName AS 'Customer Name', Customer_Phone, Customer_Email, Customer_Address 
FROM CUSTOMER_PERSONAL_INFO JOIN CUSTOMER_CONTACT_INFO 
ON CUSTOMER_PERSONAL_INFO.Customer_Id = CUSTOMER_CONTACT_INFO.Customer_Id 
WHERE CUSTOMER_PERSONAL_INFO.Customer_Id IN (SELECT Customer_Id FROM GIVES WHERE Order_Id IN 
(SELECT Order_Id FROM CHOSEN_FOR WHERE Product_Id IN(SELECT Product_Id 
FROM PRODUCT WHERE Product_Name = 'Mac Airbook 2')))

-- ?? Show the names of customers with product names who ordered at 27/09/2018
SELECT Customer_FirstName + Customer_LastName AS 'Customer Name', Product_Name AS 'Product Name' 
FROM CUSTOMER_PERSONAL_INFO, PRODUCT where CUSTOMER_PERSONAL_INFO.Customer_Id IN 
(SELECT Customer_Id FROM GIVES WHERE OrderTimeAndDate < '2018-09-28' AND OrderTimeAndDate > '2018-09-26')
AND Product_Id IN (SELECT Product_Id FROM CHOSEN_FOR 
WHERE Order_Id IN (SELECT Order_Id FROM GIVES WHERE Customer_Id IN(SELECT Customer_Id FROM GIVES 
WHERE OrderTimeAndDate < '2018-09-28' AND OrderTimeAndDate > '2018-09-26'))) 

-- ?? Find the products that have supplied by Rahim Hasan and products name starts with K
SELECT Product_Name, Product_Image, Product_Description, Product_Price, Product_Quantity 
FROM PRODUCT JOIN SUPPLIES ON PRODUCT.Product_Id = SUPPLIES.Product_Id 
WHERE Supplier_Id IN (SELECT Supplier_Id FROM SUPPLIER_PERSONAL_INFO 
WHERE Supplier_FirstName = 'Rahim' AND Supplier_LastName = 'Hasan')
AND Product_Name LIKE 'K%'

-- ?? List top 5 customers full name who ordered the highest amount
SELECT TOP 5 Customer_FirstName + Customer_LastName AS 'Full Name' FROM CUSTOMER_PERSONAL_INFO
JOIN GIVES ON CUSTOMER_PERSONAL_INFO.Customer_Id = GIVES.Customer_Id ORDER BY Price DESC

-- ?? Find the name, phone, email, address of customers who order products of average price
SELECT Customer_FirstName + Customer_LastName AS 'Customer Name', Customer_Phone, Customer_Email, Customer_Address 
FROM CUSTOMER_PERSONAL_INFO JOIN CUSTOMER_CONTACT_INFO 
ON CUSTOMER_PERSONAL_INFO.Customer_Id = CUSTOMER_CONTACT_INFO.Customer_Id 
WHERE CUSTOMER_PERSONAL_INFO.Customer_Id IN (SELECT Customer_Id FROM GIVES WHERE Price IN (SELECT AVG(Price) FROM GIVES))

-- ?? Find the customers first name who live in Dhaka
SELECT Customer_FirstName FROM CUSTOMER_PERSONAL_INFO WHERE Customer_Id IN(
SELECT Customer_Id FROM CUSTOMER_CONTACT_INFO WHERE Customer_Address LIKE '%Dhaka%')

-- ?? Find the full name of male customers
SELECT Customer_FirstName + Customer_LastName AS 'Customer Name' FROM CUSTOMER_PERSONAL_INFO WHERE Customer_Gender = 'male'

-- ?? Find the customers with all the information who ordered mobiles
SELECT CUSTOMER_PERSONAL_INFO.Customer_Id, Customer_CId, Customer_PId, Customer_FirstName, Customer_LastName,
Customer_Gender, Customer_DOB, Customer_Phone, Customer_Email, Customer_Address FROM CUSTOMER_PERSONAL_INFO JOIN CUSTOMER_CONTACT_INFO ON CUSTOMER_PERSONAL_INFO.Customer_Id = 
CUSTOMER_CONTACT_INFO.Customer_Id WHERE CUSTOMER_PERSONAL_INFO.Customer_Id IN (SELECT Customer_Id FROM GIVES WHERE Order_Id IN(
SELECT Order_Id FROM CHOSEN_FOR WHERE Product_Id IN (SELECT Product_Id FROM SUPPLIES WHERE Product_Category = 'Mobile')))





-- ADMIN

-- ?? Kick out the supplier name Sabbir Hossain and id 5
DELETE FROM SUPPLIER where Supplier_Id IN 
(SELECT Supplier_Id FROM SUPPLIER_PERSONAL_INFO WHERE Supplier_FirstName = 'Sabbir' AND Supplier_LastName = 'Hossain' AND Supplier_Id = 5)

-- ?? Remove the last upoaded product of supplier id 15
DELETE FROM PRODUCT WHERE Product_Id IN(SELECT TOP 1 Product_Id FROM SUPPLIES WHERE Supplier_Id = 15 
ORDER BY Product_UploadTimeAndDate DESC)

-- ?? Kick out the customer who ordered last
DELETE FROM CUSTOMER WHERE Customer_Id IN(SELECT TOP 1 Customer_Id FROM GIVES ORDER BY OrderTimeAndDate DESC)

-- ?? Cancel the order id 25
UPDATE TAKE_CARE_OF set Order_Status = 'Cancel' where Order_Id = 25

-- ?? Cancel all the orders of date 08/10/2018
UPDATE TAKE_CARE_OF set Order_Status = 'cancel' where Order_Id IN (SELECT Order_Id FROM GIVES WHERE OrderTimeAndDate < '2018-10-09' AND OrderTimeAndDate > '2018-10-07')

-- ?? Remove all the orders of customer name Mahmudur Rahman
DELETE FROM ORDERS WHERE Order_Id IN(SELECT Order_Id FROM GIVES WHERE Customer_Id IN(
SELECT Customer_Id FROM CUSTOMER_PERSONAL_INFO WHERE Customer_FirstName = 'Mahmudur' AND Customer_LastName = 'Rahman')

-- ?? Find the suppliers name, phone, email, address who have supplied more than 50 products
SELECT Supplier_FirstName + Supplier_LastName AS 'Supplier Name', Supplier_Phone, Supplier_Email, Supplier_Address 
FROM SUPPLIER_PERSONAL_INFO JOIN SUPPLIER_CONTACT_INFO 
ON SUPPLIER_PERSONAL_INFO.Supplier_Id = SUPPLIER_CONTACT_INFO.Supplier_Id JOIN SUPPLIES ON SUPPLIER_CONTACT_INFO.Supplier_Id = SUPPLIES.Supplier_Id WHERE (SELECT COUNT(*) FROM SUPPLIES GROUP BY Supplier_Id) > 50

-- ?? Kick out the suppliers who joined before 10/10/2018 but still didn’t supply any products
DELETE FROM SUPPLIER WHERE Supplier_joinningTimeAndDate < '2017-10-10' AND Supplier_Id IN(SELECT Supplier_Id FROM SUPPLIES WHERE (SELECT COUNT(*) FROM SUPPLIES GROUP BY Supplier_Id) = 0)

-- ?? Find out the suppliers of Dhaka
SELECT * FROM SUPPLIER_PERSONAL_INFO WHERE Supplier_Id IN (SELECT Supplier_Id FROM SUPPLIER_CONTACT_INFO WHERE Supplier_Address = '%Dhaka%')

-- ?? Find out the suppliers every information who supply computers
SELECT SUPPLIER_PERSONAL_INFO.Supplier_Id, Supplier_CId, Supplier_PId, Supplier_FirstName, Supplier_LastName,
Supplier_Gender, Supplier_DOB, Supplier_Phone, Supplier_Email, Supplier_Address FROM SUPPLIER_PERSONAL_INFO JOIN SUPPLIER_CONTACT_INFO ON SUPPLIER_PERSONAL_INFO.Supplier_Id = SUPPLIER_CONTACT_INFO.Supplier_Id WHERE SUPPLIER_PERSONAL_INFO.Supplier_Id IN(
SELECT Supplier_Id FROM SUPPLIES WHERE Product_Category = 'Computers')

