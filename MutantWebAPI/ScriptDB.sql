USE [master]
GO

/****** Object:  Database [FullCountryInfoAllCountries]    Script Date: 07/09/2020 14:43:53 ******/
IF OBJECT_ID('dbo.FullCountryInfoAllCountries', 'U') IS NOT NULL
DROP DATABASE [FullCountryInfoAllCountries]
GO

/****** Object:  Database [FullCountryInfoAllCountries]    Script Date: 07/09/2020 14:43:53 ******/
CREATE DATABASE [FullCountryInfoAllCountries]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FullCountryInfoAllCountries', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\FullCountryInfoAllCountries.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'FullCountryInfoAllCountries_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\FullCountryInfoAllCountries_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FullCountryInfoAllCountries].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ARITHABORT OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET  DISABLE_BROKER 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET  MULTI_USER 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET DB_CHAINING OFF 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [FullCountryInfoAllCountries] SET  READ_WRITE 
GO


USE [FullCountryInfoAllCountries]
GO

/****** Object:  Table [dbo].[tCountryInfo]    Script Date: 07/09/2020 14:44:05 ******/
IF OBJECT_ID('[dbo].[tCountryInfo]', 'U') IS NOT NULL
DROP TABLE [tCountryInfo]
GO

/****** Object:  Table [dbo].[tCountryInfo]    Script Date: 07/09/2020 14:44:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tCountryInfo](
	[sISOCode] [nchar](2) NOT NULL,
	[sName] [nchar](30) NULL,
	[sCapitalCity] [nchar](30) NULL,
	[sPhoneCode] [int] NULL,
	[sContinentCode] [nchar](2) NULL,
	[sCurrencyISOCode] [nchar](3) NULL,
	[sCountryFlag] [nchar](100) NULL,
 CONSTRAINT [PK_tCountryInfo] PRIMARY KEY CLUSTERED 
(
	[sISOCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [FullCountryInfoAllCountries]
GO

IF OBJECT_ID('dbo.tLanguage', 'U') IS NOT NULL
ALTER TABLE [dbo].[tLanguage] DROP CONSTRAINT [FKIDLingua]
GO

/****** Object:  Table [dbo].[tLanguage]    Script Date: 07/09/2020 14:44:28 ******/
IF OBJECT_ID('dbo.tLanguage', 'U') IS NOT NULL
DROP TABLE [dbo].[tLanguage]
GO

/****** Object:  Table [dbo].[tLanguage]    Script Date: 07/09/2020 14:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tLanguage](
	[IDLingua] [nchar](3) NOT NULL,
	[sISOCode] [nchar](2) NOT NULL,
	[sName] [nchar](30) NULL,
 CONSTRAINT [PK_tLanguage] PRIMARY KEY CLUSTERED 
(
	[IDLingua] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tLanguage]  WITH CHECK ADD  CONSTRAINT [FKIDLingua] FOREIGN KEY([sISOCode])
REFERENCES [dbo].[tCountryInfo] ([sISOCode])
GO

ALTER TABLE [dbo].[tLanguage] CHECK CONSTRAINT [FKIDLingua]
GO


