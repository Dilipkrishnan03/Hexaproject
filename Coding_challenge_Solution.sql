drop database if exists  CarRentalSystem ;
create database CarRentalSystem;
use CarRentalSystem;
drop table if exists Vehicle;
drop table if exists customer;
drop table if exists lease;
drop table if exists Payment;

 create table Vehicle
 (
	vehicleID  int auto_increment primary key ,
    make varchar(20),
    model varchar(20),
    year int(20),
    dailyRate numeric(9,2),
    status enum('1','0'),
    passengercapacity int,
    enginecapacity int
);

insert into Vehicle(make,model,year ,dailyRate ,status , passengerCapacity,  engineCapacity)
value('Toyota',' Camry',2022, 50.00, '1', 4 ,1450 ),
	('Honda', 'Civic', 2023, 45.00, '1', 7, 1500),
    ('Ford', 'Focus', 2022, 48.00 ,'0' ,4, 1400),
    ('Nissan',' Altima',2023, 52.00,'1', 7, 1200 ),
    ('Chevrolet', 'Malibu' ,2022 ,47.00,' 1', 4 ,1800),
    ('Hyundai', 'Sonata', 2023, 49.00, '0', 7, 1400 ),
    ('BMW', '3 Series',2023 ,60.00 ,'1', 7 ,2499),
   ( 'Mercedes',' C-Class', 2022, 58.00,' 1', 8 ,2599) ,
('Audi', 'A4' ,2022, 55.00, '0', 4, 2500 ),
(' Lexus', 'ES', 2023 ,54.00,' 1', 4 ,2500); 
    
create table Customer
(
CustomerID int auto_increment primary key ,
Firstname varchar(20),
Lastname varchar(20),
Email varchar(50),
Phonenumber varchar(20)
);
insert into Customer (firstName ,lastName, email, phoneNumber)
values  ('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
    ('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
    ('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
    ('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
    ('David', 'Lee', 'david@example.com', '555-987-6543'),
    ('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
    ('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
    ('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
    ('William', 'Taylor', 'william@example.com', '555-321-6547'),
    ('Olivia', 'Adams', 'olivia@example.com', '555-765-4321');
    

create table Lease
(
leaseID int auto_increment primary key,
vehicleID int ,
customerID int,
startDate date,
endDate date,
types enum('Daily','Monthly'),
FOREIGN KEY (vehicleID) references Vehicle(vehicleID),
foreign key(customerID) references Customer(customerID)
);
insert into Lease(vehicleID, customerID, startDate, endDate,types)
values (1, 1, '2023-01-01', '2023-01-05', 'Daily'),
    (2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
    (3, 3, '2023-03-10', '2023-03-15', 'Daily'),
    (4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
    (5, 5, '2023-05-05', '2023-05-10', 'Daily'),
    (4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
    (7, 7, '2023-07-01', '2023-07-10', 'Daily'),
    (8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
    (3, 3, '2023-09-07', '2023-09-10', 'Daily'),
    (10, 10, '2023-10-10', '2023-10-31', 'Monthly');
    
create  table Payment
(
	paymentID int auto_increment primary key,
    leaseID int,
    paymentDate date,
    amount numeric(9,2),
    foreign key (leaseID) references Lease(leaseID)
    
);
insert into payment(leaseID, paymentDate, amount)
values (1, '2023-01-03', 200.00),
    (2, '2023-02-20', 1000.00),
    (3, '2023-03-12', 75.00),
    (4, '2023-04-25', 900.00),
    (5, '2023-05-07', 60.00),
    (6, '2023-06-18', 1200.00),
    (7, '2023-07-03', 40.00),
    (8, '2023-08-14', 1100.00),
    (9, '2023-09-09', 80.00),
    (10, '2023-10-25', 1500.00);

select * from vehicle;
-- 1. Update the daily rate for a Mercedes car to 68. 
UPDATE vehicle SET dailyRate=68
WHERE vehicleId=8;

-- 2. Delete a specific customer and all associated leases and payments. 
DELETE FROM Payment 
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 3);

DELETE FROM Lease 
WHERE customerID = 3;

DELETE FROM Customer 
WHERE customerID =3;

-- 3. Rename the "paymentDate" column in the Payment table to "transactionDate". 
ALTER TABLE payment RENAME COLUMN paymentDate TO transactionDate;
-- 4. Find a specific customer by email. 
select * from customer where email ='laura@example.com';

-- 5. Get active leases for a specific customer. 
select lease.* , customer.customerID
from lease 
inner join customer on
lease.customerID = customer.customerID
where customer.customerID = 1; 

-- 6. Find all payments made by a customer with a specific phone number. 
select  p.* from Payment p
join Lease  l on p.leaseID = l.leaseID
join Customer c on l.customerID = c.customerID
where c.phoneNumber = '555-123-4567';

-- 7. Calculate the average daily rate of all available cars. 
select status,avg(dailyRate) from vehicle
where status = '1'
group by status;

-- 8. Find the car with the highest daily rate. 
select * from vehicle where dailyRate=(select max(dailyRate) from vehicle);

-- 9. Retrieve all cars leased by a specific customer. 
select p.* from payment p 
inner join lease l on p.leaseID=l.leaseID 
inner join customer c on l.customerID=c.customerID
where c.customerID='5';

-- 10. Find the details of the most recent lease. 
select *  from lease
order by startDate desc
limit 1;

-- 11. List all payments made in the year 2023. 
select * from payment where date_format(transactionDate,'%Y')='2023';

-- 12. Retrieve customers who have not made any payments. 

select c.* from customer c 
left join lease l on c.customerID=l.customerID
left join payment p on l.leaseID=p.leaseID
where p.paymentID is null;

-- 13. Retrieve Car Details and Their Total Payments. 
select v.*, SUM(p.amount) as TotalPayments
from vehicle v
join lease l on v.vehicleID = l.vehicleID
join payment p on l.leaseID = p.leaseID
group by v.vehicleID;

-- 14. Calculate Total Payments for Each Customer. 
select c.* ,sum(p.amount) from customer c
join lease l on c.customerID = l.customerID
join payment p on l.leaseID = p.leaseID
group by c.customerID;

-- 15. List Car Details for Each Lease. 
select l.leaseID, v.* from lease l
JOIN vehicle v ON l.vehicleID = v.vehicleID;

-- 16. Retrieve Details of Active Leases with Customer and Car Information. 
select l.leaseID, l.startDate, l.endDate, c.firstName, c.lastName, v.make, v.model, v.year, v.dailyRate
from lease l
inner join customer c on l.customerID = c.customerID
inner join  vehicle v on l.vehicleID = v.vehicleID
where l.endDate >= '2023-05-05'; 

-- 17. Find the Customer Who Has Spent the Most on Leases. 
select c.*, SUM(p.amount) as TotalSpent from customer c 
join lease l on c.customerID = l.customerID
join payment p on l.leaseID = p.leaseID
group by  c.customerID
order by  TotalSpent desc
limit 1;

-- 18. List All Cars with Their Current Lease Information. 
select v.*, l.startDate, l.endDate, c.* from vehicle v
left join  lease l on v.vehicleID = l.vehicleID and l.endDate >= '2023-02-15' 
left join customer c on l.customerID = c.customerID;






























