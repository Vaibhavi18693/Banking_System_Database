INSERT INTO Person VALUES (1,'Manish','Kamani',9869690409,'manish.kamani@gmail.com','212 Germain Street','1962-12-05',55,'Male');
INSERT INTO Person VALUES (2,'Parshva','Shah',8577897468,'shah.parshva@gmail.com','413 75 Peterborough Street','1993-06-05',24,'Female');
INSERT INTO Person VALUES (3,'Henah','Montey',9872546874,'henah.montey@gmail.com','9 Newbury Street','1982-09-15',35,'Female');
INSERT INTO Person VALUES (4,'Khushali','Mehta',31280587456,'mehta.khush@gmail.com','89 Mission Main','1953-08-18',64,'Female');
INSERT INTO Person VALUES (5,'Harsh','Jain',8577897468,'jain.Harsh@gmail.com','56 Gainsborough Street','1961-05-05',56,'Male');
INSERT INTO Person Values (6,'Varsha','Kulkarni',61774377489,'kulkarni.varsha@gmail.com','45 Smith Street','1984-02-24',33,'Female');
INSERT INTO Person VALUES (7,'Parth','Shah',8747458967,'shah.parth@gmail.com','23 Stephen Street','1982-11-25',35,'Male');
INSERT INTO Person VALUES (8,'Kaushal','Dedhia',8797458647,'dedhia.kaushal@gmail.com','14 Huntington Ave','1977-05-15',40,'Male');
INSERT INTO Person VALUES (9,'Viren','Gala',6177457896,'gala.viren@gmail.com','23 Stephen Street','1982-07-11',35,'Male');
INSERT INTO Person VALUES (10,'Krunal','Rambhia',8748567489,'rambhia.Krunal@gmail.com','12 Germain Street','1985-09-12',32,'Male');
INSERT INTO Person VALUES (11,'Amar','Desai',6178547823,'desai.amar@gmail.com','74 Longwood Ave','1988-06-09',29,'Male');
INSERT INTO Person VALUES (12,'Rahanik','Joshi',8577537486,'joshi.raha@gmail.com','02 Hemenway Street','1960-08-26',57,'Male');
INSERT INTO Person VALUES (13,'Shaival','Shah',8577456321,'shah.shaival@gmail.com','34 Peterborough Street','1995-10-28',22,'Male');
INSERT INTO Person VALUES (14,'Rohini','Shetty',857746314,'shetty.rohini@gmail.com','12 Parkdrive Street','1955-09-12',62,'Female');
INSERT INTO Person VALUES (15,'Senapati','Bapat',6174567458,'bapat.sena@gmail.com','28 Germain Street','1990-02-14',27,'Male');
INSERT INTO Person VALUES (16,'Shivani','Mehta',8547637483,'mehta.shivani@gmail.com','97 Mission Main','1992-04-19',25,'Female');
INSERT INTO Person VALUES (17,'Litesh','Mehta',8577568947,'mehta.Litesh@gmail.com','97 Columbus Ave','1982-06-25',35,'Male');
INSERT INTO Person VALUES (18,'Harsha','Gada',6177457896,'harsha45@gmail.com','54 Parker Hill','1989-07-23',28,'Female');
INSERT INTO Person VALUES (19,'Heta','Shah',6178577458,'shahHeta@gmail.com','97 Jamaica Plain','1992-09-19',25,'Female');
INSERT INTO Person VALUES (20,'Ruhi','Jain',8547468957,'jain.ruhi15@gmail.com','8 Tremont Street','1986-04-19',31,'Female');
INSERT INTO Person VALUES (21,'Jigna','Vikmani',8547961369,'vikmani.jigu@gmail.com','97 speare street','1989-01-06',28,'Female');
INSERT INTO Person VALUES (22,'Jignesh','Chedda',7485961236,'chedda.jigu@gmail.com','5 stephen street','1957-04-16',60,'Male');
INSERT INTO Person VALUES (23,'Hemant','Shah',7485963214,'shah.hemu@gmail.com','9 tremont street','1967-11-26',50,'Male');
INSERT INTO Person VALUES (24,'Krisha','Verma',85774537489,'verma.kri@gmail.com','45 smith street','1972-11-06',45,'Female');
INSERT INTO Person VALUES (25,'Harshit','Pathak',6177458965,'pathak.harshit@gmail.com','89 Peterborough street','1956-08-11',61,'Male');
INSERT INTO Person VALUES (26,'Paresh','Soni',6178967485,'soni.par@gmail.com','45 smith street','1977-09-15',40,'Male');
INSERT INTO Person VALUES (27,'Rahanik','Vora',6174587896,'vora.rahu@gmail.com','25 Hemenway street','1993-05-12',24,'Male');
INSERT INTO Person VALUES (28,'Krishna','Gandhi',8577458963,'gandhi.krish@gmail.com','9 Burney street','1990-05-17',27,'Female');
INSERT INTO Person VALUES (29,'Kavita','Shah',8574567895,'shah.kavita@gmail.com','9A Newbur street','1988-11-12',29,'Female');
INSERT INTO Person VALUES (30,'Reshma','Mulla',6174567895,'mulla.resh@gmail.com','23 Queensbery street','1985-03-16',32,'Female');
INSERT INTO Person VALUES (31,'Rahul','Sharma',6178547896,'sharma.rahul@gmail.com','23 Jersey street','1985-04-26',32,'Male');
INSERT INTO Person VALUES (32,'Prakash','Jha',8577458963,'jha.prakash@gmail.com','12 Mary street','1983-03-16',30,'Male');
INSERT INTO Person VALUES (33,'Oliver','DMello',6147568945,'dmello@gmail.com','12 Queensberry street','1982-12-26',35,'Male');
INSERT INTO Person VALUES (34,'Himesh','Mehta',6178965478,'resh@gmail.com','42 ParkDrive street','1985-09-16',32,'Male');
INSERT INTO Person VALUES (35,'Rashmi','Gada',6174568796,'rashmi@gmail.com','45 Queensbery street','1986-10-26',31,'Female');
INSERT INTO Person VALUES (36,'Hiren','Rathod',6174567896,'rathodl@gmail.com','3 Jersey street','1975-04-26',42,'Male');
INSERT INTO Person VALUES (37,'Dev','Rastogi',8577458963,'rastogi@gmail.com','15 Mary street','1973-05-16',40,'Male');
INSERT INTO Person VALUES (38,'Ruhi','Shah',6174587894,'shah.ruh@gmail.com','45 Queensberry street','1982-12-26',35,'Female');
INSERT INTO Person VALUES (39,'Kruti','Dedhia',6178954789,'kruti@gmail.com','1 Tremont street','1985-03-17',32,'Female');
INSERT INTO Person VALUES (40,'Hemlata','Gala',6174568967,'hemlata.gala@gmail.com','89 Newbury street','1986-10-26',31,'Female');

