drop database if exists hms;
create database hms;
use hms;
drop table if exists Doctor_master;
drop table if exists Room_Master;
drop table if exists Patient_master;
drop table if exists room_allocation;

CREATE TABLE Doctor_Master (
    doctor_id VARCHAR(15) PRIMARY KEY,
    doctor_name VARCHAR(15) NOT NULL,
    dept VARCHAR(15) NOT NULL
);

INSERT INTO Doctor_Master (doctor_id, doctor_name, dept)
VALUES
('D0001','Ram','ENT'),
('D0002','Rajan','ENT'),
('D0003','Smita','Eye'),
('D0004','Bhavan','Surgery'),
('D0005','Sheela','Surgery'),
('D0006','Nethra','Surgery');

CREATE TABLE Room_Master (
    room_no VARCHAR(15) PRIMARY KEY,
    room_type VARCHAR(15) NOT NULL,
    status VARCHAR(15) NOT NULL
);

INSERT INTO Room_Master (room_no, room_type, status)
VALUES
('R0001','AC','occupied'),
('R0002','Suite','vacant'),
('R0003','NonAC','vacant'),
('R0004','NonAC','occupied'),
('R0005','AC','vacant'),
('R0006','AC','occupied');

CREATE TABLE Patient_Master (
    p_id VARCHAR(15) PRIMARY KEY,
    name VARCHAR(15) NOT NULL,
    age INT NOT NULL,
    weight INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    address VARCHAR(50) NOT NULL,
    phoneno VARCHAR(10) NOT NULL,
    disease VARCHAR(50) NOT NULL,
    doctor_id VARCHAR(15) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctor_Master(doctor_id)
);

INSERT INTO Patient_Master (p_id, name, age, weight, gender, address, phoneno, disease, doctor_id)
VALUES
('P0001','Gita', 35, 65, 'F','Chennai','9867145678','Eye Infection', 'D0003'),
('P0002','Ashish', 40, 70, 'M','Delhi','9845675678','Asthma', 'D0003'),
('P0003','Radha', 25, 60, 'F','Chennai','9867166678','Pain in heart', 'D0005'),
('P0004','Chandra', 28, 55, 'F','Bangalore','9978675567','Asthma', 'D0001'),
('P0005','Goyal', 42, 65, 'M','Delhi','8967533223','Pain in Stomach', 'D0004');

CREATE TABLE Room_Allocation (
    room_no VARCHAR(15) NOT NULL,
    p_id VARCHAR(15) NOT NULL,
    admission_date DATE NOT NULL,
    release_date DATE,
    FOREIGN KEY (room_no) REFERENCES Room_Master(room_no),
    FOREIGN KEY (p_id) REFERENCES Patient_Master(p_id)
);

INSERT INTO Room_Allocation (room_no, p_id, admission_date, release_date)
VALUES
('R0001','P0001','2016-10-15','2016-10-26'),
('R0002','P0002','2016-11-15','2016-11-26'),
('R0002','P0003','2016-12-01','2016-12-30'),
('R0004','P0001','2017-01-01','2017-01-30');
select * from Room_Allocation;
select * from Patient_Master;
--  1: Display the patients who were admitted in the month of january.
SELECT * FROM Room_Allocation
WHERE MONTH(admission_date)=1;

--  2: Display the female patient who is not suffering from ashma
 SELECT * FROM Patient_Master
 where gender='f' and not disease ='Asthma';
 
 --  3: Count the number of male and female patients.
SELECT gender,COUNT(*) FROM Patient_master
group by gender;

--  4: Display the patient_id,patient_name, doctor_id, doctor_name, room_no, room_type and admission_date.
SELECT p.p_id AS patient_id, p.name AS patient_name, d.doctor_id, d.doctor_name,
       r.room_no, r.room_type, ra.admission_date
FROM Patient_Master p
JOIN Doctor_Master d ON p.doctor_id = d.doctor_id
JOIN Room_Allocation ra ON p.p_id = ra.p_id
JOIN Room_Master r ON ra.room_no = r.room_no;

--  5: Display the room_no which was never allocated to any patient.
SELECT room_no FROM Room_master
WHERE room_no NOT IN (SELECT room_no FROM ROOM_ALLOCATION);

-- 6:  Display the room_no, room_type which are allocated more than once.
SELECT ra.room_no, rm.room_type
FROM Room_Allocation ra
JOIN Room_Master rm ON ra.room_no = rm.room_no
GROUP BY ra.room_no, rm.room_type
HAVING COUNT(ra.room_no) > 1;














