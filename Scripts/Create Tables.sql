USE [DB39];

DROP TABLE IF EXISTS System;
DROP TABLE IF EXISTS Evaluation;
DROP TABLE IF EXISTS Evaluator;
DROP TABLE IF EXISTS Office;
DROP TABLE IF EXISTS Residence;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Area;

CREATE TABLE Area (
    Code INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Population INT NOT NULL,
    Income MONEY NOT NULL,
    ParentAreaCode INT NULL FOREIGN KEY REFERENCES Area(Code)
);

CREATE TABLE Address (
    Code INT PRIMARY KEY,
    Street VARCHAR(100) NOT NULL,
    Number INT NOT NULL,
    City VARCHAR(100) NOT NULL,
    PostalCode INT NULL
);

CREATE TABLE Property (
    Code INT PRIMARY KEY,
    Size INT NOT NULL,
    YearBuilt INT NOT NULL,
    Floor INT NOT NULL,
    AddressCode INT NOT NULL FOREIGN KEY REFERENCES Address(Code),
    AreaCode INT NOT NULL FOREIGN KEY REFERENCES Area(Code)
);

CREATE TABLE Category (
    Code INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Residence (
    Code INT PRIMARY KEY FOREIGN KEY REFERENCES Property(Code),
    IdNum VARCHAR(100) NOT NULL,
    CategoryCode INT NOT NULL FOREIGN KEY REFERENCES Category(Code)
);

CREATE TABLE Office (
    Code INT PRIMARY KEY FOREIGN KEY REFERENCES Property(Code),
    TaxId INT NOT NULL
);

CREATE TABLE Evaluator (
    Code INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(100) NOT NULL,
    AddressCode INT NOT NULL FOREIGN KEY REFERENCES Address(Code)
);

CREATE TABLE Evaluation (
    Code INT PRIMARY KEY,
    Price MONEY NOT NULL,
    EvaluationDate DATE NOT NULL,
    PropertyCode INT NOT NULL FOREIGN KEY REFERENCES Property(Code),
    EvaluatorCode INT NOT NULL FOREIGN KEY REFERENCES Evaluator(Code)
);

CREATE TABLE System (
    UniqueCode INT,
    ConnectionCode INT,
    Time TIME,
    Duration INT,
    Date DATE,
    CONSTRAINT PK_System PRIMARY KEY (UniqueCode, ConnectionCode),
    CONSTRAINT FK_System_Evaluator FOREIGN KEY (UniqueCode) REFERENCES Evaluator(Code)
);