INSERT INTO customer(PersonId)
SELECT PersonId
FROM Person
LIMIT 10;

INSERT INTO Customer Values(11,11);
INSERT INTO Customer Values(26,12);
INSERT INTO Customer Values(27,13);
INSERT INTO Customer Values(28,14);
INSERT INTO Customer Values(29,15);
INSERT INTO Customer Values(30,16);


INSERT INTO employee(PersonId)
SELECT PersonId
FROM Person
WHERE PersonId IN (11,12,13,14,15,17,18,19,20,21);

INSERT INTO employee VALUES(22,11,'Branch Manager',70000,'2003-04-18','YES');
INSERT INTO employee VALUES(23,12,'Branch Manager',70000,'2004-01-01','YES');
INSERT INTO employee VALUES(24,13,'Branch Manager',70000,'2007-10-15','YES');
INSERT INTO employee VALUES(25,14,'Branch Manager',70000,'2006-02-28','YES');
INSERT INTO employee VALUES(26,15,'Bank Teller',40000,'2010-08-16','YES');
INSERT INTO employee VALUES(27,16,'Bank Teller',40000,'2011-04-25','YES');
INSERT INTO employee VALUES(28,17,'Bank Clerk',30000,'2015-06-14','YES');
INSERT INTO employee VALUES(29,18,'Bank Clerk',30000,'2014-07-21','YES');
INSERT INTO employee VALUES(30,19,'Bank Teller',40000,'2016-07-12','YES');
INSERT INTO employee VALUES(31,20,'Loan Manager',60000,'2014-05-22','YES');
INSERT INTO employee VALUES(32,21,'Loan Manager',60000,'2013-07-29','YES');
INSERT INTO employee VALUES(33,22,'Loan Manager',60000,'2011-10-25','YES');
INSERT INTO employee VALUES(34,23,'Loan Manager',60000,'2009-09-15','YES');
INSERT INTO employee VALUES(35,24,'Loan Manager',60000,'2012-10-25','YES');
INSERT INTO employee VALUES(36,25,'Credit Card Manager',65000,'2011-02-15','YES');
INSERT INTO employee VALUES(37,26,'Credit Card Manager',65000,'2015-12-05','YES');
INSERT INTO employee VALUES(38,27,'Credit Card Manager',65000,'2013-03-19','YES');
INSERT INTO employee VALUES(39,28,'Credit Card Manager',65000,'2014-05-20','YES');
INSERT INTO employee VALUES(40,29,'Credit Card Manager',65000,'2013-09-20','YES');

