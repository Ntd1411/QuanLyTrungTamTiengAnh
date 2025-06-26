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
-- Cấu trúc bảng cho bảng `promotions`
--

CREATE TABLE `promotions` (
  `PromoID` int(11) NOT NULL,
  `Content` text NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date DEFAULT NULL,
  `Status` tinyint(1) DEFAULT 1,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
('GV001', 'giaovien1', 'matkhau_mahoa', 1, '2025-06-17 09:29:43'),
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

-- Phần mới update--------------------------------------------------------------------------


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