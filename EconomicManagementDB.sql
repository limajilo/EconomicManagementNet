CREATE DATABASE [EconomicManagementDB]
GO
USE [EconomicManagementDB]
GO

CREATE TABLE [Users](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[StandarEmail] [nvarchar](256) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
)
GO

CREATE TABLE [AccountTypes](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[UserId] [int] NOT NULL,
	[OrderAccount] [int] NOT NULL,
	CONSTRAINT [FK_AccountTypes_Users] FOREIGN KEY (UserId) REFERENCES Users(Id)
)
GO

CREATE TABLE [Accounts](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[AccountTypeId] [int] NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](1000) NULL,
    CONSTRAINT [FK_AccountType] FOREIGN KEY (AccountTypeId) REFERENCES AccountTypes(Id)
)
GO

CREATE TABLE [OperationTypes](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
)
GO

CREATE TABLE Categories(
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[OperationTypeId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
  CONSTRAINT [FK_Categories_Operations] FOREIGN KEY (OperationTypeId) REFERENCES OperationTypes(Id),
	CONSTRAINT [FK_Categories_Users] FOREIGN KEY (UserId) REFERENCES Users(Id)
)
GO

CREATE TABLE [Transactions](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[UserId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[AccountId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	CONSTRAINT [FK_Transactions_Users] FOREIGN KEY (UserId) REFERENCES Users(Id),
	CONSTRAINT [FK_Transactions_Account] FOREIGN KEY (AccountId) REFERENCES Accounts(Id),
	CONSTRAINT [FK_Transactions_Categories] FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)
GO

CREATE PROCEDURE Transactions_Insert
	@UserId int,
	@TransactionDate date,
	@Total decimal(18,2),
  @CategoryId int,
  @AccountId int,
	@Description nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Transactions(UserId, TransactionDate, Total, CategoryId, AccountId, Description)
	VALUES(@UserId, @TransactionDate, ABS(@Total), @CategoryId, @AccountId, @Description)

  UPDATE Accounts
  SET Balance += @Total
  WHERE Id = @AccountId;

  SELECT SCOPE_IDENTITY();
END
GO
CREATE PROCEDURE Categorie_Delete
@id int
AS
BEGIN
	SET NOCOUNT ON;
		If exists (Select 1 from Transactions where CategoryId = @id )
		BEGIN 
			DELETE FROM Transactions where CategoryId = @id
		END
		DELETE FROM Categories WHERE Id = @id
END
GO
INSERT INTO OperationTypes 
		VALUES('Income'),
				('Expenses');