UPDATE employee
SET 
	Designation = 'Branch Manager',
    Salary = 70000,
    `Date Of Joining` = '2007-06-12',
    `IsActive?` = 'YES'
WHERE PersonId = 12;

UPDATE employee
SET 
	Designation = 'Credit Card Manager',
    Salary = 65000,
    `Date Of Joining` = '2010-01-15',
    `IsActive?` = 'YES'
WHERE PersonId = 20;

UPDATE employee
SET 
	Designation = 'Loan Manager',
    Salary = 60000,
    `Date Of Joining` = '2010-01-15',
    `IsActive?` = 'YES'
WHERE PersonId = 14;

UPDATE employee
SET 
	Designation = 'Branch Co-ordinator',
    Salary = 50000,
    `Date Of Joining` = '2014-04-15',
    `IsActive?` = 'YES'
WHERE PersonId = 18;

UPDATE employee
SET 
	Designation = 'Bank Teller',
    Salary = 40000,
    `Date Of Joining` = '2015-03-15',
    `IsActive?` = 'YES'
WHERE PersonId = 15;


UPDATE employee
SET 
	Designation = 'Bank Teller',
    Salary = 40000,
    `Date Of Joining` = '2014-03-01',
    `IsActive?` = 'YES'
WHERE PersonId = 11;

UPDATE employee
SET 
	Designation = 'Bank Clerk',
    Salary = 30000,
    `Date Of Joining` = '2014-11-15',
    `IsActive?` = 'YES'
WHERE PersonId = 13;

UPDATE employee
SET 
	Designation = 'Human Resource',
    Salary = 45000,
    `Date Of Joining` = '2017-03-15',
    `IsActive?` = 'YES'
WHERE PersonId = 17;

UPDATE employee
SET 
	Designation = 'Bank Clerk',
    Salary = 30000,
    `Date Of Joining` = '2016-04-01',
    `IsActive?` = 'YES'
WHERE PersonId = 19;

UPDATE employee
SET 
	Designation = 'Bank Clerk',
    Salary = 30000,
    `Date Of Joining` = '2015-04-11',
    `IsActive?` = 'NO'
WHERE PersonId = 21;

INSERT INTO Branch VALUES(1,'Santander Huntington Ave','Huntington Ave','Boston','MA',02115,12564789355);
INSERT INTO Branch VALUES(2,'Santander Columbus Ave','Columbus Ave','Boston','MA',02118,45789632145);
INSERT INTO Branch VALUES(3,'Santander Pardrive','ParkDrive Street','Boston','MA',02215,7485963254);
INSERT INTO Branch VALUES(4,'Santander Mission Main','Mission Main','Boston','MA',02128,32541697821);
INSERT INTO Branch VALUES(5,'Santander Symphony Ave','Symphony Ave','Boston','MA',02125,65874963215);

