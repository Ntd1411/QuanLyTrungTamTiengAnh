-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 18, 2025 lúc 12:20 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `quanlytrungtamtienganh`
--

-- Tạo và sử dụng database
DROP DATABASE IF EXISTS `quanlytrungtamtienganh`;
CREATE DATABASE `quanlytrungtamtienganh`;
USE `quanlytrungtamtienganh`;

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddNewParent` (IN `p_Username` VARCHAR(50), IN `p_Password` VARCHAR(255), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE)   BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 3);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO parents (UserID, FullName, Gender, Email, Phone, BirthDate)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate);
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddNewStudent` (IN `p_Username` VARCHAR(50), IN `p_Password` VARCHAR(255), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE)   BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 2);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO students (UserID, FullName, Gender, Email, Phone, BirthDate)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate);
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddNewTeacher` (IN `p_Username` VARCHAR(50), IN `p_Password` VARCHAR(255), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE, IN `p_Salary` DECIMAL(12,0))   BEGIN
    DECLARE new_user_id VARCHAR(10);
    START TRANSACTION;
    INSERT INTO users (Username, Password, Role)
    VALUES (p_Username, p_Password, 1);
    SET new_user_id = (SELECT UserID FROM users WHERE Username = p_Username);
    INSERT INTO teachers (UserID, FullName, Gender, Email, Phone, BirthDate, Salary)
    VALUES (new_user_id, p_FullName, p_Gender, p_Email, p_Phone, p_BirthDate, p_Salary);
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteParent` (IN `p_UserID` VARCHAR(10))   BEGIN
    START TRANSACTION;
    UPDATE students SET ParentID = NULL WHERE ParentID = p_UserID;
    DELETE FROM parents WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteStudent` (IN `p_UserID` VARCHAR(10))   BEGIN
    START TRANSACTION;
    DELETE FROM attendance WHERE StudentID = p_UserID;
    DELETE FROM tuition WHERE StudentID = p_UserID;
    DELETE FROM students WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTeacher` (IN `p_UserID` VARCHAR(10))   BEGIN
    START TRANSACTION;
    UPDATE classes SET TeacherID = NULL WHERE TeacherID = p_UserID;
    DELETE FROM teachers WHERE UserID = p_UserID;
    DELETE FROM users WHERE UserID = p_UserID;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateParent` (IN `p_UserID` VARCHAR(10), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE, IN `p_ZaloID` VARCHAR(50))   BEGIN
    UPDATE parents
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ZaloID = p_ZaloID
    WHERE UserID = p_UserID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStudent` (IN `p_UserID` VARCHAR(10), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE, IN `p_ClassID` INT, IN `p_ParentID` VARCHAR(10))   BEGIN
    UPDATE students 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ClassID = p_ClassID,
        ParentID = p_ParentID
    WHERE UserID = p_UserID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTeacher` (IN `p_UserID` VARCHAR(10), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE, IN `p_Salary` DECIMAL(12,0))   BEGIN
    UPDATE teachers 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        Salary = p_Salary
    WHERE UserID = p_UserID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `attendance`
--

CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL,
  `StudentID` varchar(10) DEFAULT NULL,
  `ClassID` int(11) DEFAULT NULL,
  `AttendanceDate` date NOT NULL,
  `Status` enum('Có mặt','Vắng mặt','Đi muộn') NOT NULL,
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `attendance`
--

INSERT INTO `attendance` (`AttendanceID`, `StudentID`, `ClassID`, `AttendanceDate`, `Status`, `Note`, `CreatedAt`) VALUES
(1, 'HV001', 3, '2025-06-10', 'Có mặt', 'Đúng giờ', '2025-06-18 08:43:40'),
(2, 'HV001', 3, '2025-06-12', 'Đi muộn', 'Đến muộn 10 phút', '2025-06-18 08:43:40'),
(3, 'HV001', 3, '2025-06-14', 'Vắng mặt', 'Có xin phép', '2025-06-18 08:43:40'),
(4, 'HV001', 3, '2025-06-17', 'Có mặt', NULL, '2025-06-18 08:43:40'),
(5, 'HV005', 3, '2025-06-15', 'Có mặt', 'Đúng giờ', '2025-06-18 09:53:16'),
(6, 'HV005', 3, '2025-06-17', 'Vắng mặt', 'Có xin phép', '2025-06-18 09:53:16'),
(7, 'HV005', 3, '2025-06-19', 'Đi muộn', 'Đến muộn 5 phút', '2025-06-18 09:53:16');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `classes`
--

CREATE TABLE `classes` (
  `ClassID` int(11) NOT NULL,
  `ClassName` varchar(50) NOT NULL,
  `SchoolYear` int(11) NOT NULL,
  `TeacherID` varchar(10) DEFAULT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `ClassTime` varchar(20) NOT NULL,
  `Room` varchar(10) NOT NULL,
  `Status` enum('Đang hoạt động','Đã kết thúc','Tạm ngưng') DEFAULT 'Đang hoạt động',
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `classes`
--

INSERT INTO `classes` (`ClassID`, `ClassName`, `SchoolYear`, `TeacherID`, `StartDate`, `EndDate`, `ClassTime`, `Room`, `Status`, `CreatedAt`) VALUES
(1, 'Lớp Tiếng Anh Cơ Bản', 2025, 'GV001', '2025-06-20', '2025-08-20', 'Thứ 2, 4, 6 - 18:00', 'A101', 'Đang hoạt động', '2025-06-18 05:39:06'),
(3, 'Lớp Tiếng Anh Thiếu Nhi', 2025, 'GV001', '2025-03-20', '2025-07-20', 'Thứ 3, 5, 7 - 18:00', 'A102', 'Đang hoạt động', '2025-06-17 09:29:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `homework`
--

CREATE TABLE `homework` (
  `HomeworkID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `Status` enum('Chưa hoàn thành','Đã hoàn thành') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `homework`
--

INSERT INTO `homework` (`HomeworkID`, `ClassID`, `Title`, `Description`, `DueDate`, `Status`) VALUES
(3, 3, 'Bài tập 1', 'Mô tả', '2025-06-30', 'Chưa hoàn thành');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `id_counters`
--

