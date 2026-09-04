-- =============================================
-- RaceDay Database - Part 1 - SQL Server
-- Run this in SQL Server Management Studio (SSMS)
-- =============================================

USE master;
GO

-- Create Database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'RaceDayDB')
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

-- =============================================
-- 1. Users Table (Organisers & Participants)
-- =============================================
CREATE TABLE [User] (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    Phone NVARCHAR(20) NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsActive BIT DEFAULT 1
);
GO

-- =============================================
-- 2. Events Table
-- =============================================
CREATE TABLE [Event] (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Location NVARCHAR(200) NOT NULL,
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 NULL,
    OrganiserId INT NOT NULL,
    IsPublic BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (OrganiserId) REFERENCES [User](UserId) ON DELETE CASCADE
);
GO

-- =============================================
-- 3. RouteInfo Table (1-to-1 with Event)
-- =============================================
CREATE TABLE RouteInfo (
    RouteId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL UNIQUE,
    TotalDistance FLOAT NOT NULL,
    ElevationGain FLOAT NULL,
    MapUrl NVARCHAR(255) NULL,
    WeatherRegion NVARCHAR(100) NULL,
    FOREIGN KEY (EventId) REFERENCES [Event](EventId) ON DELETE CASCADE
);
GO

-- =============================================
-- 4. Categories Table
-- =============================================
CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Distance FLOAT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    MaxParticipants INT NOT NULL,
    FOREIGN KEY (EventId) REFERENCES [Event](EventId) ON DELETE CASCADE,
    CONSTRAINT UQ_EventCategory UNIQUE(EventId, Name)
);
GO

-- =============================================
-- 5. Enrolments Table
-- =============================================
CREATE TABLE Enrolment (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 DEFAULT GETUTCDATE(),
    Status NVARCHAR(30) DEFAULT 'Registered' CHECK (Status IN ('Registered', 'Confirmed', 'Cancelled', 'Completed')),
    BibNumber NVARCHAR(20) NULL,
    FOREIGN KEY (ParticipantId) REFERENCES [User](UserId),
    FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId),
    CONSTRAINT UQ_ParticipantCategory UNIQUE(ParticipantId, CategoryId)
);
GO

-- =============================================
-- 6. Results Table
-- =============================================
CREATE TABLE [Result] (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE,
    FinishTime TIME(7) NULL,
    OverallPosition INT NULL,
    CategoryPosition INT NULL,
    Points DECIMAL(5,2) NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (EnrolmentId) REFERENCES Enrolment(EnrolmentId)
);
GO

-- =============================================
-- Seed Test Data
-- =============================================
INSERT INTO [User] (Email, PasswordHash, FullName, Role)
VALUES 
('organiser@raceday.co.za', 'HASH-PLACEHOLDER-123', 'RaceDay Admin', 'Organiser'),
('runner@example.co.za', 'HASH-PLACEHOLDER-456', 'Jane Mbele', 'Participant');

INSERT INTO [Event] (Name, Description, Location, StartDate, OrganiserId)
VALUES 
('Soweto Summer Run', 'Annual 10km & 21km road race', 'Soweto, Johannesburg', '2026-11-15 06:00:00', 1);

INSERT INTO RouteInfo (EventId, TotalDistance, MapUrl)
VALUES (1, 21.1, 'https://raceday.co.za/maps/soweto-21km');

INSERT INTO Category (EventId, Name, Distance, Price, MaxParticipants)
VALUES 
(1, '10km Open', 10, 85.00, 500),
(1, '21km Half Marathon', 21.1, 130.00, 300);

PRINT '? RaceDayDB created successfully! All tables & test data ready.';
GO