CREATE DATABASE BankingSystem;
USE BankingSystem;

-- Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(15),
    Address NVARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Accounts table
CREATE TABLE Accounts (
    AccountID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    AccountNumber NVARCHAR(20) UNIQUE,
    AccountType NVARCHAR(20),
    Balance DECIMAL(18,2) DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Transactions table
CREATE TABLE Transactions (
    TransactionID INT IDENTITY PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    TransactionType NVARCHAR(20),
    Amount DECIMAL(18,2),
    TransactionDate DATETIME DEFAULT GETDATE(),
    Remarks NVARCHAR(200)
);

GO
CREATE PROCEDURE CreateCustomer
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(15),
    @Address NVARCHAR(200)
AS
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
    VALUES (@FirstName, @LastName, @Email, @Phone, @Address);
END;

GO
CREATE PROCEDURE OpenAccount
    @CustomerID INT,
    @AccountType NVARCHAR(20),
    @InitialDeposit DECIMAL(18,2)
AS
BEGIN
    DECLARE @AccountNumber NVARCHAR(20);
    SET @AccountNumber = CAST(@CustomerID AS NVARCHAR(10)) + CAST(ABS(CHECKSUM(NEWID())) % 1000000 AS NVARCHAR(10));

    INSERT INTO Accounts (CustomerID, AccountNumber, AccountType, Balance)
    VALUES (@CustomerID, @AccountNumber, @AccountType, @InitialDeposit);
END;

GO
CREATE PROCEDURE DepositMoney
    @AccountID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @AccountID;

    INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
    VALUES (@AccountID, 'Deposit', @Amount, 'Money deposited');
END;

GO
CREATE PROCEDURE WithdrawMoney
    @AccountID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    IF (SELECT Balance FROM Accounts WHERE AccountID = @AccountID) >= @Amount
    BEGIN
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
        VALUES (@AccountID, 'Withdrawal', @Amount, 'Money withdrawn');
    END
    ELSE
    BEGIN
        RAISERROR ('Insufficient balance', 16, 1);
    END
END;

GO
CREATE PROCEDURE TransferMoney
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        EXEC WithdrawMoney @FromAccountID, @Amount;
        EXEC DepositMoney @ToAccountID, @Amount;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Transfer failed', 16, 1);
    END CATCH
END;

GO
CREATE PROCEDURE ViewTransactionHistory
    @AccountID INT
AS
BEGIN
    SELECT * FROM Transactions
    WHERE AccountID = @AccountID
    ORDER BY TransactionDate DESC;
END;