CREATE TABLE `id_counters` (
  `role_prefix` varchar(2) NOT NULL,
  `next_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `id_counters`
--

INSERT INTO `id_counters` (`role_prefix`, `next_id`) VALUES
('GV', 2),
('HV', 6),
('PH', 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `messages`
--

CREATE TABLE `messages` (
  `MessageID` int(11) NOT NULL,
  `SenderID` varchar(10) NOT NULL,
  `ReceiverID` varchar(10) NOT NULL,
  `Subject` varchar(100) NOT NULL,
  `Content` text NOT NULL,
  `SendDate` datetime NOT NULL,
  `IsRead` tinyint(1) NOT NULL DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`MessageID`),
  CONSTRAINT chk_isread CHECK (`IsRead` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `messages`
--

INSERT INTO `messages` (`MessageID`, `SenderID`, `ReceiverID`, `Subject`, `Content`, `SendDate`, `IsRead`, `CreatedAt`) VALUES
(2, '0', 'PH001', 'Nhắc nộp học phí', 'Kính gửi quý phụ huynh, vui lòng hoàn thành việc nộp học phí cho con em trong thời gian sớm nhất. Xin cảm ơn!', '2025-06-17 16:38:30', 0, '2025-06-17 09:38:30'),
(4, '0', 'PH001', 'Khen ngợi học sinh', 'Chúc mừng quý phụ huynh, em En Ti Đi đã đạt thành tích xuất sắc trong kỳ kiểm tra vừa qua!', '2025-06-17 16:41:55', 0, '2025-06-17 09:41:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `parents`
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
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `parents`
--

INSERT INTO `parents` (`UserID`, `FullName`, `Gender`, `Email`, `Phone`, `BirthDate`, `ZaloID`, `UnpaidAmount`, `CreatedAt`) VALUES
('PH001', 'Nguyễn Tuấn Dũng', 'Nam', 'tuandung@gmail.com', '0123456789', '2025-06-17', NULL, 2000000, '2025-06-17 08:28:49');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `students`
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
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `students`
--

INSERT INTO `students` (`UserID`, `FullName`, `Gender`, `Email`, `Phone`, `BirthDate`, `ClassID`, `ParentID`, `AttendedClasses`, `AbsentClasses`, `CreatedAt`) VALUES
('HV001', 'Con En Ti Đi', 'Nữ', 'hello@gmail.com', '0123456789', '2025-06-17', 3, 'PH001', 0, 0, '2025-06-17 08:52:51'),
('HV002', 'Con Nuôi En Ti Đi', 'Nam', 'helloguys@gmail.com', '9876543210', '2025-06-18', 1, 'PH001', 0, 0, '2025-06-18 05:35:07'),
('HV005', 'Con Cưng En Ti Đi', 'Nam', 'tuandung@gmail.com', '00000000', '2004-11-15', 3, 'PH001', 0, 0, '2025-06-18 09:50:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teachers`
--

CREATE TABLE `teachers` (
  `UserID` varchar(10) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Gender` enum('Nam','Nữ') NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `BirthDate` date NOT NULL,
  `Salary` decimal(12,0) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teachers`
--

INSERT INTO `teachers` (`UserID`, `FullName`, `Gender`, `Email`, `Phone`, `BirthDate`, `Salary`, `CreatedAt`) VALUES
('GV001', 'Nguyễn Văn A', 'Nam', 'gv1@email.com', '0123456789', '0000-00-00', 0, '2025-06-17 09:29:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tuition`
--

CREATE TABLE `tuition` (
  `TuitionID` int(11) NOT NULL,
  `StudentID` varchar(10) DEFAULT NULL,
  `Amount` decimal(12,0) NOT NULL,
  `Discount` decimal(5,2) DEFAULT 0.00,
  `PaymentDate` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `Status` enum('Chưa đóng','Đã đóng','Trễ hạn') DEFAULT 'Chưa đóng',
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tuition`
--

INSERT INTO `tuition` (`TuitionID`, `StudentID`, `Amount`, `Discount`, `PaymentDate`, `DueDate`, `Status`, `Note`, `CreatedAt`) VALUES
(1, 'HV001', 2000000, 0.00, '2025-06-18', '2025-06-30', 'Chưa đóng', 'Học phí tháng 6/2025', '2025-06-17 10:06:07'),
(2, 'HV002', 1000000, 10.00, '2025-06-18', '2025-07-31', 'Đã đóng', 'Học phí tháng 7/2025 - Con Nuôi En Ti Đi', '2025-06-18 05:43:17');

--
-- Bẫy `tuition`
--
DELIMITER $$
CREATE TRIGGER `after_tuition_insert` AFTER INSERT ON `tuition` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_tuition_update` AFTER UPDATE ON `tuition` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `UserID` varchar(10) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` tinyint(1) NOT NULL COMMENT '0: Admin, 1: Teacher, 2: Student, 3: Parent',
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`UserID`, `Username`, `Password`, `Role`, `CreatedAt`) VALUES
('0', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 0, '2025-06-17 08:22:54'),
('GV001', 'giaovien1', '$2y$10$Fk75byfTkU1JoLwjsWhTd.8fFUjCEfEMufA8b/imxf4lsDoDdwS6W', 1, '2025-06-17 09:29:43'),
('HV001', 'student', '$2y$10$Fk75byfTkU1JoLwjsWhTd.8fFUjCEfEMufA8b/imxf4lsDoDdwS6W', 2, '2025-06-17 08:52:51'),
('HV002', 'student_second', '$2y$10$V994R/NFtvD809nOirDs1uEH4vQlL4rL7.FPqyPiBr5sPRUi2Jz3u', 2, '2025-06-18 05:35:07'),
('HV003', 'test', '$2y$10$TVLNfmOeF2t26T4s6VVZXeeP/iQRt/bUg9qa.VnFuaolUA4AWB/VO', 2, '2025-06-18 08:29:57'),
('HV004', 'test0', '$2y$10$pndw3X7MsmoOBE3QTbqw7uyGqnCLGP.riTyQZaTT6sU02bPn.Uudq', 2, '2025-06-18 08:33:22'),
('HV005', 'student_third', '$2y$10$p2Y6bR7syfs/utU9kxtI6e2wVu6H3S24HsY98eUw676SItfNBjVcW', 2, '2025-06-18 09:50:41'),
('PH001', 'parent', '$2y$10$LbPjtFPbEz4JonNNF87LAuacePR8abXl93y/4j.WpowigC07d0ruK', 3, '2025-06-17 08:28:49');

--
-- Bẫy `users`
--
DELIMITER $$
CREATE TRIGGER `before_user_insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`AttendanceID`),
  ADD KEY `StudentID` (`StudentID`),
  ADD KEY `ClassID` (`ClassID`);

--
-- Chỉ mục cho bảng `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`ClassID`),
  ADD KEY `TeacherID` (`TeacherID`);

--
-- Chỉ mục cho bảng `homework`
--
ALTER TABLE `homework`
  ADD PRIMARY KEY (`HomeworkID`),
  ADD KEY `StudentID` (`ClassID`);

--
-- Chỉ mục cho bảng `id_counters`
--
ALTER TABLE `id_counters`
  ADD PRIMARY KEY (`role_prefix`);

--
-- Chỉ mục cho bảng `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`MessageID`),
  ADD KEY `SenderID` (`SenderID`),
  ADD KEY `ReceiverID` (`ReceiverID`);

--
-- Chỉ mục cho bảng `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Chỉ mục cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`PromoID`);

--
-- Chỉ mục cho bảng `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD KEY `ClassID` (`ClassID`),
  ADD KEY `ParentID` (`ParentID`);

--
-- Chỉ mục cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Chỉ mục cho bảng `tuition`
--
ALTER TABLE `tuition`
  ADD PRIMARY KEY (`TuitionID`),
  ADD KEY `StudentID` (`StudentID`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `attendance`
--
ALTER TABLE `attendance`
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `classes`
--
ALTER TABLE `classes`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `homework`
--
ALTER TABLE `homework`
  MODIFY `HomeworkID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `messages`
--
ALTER TABLE `messages`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `promotions`
--
ALTER TABLE `promotions`
  MODIFY `PromoID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tuition`
--
ALTER TABLE `tuition`
  MODIFY `TuitionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`UserID`),
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`);

--
-- Các ràng buộc cho bảng `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`TeacherID`) REFERENCES `teachers` (`UserID`);

--
-- Các ràng buộc cho bảng `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`SenderID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`ReceiverID`) REFERENCES `users` (`UserID`);

