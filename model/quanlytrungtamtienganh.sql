-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 17, 2025 lúc 02:40 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+07:00";

--
-- Cơ sở dữ liệu: `quanlytrungtamtienganh`
--

-- Tạo và sử dụng database
DROP DATABASE IF EXISTS `quanlytrungtamtienganh`;
CREATE DATABASE `quanlytrungtamtienganh`;
USE `quanlytrungtamtienganh`;

--
-- Tạo bảng `users`
--
CREATE TABLE `users` (
  `UserID` varchar(10) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` tinyint(1) NOT NULL COMMENT '0: Admin, 1: Teacher, 2: Student, 3: Parent',
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `parents`
--
CREATE TABLE `parents` (
  `UserID` varchar(10) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Gender` enum('Nam','Nữ') NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `BirthDate` date NOT NULL,
  `ZaloID` varchar(50) DEFAULT NULL,
  `UnpaidAmount` decimal(12,0) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Phone` (`Phone`),
  FOREIGN KEY (`UserID`) REFERENCES `users`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `promotions`
--
CREATE TABLE `promotions` (
  `PromoID` int(11) NOT NULL AUTO_INCREMENT,
  `Content` text NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date DEFAULT NULL,
  `Status` tinyint(1) DEFAULT 1,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`PromoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `id_counters`
--
CREATE TABLE `id_counters` (
  `role_prefix` varchar(2) NOT NULL,
  `next_id` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`role_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `teachers`
--
CREATE TABLE `teachers` (
  `UserID` varchar(10) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Gender` enum('Nam','Nữ') NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `BirthDate` date NOT NULL,
  `Salary` decimal(12,0) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Phone` (`Phone`),
  FOREIGN KEY (`UserID`) REFERENCES `users`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `classes`
--
CREATE TABLE `classes` (
  `ClassID` int(11) NOT NULL AUTO_INCREMENT,
  `ClassName` varchar(50) NOT NULL,
  `SchoolYear` int(11) NOT NULL,
  `TeacherID` varchar(10) DEFAULT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `ClassTime` varchar(20) NOT NULL,
  `Room` varchar(10) NOT NULL,
  `Status` enum('Đang hoạt động','Đã kết thúc','Tạm ngưng') DEFAULT 'Đang hoạt động',
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ClassID`),
  FOREIGN KEY (`TeacherID`) REFERENCES `teachers`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `students`
--
CREATE TABLE `students` (
  `UserID` varchar(10) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Gender` enum('Nam','Nữ') NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `BirthDate` date NOT NULL,
  `ClassID` int(11) DEFAULT NULL,
  `ParentID` varchar(10) DEFAULT NULL,
  `AttendedClasses` int(11) DEFAULT 0,
  `AbsentClasses` int(11) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Phone` (`Phone`),
  FOREIGN KEY (`UserID`) REFERENCES `users`(`UserID`),
  FOREIGN KEY (`ClassID`) REFERENCES `classes`(`ClassID`),
  FOREIGN KEY (`ParentID`) REFERENCES `parents`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `attendance`
--
CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(10) DEFAULT NULL,
  `ClassID` int(11) DEFAULT NULL,
  `AttendanceDate` date NOT NULL,
  `Status` enum('Có mặt','Vắng mặt','Đi muộn') NOT NULL,
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`AttendanceID`),
  FOREIGN KEY (`StudentID`) REFERENCES `students`(`UserID`),
  FOREIGN KEY (`ClassID`) REFERENCES `classes`(`ClassID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `tuition`
--
CREATE TABLE `tuition` (
  `TuitionID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(10) DEFAULT NULL,
  `Amount` decimal(12,0) NOT NULL,
  `Discount` decimal(5,2) DEFAULT 0.00,
  `PaymentDate` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `Status` enum('Chưa đóng','Đã đóng','Trễ hạn') DEFAULT 'Chưa đóng',
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`TuitionID`),
  FOREIGN KEY (`StudentID`) REFERENCES `students`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tạo bảng `messages`
--
CREATE TABLE `messages` (
  `MessageID` int(11) NOT NULL AUTO_INCREMENT,
  `SenderID` varchar(10) NOT NULL,
  `ReceiverID` varchar(10) NOT NULL,
  `Subject` varchar(100) NOT NULL,
  `Content` text NOT NULL,
  `SendDate` datetime NOT NULL,
  `IsRead` tinyint(1) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`MessageID`),
  FOREIGN KEY (`SenderID`) REFERENCES `users`(`UserID`),
  FOREIGN KEY (`ReceiverID`) REFERENCES `users`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE homework (
    HomeworkID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ClassID INT(11) NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES classes(ClassID),
    Description TEXT,
    DueDate DATE,
    Status ENUM('Chưa hoàn thành', 'Đã hoàn thành') NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES students(UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Trigger để tự động sinh UserID
--
DELIMITER //
CREATE TRIGGER before_user_insert 
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE prefix VARCHAR(2);
    DECLARE next_num INT;
    
    CASE NEW.Role
        WHEN 0 THEN SET NEW.UserID = '0';
        WHEN 1 THEN 
            SELECT 'GV', next_id INTO prefix, next_num FROM id_counters WHERE role_prefix = 'GV';
            UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'GV';
            SET NEW.UserID = CONCAT(prefix, LPAD(next_num, 3, '0'));
        WHEN 2 THEN
            SELECT 'HV', next_id INTO prefix, next_num FROM id_counters WHERE role_prefix = 'HV';
            UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'HV';
            SET NEW.UserID = CONCAT(prefix, LPAD(next_num, 3, '0'));
        WHEN 3 THEN
            SELECT 'PH', next_id INTO prefix, next_num FROM id_counters WHERE role_prefix = 'PH';
            UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'PH';
            SET NEW.UserID = CONCAT(prefix, LPAD(next_num, 3, '0'));
    END CASE;
END //
DELIMITER ;

--
-- Trigger để cập nhật UnpaidAmount trong parents sau INSERT
--
DELIMITER //
CREATE TRIGGER after_tuition_insert
AFTER INSERT ON tuition
FOR EACH ROW
BEGIN
    DECLARE total_unpaid DECIMAL(12,0);
    SELECT SUM(Amount - IFNULL(Discount, 0) - CASE WHEN Status = 'Đã đóng' THEN Amount ELSE 0 END)
    INTO total_unpaid
    FROM tuition t
    JOIN students s ON t.StudentID = s.UserID
    WHERE s.ParentID = (SELECT ParentID FROM students WHERE UserID = NEW.StudentID)
    AND t.Status != 'Đã đóng';
    
    UPDATE parents
    SET UnpaidAmount = COALESCE(total_unpaid, 0)
    WHERE UserID = (SELECT ParentID FROM students WHERE UserID = NEW.StudentID);
END //
DELIMITER ;

--
-- Trigger để cập nhật UnpaidAmount trong parents sau UPDATE
--
DELIMITER //
CREATE TRIGGER after_tuition_update
AFTER UPDATE ON tuition
FOR EACH ROW
BEGIN
    DECLARE total_unpaid DECIMAL(12,0);
    SELECT SUM(Amount - IFNULL(Discount, 0) - CASE WHEN Status = 'Đã đóng' THEN Amount ELSE 0 END)
    INTO total_unpaid
    FROM tuition t
    JOIN students s ON t.StudentID = s.UserID
    WHERE s.ParentID = (SELECT ParentID FROM students WHERE UserID = NEW.StudentID)
    AND t.Status != 'Đã đóng';
    
    UPDATE parents
    SET UnpaidAmount = COALESCE(total_unpaid, 0)
    WHERE UserID = (SELECT ParentID FROM students WHERE UserID = NEW.StudentID);
END //
DELIMITER ;

--
-- Stored procedures
--
DELIMITER //

CREATE PROCEDURE AddNewTeacher(
    IN p_Username VARCHAR(50),
    IN p_Password VARCHAR(255),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE,
    IN p_Salary DECIMAL(12,0)
)
BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 1);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO teachers (UserID, FullName, Gender, Email, Phone, BirthDate, Salary)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate, p_Salary);
    COMMIT;
END //

CREATE PROCEDURE AddNewParent(
    IN p_Username VARCHAR(50),
    IN p_Password VARCHAR(255),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE
)
BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 3);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO parents (UserID, FullName, Gender, Email, Phone, BirthDate)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate);
    COMMIT;
