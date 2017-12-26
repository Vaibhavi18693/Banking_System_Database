CREATE USER 'Manager'@'localhost'
IDENTIFIED BY 'man';

CREATE USER 'Clerk'@'localhost'
IDENTIFIED BY 'clerk';

CREATE USER 'Teller'@'localhost'
IDENTIFIED BY 'teller';

CREATE USER 'LoanManager'@'localhost'
IDENTIFIED BY 'lman';

CREATE USER 'HR'@'localhost'
IDENTIFIED BY 'HR';

GRANT ALL ON bankdb.* TO 'Manager'@'localhost' WITH GRANT OPTION;

GRANT SELECT ON bankdb.Bank_Transactions
TO 'Clerk'@'localhost';

GRANT SELECT ON bankdb.Accounts
TO 'Clerk'@'localhost';

GRANT SELECT ON bankdb.Customer_Accounts
TO 'Clerk'@'localhost';

GRANT SELECT(PersonId,FirstName,LastName,`Date Of Birth`,Gender) ON bankdb.Person
TO 'Clerk'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Bank_Transactions
TO 'Teller'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Accounts
TO 'Teller'@'localhost'; 

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Customer_Accounts
TO 'Teller'@'localhost';

GRANT SELECT, UPDATE ON bankdb.Customer
TO 'Teller'@'localhost';

GRANT SELECT, UPDATE  ON bankdb.Person
TO 'Teller'@'localhost';

GRANT EXECUTE ON PROCEDURE bankdb.bank_Statement
TO 'Teller'@'localhost';

GRANT EXECUTE ON PROCEDURE bankdb.beginTransaction
TO 'Teller'@'localhost';

GRANT EXECUTE ON PROCEDURE bankdb.transferInterAccAmount
TO 'Teller'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Loan 
TO 'LoanManager'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Loan_Customer 
TO 'LoanManager'@'localhost'; 

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Loan_Calculation 
TO 'LoanManager'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Loan_Transfer 
TO 'LoanManager'@'localhost';

GRANT SELECT, UPDATE ON bankdb.Customer 
TO 'LoanManager'@'localhost';

GRANT SELECT ON bankdb.Customer_Accounts 
TO 'LoanManager'@'localhost';

GRANT SELECT  ON bankdb.Accounts 
TO 'LoanManager'@'localhost';

GRANT EXECUTE ON PROCEDURE bankdb.calculate_loan
TO 'LoanManager'@'localhost'; 

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Person 
TO 'HR'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT ON bankdb.Employee 
TO 'HR'@'localhost';