INSERT INTO Accounts VALUES(1234569872,'Checking',1,'2016-05-15',14000,1500,'YES',null);
INSERT INTO Accounts VALUES(8974563215,'Savings',1,'2017-04-25',20000,1500,'YES',null);	
INSERT INTO Accounts VALUES(7485963258,'Checking',1,'2016-05-25',30000,1600,'YES',null);	
INSERT INTO Accounts VALUES(8574963214,'Checking',1,'2016-09-05',35000,1600,'YES',null);	
INSERT INTO Accounts VALUES(4517896325,'LoanAcc',1,'2015-07-12',60000,2000,'YES',null);
INSERT INTO Accounts VALUES(1236547895,'Checking',1,'2014-01-03',25406,1600,'YES',null);
INSERT INTO Accounts VALUES(4115872696,'Checking',1,'2013-06-21',365412,1600,'YES',null);	
INSERT INTO Accounts VALUES(7459631258,'Savings',1,'2012-12-02',74562,1500,'YES',null);			
INSERT INTO Accounts VALUES(7489544933,'LoanAcc',1,'2017-11-17',45000,2000,'YES',null);	
INSERT INTO Accounts VALUES(8547963326,'Checking',2,'2010-12-05',65000,1500,'YES',null);
INSERT INTO Accounts VALUES(4587963155,'Checking',2,'2013-07-25',45896,1600,'YES',null);
INSERT INTO Accounts VALUES(7458585547,'LoanAcc',2,'2017-01-01',70000,5000,'YES',null);	
INSERT INTO Accounts VALUES(9475855258,'Savings',2,'2012-10-17',56000,1500,'YES',null);	
INSERT INTO Accounts VALUES(7485964125,'Checking',2,'2013-06-18',90000,1600,'YES',null);
INSERT INTO Accounts VALUES(5478963112,'Checking',3,'2014-10-15',85000,1600,'YES',null);	
INSERT INTO Accounts VALUES(7458931234,'Checking',3,'2014-11-17',74000,1600,'YES',null);
INSERT INTO Accounts VALUES(4558223682,'Savings',3,'2015-02-27',23000,1500,'YES',null);	
INSERT INTO Accounts VALUES(4578576585,'Checking',3,'2016-02-12',54002,1600,'YES',null);	
INSERT INTO Accounts VALUES(7458596854,'Checking',3,'2016-01-17',87500,1600,'YES',null);
INSERT INTO Accounts VALUES(3654485225,'Checking',2,'2017-01-07',25000,1600,'YES',null);
INSERT INTO Accounts VALUES(4587215665,'Checking',2,'2014-05-07',45215,1600,'YES',null);
INSERT INTO Accounts VALUES(5485214755,'Checking',1,'2016-11-07',45875,1600,'YES',null);
INSERT INTO Accounts VALUES(5478992582,'Checking',2,'2017-11-07',585445,1600,'YES',null);

INSERT INTO Accounts VALUES(5467874253,'LoanAcc',2,'2016-01-01',80000,5000,'YES',null);	
INSERT INTO Accounts VALUES(4654646464,'LoanAcc',1,'2016-05-01',90000,5000,'YES',null);	
INSERT INTO Accounts VALUES(5841235983,'LoanAcc',2,'2017-05-01',60000,2000,'YES',null);			
	
INSERT INTO credit_card VALUES(12365478924,'2015-01-05','2017-12-26',1,500,100000,'YES',null);
INSERT INTO credit_card VALUES(12547993282,'2017-12-05','2030-08-25',2,413,50000,'YES',null);
INSERT INTO credit_card VALUES(45789148268,'2017-12-12','2027-11-12',3,450,50000,'YES',null);
INSERT INTO credit_card VALUES(748591255558,'2017-11-25','2025-06-06',10,550,150000,'YES',null);
INSERT INTO credit_card VALUES(748526588852,'2017-05-06','2025-06-06',8,700,200000,'YES',null);
INSERT INTO credit_card VALUES(745821479248,'2017-09-03','2027-02-23',7,650,100000,'YES',null);
INSERT INTO credit_card VALUES(458757812821,'2017-04-15','2028-09-14',5,600,175000,'YES',null);
INSERT INTO credit_card VALUES(785214785448,'2017-03-03','2025-02-23',7,650,500000,'YES',null);
INSERT INTO credit_card VALUES(587496828525,'2017-07-15','2029-09-14',5,600,2000000,'YES',null);

INSERT INTO Loan VALUES(1,'Secured Education',12.5,500000);
INSERT INTO Loan VALUES(2,'Secured Housing',10.5,1000000);
INSERT INTO Loan VALUES(3,'Secured Vehicles',12.75,300000);
INSERT INTO Loan VALUES(4,'Secured Personal',11.25,700000);
INSERT INTO Loan VALUES(5,'Unsecured Education',13.5,400000);
INSERT INTO Loan VALUES(6,'Unsecured Housing',11.5,900000);
INSERT INTO Loan VALUES(7,'Unsecured Vehicles',13.25,200000);
INSERT INTO Loan VALUES(8,'Unsecured Mortgage',12.25,500000);

