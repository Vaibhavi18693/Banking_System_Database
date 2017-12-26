CREATE DATABASE  IF NOT EXISTS `bankdb` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `bankdb`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: bankdb
-- ------------------------------------------------------
-- Server version	5.7.19-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `Account Number` bigint(10) NOT NULL,
  `Account Type` varchar(50) NOT NULL,
  `BranchId` int(11) NOT NULL,
  `Date Of Opening` date DEFAULT NULL,
  `Account Balance` double DEFAULT NULL,
  `Minimum Balance Restriction` double NOT NULL,
  `IsActive?` enum('YES','NO') DEFAULT NULL,
  `Date Of Closing` date DEFAULT NULL,
  PRIMARY KEY (`Account Number`),
  KEY `BranchId_Acc_FK_idx` (`BranchId`),
  CONSTRAINT `BranchId_Acc_FK` FOREIGN KEY (`BranchId`) REFERENCES `branch` (`BranchId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1234569872,'Checking',1,'2016-05-15',22000,1500,'YES',NULL),(1236547895,'Checking',1,'2014-01-03',25406,1600,'YES',NULL),(3654485225,'Checking',2,'2017-01-07',25000,1600,'YES',NULL),(4115872696,'Checking',1,'2013-06-21',365412,1600,'YES',NULL),(4517896325,'LoanAcc',1,'2015-07-12',60000,2000,'YES',NULL),(4558223682,'Savings',3,'2015-02-27',51500,1500,'YES',NULL),(4578576585,'Checking',3,'2016-02-12',54002,1600,'YES',NULL),(4587215665,'Checking',2,'2014-05-07',45215,1600,'YES',NULL),(4587963155,'Checking',2,'2013-07-25',45896,1600,'YES',NULL),(4654646464,'LoanAcc',1,'2016-05-01',90000,5000,'YES',NULL),(5467874253,'LoanAcc',2,'2016-01-01',80000,5000,'YES',NULL),(5478963112,'Checking',3,'2014-10-15',85000,1600,'YES',NULL),(5478992582,'Checking',2,'2017-11-07',585445,1600,'YES',NULL),(5485214755,'Checking',1,'2016-11-07',45875,1600,'YES',NULL),(5841235983,'LoanAcc',2,'2017-05-01',60000,2000,'YES',NULL),(7458585547,'LoanAcc',2,'2017-01-01',70000,5000,'YES',NULL),(7458596854,'Checking',3,'2016-01-17',87500,1600,'YES',NULL),(7458931234,'Checking',3,'2014-11-17',74000,1600,'YES',NULL),(7459631258,'Savings',1,'2012-12-02',74562,1500,'YES',NULL),(7485963258,'Checking',1,'2016-05-25',30000,1600,'YES',NULL),(7485964125,'Checking',2,'2013-06-18',90000,1600,'YES',NULL),(7489544933,'LoanAcc',1,'2017-11-17',45000,2000,'YES',NULL),(8547963326,'Checking',2,'2010-12-05',65000,1500,'YES',NULL),(8574963214,'Checking',1,'2016-09-05',35000,1600,'YES',NULL),(8974563215,'Savings',1,'2017-04-25',20000,1500,'YES',NULL),(9475855258,'Savings',2,'2012-10-17',56000,1500,'YES',NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER inactiveAccount 
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN
	IF (new.`IsActive?` = 'YES' && OLD.`IsActive?` = 'NO') THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'You cannot activate closed account.';
	ELSE
		IF (new.`IsActive?` != OLD.`IsActive?` && new.`IsActive?` = 'NO')THEN
				SET new.`Date Of Closing` = CURDATE();
				DELETE 
				FROM CUSTOMER_ACCOUNTS 
				WHERE `Account Number` IN (SELECT `Account Number` 
										 FROM Accounts 
										 WHERE new.`IsActive?` != old.`IsActive?` && new.`IsActive?` = 'NO'  
										 && `Account Number` = OLD.`Account Number`);
			END IF;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bank_transactions`
--

DROP TABLE IF EXISTS `bank_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bank_transactions` (
  `TransactionId` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerId` int(11) DEFAULT NULL,
  `Transaction DateTime` datetime DEFAULT NULL,
  `Transaction Type` varchar(45) DEFAULT NULL,
  `Amount Transferred To Account` bigint(10) NOT NULL,
  `Amount Transferred From Account` bigint(10) DEFAULT NULL,
  `Transaction Amount` double DEFAULT NULL,
  `Transaction Details` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TransactionId`),
  KEY `CustomerId_BankTrans_FK_idx` (`CustomerId`),
  KEY `AccNum_BankTrans_FK_idx` (`Amount Transferred To Account`),
  KEY `AccNumFrom_BankTrans_FK_idx` (`Amount Transferred From Account`),
  CONSTRAINT `AccNumFrom_BankTrans_FK` FOREIGN KEY (`Amount Transferred From Account`) REFERENCES `customer_accounts` (`Account Number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `AccNumTo_BankTrans_FK` FOREIGN KEY (`Amount Transferred To Account`) REFERENCES `customer_accounts` (`Account Number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CustomerId_BankTrans_FK` FOREIGN KEY (`CustomerId`) REFERENCES `customer_accounts` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_transactions`
--

LOCK TABLES `bank_transactions` WRITE;
/*!40000 ALTER TABLE `bank_transactions` DISABLE KEYS */;
INSERT INTO `bank_transactions` VALUES (1,13,'2017-12-13 19:06:42','Withdraw',1234569872,NULL,1000,'Amount withdrawed.'),(2,13,'2017-12-13 19:06:42','Deposit',1234569872,NULL,10000,'Amount deposited.'),(3,1,'2017-12-13 19:06:42','Deposit',4558223682,NULL,12000,'Amount deposited.'),(4,1,'2017-12-13 19:06:43','Deposit',4558223682,NULL,20000,'Amount deposited.'),(5,1,'2017-12-13 19:06:43','Withdraw',4558223682,NULL,4500,'Amount withdrawed.'),(6,13,'2017-12-13 19:06:44','Amount Transfer',4558223682,1234569872,1000,'Amount transferred.');
/*!40000 ALTER TABLE `bank_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch` (
  `BranchId` int(11) NOT NULL AUTO_INCREMENT,
  `BranchName` varchar(50) DEFAULT NULL,
  `Street` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `State` varchar(45) DEFAULT NULL,
  `ZipCode` varchar(45) DEFAULT NULL,
  `IFSC Code` varchar(50) NOT NULL,
  PRIMARY KEY (`BranchId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'Santander Huntington Ave','Huntington Ave','Boston','MA','2115','12564789355'),(2,'Santander Columbus Ave','Columbus Ave','Boston','MA','2118','45789632145'),(3,'Santander Pardrive','ParkDrive Street','Boston','MA','2215','7485963254'),(4,'Santander Mission Main','Mission Main','Boston','MA','2128','32541697821'),(5,'Santander Symphony Ave','Symphony Ave','Boston','MA','2125','65874963215');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch_employees`
--

DROP TABLE IF EXISTS `branch_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch_employees` (
  `BranchId` int(11) NOT NULL,
  `EmployeeId` int(11) NOT NULL,
  `Date Of Joining` date DEFAULT NULL,
  PRIMARY KEY (`EmployeeId`),
  KEY `EmployeeId_BranchEmp_FK_idx` (`EmployeeId`),
  KEY `BranchId_BranchEmp_FK` (`BranchId`),
  CONSTRAINT `BranchId_BranchEmp_FK` FOREIGN KEY (`BranchId`) REFERENCES `branch` (`BranchId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `EmployeeId_BranchEmp_FK` FOREIGN KEY (`EmployeeId`) REFERENCES `employee` (`PersonId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch_employees`
--

LOCK TABLES `branch_employees` WRITE;
/*!40000 ALTER TABLE `branch_employees` DISABLE KEYS */;
INSERT INTO `branch_employees` VALUES (1,1,'2015-04-11'),(1,2,'2010-01-15'),(2,3,'2016-04-01'),(1,6,'2015-03-15'),(5,7,'2010-01-15'),(3,8,'2014-11-15'),(1,9,'2007-06-12'),(2,10,'2014-03-01'),(2,11,'2003-04-18'),(3,12,'2004-01-01'),(4,13,'2007-10-15'),(5,14,'2006-02-28'),(3,15,'2010-08-16'),(4,16,'2011-04-25'),(4,17,'2015-06-14'),(5,18,'2014-07-21'),(5,19,'2016-07-12'),(1,20,'2014-05-22'),(2,21,'2013-07-29'),(3,22,'2011-10-25'),(4,23,'2009-09-15'),(5,25,'2011-02-15'),(2,26,'2015-12-05'),(3,27,'2013-03-19'),(4,28,'2014-05-20');
/*!40000 ALTER TABLE `branch_employees` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER branchUpdate
BEFORE UPDATE ON BRANCH_EMPLOYEES
FOR EACH ROW
BEGIN
	IF(New.`Date Of Joining` != OLD.`Date Of Joining`) THEN
	SET @designation = (SELECT Designation
						FROM Employee
                        WHERE EmployeeId = old.EmployeeId);
	INSERT INTO BRANCH_EMPLOYEES_HISTORY 
    SET Previous_BranchId = OLD.BranchId,
		EmployeeId = OLD.EmployeeId,
        `Start Date` = OLD.`Date Of Joining`,
        `End Date` = curdate(),
        Designation = @designation;
    ELSE 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Please update the date of Joining.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER branchDelete
BEFORE DELETE ON BRANCH_EMPLOYEES
FOR EACH ROW
BEGIN
	SET @designation = (SELECT Designation
						FROM Employee
                        WHERE EmployeeId = old.EmployeeId);
	INSERT INTO BRANCH_EMPLOYEES_HISTORY 
    SET Previous_BranchId = OLD.BranchId,
		EmployeeId = OLD.EmployeeId,
        `Start Date` = OLD.`Date Of Joining`,
        `End Date` = curdate(),
        Designation = @designation;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `branch_employees_history`
--

DROP TABLE IF EXISTS `branch_employees_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch_employees_history` (
  `Previous_BranchId` int(11) NOT NULL,
  `EmployeeId` int(11) NOT NULL,
  `Start Date` date NOT NULL,
  `End Date` date DEFAULT NULL,
  `Designation` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Start Date`,`EmployeeId`),
  KEY `BranchId_BranchEmp_FK_idx` (`Previous_BranchId`),
  KEY `EmployeeId_BranchEmp_FK_idx` (`EmployeeId`),
  CONSTRAINT `BranchId_BranchEmpK_FK` FOREIGN KEY (`Previous_BranchId`) REFERENCES `branch_employees` (`BranchId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `EmployeeId_BranchEmpK_FK` FOREIGN KEY (`EmployeeId`) REFERENCES `branch_employees` (`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch_employees_history`
--

LOCK TABLES `branch_employees_history` WRITE;
/*!40000 ALTER TABLE `branch_employees_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `branch_employees_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_card`
--

DROP TABLE IF EXISTS `credit_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credit_card` (
  `CC Number` bigint(10) NOT NULL,
  `Date Of Activation` date DEFAULT NULL,
  `Expiry Date` date DEFAULT NULL,
  `CustomerId` int(11) NOT NULL,
  `Credit Score` double DEFAULT NULL,
  `Maximum Limit` double NOT NULL,
  `IsActive?` enum('YES','NO') DEFAULT NULL,
  `Date of Deactivation` date DEFAULT NULL,
  PRIMARY KEY (`CC Number`),
  KEY `CustomerId_CC_FK_idx` (`CustomerId`),
  CONSTRAINT `CustomerId_CC_FK` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card`
--

LOCK TABLES `credit_card` WRITE;
/*!40000 ALTER TABLE `credit_card` DISABLE KEYS */;
INSERT INTO `credit_card` VALUES (12365478924,'2015-01-05','2017-12-26',1,500,100000,'YES',NULL),(12547993282,'2017-12-05','2030-08-25',2,413,50000,'YES',NULL),(45789148268,'2017-12-12','2027-11-12',3,450,50000,'YES',NULL),(458757812821,'2017-04-15','2028-09-14',5,600,175000,'YES',NULL),(587496828525,'2017-07-15','2029-09-14',5,600,2000000,'YES',NULL),(745821479248,'2017-09-03','2027-02-23',7,650,100000,'YES',NULL),(748526588852,'2017-05-06','2025-06-06',8,700,200000,'YES',NULL),(748591255558,'2017-11-25','2025-06-06',10,550,150000,'YES',NULL),(785214785448,'2017-03-03','2025-02-23',7,650,500000,'YES',NULL);
/*!40000 ALTER TABLE `credit_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_card_transactions`
--

DROP TABLE IF EXISTS `credit_card_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credit_card_transactions` (
  `CC Number` bigint(10) NOT NULL,
  `TransactionId` int(11) NOT NULL AUTO_INCREMENT,
  `Transaction DateTime` datetime DEFAULT NULL,
  `Transaction Amount` double DEFAULT NULL,
  `Transaction Details` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TransactionId`),
  KEY `CCNum_CCTransaction_FK_idx` (`CC Number`),
  CONSTRAINT `CCNum_CCTransaction_FK` FOREIGN KEY (`CC Number`) REFERENCES `credit_card` (`CC Number`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card_transactions`
--

LOCK TABLES `credit_card_transactions` WRITE;
/*!40000 ALTER TABLE `credit_card_transactions` DISABLE KEYS */;
INSERT INTO `credit_card_transactions` VALUES (12547993282,1,'2017-12-13 19:07:04',1000,'Transaction Completed Successfully.'),(12547993282,2,'2017-12-13 19:07:04',1500,'Transaction Completed Successfully.'),(45789148268,3,'2017-12-13 19:07:04',500,'Transaction Completed Successfully.'),(745821479248,4,'2017-12-13 19:07:04',2000,'Transaction Completed Successfully.'),(748591255558,5,'2017-12-13 19:07:04',3000,'Transaction Completed Successfully.'),(748526588852,6,'2017-12-13 19:07:04',4000,'Transaction Completed Successfully.');
/*!40000 ALTER TABLE `credit_card_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `PersonId` int(11) NOT NULL,
  `CustomerId` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`CustomerId`),
  KEY `PersonId_Customer_FK_idx` (`PersonId`),
  CONSTRAINT `PersonId_Customer_FK` FOREIGN KEY (`PersonId`) REFERENCES `person` (`PersonId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(26,12),(27,13),(28,14),(29,15),(30,16);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_accounts`
--

DROP TABLE IF EXISTS `customer_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_accounts` (
  `CustomerId` int(11) NOT NULL,
  `Account Number` bigint(10) NOT NULL,
  PRIMARY KEY (`CustomerId`,`Account Number`),
  KEY `AccountId_CustAcc_FK_idx` (`Account Number`),
  CONSTRAINT `AccountId_CustAcc_FK` FOREIGN KEY (`Account Number`) REFERENCES `accounts` (`Account Number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CustomerId_CustAcc_FK` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`PersonId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_accounts`
--

LOCK TABLES `customer_accounts` WRITE;
/*!40000 ALTER TABLE `customer_accounts` DISABLE KEYS */;
INSERT INTO `customer_accounts` VALUES (13,1234569872),(1,1236547895),(2,3654485225),(3,4115872696),(5,4517896325),(1,4558223682),(4,4578576585),(14,4587215665),(5,4587963155),(3,4654646464),(2,5467874253),(6,5478963112),(16,5478992582),(15,5485214755),(4,5841235983),(6,7458585547),(7,7458596854),(8,7458931234),(2,7459631258),(9,7485963258),(10,7485964125),(7,7489544933),(11,8547963326),(12,8574963214),(3,8974563215),(4,9475855258);
/*!40000 ALTER TABLE `customer_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
  `PersonId` int(11) NOT NULL,
  `EmployeeId` int(11) NOT NULL AUTO_INCREMENT,
  `Designation` varchar(50) DEFAULT NULL,
  `Salary` double DEFAULT NULL,
  `Date Of Joining` date DEFAULT NULL,
  `IsActive?` enum('YES','NO') DEFAULT NULL,
  PRIMARY KEY (`EmployeeId`),
  KEY `PersonId_Employee_FK_idx` (`PersonId`),
  CONSTRAINT `PersonId_Employee_FK` FOREIGN KEY (`PersonId`) REFERENCES `person` (`PersonId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (11,1,'Bank Teller',40000,'2014-03-01','YES'),(12,2,'Branch Manager',70000,'2007-06-12','YES'),(13,3,'Bank Clerk',30000,'2014-11-15','YES'),(14,4,'Loan Manager',60000,'2010-01-15','YES'),(15,5,'Bank Teller',40000,'2015-03-15','YES'),(17,6,'Human Resource',45000,'2017-03-15','YES'),(18,7,'Branch Co-ordinator',50000,'2014-04-15','YES'),(19,8,'Bank Clerk',30000,'2016-04-01','YES'),(20,9,'Credit Card Manager',65000,'2010-01-15','YES'),(21,10,'Bank Clerk',30000,'2015-04-11','NO'),(22,11,'Branch Manager',70000,'2003-04-18','YES'),(23,12,'Branch Manager',70000,'2004-01-01','YES'),(24,13,'Branch Manager',70000,'2007-10-15','YES'),(25,14,'Branch Manager',70000,'2006-02-28','YES'),(26,15,'Bank Teller',40000,'2010-08-16','YES'),(27,16,'Bank Teller',40000,'2011-04-25','YES'),(28,17,'Bank Clerk',30000,'2015-06-14','YES'),(29,18,'Bank Clerk',30000,'2014-07-21','YES'),(30,19,'Bank Teller',40000,'2016-07-12','YES'),(31,20,'Loan Manager',60000,'2014-05-22','YES'),(32,21,'Loan Manager',60000,'2013-07-29','YES'),(33,22,'Loan Manager',60000,'2011-10-25','YES'),(34,23,'Loan Manager',60000,'2009-09-15','YES'),(35,24,'Loan Manager',60000,'2012-10-25','YES'),(36,25,'Credit Card Manager',65000,'2011-02-15','YES'),(37,26,'Credit Card Manager',65000,'2015-12-05','YES'),(38,27,'Credit Card Manager',65000,'2013-03-19','YES'),(39,28,'Credit Card Manager',65000,'2014-05-20','YES'),(40,29,'Credit Card Manager',65000,'2013-09-20','YES');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER inactiveEmp
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
	IF new.`IsActive?` = 'YES' THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'You cannot make an inactive employee active.';
	ELSE
		IF (new.`IsActive?` != OLD.`IsActive?` && new.`IsActive?` = 'NO')THEN
			DELETE 
			FROM Branch_Employees 
			WHERE EmployeeID IN (SELECT EmployeeId 
								 FROM Employee 
								 WHERE new.`IsActive?` != old.`IsActive?` && new.`IsActive?` = 'NO'  
                                 && EmployeeId = OLD.EmployeeId);
		END IF;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan` (
  `LoanId` int(11) NOT NULL AUTO_INCREMENT,
  `LoanType` varchar(45) DEFAULT NULL,
  `Rate Of Interest` float DEFAULT NULL,
  `Loan Amount Limit` double DEFAULT NULL,
  PRIMARY KEY (`LoanId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (1,'Secured Education',12.5,500000),(2,'Secured Housing',10.5,1000000),(3,'Secured Vehicles',12.75,300000),(4,'Secured Personal',11.25,700000),(5,'Unsecured Education',13.5,400000),(6,'Unsecured Housing',11.5,900000),(7,'Unsecured Vehicles',13.25,200000),(8,'Unsecured Mortgage',12.25,500000);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_calculation`
--

DROP TABLE IF EXISTS `loan_calculation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan_calculation` (
  `Date` date NOT NULL,
  `LoanId` int(11) NOT NULL,
  `CustomerId` int(11) NOT NULL,
  `Account Number` bigint(10) NOT NULL,
  `Amount` double NOT NULL,
  `Interest` double DEFAULT NULL,
  `Redemption` double DEFAULT NULL,
  `Payment` double DEFAULT NULL,
  PRIMARY KEY (`Date`,`LoanId`,`CustomerId`),
  KEY `CustomerId_LoanCal_FK_idx` (`CustomerId`),
  KEY `LoanId_LoanCal_FK` (`LoanId`),
  CONSTRAINT `CustomerId_LoanCal_FK` FOREIGN KEY (`CustomerId`) REFERENCES `loan_customer` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `LoanId_LoanCal_FK` FOREIGN KEY (`LoanId`) REFERENCES `loan_customer` (`LoanId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=ascii;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_calculation`
--

LOCK TABLES `loan_calculation` WRITE;
/*!40000 ALTER TABLE `loan_calculation` DISABLE KEYS */;
INSERT INTO `loan_calculation` VALUES ('2016-02-01',1,2,5467874253,65729.17,729.17,4270.83,5000),('2016-02-01',2,3,4654646464,76050,1050,3950,5000),('2016-02-01',4,4,5841235983,53515.62,515.62,1484.38,2000),('2016-03-01',1,2,5467874253,61413.85,684.68,4315.32,5000),('2016-03-01',2,3,4654646464,72048.16,998.16,4001.84,5000),('2016-03-01',4,4,5841235983,52017.33,501.71,1498.29,2000),('2016-04-01',1,2,5467874253,57053.57,639.73,4360.27,5000),('2016-04-01',2,3,4654646464,67993.79,945.63,4054.37,5000),('2016-04-01',4,4,5841235983,50505,487.66,1512.34,2000),('2016-05-01',1,2,5467874253,52647.88,594.31,4405.69,5000),('2016-05-01',2,3,4654646464,63886.21,892.42,4107.58,5000),('2016-05-01',4,4,5841235983,48978.48,473.48,1526.52,2000),('2016-06-01',1,2,5467874253,48196.3,548.42,4451.58,5000),('2016-06-01',2,3,4654646464,59724.71,838.51,4161.49,5000),('2016-06-01',4,4,5841235983,47437.65,459.17,1540.83,2000),('2016-07-01',1,2,5467874253,43698.34,502.04,4497.96,5000),('2016-07-01',2,3,4654646464,55508.6,783.89,4216.11,5000),('2016-07-01',4,4,5841235983,45882.38,444.73,1555.27,2000),('2016-08-01',1,2,5467874253,39153.53,455.19,4544.81,5000),('2016-08-01',2,3,4654646464,51237.15,728.55,4271.45,5000),('2016-08-01',4,4,5841235983,44312.53,430.15,1569.85,2000),('2016-09-01',1,2,5467874253,34561.38,407.85,4592.15,5000),('2016-09-01',2,3,4654646464,46909.64,672.49,4327.51,5000),('2016-09-01',4,4,5841235983,42727.96,415.43,1584.57,2000),('2016-10-01',1,2,5467874253,29921.4,360.01,4639.99,5000),('2016-10-01',2,3,4654646464,42525.33,615.69,4384.31,5000),('2016-10-01',4,4,5841235983,41128.53,400.57,1599.43,2000),('2016-10-12',4,7,7489544933,59125,1125,875,2000),('2016-11-01',1,2,5467874253,25233.08,311.68,4688.32,5000),('2016-11-01',2,3,4654646464,38083.47,558.14,4441.86,5000),('2016-11-01',4,4,5841235983,39514.11,385.58,1614.42,2000),('2016-11-12',4,7,7489544933,58233.59,1108.59,891.41,2000),('2016-12-01',1,2,5467874253,20495.92,262.84,4737.16,5000),('2016-12-01',2,3,4654646464,33583.32,499.85,4500.15,5000),('2016-12-01',4,4,5841235983,37884.56,370.44,1629.56,2000),('2016-12-12',4,7,7489544933,57325.47,1091.88,908.12,2000),('2017-01-01',1,2,5467874253,15709.42,213.5,4786.5,5000),('2017-01-01',2,3,4654646464,29024.1,440.78,4559.22,5000),('2017-01-01',4,4,5841235983,36239.73,355.17,1644.83,2000),('2017-01-12',4,7,7489544933,56400.33,1074.85,925.15,2000),('2017-02-01',1,2,5467874253,10873.06,163.64,4836.36,5000),('2017-02-01',2,3,4654646464,24405.04,380.94,4619.06,5000),('2017-02-01',2,6,7458585547,45437.5,437.5,4562.5,5000),('2017-02-01',4,4,5841235983,34579.47,339.75,1660.25,2000),('2017-02-12',4,7,7489544933,55457.83,1057.51,942.49,2000),('2017-03-01',1,2,5467874253,5986.32,113.26,4886.74,5000),('2017-03-01',2,3,4654646464,19725.36,320.32,4679.68,5000),('2017-03-01',2,6,7458585547,40835.08,397.58,4602.42,5000),('2017-03-01',4,4,5841235983,32903.66,324.18,1675.82,2000),('2017-03-12',4,7,7489544933,54497.67,1039.83,960.17,2000),('2017-04-01',1,2,5467874253,1048.68,62.36,4937.64,5000),('2017-04-01',2,3,4654646464,14984.25,258.9,4741.1,5000),('2017-04-01',2,6,7458585547,36192.39,357.31,4642.69,5000),('2017-04-01',4,4,5841235983,31212.13,308.47,1691.53,2000),('2017-04-12',4,7,7489544933,53519.5,1021.83,978.17,2000),('2017-05-01',1,2,5467874253,0,10.92,1048.68,5000),('2017-05-01',2,3,4654646464,10180.92,196.67,4803.33,5000),('2017-05-01',2,6,7458585547,31509.07,316.68,4683.32,5000),('2017-05-01',4,4,5841235983,29504.74,292.61,1707.39,2000),('2017-05-12',4,7,7489544933,52522.99,1003.49,996.51,2000),('2017-06-01',2,3,4654646464,5314.54,133.62,4866.38,5000),('2017-06-01',2,6,7458585547,26784.77,275.7,4724.3,5000),('2017-06-01',4,4,5841235983,27781.35,276.61,1723.39,2000),('2017-06-12',4,7,7489544933,51507.79,984.81,1015.19,2000),('2017-07-01',2,3,4654646464,384.3,69.75,4930.25,5000),('2017-07-01',2,6,7458585547,22019.14,234.37,4765.63,5000),('2017-07-01',4,4,5841235983,26041.8,260.45,1739.55,2000),('2017-07-06',1,5,4517896325,53572.92,572.92,1427.08,2000),('2017-07-12',4,7,7489544933,50473.57,965.77,1034.23,2000),('2017-08-01',2,3,4654646464,0,5.04,384.3,5000),('2017-08-01',2,6,7458585547,17211.81,192.67,4807.33,5000),('2017-08-01',4,4,5841235983,24285.94,244.14,1755.86,2000),('2017-08-06',1,5,4517896325,52130.97,558.05,1441.95,2000),('2017-08-12',4,7,7489544933,49419.95,946.38,1053.62,2000),('2017-09-01',2,6,7458585547,12362.41,150.6,4849.4,5000),('2017-09-01',4,4,5841235983,22513.62,227.68,1772.32,2000),('2017-09-06',1,5,4517896325,50674,543.03,1456.97,2000),('2017-09-12',4,7,7489544933,48346.57,926.62,1073.38,2000),('2017-10-01',2,6,7458585547,7470.58,108.17,4891.83,5000),('2017-10-01',4,4,5841235983,20724.69,211.07,1788.93,2000),('2017-10-06',1,5,4517896325,49201.85,527.85,1472.15,2000),('2017-10-12',4,7,7489544933,47253.07,906.5,1093.5,2000),('2017-11-01',2,6,7458585547,2535.95,65.37,4934.63,5000),('2017-11-01',4,4,5841235983,18918.98,194.29,1805.71,2000),('2017-11-06',1,5,4517896325,47714.37,512.52,1487.48,2000),('2017-11-12',4,7,7489544933,46139.06,886,1114,2000),('2017-12-01',2,6,7458585547,0,22.19,2535.95,5000),('2017-12-01',4,4,5841235983,17096.35,177.37,1822.63,2000),('2017-12-06',1,5,4517896325,46211.4,497.02,1502.98,2000),('2017-12-12',4,7,7489544933,45004.17,865.11,1134.89,2000),('2018-01-01',4,4,5841235983,15256.62,160.28,1839.72,2000),('2018-01-06',1,5,4517896325,44692.77,481.37,1518.63,2000),('2018-01-12',4,7,7489544933,43848,843.83,1156.17,2000),('2018-02-01',4,4,5841235983,13399.66,143.03,1856.97,2000),('2018-02-06',1,5,4517896325,43158.32,465.55,1534.45,2000),('2018-02-12',4,7,7489544933,42670.15,822.15,1177.85,2000),('2018-03-01',4,4,5841235983,11525.28,125.62,1874.38,2000),('2018-03-06',1,5,4517896325,41607.88,449.57,1550.43,2000),('2018-03-12',4,7,7489544933,41470.21,800.07,1199.93,2000),('2018-04-01',4,4,5841235983,9633.33,108.05,1891.95,2000),('2018-04-06',1,5,4517896325,40041.3,433.42,1566.58,2000),('2018-04-12',4,7,7489544933,40247.78,777.57,1222.43,2000),('2018-05-01',4,4,5841235983,7723.64,90.31,1909.69,2000),('2018-05-06',1,5,4517896325,38458.39,417.1,1582.9,2000),('2018-05-12',4,7,7489544933,39002.43,754.65,1245.35,2000),('2018-06-01',4,4,5841235983,5796.05,72.41,1927.59,2000),('2018-06-06',1,5,4517896325,36859,400.61,1599.39,2000),('2018-06-12',4,7,7489544933,37733.72,731.3,1268.7,2000),('2018-07-01',4,4,5841235983,3850.39,54.34,1945.66,2000),('2018-07-06',1,5,4517896325,35242.95,383.95,1616.05,2000),('2018-07-12',4,7,7489544933,36441.23,707.51,1292.49,2000),('2018-08-01',4,4,5841235983,1886.48,36.1,1963.9,2000),('2018-08-06',1,5,4517896325,33610.06,367.11,1632.89,2000),('2018-08-12',4,7,7489544933,35124.5,683.27,1316.73,2000),('2018-09-01',4,4,5841235983,0,17.69,1886.48,2000),('2018-09-06',1,5,4517896325,31960.17,350.1,1649.9,2000),('2018-09-12',4,7,7489544933,33783.09,658.58,1341.42,2000),('2018-10-06',1,5,4517896325,30293.09,332.92,1667.08,2000),('2018-10-12',4,7,7489544933,32416.52,633.43,1366.57,2000),('2018-11-06',1,5,4517896325,28608.64,315.55,1684.45,2000),('2018-11-12',4,7,7489544933,31024.33,607.81,1392.19,2000),('2018-12-06',1,5,4517896325,26906.65,298.01,1701.99,2000),('2018-12-12',4,7,7489544933,29606.03,581.71,1418.29,2000),('2019-01-06',1,5,4517896325,25186.92,280.28,1719.72,2000),('2019-01-12',4,7,7489544933,28161.15,555.11,1444.89,2000),('2019-02-06',1,5,4517896325,23449.29,262.36,1737.64,2000),('2019-02-12',4,7,7489544933,26689.17,528.02,1471.98,2000),('2019-03-06',1,5,4517896325,21693.55,244.26,1755.74,2000),('2019-03-12',4,7,7489544933,25189.59,500.42,1499.58,2000),('2019-04-06',1,5,4517896325,19919.53,225.97,1774.03,2000),('2019-04-12',4,7,7489544933,23661.9,472.3,1527.7,2000),('2019-05-06',1,5,4517896325,18127.02,207.5,1792.5,2000),('2019-05-12',4,7,7489544933,22105.56,443.66,1556.34,2000),('2019-06-06',1,5,4517896325,16315.84,188.82,1811.18,2000),('2019-06-12',4,7,7489544933,20520.04,414.48,1585.52,2000),('2019-07-06',1,5,4517896325,14485.8,169.96,1830.04,2000),('2019-07-12',4,7,7489544933,18904.79,384.75,1615.25,2000),('2019-08-06',1,5,4517896325,12636.69,150.89,1849.11,2000),('2019-08-12',4,7,7489544933,17259.25,354.46,1645.54,2000),('2019-09-06',1,5,4517896325,10768.33,131.63,1868.37,2000),('2019-09-12',4,7,7489544933,15582.86,323.61,1676.39,2000),('2019-10-06',1,5,4517896325,8880.5,112.17,1887.83,2000),('2019-10-12',4,7,7489544933,13875.04,292.18,1707.82,2000),('2019-11-06',1,5,4517896325,6973,92.51,1907.49,2000),('2019-11-12',4,7,7489544933,12135.2,260.16,1739.84,2000),('2019-12-06',1,5,4517896325,5045.64,72.64,1927.36,2000),('2019-12-12',4,7,7489544933,10362.73,227.53,1772.47,2000),('2020-01-06',1,5,4517896325,3098.2,52.56,1947.44,2000),('2020-01-12',4,7,7489544933,8557.03,194.3,1805.7,2000),('2020-02-06',1,5,4517896325,1130.47,32.27,1967.73,2000),('2020-02-12',4,7,7489544933,6717.48,160.44,1839.56,2000),('2020-03-06',1,5,4517896325,0,11.78,1130.47,2000),('2020-03-12',4,7,7489544933,4843.43,125.95,1874.05,2000),('2020-04-12',4,7,7489544933,2934.25,90.81,1909.19,2000),('2020-05-12',4,7,7489544933,989.26,55.02,1944.98,2000),('2020-06-12',4,7,7489544933,0,18.55,989.26,2000);
/*!40000 ALTER TABLE `loan_calculation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_customer`
--

DROP TABLE IF EXISTS `loan_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan_customer` (
  `LoanId` int(11) NOT NULL,
  `CustomerId` int(11) NOT NULL,
  `Account Number` bigint(10) NOT NULL,
  `Loan Duration` int(11) DEFAULT NULL,
  `Start Date` date DEFAULT NULL,
  `Loan Amount` double DEFAULT NULL,
  `Loan Transferred` enum('YES','NO') DEFAULT NULL,
  PRIMARY KEY (`LoanId`,`CustomerId`),
  KEY `CustomerId_LoanCust_FK_idx` (`CustomerId`),
  KEY `AccountNum_LoanCust_FK_idx` (`Account Number`),
  CONSTRAINT `AccountNum_LoanCust_FK` FOREIGN KEY (`Account Number`) REFERENCES `accounts` (`Account Number`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CustomerId_LoanCust_FK` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `LoanId_LoanCust_FK` FOREIGN KEY (`LoanId`) REFERENCES `loan` (`LoanId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_customer`
--

LOCK TABLES `loan_customer` WRITE;
/*!40000 ALTER TABLE `loan_customer` DISABLE KEYS */;
INSERT INTO `loan_customer` VALUES (1,2,5467874253,12,'2016-01-01',70000,'NO'),(1,5,4517896325,12,'2017-06-06',55000,'NO'),(2,3,7458585547,18,'2016-01-01',80000,'NO'),(2,6,7458585547,12,'2017-01-01',50000,'NO'),(4,4,7489544933,12,'2016-01-01',55000,'NO'),(4,7,7489544933,24,'2016-09-12',60000,'NO');
/*!40000 ALTER TABLE `loan_customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER check_loanAmount
	BEFORE INSERT ON Loan_Customer
		FOR EACH ROW
			BEGIN
				SET @amount = (SELECT `Loan Amount Limit` FROM Loan WHERE LoanId = new.LoanId);
				IF(new.`Loan Amount` > @amount) THEN
					BEGIN
						SIGNAL SQLSTATE '45000' 
						SET MESSAGE_TEXT = 'The Amount limit exceeds the loan amount that can be provided.';
					END;
				END IF;
			END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER check_OnupdateloanAmount
BEFORE UPDATE ON LOAN_CUSTOMER
FOR EACH ROW
BEGIN
	SET @amtLimit = (SELECT `Loan Amount Limit`
					 FROM Loan
                     WHERE new.LoanId = LoanId);
	IF (new.`Loan Amount` > @amtLimit) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'The loan amount exceed given loan limit.';
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER  loanTransfer
BEFORE UPDATE ON LOAN_CUSTOMER
FOR EACH ROW
BEGIN
	IF(new.CustomerId != OLD.CustomerId) THEN
		 SET @checkLoanExistsWithCustomer = (SELECT 'True'
											FROM Loan_Customer
											WHERE OLD.CustomerId = new.CustomerId AND OLD.LoanId = new.LoanId);
		 SET @custId = OLD.CustomerId;
         SET @loan_Id = OLD.LoanId;
			
		 IF (@checkLoanExistsWithCustomer) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The Customer already has the same loan so cannot be transferred.';
		 ELSE
			SET @startdate = OLD.`Start Date`;
			SET @actualdate = (SELECT CURDATE());
			SET @duration = OLD.`Loan Duration`;
			SET @monNum = (SELECT TIMESTAMPDIFF(MONTH,@startdate,@actualdate));
            SET @duartionDiff = @duration - @monNum;            
			SET @getMon = (SELECT ADDDATE(@startdate, INTERVAL @monNum MONTH));
			SET @getAmount = (SELECT Amount
							  FROM Loan_Calculation as lc
							  WHERE lc.`Date` = @getMon AND (lc.CustomerId = @custId AND lc.LoanId = @loan_Id));
            
            SET NEW.`Loan Transferred` =  'YES';
            SET new.`Start date` = @actualdate;
            SET new.`Loan Duration` = @duartionDiff;
            SET new.`Loan Amount` = @getAmount;
            			
			INSERT INTO LOAN_TRANSFER 
			(LoanId,`Loan Transferred From`,`Loan Transferred To`,`Account Number`,Duration,`Date Of Transfer`,`Amount Transferred`,`Date Of Loan Commencement`,`Total Amount Loan`)
			VALUES
			(OLD.LoanId, OLD.CustomerId, NEW.CustomerId,OLD.`Account Number`,OLD.`Loan Duration`,@actualdate,@getAmount,OLD.`Start Date`,OLD.`Loan Amount`);
        END IF;
	END IF;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `loan_transfer`
--

DROP TABLE IF EXISTS `loan_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan_transfer` (
  `LoanId` int(11) NOT NULL,
  `Loan Transferred From` int(11) NOT NULL,
  `Loan Transferred To` int(11) NOT NULL,
  `Account Number` bigint(10) NOT NULL,
  `Duration` int(11) DEFAULT NULL,
  `Date Of Transfer` datetime DEFAULT NULL,
  `Amount Transferred` double DEFAULT NULL,
  `Date Of Loan Commencement` date DEFAULT NULL,
  `Total Amount Loan` double DEFAULT NULL,
  PRIMARY KEY (`LoanId`,`Loan Transferred From`),
  KEY `Loan_Transfer_To_FK_idx` (`Loan Transferred To`),
  CONSTRAINT `LoanId_Transfer_FK` FOREIGN KEY (`LoanId`) REFERENCES `loan_customer` (`LoanId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Loan_Transfer_To_FK` FOREIGN KEY (`Loan Transferred To`) REFERENCES `customer` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_transfer`
--

LOCK TABLES `loan_transfer` WRITE;
/*!40000 ALTER TABLE `loan_transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `loan_transfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `PersonId` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Contact_Number` bigint(10) NOT NULL,
  `Email_Address` varchar(50) DEFAULT NULL,
  `Address` varchar(150) DEFAULT NULL,
  `Date Of Birth` date NOT NULL,
  `Age` tinyint(100) NOT NULL,
  `Gender` enum('Male','Female') DEFAULT NULL,
  PRIMARY KEY (`PersonId`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'Manish','Kamani',9869690409,'manish.kamani@gmail.com','212 Germain Street','1962-12-05',55,'Male'),(2,'Parshva','Shah',8577897468,'shah.parshva@gmail.com','413 75 Peterborough Street','1993-06-05',24,'Female'),(3,'Henah','Montey',9872546874,'henah.montey@gmail.com','9 Newbury Street','1982-09-15',35,'Female'),(4,'Khushali','Mehta',31280587456,'mehta.khush@gmail.com','89 Mission Main','1953-08-18',64,'Female'),(5,'Harsh','Jain',8577897468,'jain.Harsh@gmail.com','56 Gainsborough Street','1961-05-05',56,'Male'),(6,'Varsha','Kulkarni',61774377489,'kulkarni.varsha@gmail.com','45 Smith Street','1984-02-24',33,'Female'),(7,'Parth','Shah',8747458967,'shah.parth@gmail.com','23 Stephen Street','1982-11-25',35,'Male'),(8,'Kaushal','Dedhia',8797458647,'dedhia.kaushal@gmail.com','14 Huntington Ave','1977-05-15',40,'Male'),(9,'Viren','Gala',6177457896,'gala.viren@gmail.com','23 Stephen Street','1982-07-11',35,'Male'),(10,'Krunal','Rambhia',8748567489,'rambhia.Krunal@gmail.com','12 Germain Street','1985-09-12',32,'Male'),(11,'Amar','Desai',6178547823,'desai.amar@gmail.com','74 Longwood Ave','1988-06-09',29,'Male'),(12,'Rahanik','Joshi',8577537486,'joshi.raha@gmail.com','02 Hemenway Street','1960-08-26',57,'Male'),(13,'Shaival','Shah',8577456321,'shah.shaival@gmail.com','34 Peterborough Street','1995-10-28',22,'Male'),(14,'Rohini','Shetty',857746314,'shetty.rohini@gmail.com','12 Parkdrive Street','1955-09-12',62,'Female'),(15,'Senapati','Bapat',6174567458,'bapat.sena@gmail.com','28 Germain Street','1990-02-14',27,'Male'),(16,'Shivani','Mehta',8547637483,'mehta.shivani@gmail.com','97 Mission Main','1992-04-19',25,'Female'),(17,'Litesh','Mehta',8577568947,'mehta.Litesh@gmail.com','97 Columbus Ave','1982-06-25',35,'Male'),(18,'Harsha','Gada',6177457896,'harsha45@gmail.com','54 Parker Hill','1989-07-23',28,'Female'),(19,'Heta','Shah',6178577458,'shahHeta@gmail.com','97 Jamaica Plain','1992-09-19',25,'Female'),(20,'Ruhi','Jain',8547468957,'jain.ruhi15@gmail.com','8 Tremont Street','1986-04-19',31,'Female'),(21,'Jigna','Vikmani',8547961369,'vikmani.jigu@gmail.com','97 speare street','1989-01-06',28,'Female'),(22,'Jignesh','Chedda',7485961236,'chedda.jigu@gmail.com','5 stephen street','1957-04-16',60,'Male'),(23,'Hemant','Shah',7485963214,'shah.hemu@gmail.com','9 tremont street','1967-11-26',50,'Male'),(24,'Krisha','Verma',85774537489,'verma.kri@gmail.com','45 smith street','1972-11-06',45,'Female'),(25,'Harshit','Pathak',6177458965,'pathak.harshit@gmail.com','89 Peterborough street','1956-08-11',61,'Male'),(26,'Paresh','Soni',6178967485,'soni.par@gmail.com','45 smith street','1977-09-15',40,'Male'),(27,'Rahanik','Vora',6174587896,'vora.rahu@gmail.com','25 Hemenway street','1993-05-12',24,'Male'),(28,'Krishna','Gandhi',8577458963,'gandhi.krish@gmail.com','9 Burney street','1990-05-17',27,'Female'),(29,'Kavita','Shah',8574567895,'shah.kavita@gmail.com','9A Newbur street','1988-11-12',29,'Female'),(30,'Reshma','Mulla',6174567895,'mulla.resh@gmail.com','23 Queensbery street','1985-03-16',32,'Female'),(31,'Rahul','Sharma',6178547896,'sharma.rahul@gmail.com','23 Jersey street','1985-04-26',32,'Male'),(32,'Prakash','Jha',8577458963,'jha.prakash@gmail.com','12 Mary street','1983-03-16',30,'Male'),(33,'Oliver','DMello',6147568945,'dmello@gmail.com','12 Queensberry street','1982-12-26',35,'Male'),(34,'Himesh','Mehta',6178965478,'resh@gmail.com','42 ParkDrive street','1985-09-16',32,'Male'),(35,'Rashmi','Gada',6174568796,'rashmi@gmail.com','45 Queensbery street','1986-10-26',31,'Female'),(36,'Hiren','Rathod',6174567896,'rathodl@gmail.com','3 Jersey street','1975-04-26',42,'Male'),(37,'Dev','Rastogi',8577458963,'rastogi@gmail.com','15 Mary street','1973-05-16',40,'Male'),(38,'Ruhi','Shah',6174587894,'shah.ruh@gmail.com','45 Queensberry street','1982-12-26',35,'Female'),(39,'Kruti','Dedhia',6178954789,'kruti@gmail.com','1 Tremont street','1985-03-17',32,'Female'),(40,'Hemlata','Gala',6174568967,'hemlata.gala@gmail.com','89 Newbury street','1986-10-26',31,'Female');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER check_Person_Age
	BEFORE INSERT ON Person
		FOR EACH ROW
			BEGIN
				IF(new.Age < 18) THEN
					BEGIN
						SIGNAL SQLSTATE '45000'  
						SET MESSAGE_TEXT = 'The Age of Person should not be less than 18';
                    END;
				END IF;
			END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `view_bank_profit_per_branch_annually`
--

DROP TABLE IF EXISTS `view_bank_profit_per_branch_annually`;
/*!50001 DROP VIEW IF EXISTS `view_bank_profit_per_branch_annually`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_bank_profit_per_branch_annually` AS SELECT 
 1 AS `BranchId`,
 1 AS `LoanType`,
 1 AS `Total Interest`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_customerswithmorethan_one_account`
--

DROP TABLE IF EXISTS `view_customerswithmorethan_one_account`;
/*!50001 DROP VIEW IF EXISTS `view_customerswithmorethan_one_account`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_customerswithmorethan_one_account` AS SELECT 
 1 AS `CustomerId`,
 1 AS `Full Name`,
 1 AS `BranchId`,
 1 AS `Account Number`,
 1 AS `Account Type`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_customerwithmorethan_onecc`
--

DROP TABLE IF EXISTS `view_customerwithmorethan_onecc`;
/*!50001 DROP VIEW IF EXISTS `view_customerwithmorethan_onecc`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_customerwithmorethan_onecc` AS SELECT 
 1 AS `CustomerId`,
 1 AS `Full Name`,
 1 AS `CC Number`,
 1 AS `Date of Activation`,
 1 AS `Expiry Date`,
 1 AS `Credit Score`,
 1 AS `Maximum Limit`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_employees_customers`
--

DROP TABLE IF EXISTS `view_employees_customers`;
/*!50001 DROP VIEW IF EXISTS `view_employees_customers`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_employees_customers` AS SELECT 
 1 AS `EmployeeId`,
 1 AS `Full Name`,
 1 AS `Designation`,
 1 AS `BranchId`,
 1 AS `Account Number`,
 1 AS `Account Type`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_quaterly_accounts_opened`
--

DROP TABLE IF EXISTS `view_quaterly_accounts_opened`;
/*!50001 DROP VIEW IF EXISTS `view_quaterly_accounts_opened`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_quaterly_accounts_opened` AS SELECT 
 1 AS `BranchId`,
 1 AS `Total Number Of Accounts`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_totalcustomers_perbranch_annually`
--

DROP TABLE IF EXISTS `view_totalcustomers_perbranch_annually`;
/*!50001 DROP VIEW IF EXISTS `view_totalcustomers_perbranch_annually`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_totalcustomers_perbranch_annually` AS SELECT 
 1 AS `BranchId`,
 1 AS `LoanType`,
 1 AS `Total Customers`,
 1 AS `Total Loan Amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_totalinterest_customer_paid`
--

DROP TABLE IF EXISTS `view_totalinterest_customer_paid`;
/*!50001 DROP VIEW IF EXISTS `view_totalinterest_customer_paid`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_totalinterest_customer_paid` AS SELECT 
 1 AS `CustomerId`,
 1 AS `Full Name`,
 1 AS `loanId`,
 1 AS `LoanType`,
 1 AS `Loan Amount`,
 1 AS `Loan Duration`,
 1 AS `Total Interest`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_weekly_transactions_per_branch`
--

DROP TABLE IF EXISTS `view_weekly_transactions_per_branch`;
/*!50001 DROP VIEW IF EXISTS `view_weekly_transactions_per_branch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_weekly_transactions_per_branch` AS SELECT 
 1 AS `BranchId`,
 1 AS `Total Transactions`,
 1 AS `Total Amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'bankdb'
--

--
-- Dumping routines for database 'bankdb'
--
/*!50003 DROP FUNCTION IF EXISTS `calculateInterest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculateInterest`(loanAmt Double, roi Double, duration INT) RETURNS double
BEGIN
	RETURN  (loanAmt*(roi/100)*(duration/12))/12;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `concat_Name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `concat_Name`(firstName VARCHAR(50), lastName VARCHAR(50)) RETURNS varchar(100) CHARSET utf8
RETURN CONCAT_WS(' ',firstName, lastName) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `bank_Statement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `bank_Statement`(IN startDate DATE, IN endDate DATE, IN custId int)
BEGIN
SELECT cust.CustomerId,	concat_Name(per.FirstName, per.LastName) AS 'FULL Name', ca.`Account Number`, 
		bt.`Transaction DateTime`, bt.`Transaction Amount`, bt.`Transaction Type`, bt.`Amount Transferred To Account`
FROM Customer AS cust 
	INNER JOIN  Person AS per ON per.PersonId = cust.PersonId
	INNER JOIN Customer_Accounts AS ca ON ca.CustomerId = cust.CustomerId
    LEFT JOIN Bank_Transactions AS bt ON bt.CustomerId = cust.CustomerId 
WHERE cust.CustomerId = custId AND (DATE(bt.`Transaction DateTime`) BETWEEN startdate AND endDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `beginTransaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `beginTransaction`(IN amount double,IN transactionType VARCHAR(20),IN accNum BIGINT(10))
BEGIN
	IF transactionType = 'Withdraw' THEN
		SET @minAmt = (SELECT `Minimum Balance Restriction` 
					  FROM Accounts 
					  WHERE `Account Number` = accNum);
		SET @balRem = (SELECT `Account Balance`
					  FROM Accounts
                      WHERE `Account Number` = accNum);
		SET @transactDetails = 'Amount withdrawed.';
        
		IF @balRem - amount > @minAmt THEN
			START TRANSACTION;
				SET @amtRemain = @balRem - amount;
				UPDATE Accounts
				SET `Account Balance` = @amtRemain
				WHERE `Account Number` = accNum ;
				
				SET @custId = (SELECT CustomerId FROM CUSTOMER_ACCOUNTS WHERE `Account Number` = accNum);
				
				INSERT INTO BANK_TRANSACTIONS (`Transaction DateTime`,`Transaction Type`,`Amount Transferred To Account`,`CustomerId`,`Transaction Amount`,`Transaction Details`)
				VALUES
				(NOW(),transactionType,accNum,@custId,amount,@transactDetails);
			COMMIT;
			
            SELECT 'Transaction Completed Successfully.';
		ELSE
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT ='The remaining amount is less than the minimum balance in the account!';
		END IF;
    END IF;
    
    IF transactionType = 'Deposit' THEN
		SET @balRem = (SELECT `Account Balance`
					  FROM Accounts
                      WHERE `Account Number` = accNum);
		SET @transactDetails = 'Amount deposited.';
        
        START TRANSACTION;
				SET @amtRemain = @balRem + amount;
				SET @custId = (SELECT CustomerId FROM CUSTOMER_ACCOUNTS WHERE `Account Number` = accNum);
                
                UPDATE Accounts
				SET `Account Balance` = @amtRemain
				WHERE `Account Number` = accNum ;
				
				INSERT INTO BANK_TRANSACTIONS(`CustomerId`,`Transaction DateTime`,`Transaction Type`,`Amount Transferred To Account`,`Transaction Amount`,`Transaction Details`)
				VALUES
				(@custId,NOW(),transactionType,accNum,amount,@transactDetails);
		COMMIT;
			
		SELECT 'Transaction Completed Successfully.';
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calculate_loan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_loan`(IN loan_Id INT,IN custId INT)
BEGIN
	SET @loanAmount = (SELECT `Loan Amount`
						FROM Loan_Customer
                        WHERE LoanId = loan_Id AND CustomerId = custId);
	SET @startDate = (SELECT `Start Date`
						FROM Loan_Customer
                        WHERE LoanId = loan_Id AND CustomerId = custId);
	SET @rateOfInterest = (SELECT `Rate Of Interest`
							FROM loan
                            WHERE LoanId = loan_Id);
	SET @duration = (SELECT `Loan Duration`
					FROM loan_customer
                    WHERE LoanId = loan_Id AND CustomerId = custId);
	SET @payment = (SELECT `Minimum Balance Restriction`
					FROM Accounts
					WHERE `Account Number` = (SELECT ac.`Account Number`
												FROM customer_accounts AS ca 
                                                JOIN Accounts AS ac ON ca.`Account Number` = ac.`Account Number`
                                                WHERE ca.CustomerId = custId AND ac.`Account Type` = 'LoanAcc'));
	SET @accNum = (SELECT ac.`Account Number`
				   FROM customer_accounts AS ca 
                   JOIN Accounts AS ac ON ca.`Account Number` = ac.`Account Number`
                   WHERE ca.CustomerId = custId AND ac.`Account Type` = 'LoanAcc');
	SET @mon = @startDate;
                            
	SET @totalamount = @loanAmount;
	WHILE @totalamount > 0 DO
		SET @interest = (SELECT calculateInterest(@totalamount,@rateOfInterest,@duration));
		SET @redemption = @payment - @interest;
    
        IF(@totalamount > @redemption) THEN
			SET @totalamount = @totalamount - @redemption;
		ELSE 
			SET @redemption = @totalamount;
			SET @totalAmount = 0;
		END IF;
        SET @mon = (SELECT ADDDATE(@mon, INTERVAL '1' MONTH));
        
        INSERT INTO Loan_Calculation
        (`Date`,LoanId,CustomerId,`Account Number`,Amount,Interest,Redemption,Payment)
        VALUES 
        (@mon,loan_Id,custId,@accNum,ROUND(@totalamount,2),ROUND(@interest,2),ROUND(@redemption,2),@payment);
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creditcardTransaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creditcardTransaction`(IN amount INT, IN ccNum BIGINT(10))
BEGIN
	SET @amt = (SELECT `Maximum Limit` 
				FROM CREDIT_CARD
                WHERE `CC Number` = ccNum);
	
    IF(amount < @amt) THEN
		SET @transactDetails ='Transaction Completed Successfully.';
		INSERT INTO credit_card_transactions
        (`CC Number`, `Transaction DateTime`,`Transaction Amount`,`Transaction Details`)
        VALUES 
        (ccNum,NOW(),amount,@transactDetails);
    ELSE
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT ='The amount is greater than credit card limit offered.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `transferInterAccAmount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `transferInterAccAmount`(IN amount INT, IN accFrom BIGINT(10),IN accTo BIGINT(10))
BEGIN
	SET @minAmt = (SELECT `Minimum Balance Restriction` 
					  FROM Accounts 
					  WHERE `Account Number` = accFrom);
	SET @balRemAccFrom = (SELECT `Account Balance`
					  FROM Accounts
                      WHERE `Account Number` = accFrom);
	SET @balRemAccTo = (SELECT `Account Balance`
					  FROM Accounts
                      WHERE `Account Number` = accTo);
	SET @transactDetails = 'Amount transferred.';
    
	IF @balRemAccFrom - amount > @minAmt THEN
		START TRANSACTION;
			SET @amtRemain = @balRemAccFrom - amount;
            SET @amtForAccTo = @balRemAccTo + amount;
            SET @custId = (SELECT CustomerId FROM CUSTOMER_ACCOUNTS WHERE `Account Number` = accFrom);
			
            UPDATE Accounts
			SET `Account Balance` = @amtRemain
			WHERE `Account Number` = accFrom ;
            
            UPDATE Accounts
			SET `Account Balance` = @amtForAccTo
			WHERE `Account Number` = accTo ;
            
            INSERT INTO BANK_TRANSACTIONS(`CustomerId`,`Transaction DateTime`,`Transaction Type`,`Amount Transferred To Account`,`Amount Transferred From Account`,`Transaction Amount`,`Transaction Details`)
            VALUES
            (@custId,NOW(),'Amount Transfer',accTo,accFrom,amount,@transactDetails);
          COMMIT;  
		  SELECT 'Transaction Completed Successfully.'; 
	ELSE
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT ='The remaining amount is less than the minimum balance in the account!';
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_bank_profit_per_branch_annually`
--

/*!50001 DROP VIEW IF EXISTS `view_bank_profit_per_branch_annually`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_bank_profit_per_branch_annually` AS select `ac`.`BranchId` AS `BranchId`,`l`.`LoanType` AS `LoanType`,round(sum(`lc`.`Interest`),2) AS `Total Interest` from ((`loan_calculation` `lc` join `accounts` `ac` on((`ac`.`Account Number` = `lc`.`Account Number`))) left join `loan` `l` on((`l`.`LoanId` = `lc`.`LoanId`))) where ((`lc`.`Date` <= curdate()) and (`lc`.`Date` >= (curdate() - interval '1' year))) group by `ac`.`BranchId`,`l`.`LoanType` with rollup */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_customerswithmorethan_one_account`
--

/*!50001 DROP VIEW IF EXISTS `view_customerswithmorethan_one_account`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_customerswithmorethan_one_account` AS select `cust`.`CustomerId` AS `CustomerId`,`concat_Name`(`per`.`FirstName`,`per`.`LastName`) AS `Full Name`,`ac`.`BranchId` AS `BranchId`,`ca`.`Account Number` AS `Account Number`,`ac`.`Account Type` AS `Account Type` from (((`customer` `cust` join `person` `per` on((`per`.`PersonId` = `cust`.`PersonId`))) join `customer_accounts` `ca` on((`ca`.`CustomerId` = `cust`.`CustomerId`))) left join `accounts` `ac` on((`ac`.`Account Number` = `ca`.`Account Number`))) where `ca`.`CustomerId` in (select `customer_accounts`.`CustomerId` from `customer_accounts` group by `customer_accounts`.`CustomerId` having (count(`customer_accounts`.`CustomerId`) > 1)) order by `cust`.`CustomerId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_customerwithmorethan_onecc`
--

/*!50001 DROP VIEW IF EXISTS `view_customerwithmorethan_onecc`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_customerwithmorethan_onecc` AS select `cc`.`CustomerId` AS `CustomerId`,`concat_Name`(`per`.`FirstName`,`per`.`LastName`) AS `Full Name`,`cc`.`CC Number` AS `CC Number`,`cc`.`Date Of Activation` AS `Date of Activation`,`cc`.`Expiry Date` AS `Expiry Date`,`cc`.`Credit Score` AS `Credit Score`,`cc`.`Maximum Limit` AS `Maximum Limit` from ((`credit_card` `cc` join `customer` `cust` on((`cust`.`CustomerId` = `cc`.`CustomerId`))) left join `person` `per` on((`per`.`PersonId` = `cust`.`PersonId`))) where `cc`.`CustomerId` in (select `credit_card`.`CustomerId` from `credit_card` group by `credit_card`.`CustomerId` having (count(`credit_card`.`CustomerId`) > 1)) order by `cc`.`CustomerId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_employees_customers`
--

/*!50001 DROP VIEW IF EXISTS `view_employees_customers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_employees_customers` AS select `emp`.`EmployeeId` AS `EmployeeId`,`concat_Name`(`per`.`FirstName`,`per`.`LastName`) AS `Full Name`,`emp`.`Designation` AS `Designation`,`ac`.`BranchId` AS `BranchId`,`ac`.`Account Number` AS `Account Number`,`ac`.`Account Type` AS `Account Type` from ((((`employee` `emp` join `person` `per` on((`per`.`PersonId` = `emp`.`PersonId`))) join `customer` `cust` on((`cust`.`PersonId` = `per`.`PersonId`))) left join `customer_accounts` `ca` on((`ca`.`CustomerId` = `cust`.`CustomerId`))) left join `accounts` `ac` on((`ac`.`Account Number` = `ca`.`Account Number`))) where (`emp`.`IsActive?` = 'YES') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_quaterly_accounts_opened`
--

/*!50001 DROP VIEW IF EXISTS `view_quaterly_accounts_opened`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_quaterly_accounts_opened` AS select `accounts`.`BranchId` AS `BranchId`,count(`accounts`.`Account Type`) AS `Total Number Of Accounts` from `accounts` where ((`accounts`.`IsActive?` = 'YES') and (`accounts`.`Date Of Opening` <= curdate()) and (`accounts`.`Date Of Opening` >= (curdate() - interval '3' month))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_totalcustomers_perbranch_annually`
--

/*!50001 DROP VIEW IF EXISTS `view_totalcustomers_perbranch_annually`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_totalcustomers_perbranch_annually` AS select `ac`.`BranchId` AS `BranchId`,`l`.`LoanType` AS `LoanType`,count(`lc`.`CustomerId`) AS `Total Customers`,sum(`lc`.`Loan Amount`) AS `Total Loan Amount` from ((`loan_customer` `lc` join `loan` `l` on((`l`.`LoanId` = `lc`.`LoanId`))) left join `accounts` `ac` on((`lc`.`Account Number` = `ac`.`Account Number`))) where (curdate() >= (curdate() - interval '1' year)) group by `ac`.`BranchId`,`l`.`LoanType` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_totalinterest_customer_paid`
--

/*!50001 DROP VIEW IF EXISTS `view_totalinterest_customer_paid`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_totalinterest_customer_paid` AS select `cust`.`CustomerId` AS `CustomerId`,`concat_Name`(`per`.`FirstName`,`per`.`LastName`) AS `Full Name`,`l`.`LoanId` AS `loanId`,`l`.`LoanType` AS `LoanType`,`lc`.`Loan Amount` AS `Loan Amount`,`lc`.`Loan Duration` AS `Loan Duration`,round(sum(`lcal`.`Interest`),2) AS `Total Interest` from ((((`customer` `cust` join `loan_customer` `lc` on((`lc`.`CustomerId` = `cust`.`CustomerId`))) join `person` `per` on((`per`.`PersonId` = `cust`.`PersonId`))) left join `loan` `l` on((`l`.`LoanId` = `lc`.`LoanId`))) left join `loan_calculation` `lcal` on(((`lcal`.`LoanId` = `lc`.`LoanId`) and (`lc`.`CustomerId` = `lcal`.`CustomerId`)))) group by `cust`.`CustomerId`,'Full Name',`l`.`LoanId`,`l`.`LoanType`,`lc`.`Loan Amount`,`lc`.`Loan Duration` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_weekly_transactions_per_branch`
--

/*!50001 DROP VIEW IF EXISTS `view_weekly_transactions_per_branch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_weekly_transactions_per_branch` AS select `ac`.`BranchId` AS `BranchId`,count(`bt`.`TransactionId`) AS `Total Transactions`,sum(`bt`.`Transaction Amount`) AS `Total Amount` from (`bank_transactions` `bt` join `accounts` `ac` on((`ac`.`Account Number` = `bt`.`Amount Transferred To Account`))) where ((cast(`bt`.`Transaction DateTime` as date) <= curdate()) and (cast(`bt`.`Transaction DateTime` as date) >= (curdate() - interval '7' day))) group by `ac`.`BranchId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-13 20:05:42