END //

CREATE PROCEDURE AddNewStudent(
    IN p_Username VARCHAR(50),
    IN p_Password VARCHAR(255),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE
)
BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 2);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO students (UserID, FullName, Gender, Email, Phone, BirthDate)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate);
    COMMIT;
END //

CREATE PROCEDURE UpdateTeacher(
    IN p_UserID VARCHAR(10),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE,
    IN p_Salary DECIMAL(12,0)
)
BEGIN
    UPDATE teachers 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        Salary = p_Salary
    WHERE UserID = p_UserID;
END //

CREATE PROCEDURE UpdateStudent(
    IN p_UserID VARCHAR(10),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE,
    IN p_ClassID INT,
    IN p_ParentID VARCHAR(10)
)
BEGIN
    UPDATE students 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ClassID = p_ClassID,
        ParentID = p_ParentID
    WHERE UserID = p_UserID;
END //

CREATE PROCEDURE UpdateParent(
    IN p_UserID VARCHAR(10),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE,
    IN p_ZaloID VARCHAR(50)
)
BEGIN
    UPDATE parents
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ZaloID = p_ZaloID
    WHERE UserID = p_UserID;
END //

CREATE PROCEDURE DeleteTeacher(IN p_UserID VARCHAR(10))
BEGIN
    START TRANSACTION;
    UPDATE classes SET TeacherID = NULL WHERE TeacherID = p_UserID;
    DELETE FROM teachers WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END //

CREATE PROCEDURE DeleteStudent(IN p_UserID VARCHAR(10))
BEGIN
    START TRANSACTION;
    DELETE FROM attendance WHERE StudentID = p_UserID;
    DELETE FROM tuition WHERE StudentID = p_UserID;
    DELETE FROM students WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END //

CREATE PROCEDURE DeleteParent(IN p_UserID VARCHAR(10))
BEGIN
    START TRANSACTION;
    UPDATE students SET ParentID = NULL WHERE ParentID = p_UserID;
    DELETE FROM parents WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END //

DELIMITER ;

--
-- Khởi tạo counters
--
INSERT INTO id_counters (role_prefix, next_id) VALUES 
('GV', 1),  -- Giáo viên
('HV', 1),  -- Học viên
('PH', 1);  -- Phụ huynh

--
-- Insert admin user
--
INSERT INTO `users` (`UserID`, `Username`, `Password`, `Role`, `CreatedAt`) 
VALUES ('0', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 0, NOW());