INSERT INTO branch_employees VALUES(1,9,'2007-06-12');
INSERT INTO branch_employees VALUES(2,11,'2003-04-18');
INSERT INTO branch_employees VALUES(3,12,'2004-01-01');
INSERT INTO branch_employees VALUES(4,13,'2007-10-15');
INSERT INTO branch_employees VALUES(5,14,'2006-02-28');
INSERT INTO branch_employees VALUES(1,6,'2015-03-15');
INSERT INTO branch_employees VALUES(2,10,'2014-03-01');
INSERT INTO branch_employees VALUES(3,15,'2010-08-16');
INSERT INTO branch_employees VALUES(4,16,'2011-04-25');
INSERT INTO branch_employees VALUES(5,19,'2016-07-12');
INSERT INTO branch_employees VALUES(1,1,'2015-04-11');
INSERT INTO branch_employees VALUES(2,3,'2016-04-01');
INSERT INTO branch_employees VALUES(3,8,'2014-11-15');
INSERT INTO branch_employees VALUES(4,17,'2015-06-14');
INSERT INTO branch_employees VALUES(5,18,'2014-07-21');
INSERT INTO branch_employees VALUES(1,20,'2014-05-22');
INSERT INTO branch_employees VALUES(2,21,'2013-07-29');
INSERT INTO branch_employees VALUES(3,22,'2011-10-25');
INSERT INTO branch_employees VALUES(4,23,'2009-09-15');
INSERT INTO branch_employees VALUES(5,7,'2010-01-15');
INSERT INTO branch_employees VALUES(1,2,'2010-01-15');
INSERT INTO branch_employees VALUES(2,26,'2015-12-05');
INSERT INTO branch_employees VALUES(3,27,'2013-03-19');
INSERT INTO branch_employees VALUES(4,28,'2014-05-20');
INSERT INTO branch_employees VALUES(5,25,'2011-02-15');

INSERT INTO customer_accounts VALUES(1,1236547895);
INSERT INTO customer_accounts VALUES(2,3654485225);
INSERT INTO customer_accounts VALUES(3,4115872696);
INSERT INTO customer_accounts VALUES(4,4578576585);
INSERT INTO customer_accounts VALUES(5,4587963155);
INSERT INTO customer_accounts VALUES(6,5478963112);
INSERT INTO customer_accounts VALUES(7,7458596854);
INSERT INTO customer_accounts VALUES(8,7458931234);
INSERT INTO customer_accounts VALUES(9,7485963258);
INSERT INTO customer_accounts VALUES(10,7485964125);
INSERT INTO customer_accounts VALUES(11,8547963326);
INSERT INTO customer_accounts VALUES(12,8574963214);
INSERT INTO customer_accounts VALUES(13,1234569872);
INSERT INTO customer_accounts VALUES(14,4587215665);
INSERT INTO customer_accounts VALUES(15,5485214755);
INSERT INTO customer_accounts VALUES(16,5478992582);
INSERT INTO customer_accounts VALUES(1,4558223682);
INSERT INTO customer_accounts VALUES(2,7459631258);
INSERT INTO customer_accounts VALUES(3,8974563215);
INSERT INTO customer_accounts VALUES(4,9475855258);
INSERT INTO customer_accounts VALUES(5,4517896325);
INSERT INTO customer_accounts VALUES(6,7458585547);
INSERT INTO customer_accounts VALUES(7,7489544933);

INSERT INTO customer_accounts VALUES(2,5467874253);
INSERT INTO customer_accounts VALUES(3,4654646464);
INSERT INTO customer_accounts VALUES(4,5841235983);

INSERT INTO Loan_Customer VALUES(1,5,4517896325,12,'2017-06-06',55000,'NO');
INSERT INTO Loan_Customer VALUES(2,6,7458585547,12,'2017-01-01',50000,'NO');
INSERT INTO Loan_Customer VALUES(4,7,7489544933,24,'2016-09-12',60000,'NO');
INSERT INTO Loan_Customer VALUES(1,2,5467874253,12,'2016-01-01',70000,'NO');
INSERT INTO Loan_Customer VALUES(2,3,7458585547,18,'2016-01-01',80000,'NO');
INSERT INTO Loan_Customer VALUES(4,4,7489544933,12,'2016-01-01',55000,'NO');



	
