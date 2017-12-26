-- TRIGGERS

DROP TRIGGER IF EXISTS check_Person_Age;
DELIMITER $$
	CREATE TRIGGER check_Person_Age
	BEFORE INSERT ON Person
		FOR EACH ROW
			BEGIN
				IF(new.Age < 18) THEN
					BEGIN
						SIGNAL SQLSTATE '45000'  
						SET MESSAGE_TEXT = 'The Age of Person should not be less than 18';
                    END;
				END IF;
			END
$$

DROP TRIGGER IF EXISTS check_loanAmount;
DELIMITER $$
	CREATE TRIGGER check_loanAmount
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
			END
$$

DROP TRIGGER IF EXISTS inactiveEmp; -- If the employee is made inactive delete it from branch employee and it add it in branch employee history
DELIMITER $$
CREATE TRIGGER inactiveEmp
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
END
$$


DROP TRIGGER IF EXISTS branchUpdate;
DELIMITER $$
CREATE TRIGGER branchUpdate
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
END
$$

DROP TRIGGER IF EXISTS branchDelete;
DELIMITER $$
CREATE TRIGGER branchDelete
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
END
$$


DROP TRIGGER IF EXISTS inactiveAccount;
DELIMITER $$
CREATE TRIGGER inactiveAccount 
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
END
$$

DROP TRIGGER IF EXISTS check_loanAmount;
DELIMITER $$
CREATE TRIGGER check_loanAmount
BEFORE INSERT ON LOAN_CUSTOMER
FOR EACH ROW
BEGIN
	SET @amtLimit = (SELECT `Loan Amount Limit`
					 FROM Loan
                     WHERE new.LoanId = LoanId);
	IF (new.`Loan Amount` > @amtLimit) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'The loan amount exceed given loan limit.';
	END IF;
END
$$

DROP TRIGGER IF EXISTS check_OnupdateloanAmount;
DELIMITER $$
CREATE TRIGGER check_OnupdateloanAmount
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
END
$$

DROP TRIGGER IF EXISTS loanTransfer;
DELIMITER $$
CREATE TRIGGER  loanTransfer
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
END
$$


-- FUNCTIONS

DROP FUNCTION IF EXISTS calculateInterest;
DELIMITER $$
CREATE FUNCTION calculateInterest(loanAmt Double, roi Double, duration INT)
RETURNS DOUBLE
BEGIN
	RETURN  (loanAmt*(roi/100)*(duration/12))/12;
END
$$

DROP FUNCTION IF EXISTS concat_Name;
DELIMITER $$
CREATE FUNCTION concat_Name (firstName VARCHAR(50), lastName VARCHAR(50))
RETURNS VARCHAR(100)
RETURN CONCAT_WS(' ',firstName, lastName);
$$


-- PROCEDURES

DROP PROCEDURE IF EXISTS beginTransaction;
DELIMITER $$
CREATE PROCEDURE beginTransaction(IN amount double,IN transactionType VARCHAR(20),IN accNum BIGINT(10))
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
END
$$

DROP PROCEDURE IF EXISTS transferInterAccAmount;
DELIMITER $$
CREATE PROCEDURE transferInterAccAmount(IN amount INT, IN accFrom BIGINT(10),IN accTo BIGINT(10))
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
END
$$


DROP PROCEDURE IF EXISTS creditcardTransaction;
DELIMITER $$
CREATE PROCEDURE creditcardTransaction(IN amount INT, IN ccNum BIGINT(10))
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
END
$$

DROP PROCEDURE IF EXISTS calculate_loan;
DELIMITER $$
CREATE PROCEDURE calculate_loan(IN loan_Id INT,IN custId INT)
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
END
$$

