USE [master]
GO
/****** Object:  Database [Librarie]    Script Date: 22.05.2024 23:30:18 ******/
CREATE DATABASE [Librarie]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Librarie', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Librarie.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Librarie_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Librarie_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Librarie] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Librarie].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Librarie] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Librarie] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Librarie] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Librarie] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Librarie] SET ARITHABORT OFF 
GO
ALTER DATABASE [Librarie] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Librarie] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Librarie] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Librarie] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Librarie] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Librarie] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Librarie] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Librarie] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Librarie] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Librarie] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Librarie] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Librarie] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Librarie] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Librarie] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Librarie] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Librarie] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Librarie] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Librarie] SET RECOVERY FULL 
GO
ALTER DATABASE [Librarie] SET  MULTI_USER 
GO
ALTER DATABASE [Librarie] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Librarie] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Librarie] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Librarie] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Librarie] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Librarie] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Librarie', N'ON'
GO
ALTER DATABASE [Librarie] SET QUERY_STORE = ON
GO
ALTER DATABASE [Librarie] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Librarie]
GO
/****** Object:  Table [dbo].[Categoris]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoris](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Categoris] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[BookID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NULL,
	[AuthorID] [int] NULL,
	[CategoryID] [int] NULL,
	[ISBN] [nvarchar](13) NULL,
	[PublishDate] [date] NULL,
	[Price] [decimal](10, 2) NULL,
 CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BooksByCategory]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Crearea vederilor
CREATE VIEW [dbo].[BooksByCategory] AS
SELECT c.CategoryName, b.Title, b.Price
FROM Books b
JOIN Categoris c ON b.CategoryID = c.CategoryID;
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nchar](100) NULL,
	[LastName] [nchar](100) NULL,
	[Email] [nchar](100) NULL,
	[Phone] [nchar](10) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [date] NULL,
	[CustomerID] [int] NULL,
	[TotalAmount] [decimal](10, 2) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CustomerOrders]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerOrders] AS
SELECT cu.FirstName, cu.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID;
GO
/****** Object:  Table [dbo].[Authors]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authors](
	[AuthorID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Bio] [nvarchar](max) NULL,
 CONSTRAINT [PK_Authors] PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookInventory]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookInventory](
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_BookInventory] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookPublishers]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookPublishers](
	[BookPublisherID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NULL,
	[PublisherID] [int] NULL,
 CONSTRAINT [PK_BookPublishers] PRIMARY KEY CLUSTERED 
(
	[BookPublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[BookID] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publishers](
	[PublisherID] [int] IDENTITY(1,1) NOT NULL,
	[PublisherName] [nvarchar](100) NULL,
	[ContactName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Publishers] PRIMARY KEY CLUSTERED 
(
	[PublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NULL,
	[CustomerID] [int] NULL,
	[Rating] [int] NULL,
	[ReviewText] [nvarchar](max) NULL,
	[ReviewDate] [date] NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[BookInventory]  WITH CHECK ADD  CONSTRAINT [FK_BookInventory_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[BookInventory] CHECK CONSTRAINT [FK_BookInventory_Books]
GO
ALTER TABLE [dbo].[BookPublishers]  WITH CHECK ADD  CONSTRAINT [FK_BookPublishers_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[BookPublishers] CHECK CONSTRAINT [FK_BookPublishers_Books]
GO
ALTER TABLE [dbo].[BookPublishers]  WITH CHECK ADD  CONSTRAINT [FK_BookPublishers_Publishers] FOREIGN KEY([PublisherID])
REFERENCES [dbo].[Publishers] ([PublisherID])
GO
ALTER TABLE [dbo].[BookPublishers] CHECK CONSTRAINT [FK_BookPublishers_Publishers]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Authors] FOREIGN KEY([AuthorID])
REFERENCES [dbo].[Authors] ([AuthorID])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Authors]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Categoris] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categoris] ([CategoryID])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Categoris]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Books]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Books]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Customers]
GO
/****** Object:  StoredProcedure [dbo].[AddBook]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crearea procedurilor stocate
CREATE PROCEDURE [dbo].[AddBook]
    @Title NVARCHAR(200),
    @AuthorID INT,
    @CategoryID INT,
    @ISBN NVARCHAR(13),
    @PublishDate DATE,
    @Price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Books (Title, AuthorID, CategoryID, ISBN, PublishDate, Price)
    VALUES (@Title, @AuthorID, @CategoryID, @ISBN, @PublishDate, @Price);
END;
GO
/****** Object:  StoredProcedure [dbo].[PlaceOrder]    Script Date: 22.05.2024 23:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PlaceOrder]
    @CustomerID INT,
    @OrderDate DATE,
    @TotalAmount DECIMAL(10, 2),
    @BookID INT,
    @Quantity INT
AS
BEGIN
    DECLARE @OrderID INT;
    
    -- Insert Order
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (@CustomerID, @OrderDate, @TotalAmount);
    
    SET @OrderID = SCOPE_IDENTITY();
    
    -- Insert OrderDetails
    INSERT INTO OrderDetails (OrderID, BookID, Quantity)
    VALUES (@OrderID, @BookID, @Quantity);
    
    -- Update Inventory
    UPDATE BookInventory
    SET Quantity = Quantity - @Quantity
    WHERE BookID = @BookID;
END;
GO
USE [master]
GO
ALTER DATABASE [Librarie] SET  READ_WRITE 
GO
