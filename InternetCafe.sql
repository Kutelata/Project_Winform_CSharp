﻿USE master
GO
--DROP DATABASE IF EXISTs InternetCafe
--GO
CREATE DATABASE InternetCafe
GO
USE InternetCafe
GO

CREATE TABLE [food_type]
(
	entity_id INT PRIMARY KEY IDENTITY,
	[name] NVARCHAR(255) NOT NULL unique
)
GO
CREATE TABLE [area]
(
	entity_id INT PRIMARY KEY IDENTITY,
	[name] NVARCHAR(255) NOT NULL unique,
	price FLOAT NOT NULL
)
GO
CREATE TABLE [role]
(
	entity_id INT PRIMARY KEY IDENTITY,
	[name] NVARCHAR(255) NOT NULL unique
)
GO
CREATE TABLE [food]
(
	entity_id INT PRIMARY KEY IDENTITY,
	[name] NVARCHAR(255) NOT NULL unique,
	price FLOAT NOT NULL,
	quantity INT NOT NULL,
	[image] VARCHAR(255) NOT NULL,
	food_type_id INT NOT NULL,
	FOREIGN KEY (food_type_id) REFERENCES [food_type](entity_id)
)
GO
CREATE TABLE [user]
(
	entity_id INT PRIMARY KEY IDENTITY,
	account VARCHAR(255) NOT NULL,
	[password] VARCHAR(255) NOT NULL,
	firstName NVARCHAR(255),
	lastName NVARCHAR(255) NOT NULL,
	[image] VARCHAR(255) NOT NULL,
	role_id INT NOT NULL,
	FOREIGN KEY (role_id) REFERENCES [role](entity_id)
)
GO
CREATE TABLE [computer]
(
	entity_id INT PRIMARY KEY IDENTITY,
	[name] NVARCHAR(255) NOT NULL unique,
	[status] BIT DEFAULT(0),
	area_id INT NOT NULL,
	FOREIGN KEY (area_id) REFERENCES [area](entity_id)
)
GO
CREATE TABLE [order]
(
	entity_id INT PRIMARY KEY IDENTITY,
	computer_id INT NOT NULL,
	food_id INT,
	quantity INT,
	[user_id] INT,
	start_time DATETIME NOT NULL,
	end_time DATETIME NOT NULL,
	FOREIGN KEY (computer_id) REFERENCES [computer](entity_id),
	FOREIGN KEY (food_id) REFERENCES [food](entity_id),
	FOREIGN KEY ([user_id]) REFERENCES [user](entity_id)
)
GO
CREATE TABLE [bill]
(
	entity_id INT PRIMARY KEY IDENTITY,
	order_id INT NOT NULL,
	FOREIGN KEY (order_id) REFERENCES [order](entity_id)
)
GO 

INSERT INTO [food_type] VALUES
	(N'Đồ uống'),
	(N'Đồ ăn')
GO
INSERT INTO [role] VALUES
	(N'admin'),
	(N'vendor')
GO
INSERT INTO [user] VALUES
	(N'admin','admin123',N'Hoang Cao',N'Long','0',1),
	(N'vendor','vendor123',N'My',N'Vendor','0',2)
GO
INSERT INTO [area] VALUES
	(N'Hút thuốc',5000),
	(N'Không được hút thuốc',10000),
	(N'Thi đấu',20000),
	(N'Qua đêm',30000),
	(N'A',5000),
	(N'B',6000),
	(N'C',7000),
	(N'D',8000)
GO
INSERT INTO [computer] VALUES
	(N'HT1',1,1),
	(N'KHT1',0,2),
	(N'KHT2',1,2),
	(N'TD1',0,3),
	(N'TD2',1,3),
	(N'TD3',0,3),
	(N'QD1',1,4),
	(N'QD2',0,4),
	(N'QD3',1,4),
	(N'QD4',0,4)
GO

CREATE PROC getUser
	@account VARCHAR(255),
	@password VARCHAR(255)
AS	
	SELECT 
		*
	FROM [user] u
	JOIN [role] r on u.role_id = r.entity_id
	WHERE u.account = @account and u.[password] = @password 
GO
-- Area Admin
CREATE PROC getAllArea AS SELECT * FROM [area] 
GO 
CREATE PROC searchArea
	@name NVARCHAR(255)
AS	
	SELECT * FROM [area] where lower([name]) like '%'+lower(@name)+'%'  
GO  

-- Computer Admin
CREATE PROC getAllComputer 
AS 
	SELECT  
		c.entity_id,
		c.[name],
		CASE
			WHEN c.[status] = 0 then N'Không hoạt động'
			WHEN c.[status] = 1 then N'Đang hoạt động'
			ELSE N'Không hoạt động'
		END as 'status',
		a.[name] as 'area',
		c.area_id
	FROM [computer] c
	JOIN [area] a on a.entity_id = c.area_id
GO 
CREATE PROC searchComputer
	@name NVARCHAR(255)
AS	
	SELECT  
		c.entity_id,
		c.[name],
		CASE
			WHEN c.[status] = 0 then N'Không hoạt động'
			WHEN c.[status] = 1 then N'Đang hoạt động'
			ELSE N'Không hoạt động'
		END as 'status',
		a.[name] as 'area',
		c.area_id
	FROM [computer] c
	JOIN [area] a on a.entity_id = c.area_id
	where lower(c.[name]) like '%'+lower(@name)+'%'      
GO       

-- Food Admin
CREATE PROC getALLFood
AS
	SELECT 
		f.entity_id,
		f.[name],
		f.price,
		f.quantity,
		f.[image],
		ft.[name] as 'type',
		f.food_type_id
	FROM [food] f
	JOIN [food_type] ft on ft.entity_id = f.food_type_id     
GO       