-- to get the bank statement of the customer between particular date
DROP PROCEDURE IF EXISTS bank_Statement;
DELIMITER $$
CREATE PROCEDURE bank_Statement(IN startDate DATE, IN endDate DATE, IN custId int)
BEGIN
SELECT cust.CustomerId,	concat_Name(per.FirstName, per.LastName) AS 'FULL Name', ca.`Account Number`, 
		bt.`Transaction DateTime`, bt.`Transaction Amount`, bt.`Transaction Type`, bt.`Amount Transferred To Account`
FROM Customer AS cust 
	INNER JOIN  Person AS per ON per.PersonId = cust.PersonId
	INNER JOIN Customer_Accounts AS ca ON ca.CustomerId = cust.CustomerId
    LEFT JOIN Bank_Transactions AS bt ON bt.CustomerId = cust.CustomerId 
WHERE cust.CustomerId = custId AND (DATE(bt.`Transaction DateTime`) BETWEEN startdate AND endDate);
END
$$


-- VIEWS

-- To get total number of transactions per branch 
DROP VIEW IF EXISTS view_Weekly_Transactions_Per_Branch;
CREATE VIEW view_Weekly_Transactions_Per_Branch AS
	SELECT ac.BranchId, COUNT(bt.TransactionId) AS 'Total Transactions', SUM(bt.`Transaction Amount`) AS 'Total Amount'
	FROM Bank_Transactions AS bt JOIN Accounts AS ac ON ac.`Account Number` = bt.`Amount transferred To Account`
    WHERE (DATE(`Transaction DateTime`) <= CURDATE() AND DATE(`Transaction DateTime`) >= SUBDATE(CURDATE(), INTERVAL '7' DAY))
    GROUP BY ac.BranchId;
    
SELECT * FROM view_Weekly_Transactions_Per_Branch;


-- To get total accounts opened by bank per branch quaterly
DROP VIEW IF EXISTS view_Quaterly_Accounts_Opened;
CREATE VIEW view_Quaterly_Accounts_Opened AS
	SELECT BranchId, COUNT(`Account Type`) AS 'Total Number Of Accounts'
    FROM Accounts
    WHERE `IsActive?` = 'YES' AND 
		`Date Of Opening` <= CURDATE() AND  `Date Of Opening` >= SUBDATE(CURDATE(), INTERVAL '3' MONTH);

SELECT * FROM view_Quaterly_Accounts_Opened;

-- To calculate total profit made by bank based on loan interest per branch
DROP VIEW IF EXISTS view_Bank_Profit_Per_Branch_Annually;
CREATE VIEW view_Bank_Profit_Per_Branch_Annually AS
	SELECT ac.BranchId AS BranchId,l.LoanType, ROUND(SUM(lc.Interest),2) AS 'Total Interest' 
	FROM loan_calculation AS lc 
		INNER JOIN accounts AS ac ON ac.`Account Number` = lc.`Account Number`
		LEFT JOIN loan AS l ON l.loanid = lc.loanid
	WHERE lc.`Date` <= CURDATE() AND lc.`Date` >=  SUBDATE(CURDATE(), INTERVAL '1' YEAR) 
	GROUP BY ac.BranchId,l.loanType WITH ROLLUP;		

SELECT * FROM view_Bank_Profit_Per_Branch_Annually;

-- To get total loan type count by customers per branch per year
DROP VIEW IF EXISTS view_TotalCustomers_PerBranch_Annually;
CREATE VIEW view_TotalCustomers_PerBranch_Annually AS
	SELECT ac.BranchId, l.LoanType ,COUNT(lc.CustomerId) AS 'Total Customers', SUM(lc.`Loan Amount`) AS 'Total Loan Amount'
	FROM loan_Customer AS lc
		INNER JOIN loan AS l ON l.loanId = lc.LoanId
		LEFT JOIN Accounts AS ac ON lc.`Account Number` = ac.`Account Number`
	WHERE CURDATE() >= SUBDATE(CURDATE(), INTERVAL'1' YEAR)
	GROUP BY ac.BranchId, l.LoanType;
    
 SELECT * FROM view_TotalCustomers_PerBranch_Annually;   