--
-- Các ràng buộc cho bảng `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Các ràng buộc cho bảng `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`),
  ADD CONSTRAINT `students_ibfk_3` FOREIGN KEY (`ParentID`) REFERENCES `parents` (`UserID`);

--
-- Các ràng buộc cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Các ràng buộc cho bảng `tuition`
--
ALTER TABLE `tuition`
  ADD CONSTRAINT `tuition_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

--
--Tạo bảng tin tức
--
CREATE TABLE news (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT NOT NULL,
    image VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--
-- Tạo bảng phiên dạy
--
CREATE TABLE teaching_sessions (
  SessionID int(11) NOT NULL AUTO_INCREMENT,
  TeacherID varchar(10) NOT NULL,
  ClassID int(11) NOT NULL,
  SessionDate date NOT NULL,
  Status enum('Đã dạy','Nghỉ','Dời lịch') DEFAULT 'Đã dạy',
  Note text DEFAULT NULL,
  CreatedAt timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (SessionID),
  KEY TeacherID (TeacherID),
  KEY ClassID (ClassID),
  CONSTRAINT teaching_sessions_ibfk_1 FOREIGN KEY (TeacherID) REFERENCES teachers (UserID),
  CONSTRAINT teaching_sessions_ibfk_2 FOREIGN KEY (ClassID) REFERENCES classes (ClassID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Thêm dữ liệu mẫu cho bảng news
INSERT INTO news (title, content, excerpt, image, author, date) VALUES
(
    'Khai giảng Trại hè Tiếng Anh 2025 - Vui học, vui khám phá!',
    'Trại hè Tiếng Anh KEC 2025 chính thức khai giảng, mang đến một mùa hè sôi động, bổ ích với vô vàn hoạt động lý thú kết hợp học tập và trải nghiệm thực tế...',
    'Trại hè Tiếng Anh KEC 2025 chính thức khai giảng, mang đến một mùa hè sôi động, bổ ích với vô vàn hoạt động lý thú kết hợp học tập và trải nghiệm thực tế...',
    'summercamp.jpg',
    'KEC Team',
    '2025-06-10'
),
(
    'Chúc mừng học viên Nguyễn Văn A đạt IELTS 7.5 Overall!',
    'KEC xin gửi lời chúc mừng chân thành nhất đến học viên Nguyễn Văn A đã xuất sắc đạt 7.5 IELTS chỉ sau 6 tháng học tại trung tâm. Cùng tìm hiểu bí quyết thành công của bạn...',
    'KEC xin gửi lời chúc mừng chân thành nhất đến học viên Nguyễn Văn A đã xuất sắc đạt 7.5 IELTS chỉ sau 6 tháng học tại trung tâm. Cùng tìm hiểu bí quyết thành công của bạn...',
    'ielts7-5.jpg',
    'Ban Tuyển sinh',
    '2025-06-05'
),
(
    '5 mẹo học từ vựng tiếng Anh hiệu quả không thể bỏ qua',
    'Bạn gặp khó khăn khi ghi nhớ từ vựng? Đừng lo, bài viết này sẽ chia sẻ 5 chiến lược đã được kiểm chứng giúp bạn mở rộng vốn từ nhanh chóng và hiệu quả...',
    'Bạn gặp khó khăn khi ghi nhớ từ vựng? Đừng lo, bài viết này sẽ chia sẻ 5 chiến lược đã được kiểm chứng giúp bạn mở rộng vốn từ nhanh chóng và hiệu quả...',
    'hocTA.jpg',
    'Cô Lan Anh',
    '2025-06-01'
),
(
    'Cập nhật cấu trúc đề thi TOEIC Reading mới nhất 2025',
    'Những thay đổi quan trọng trong phần thi Reading của kỳ thi TOEIC năm 2025 mà bạn cần biết để chuẩn bị tốt nhất cho bài thi của mình...',
    'Những thay đổi quan trọng trong phần thi Reading của kỳ thi TOEIC năm 2025 mà bạn cần biết để chuẩn bị tốt nhất cho bài thi của mình...',
    'toeic.png',
    'Thầy Duy Hưng',
    '2025-05-28'
);

-- Tạo bảng student_parent_keys
CREATE TABLE student_parent_keys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10) NOT NULL,
    parent_id VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_key (student_id, parent_id),
    FOREIGN KEY (student_id) REFERENCES students(UserID) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES parents(UserID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Thêm cột Tuition vào bảng classes
ALTER TABLE classes
ADD COLUMN Tuition DECIMAL(12,0) NOT NULL DEFAULT 0 AFTER Room;



-- Cập nhật dữ liệu mẫu
UPDATE classes 
SET Tuition = 2000000 
WHERE ClassID = 1;

UPDATE classes 
SET Tuition = 1500000 
WHERE ClassID = 3;

-- Thêm trigger để tự động tạo học phí khi thêm học sinh vào lớp
DELIMITER $$
CREATE TRIGGER after_student_class_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    -- Xóa học phí khi học sinh rời lớp
    IF OLD.ClassID IS NOT NULL AND NEW.ClassID IS NULL THEN
        DELETE FROM tuition 
        WHERE StudentID = NEW.UserID 
        AND Status = 'Chưa đóng';
        
    -- Xử lý khi chuyển lớp    
    ELSEIF OLD.ClassID IS NOT NULL AND NEW.ClassID != OLD.ClassID THEN
        -- Xóa học phí chưa đóng của lớp cũ
        DELETE FROM tuition 
        WHERE StudentID = NEW.UserID 
        AND Status = 'Chưa đóng'
        AND TuitionID = (
            SELECT t.TuitionID
            FROM tuition t
            WHERE t.StudentID = NEW.UserID
            AND t.Status = 'Chưa đóng'
            ORDER BY t.CreatedAt DESC
            LIMIT 1
        );
        
        -- Thêm học phí cho lớp mới
        INSERT INTO tuition (StudentID, Amount, DueDate, Status, Note)
        SELECT 
            NEW.UserID,
            c.Tuition,
            LAST_DAY(CURRENT_DATE),
            'Chưa đóng',
            CONCAT('Học phí lớp ', c.ClassName, ' - ', DATE_FORMAT(CURRENT_DATE, '%m/%Y'))
        FROM classes c
        WHERE c.ClassID = NEW.ClassID;
        
    -- Xử lý khi thêm vào lớp lần đầu    
    ELSEIF NEW.ClassID IS NOT NULL AND OLD.ClassID IS NULL THEN
        INSERT INTO tuition (StudentID, Amount, DueDate, Status, Note)
        SELECT 
            NEW.UserID,
            c.Tuition,
            LAST_DAY(CURRENT_DATE),
            'Chưa đóng',
            CONCAT('Học phí lớp ', c.ClassName, ' - ', DATE_FORMAT(CURRENT_DATE, '%m/%Y'))
        FROM classes c
        WHERE c.ClassID = NEW.ClassID;
    END IF;
END $$

-- Trigger cho việc thêm mới học sinh
CREATE TRIGGER after_student_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.ClassID IS NOT NULL THEN
        -- Kiểm tra trùng lặp học phí
        IF NOT EXISTS (
            SELECT 1 FROM tuition 
            WHERE StudentID = NEW.UserID 
            AND MONTH(DueDate) = MONTH(CURRENT_DATE)
            AND YEAR(DueDate) = YEAR(CURRENT_DATE)
        ) THEN
            INSERT INTO tuition (StudentID, Amount, DueDate, Status, Note)
            SELECT 
                NEW.UserID,
                c.Tuition,
                LAST_DAY(CURRENT_DATE),
                'Chưa đóng',
                CONCAT('Học phí lớp ', c.ClassName, ' - ', DATE_FORMAT(CURRENT_DATE, '%m/%Y'))
            FROM classes c
            WHERE c.ClassID = NEW.ClassID;
        END IF;
    END IF;
END $$
DELIMITER ;

-- Xóa foreign key và index của ParentID
ALTER TABLE students
DROP FOREIGN KEY students_ibfk_3,
DROP INDEX ParentID;

-- Xóa cột ParentID
ALTER TABLE students
DROP COLUMN ParentID;

-- Xóa các trigger cũ
-- DROP TRIGGER IF EXISTS after_student_class_update;

-- 
-- DROP TRIGGER IF EXISTS after_student_insert;

DELIMITER $$

DROP TRIGGER IF EXISTS after_tuition_insert$$
CREATE TRIGGER after_tuition_insert
AFTER INSERT ON tuition
FOR EACH ROW
BEGIN
    -- Tạo biến tạm để lưu trữ tổng học phí
    DECLARE total_unpaid DECIMAL(12,0);
    
    -- Tính tổng học phí chưa đóng cho từng phụ huynh
    SELECT COALESCE(SUM(
        CASE 
            WHEN t.Status = 'Chưa đóng' THEN t.Amount - IFNULL(t.Discount, 0)
            ELSE 0 
        END
    ), 0)
    INTO total_unpaid
    FROM tuition t
    JOIN student_parent_keys spk ON t.StudentID = spk.student_id
    WHERE spk.parent_id IN (
        SELECT parent_id 
        FROM student_parent_keys 
        WHERE student_id = NEW.StudentID
    )
    AND t.Status = 'Chưa đóng';

    -- Cập nhật UnpaidAmount cho phụ huynh
    UPDATE parents p
    SET p.UnpaidAmount = total_unpaid
    WHERE p.UserID IN (
        SELECT parent_id 
        FROM student_parent_keys 
        WHERE student_id = NEW.StudentID
    );
END $$

-- Sửa trigger after_tuition_update
DROP TRIGGER IF EXISTS after_tuition_update$$
CREATE TRIGGER after_tuition_update
AFTER UPDATE ON tuition
FOR EACH ROW
BEGIN
    DECLARE total_unpaid DECIMAL(12,0);
    -- Chỉ cập nhật khi có thay đổi liên quan đến tiền
    IF NEW.Status != OLD.Status OR NEW.Amount != OLD.Amount OR NEW.Discount != OLD.Discount THEN
        
        
        -- Tính lại tổng học phí chưa đóng
        SELECT COALESCE(SUM(
            CASE 
                WHEN t.Status = 'Chưa đóng' THEN t.Amount - IFNULL(t.Discount, 0)
                ELSE 0 
            END
        ), 0)
        INTO total_unpaid
        FROM tuition t
        JOIN student_parent_keys spk ON t.StudentID = spk.student_id
        WHERE spk.parent_id IN (
            SELECT parent_id 
            FROM student_parent_keys 
            WHERE student_id = NEW.StudentID
        )
        AND t.Status = 'Chưa đóng';

        -- Cập nhật UnpaidAmount
        UPDATE parents p
        SET p.UnpaidAmount = total_unpaid
        WHERE p.UserID IN (
            SELECT parent_id 
            FROM student_parent_keys 
            WHERE student_id = NEW.StudentID
        );
    END IF;
END $$

-- Sửa stored procedure DeleteParent
DROP PROCEDURE IF EXISTS DeleteParent$$
CREATE PROCEDURE DeleteParent(IN p_UserID VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi khi xóa phụ huynh';
    END;

    START TRANSACTION;
    
    -- Xóa các key liên kết với phụ huynh
    DELETE FROM student_parent_keys 
    WHERE parent_id = p_UserID;
    
    -- Xóa thông tin phụ huynh
    DELETE FROM parents 
    WHERE UserID = p_UserID;
    
    -- Xóa tài khoản người dùng
    DELETE FROM users 
    WHERE UserID = p_UserID;
    
    COMMIT;
END $$

-- Sửa procedure UpdateStudent bỏ tham số ParentID
DROP PROCEDURE IF EXISTS UpdateStudent $$
CREATE PROCEDURE UpdateStudent(
    IN p_UserID VARCHAR(10),
    IN p_FullName VARCHAR(100),
    IN p_Gender ENUM('Nam','Nữ'),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_BirthDate DATE,
    IN p_ClassID INT
)
BEGIN
    UPDATE students 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ClassID = p_ClassID
    WHERE UserID = p_UserID;
END $$

-- Sửa procedure DeleteStudent để xóa cả liên kết trong student_parent_keys
DROP PROCEDURE IF EXISTS DeleteStudent $$
CREATE PROCEDURE DeleteStudent(IN p_UserID VARCHAR(10))
BEGIN
    START TRANSACTION;
    
    -- Xóa điểm danh
    DELETE FROM attendance WHERE StudentID = p_UserID;
    
    -- Xóa học phí
    DELETE FROM tuition WHERE StudentID = p_UserID;
    
    -- Xóa liên kết với phụ huynh
    DELETE FROM student_parent_keys WHERE student_id = p_UserID;
    
    -- Xóa thông tin học sinh
    DELETE FROM students WHERE UserID = p_UserID;
    
    -- Xóa tài khoản người dùng
    DELETE FROM users WHERE UserID = p_UserID;
    
    COMMIT;
END $$
DELIMITER ;

-- Thêm cột isShowTeacher vào bảng parents
ALTER TABLE parents 
ADD COLUMN isShowTeacher BOOLEAN DEFAULT FALSE;

-------------------- Phần mới update -----------------------
CREATE TABLE consulting (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(100) NOT NULL,
    birthyear VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    course VARCHAR(100) NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE consulting
ADD COLUMN status ENUM('Chưa tư vấn', 'Đã tư vấn') NOT NULL DEFAULT 'Chưa tư vấn';

CREATE TABLE payment_history (
    paymentID INT PRIMARY KEY AUTO_INCREMENT,
    parentID VARCHAR(10) NOT NULL,
    paidAmount DECIMAL(12,0) NOT NULL,
    note TEXT,
    paymentDate DATE NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parentID) REFERENCES parents(UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE payment_history ADD COLUMN studentID VARCHAR(10) NOT NULL AFTER paymentID;


-- Insert 100 users with different roles
-- 1 Admin (already exists), 20 Teachers, 50 Students, 29 Parents

-- Insert 20 Teachers (Role = 1)
INSERT INTO users (Username, Password, Role) VALUES
('teacher01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher06', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1),
('teacher20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);

-- Insert 50 Students (Role = 2)
INSERT INTO users (Username, Password, Role) VALUES
('student01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student06', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student21', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student22', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student23', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student24', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student25', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student27', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student28', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student29', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student30', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student31', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student32', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student33', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student34', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student35', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student36', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student37', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student38', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student39', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student40', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student41', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student42', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student43', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student44', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student45', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student46', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student47', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student48', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student49', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2),
('student50', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2);

-- Insert 29 Parents (Role = 3) to make total 100 users
INSERT INTO users (Username, Password, Role) VALUES
('parent01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent06', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent21', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent22', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent23', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent24', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent25', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent27', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent28', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3),
('parent29', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3);


-- Verify the results
SELECT 
    Role,
    CASE 
        WHEN Role = 0 THEN 'Admin'
        WHEN Role = 1 THEN 'Teacher'
        WHEN Role = 2 THEN 'Student'
        WHEN Role = 3 THEN 'Parent'
    END as RoleName,
    COUNT(*) as Count
FROM users 
GROUP BY Role
ORDER BY Role;

-- Show total count
SELECT COUNT(*) as TotalUsers FROM users;

-- Insert teacher data for the 20 new teachers (GV002 to GV021)
INSERT INTO teachers (UserID, FullName, Gender, Email, Phone, BirthDate, Salary) VALUES
('GV002', 'Nguyễn Thị Lan', 'Nữ', 'gv002@email.com', '0123456781', '1985-03-15', 8000000),
('GV003', 'Trần Văn Minh', 'Nam', 'gv003@email.com', '0123456782', '1988-07-22', 7500000),
('GV004', 'Lê Thị Hương', 'Nữ', 'gv004@email.com', '0123456783', '1990-11-08', 7200000),
('GV005', 'Phạm Đức Anh', 'Nam', 'gv005@email.com', '0123456784', '1987-02-14', 8500000),
('GV006', 'Hoàng Thị Mai', 'Nữ', 'gv006@email.com', '0123456785', '1992-06-30', 7800000),
('GV007', 'Vũ Văn Hải', 'Nam', 'gv007@email.com', '0123456786', '1984-09-12', 9000000),
('GV008', 'Đỗ Thị Linh', 'Nữ', 'gv008@email.com', '0123456787', '1989-04-25', 7600000),
('GV009', 'Bùi Văn Thành', 'Nam', 'gv009@email.com', '0123456788', '1991-12-03', 7300000),
('GV010', 'Ngô Thị Nga', 'Nữ', 'gv010@email.com', '0123456789', '1986-08-17', 8200000),
('GV011', 'Lý Văn Quang', 'Nam', 'gv011@email.com', '0123456790', '1993-01-28', 7000000),
('GV012', 'Đinh Thị Thu', 'Nữ', 'gv012@email.com', '0123456791', '1988-05-11', 7700000),
('GV013', 'Võ Văn Tùng', 'Nam', 'gv013@email.com', '0123456792', '1985-10-20', 8800000),
('GV014', 'Đặng Thị Phượng', 'Nữ', 'gv014@email.com', '0123456793', '1990-03-07', 7400000),
('GV015', 'Tạ Văn Dũng', 'Nam', 'gv015@email.com', '0123456794', '1987-07-15', 8100000),
('GV016', 'Chu Thị Hoa', 'Nữ', 'gv016@email.com', '0123456795', '1989-11-23', 7900000),
('GV017', 'Dương Văn Khang', 'Nam', 'gv017@email.com', '0123456796', '1992-02-18', 7500000),
('GV018', 'Mai Thị Bích', 'Nữ', 'gv018@email.com', '0123456797', '1986-09-05', 8300000),
('GV019', 'Lưu Văn Tuấn', 'Nam', 'gv019@email.com', '0123456798', '1988-12-12', 7600000),
('GV020', 'Phan Thị Yến', 'Nữ', 'gv020@email.com', '0123456799', '1991-04-09', 7800000)


-- Insert additional classes data
INSERT INTO classes (ClassName, SchoolYear, TeacherID, StartDate, EndDate, ClassTime, Room, Tuition, Status) VALUES
-- Lớp cơ bản
('Lớp Tiếng Anh Căn Bản A1', 2025, 'GV002', '2025-07-01', '2025-12-30', 'Thứ 2, 4, 6 - 19:00', 'A103', 1800000, 'Đang hoạt động'),
('Lớp Tiếng Anh Căn Bản A2', 2025, 'GV003', '2025-07-01', '2025-12-30', 'Thứ 3, 5, 7 - 19:00', 'A104', 1800000, 'Đang hoạt động'),

-- Lớp trung cấp
('Lớp Tiếng Anh Trung Cấp B1', 2025, 'GV004', '2025-07-15', '2026-01-15', 'Thứ 2, 4, 6 - 18:30', 'B101', 2200000, 'Đang hoạt động'),
('Lớp Tiếng Anh Trung Cấp B2', 2025, 'GV005', '2025-07-15', '2026-01-15', 'Thứ 3, 5, 7 - 18:30', 'B102', 2200000, 'Đang hoạt động'),

-- Lớp nâng cao
('Lớp Tiếng Anh Nâng Cao C1', 2025, 'GV006', '2025-08-01', '2026-02-28', 'Thứ 2, 4, 6 - 17:30', 'C101', 2800000, 'Đang hoạt động'),
('Lớp Tiếng Anh Nâng Cao C2', 2025, 'GV007', '2025-08-01', '2026-02-28', 'Thứ 3, 5, 7 - 17:30', 'C102', 2800000, 'Đang hoạt động'),

-- Lớp IELTS
('Lớp Luyện Thi IELTS 5.5+', 2025, 'GV008', '2025-07-01', '2025-10-30', 'Thứ 7, CN - 08:00', 'D101', 3500000, 'Đang hoạt động'),
('Lớp Luyện Thi IELTS 6.5+', 2025, 'GV009', '2025-07-01', '2025-10-30', 'Thứ 7, CN - 14:00', 'D102', 4000000, 'Đang hoạt động'),
('Lớp Luyện Thi IELTS 7.0+', 2025, 'GV010', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 09:30', 'D103', 4500000, 'Đang hoạt động'),

-- Lớp TOEIC
('Lớp Luyện Thi TOEIC 450+', 2025, 'GV011', '2025-07-01', '2025-10-30', 'Thứ 2, 4, 6 - 20:00', 'E101', 2500000, 'Đang hoạt động'),
('Lớp Luyện Thi TOEIC 650+', 2025, 'GV012', '2025-07-01', '2025-10-30', 'Thứ 3, 5, 7 - 20:00', 'E102', 2800000, 'Đang hoạt động'),
('Lớp Luyện Thi TOEIC 850+', 2025, 'GV013', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 16:00', 'E103', 3200000, 'Đang hoạt động'),

-- Lớp thiếu nhi
('Lớp Tiếng Anh Thiếu Nhi Starter', 2025, 'GV014', '2025-07-01', '2025-12-30', 'Thứ 3, 5, 7 - 17:00', 'F101', 1500000, 'Đang hoạt động'),
('Lớp Tiếng Anh Thiếu Nhi Beginner', 2025, 'GV015', '2025-07-01', '2025-12-30', 'Thứ 2, 4, 6 - 17:00', 'F102', 1500000, 'Đang hoạt động'),
('Lớp Tiếng Anh Thiếu Nhi Elementary', 2025, 'GV016', '2025-07-15', '2026-01-15', 'Thứ 7, CN - 08:30', 'F103', 1600000, 'Đang hoạt động'),

-- Lớp giao tiếp
('Lớp Giao Tiếp Tiếng Anh Cơ Bản', 2025, 'GV017', '2025-07-01', '2025-10-30', 'Thứ 2, 4 - 19:30', 'G101', 2000000, 'Đang hoạt động'),
('Lớp Giao Tiếp Tiếng Anh Nâng Cao', 2025, 'GV018', '2025-07-01', '2025-10-30', 'Thứ 3, 5 - 19:30', 'G102', 2300000, 'Đang hoạt động'),

-- Lớp doanh nghiệp
('Lớp Tiếng Anh Doanh Nghiệp', 2025, 'GV019', '2025-08-01', '2025-12-30', 'Thứ 7 - 08:00', 'H101', 3000000, 'Đang hoạt động'),
('Lớp Tiếng Anh Chuyên Ngành IT', 2025, 'GV020', '2025-08-01', '2025-12-30', 'CN - 08:00', 'H102', 3200000, 'Đang hoạt động'),

-- Lớp đã kết thúc
('Lớp Tiếng Anh Cơ Bản - Khoá 1', 2024, 'GV002', '2024-01-15', '2024-06-15', 'Thứ 2, 4, 6 - 18:00', 'A105', 1600000, 'Đã kết thúc'),
('Lớp IELTS 6.0 - Khoá 2', 2024, 'GV008', '2024-03-01', '2024-08-30', 'Thứ 7, CN - 09:00', 'D104', 3800000, 'Đã kết thúc'),

-- Lớp tạm ngưng
('Lớp Tiếng Anh Du Lịch', 2025, 'GV003', '2025-09-01', '2025-12-30', 'Thứ 7 - 14:00', 'I101', 2200000, 'Tạm ngưng');


-- Insert student data for the 50 new students (HV006 to HV055)
INSERT INTO students (UserID, FullName, Gender, Email, Phone, BirthDate, ClassID) VALUES
-- Học sinh lớp cơ bản A1 (ClassID = 4)
('HV006', 'Nguyễn Văn An', 'Nam', 'nguyenvanan@email.com', '0901234567', '2010-03-15', 4),
('HV007', 'Trần Thị Bảo', 'Nữ', 'tranthbao@email.com', '0901234568', '2009-07-22', 4),
('HV008', 'Lê Hoàng Cường', 'Nam', 'lehoangcuong@email.com', '0901234569', '2011-01-08', 4),
('HV009', 'Phạm Thị Dung', 'Nữ', 'phamthidung@email.com', '0901234570', '2010-11-14', 4),

-- Học sinh lớp cơ bản A2 (ClassID = 5)
('HV010', 'Hoàng Văn Em', 'Nam', 'hoangvanem@email.com', '0901234571', '2009-05-30', 5),
('HV011', 'Vũ Thị Phương', 'Nữ', 'vuthiphuong@email.com', '0901234572', '2010-09-12', 5),
('HV012', 'Đỗ Minh Giang', 'Nam', 'dominhhgiang@email.com', '0901234573', '2011-04-25', 5),
('HV013', 'Bùi Thị Hạnh', 'Nữ', 'buithihanh@email.com', '0901234574', '2009-12-03', 5),

-- Học sinh lớp trung cấp B1 (ClassID = 6)
('HV014', 'Ngô Văn Ích', 'Nam', 'ngovanic@email.com', '0901234575', '2008-08-17', 6),
('HV015', 'Lý Thị Khánh', 'Nữ', 'lythikhanh@email.com', '0901234576', '2007-01-28', 6),
('HV016', 'Đinh Văn Lâm', 'Nam', 'dinhvanlam@email.com', '0901234577', '2008-05-11', 6),
('HV017', 'Võ Thị Mai', 'Nữ', 'vothimai@email.com', '0901234578', '2007-10-20', 6),

-- Học sinh lớp trung cấp B2 (ClassID = 7)
('HV018', 'Đặng Văn Nam', 'Nam', 'dangvannam@email.com', '0901234579', '2008-03-07', 7),
('HV019', 'Tạ Thị Oanh', 'Nữ', 'tathioanh@email.com', '0901234580', '2007-07-15', 7),
('HV020', 'Chu Văn Phúc', 'Nam', 'chuvanphuc@email.com', '0901234581', '2008-11-23', 7),
('HV021', 'Dương Thị Quỳnh', 'Nữ', 'duongthiquynh@email.com', '0901234582', '2007-02-18', 7),

-- Học sinh lớp nâng cao C1 (ClassID = 8)
('HV022', 'Mai Văn Rồng', 'Nam', 'maivanrong@email.com', '0901234583', '2006-09-05', 8),
('HV023', 'Lưu Thị Sáng', 'Nữ', 'luuthisang@email.com', '0901234584', '2005-12-12', 8),
('HV024', 'Phan Văn Tài', 'Nam', 'phanvantai@email.com', '0901234585', '2006-04-09', 8),
('HV025', 'Trịnh Thị Uyên', 'Nữ', 'trinhthiuyen@email.com', '0901234586', '2005-08-26', 8),

-- Học sinh lớp nâng cao C2 (ClassID = 9)
('HV026', 'Lương Văn Việt', 'Nam', 'luongvanviet@email.com', '0901234587', '2006-06-14', 9),
('HV027', 'Hồ Thị Xuân', 'Nữ', 'hothixuan@email.com', '0901234588', '2005-10-31', 9),
('HV028', 'Cao Văn Yên', 'Nam', 'caovanyen@email.com', '0901234589', '2006-02-28', 9),
('HV029', 'Kiều Thị Ý', 'Nữ', 'kieuthiy@email.com', '0901234590', '2005-07-08', 9),

-- Học sinh lớp IELTS 5.5+ (ClassID = 10)
('HV030', 'Trương Văn Ấn', 'Nam', 'truongvanan@email.com', '0901234591', '2004-03-20', 10),
('HV031', 'Nguyễn Thị Ấm', 'Nữ', 'nguyenthiam@email.com', '0901234592', '2003-11-15', 10),
('HV032', 'Lê Văn Đức', 'Nam', 'levanduc@email.com', '0901234593', '2004-05-22', 10),

-- Học sinh lớp IELTS 6.5+ (ClassID = 11)
('HV033', 'Phạm Thị Nga', 'Nữ', 'phamthinga@email.com', '0901234594', '2003-09-18', 11),
('HV034', 'Hoàng Văn Hùng', 'Nam', 'hoangvanhung@email.com', '0901234595', '2004-01-25', 11),
('HV035', 'Vũ Thị Linh', 'Nữ', 'vuthilinh@email.com', '0901234596', '2003-06-30', 11),

-- Học sinh lớp IELTS 7.0+ (ClassID = 12)
('HV036', 'Đỗ Văn Mạnh', 'Nam', 'dovanmanh@email.com', '0901234597', '2002-12-10', 12),
('HV037', 'Bùi Thị Oanh', 'Nữ', 'buithioanh@email.com', '0901234598', '2003-04-16', 12),

-- Học sinh lớp TOEIC 450+ (ClassID = 13)
('HV038', 'Ngô Văn Phong', 'Nam', 'ngovanphong@email.com', '0901234599', '2004-08-23', 13),
('HV039', 'Lý Thị Quân', 'Nữ', 'lythiquan@email.com', '0901234600', '2003-02-14', 13),
('HV040', 'Đinh Văn Sơn', 'Nam', 'dinhvanson@email.com', '0901234601', '2004-10-05', 13),

-- Học sinh lớp TOEIC 650+ (ClassID = 14)
('HV041', 'Võ Thị Thảo', 'Nữ', 'vothithao@email.com', '0901234602', '2003-07-12', 14),
('HV042', 'Đặng Văn Tuấn', 'Nam', 'dangvantuan@email.com', '0901234603', '2004-03-28', 14),
('HV043', 'Tạ Thị Uyên', 'Nữ', 'tathiuyen@email.com', '0901234604', '2003-11-19', 14),

-- Học sinh lớp TOEIC 850+ (ClassID = 15)
('HV044', 'Chu Văn Vinh', 'Nam', 'chuvanvinh@email.com', '0901234605', '2002-05-07', 15),
('HV045', 'Dương Thị Xuân', 'Nữ', 'duongthixuan@email.com', '0901234606', '2003-09-24', 15),

-- Học sinh lớp thiếu nhi Starter (ClassID = 16)
('HV046', 'Mai Văn Yến', 'Nam', 'maivanyen@email.com', '0901234607', '2012-01-11', 16),
('HV047', 'Lưu Thị Anh', 'Nữ', 'luuthianh@email.com', '0901234608', '2013-06-18', 16),
('HV048', 'Phan Văn Bình', 'Nam', 'phanvanbinh@email.com', '0901234609', '2012-10-25', 16),

-- Học sinh lớp thiếu nhi Beginner (ClassID = 17)
('HV049', 'Trịnh Thị Cúc', 'Nữ', 'trinhthicuc@email.com', '0901234610', '2013-04-02', 17)


-- Insert parent data for the 29 new parents (PH002 to PH030)
INSERT INTO parents (UserID, FullName, Gender, Email, Phone, BirthDate, ZaloID, UnpaidAmount, isShowTeacher) VALUES
('PH002', 'Nguyễn Văn Bình', 'Nam', 'nguyenvanbinhph@email.com', '0912345678', '1975-03-20', 'nguyenvanbinh75', 0, TRUE),
('PH003', 'Trần Thị Lan', 'Nữ', 'tranthilanph@email.com', '0912345679', '1978-07-15', 'tranthilan78', 0, FALSE),
('PH004', 'Lê Văn Hùng', 'Nam', 'levanhungph@email.com', '0912345680', '1973-11-08', 'levanhung73', 0, TRUE),
('PH005', 'Phạm Thị Mai', 'Nữ', 'phamthimaiph@email.com', '0912345681', '1980-02-14', 'phamthimai80', 0, FALSE),
('PH006', 'Hoàng Văn Đức', 'Nam', 'hoangvanducph@email.com', '0912345682', '1977-06-30', 'hoangvanduc77', 0, TRUE),
('PH007', 'Vũ Thị Hoa', 'Nữ', 'vuthihoaph@email.com', '0912345683', '1979-09-12', 'vuthihoa79', 0, FALSE),
('PH008', 'Đỗ Văn Thành', 'Nam', 'dovanthanhph@email.com', '0912345684', '1974-04-25', 'dovanthanh74', 0, TRUE),
('PH009', 'Bùi Thị Nga', 'Nữ', 'buithingaph@email.com', '0912345685', '1981-12-03', 'buithinga81', 0, FALSE),
('PH010', 'Ngô Văn Quang', 'Nam', 'ngovanquangph@email.com', '0912345686', '1976-08-17', 'ngovanquang76', 0, TRUE),
('PH011', 'Lý Thị Thu', 'Nữ', 'lythithuph@email.com', '0912345687', '1982-01-28', 'lythithu82', 0, FALSE),
('PH012', 'Đinh Văn Tùng', 'Nam', 'dinhvantungph@email.com', '0912345688', '1975-05-11', 'dinhvantung75', 0, TRUE),
('PH013', 'Võ Thị Phượng', 'Nữ', 'vothiphuongph@email.com', '0912345689', '1978-10-20', 'vothiphuong78', 0, FALSE),
('PH014', 'Đặng Văn Dũng', 'Nam', 'dangvandungph@email.com', '0912345690', '1973-03-07', 'dangvandung73', 0, TRUE),
('PH015', 'Tạ Thị Bích', 'Nữ', 'tathibichph@email.com', '0912345691', '1980-07-15', 'tathibich80', 0, FALSE),
('PH016', 'Chu Văn Khang', 'Nam', 'chuvankhangph@email.com', '0912345692', '1977-11-23', 'chuvankhang77', 0, TRUE),
('PH017', 'Dương Thị Linh', 'Nữ', 'duongthilinhph@email.com', '0912345693', '1979-02-18', 'duongthilinh79', 0, FALSE),
('PH018', 'Mai Văn Tuấn', 'Nam', 'maivantuanph@email.com', '0912345694', '1974-09-05', 'maivantuan74', 0, TRUE),
('PH019', 'Lưu Thị Yến', 'Nữ', 'luuthiyenph@email.com', '0912345695', '1981-12-12', 'luuthiyen81', 0, FALSE),
('PH020', 'Phan Văn Nam', 'Nam', 'phanvannamph@email.com', '0912345696', '1976-04-09', 'phanvannam76', 0, TRUE),
('PH021', 'Trịnh Thị Uyên', 'Nữ', 'trinhthiuyenph@email.com', '0912345697', '1982-08-26', 'trinhthiuyen82', 0, FALSE),
('PH022', 'Lương Văn Việt', 'Nam', 'luongvanvietph@email.com', '0912345698', '1975-06-14', 'luongvanviet75', 0, TRUE),
('PH023', 'Hồ Thị Xuân', 'Nữ', 'hothixuanph@email.com', '0912345699', '1978-10-31', 'hothixuan78', 0, FALSE),
('PH024', 'Cao Văn Yên', 'Nam', 'caovanyenph@email.com', '0912345700', '1973-02-28', 'caovanyen73', 0, TRUE),
('PH025', 'Kiều Thị Ý', 'Nữ', 'kieuthiyph@email.com', '0912345701', '1980-07-08', 'kieuthiy80', 0, FALSE),
('PH026', 'Trương Văn Ấn', 'Nam', 'truongvananph@email.com', '0912345702', '1977-03-20', 'truongvanan77', 0, TRUE),
('PH027', 'Nguyễn Thị Ấm', 'Nữ', 'nguyenthiamph@email.com', '0912345703', '1979-11-15', 'nguyenthiam79', 0, FALSE),
('PH028', 'Lê Văn Đức', 'Nam', 'levanducph@email.com', '0912345704', '1974-05-22', 'levanduc74', 0, TRUE),
('PH029', 'Phạm Thị Nga', 'Nữ', 'phamthingaph@email.com', '0912345705', '1981-09-18', 'phamthinga81', 0, FALSE);



INSERT INTO student_parent_keys (student_id, parent_id) VALUES
-- PH002 có 2 con: HV006, HV007
('HV006', 'PH002'),
('HV007', 'PH002'),

-- PH003 có 2 con: HV008, HV009  
('HV008', 'PH003'),
('HV009', 'PH003'),

-- PH004 có 2 con: HV010, HV011
('HV010', 'PH004'),
('HV011', 'PH004'),

-- PH005 có 2 con: HV012, HV013
('HV012', 'PH005'),
('HV013', 'PH005'),

-- PH006 có 2 con: HV014, HV015
('HV014', 'PH006'),
('HV015', 'PH006'),

-- PH007 có 2 con: HV016, HV017
('HV016', 'PH007'),
('HV017', 'PH007'),

-- PH008 có 2 con: HV018, HV019
('HV018', 'PH008'),
('HV019', 'PH008'),

-- PH009 có 2 con: HV020, HV021
('HV020', 'PH009'),
('HV021', 'PH009'),

-- PH010 có 2 con: HV022, HV023
('HV022', 'PH010'),
('HV023', 'PH010'),

-- PH011 có 2 con: HV024, HV025
('HV024', 'PH011'),
('HV025', 'PH011'),

-- PH012 có 2 con: HV026, HV027
('HV026', 'PH012'),
('HV027', 'PH012'),

-- PH013 có 2 con: HV028, HV029
('HV028', 'PH013'),
('HV029', 'PH013'),

-- PH014 có 2 con: HV030, HV031
('HV030', 'PH014'),
('HV031', 'PH014'),

-- PH015 có 1 con: HV032
('HV032', 'PH015'),

-- PH016 có 2 con: HV033, HV034
('HV033', 'PH016'),
('HV034', 'PH016'),

-- PH017 có 1 con: HV035
('HV035', 'PH017'),

-- PH018 có 2 con: HV036, HV037
('HV036', 'PH018'),
('HV037', 'PH018'),

-- PH019 có 2 con: HV038, HV039
('HV038', 'PH019'),
('HV039', 'PH019'),

-- PH020 có 1 con: HV040
('HV040', 'PH020'),

-- PH021 có 2 con: HV041, HV042
('HV041', 'PH021'),
('HV042', 'PH021'),

-- PH022 có 1 con: HV043
('HV043', 'PH022'),

-- PH023 có 2 con: HV044, HV045
('HV044', 'PH023'),
('HV045', 'PH023'),

-- PH024 có 2 con: HV046, HV047
('HV046', 'PH024'),
('HV047', 'PH024'),

-- PH025 có 1 con: HV048
('HV048', 'PH025')