-- TO get the list of employees who are also the customers of the same bank
DROP VIEW IF EXISTS view_Employees_Customers;
CREATE VIEW view_Employees_Customers AS
	SELECT emp.EmployeeId,concat_Name(per.FirstName,per.LastName) AS 'Full Name', emp.Designation, 
			ac.BranchId, ac.`Account Number`,ac.`Account Type`
	FROM Employee AS emp 
		INNER JOIN Person AS per ON per.PersonId = emp.PersonId
		INNER JOIN Customer AS cust ON cust.PersonId = per.PersonId
		LEFT JOIN Customer_Accounts AS ca ON ca.CustomerId = cust.CustomerId
		LEFT JOIN Accounts AS ac ON ac.`Account Number` = ca.`Account Number`
	WHERE emp.`IsActive?` = 'YES';
    
SELECT * FROM view_Employees_Customers;

-- To get the list of customers having more than on account in bank branch
DROP VIEW IF EXISTS view_CustomersWithMoreThan_One_Account;
CREATE VIEW view_CustomersWithMoreThan_One_Account AS
	SELECT cust.CustomerId,concat_Name(per.FirstName, per.LastName) AS 'Full Name', ac.BranchId, 
			ca.`Account Number`,ac.`Account Type`
	FROM Customer AS cust
		INNER JOIN Person AS per ON per.PersonId = cust.PersonId
		INNER JOIN Customer_Accounts AS ca ON ca.CustomerId = cust.CustomerId
		LEFT JOIN Accounts AS ac ON ac.`Account Number` = ca.`Account Number`
	WHERE ca.CustomerId IN (SELECT CustomerId
							FROM Customer_Accounts
							GROUP BY CustomerId
							HAVING COUNT(CustomerId)>1)
	ORDER BY cust.CustomerId;

SELECT * FROM view_CustomersWithMoreThan_One_Account;

-- To let the amount of interest the customer pays on loan for particular amount and period
DROP VIEW IF EXISTS view_TotalInterest_Customer_Paid;
CREATE VIEW view_TotalInterest_Customer_Paid AS
	SELECT cust.CustomerId, concat_Name(per.FirstName, per.LastName) AS 'Full Name', 
			l.loanId,l.LoanType, lc.`Loan Amount`, lc.`Loan Duration`, ROUND(SUM(lcal.Interest),2) AS 'Total Interest'
	FROM customer AS cust
		INNER JOIN loan_customer AS lc ON lc.CustomerId = cust.CustomerId
		INNER JOIN Person AS per ON per.PersonId = cust.PersonId
		LEFT JOIN Loan AS l ON l.LoanId = lc.LoanId
		LEFT JOIN loan_calculation AS lcal ON lcal.LoanId = lc.LoanId and lc.CustomerId = lcal.CustomerId
	GROUP By cust.CustomerId, 'Full Name', l.loanId, l.LoanType, lc.`Loan Amount`, lc.`Loan Duration`;

SELECT * FROM view_TotalInterest_Customer_Paid;


-- To get the details of the customer and credit card having more than 1 credit card
DROP VIEW IF EXISTS view_CustomerWithMoreThan_OneCC;
CREATE VIEW view_CustomerWithMoreThan_OneCC AS
	SELECT cc.CustomerId,concat_Name(per.FirstName,per.LastName) AS 'Full Name', cc.`CC Number`,
			cc.`Date of Activation`, cc.`Expiry Date`, cc.`Credit Score`, cc.`Maximum Limit`
	FROM credit_card AS cc
		 INNER JOIN Customer AS cust ON cust.CustomerId = cc.CustomerId
		 LEFT JOIN Person  AS per ON per.PersonId = cust.PersonId
	WHERE cc.CustomerId IN (SELECT CustomerId
							FROM credit_card
							GROUP BY CustomerId
							HAVING COUNT(CustomerId) > 1)
	ORDER BY cc.CustomerId;

SELECT * FROM view_CustomerWithMoreThan_OneCC;

