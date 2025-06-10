-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 10, 2025 lúc 10:56 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

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

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admin`
--

CREATE TABLE `admin` (
  `AdminID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `admin`
--

INSERT INTO `admin` (`AdminID`, `Username`, `Password`, `Email`, `CreatedAt`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@example.com', '2025-06-10 08:54:24');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `attendance`
--

CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL,
  `StudentID` int(11) DEFAULT NULL,
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
(1, 1, 1, '2025-06-01', 'Có mặt', NULL, '2025-06-10 08:54:25'),
(2, 1, 1, '2025-06-03', 'Có mặt', NULL, '2025-06-10 08:54:25'),
(3, 2, 2, '2025-06-01', 'Có mặt', NULL, '2025-06-10 08:54:25'),
(4, 2, 2, '2025-06-03', 'Đi muộn', 'Đến muộn 15 phút', '2025-06-10 08:54:25'),
(5, 3, 3, '2025-06-02', 'Vắng mặt', 'Có phép - Ốm', '2025-06-10 08:54:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `classes`
--

CREATE TABLE `classes` (
  `ClassID` int(11) NOT NULL,
  `ClassName` varchar(50) NOT NULL,
  `SchoolYear` int(11) NOT NULL,
  `TeacherID` int(11) DEFAULT NULL,
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
(1, 'Lớp 3.1', 2025, 1, '2025-06-01', '2025-08-30', '18:00-19:30', 'P201', 'Đang hoạt động', '2025-06-10 08:54:25'),
(2, 'Lớp 4.2', 2025, 2, '2025-06-01', '2025-08-30', '19:45-21:15', 'P202', 'Đang hoạt động', '2025-06-10 08:54:25'),
(3, 'Lớp 5.1', 2025, 3, '2025-06-15', '2025-09-15', '18:00-19:30', 'P203', 'Đang hoạt động', '2025-06-10 08:54:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `parents`
--

CREATE TABLE `parents` (
  `ParentID` int(11) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
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

INSERT INTO `parents` (`ParentID`, `FullName`, `Username`, `Password`, `Gender`, `Email`, `Phone`, `BirthDate`, `ZaloID`, `UnpaidAmount`, `CreatedAt`) VALUES
(1, 'Phạm Văn Toàn', 'toan_parent', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nam', 'toan@example.com', '0945678901', '1980-12-25', 'zalo001', 0, '2025-06-10 08:54:25'),
(2, 'Nguyễn Thị Mai', 'mai_parent', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nữ', 'mai@example.com', '0956789012', '1982-07-15', 'zalo002', 1500000, '2025-06-10 08:54:25'),
(3, 'Trần Văn Hùng', 'hung_parent', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nam', 'hung@example.com', '0967890123', '1979-04-20', 'zalo003', 500000, '2025-06-10 08:54:25');

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

--
-- Đang đổ dữ liệu cho bảng `promotions`
--

INSERT INTO `promotions` (`PromoID`, `Content`, `StartDate`, `EndDate`, `Status`, `CreatedAt`) VALUES
(1, 'Giảm 20% học phí khi đăng ký 2 khóa liên tiếp', '2025-06-01', '2025-06-30', 1, '2025-06-10 08:54:25'),
(2, 'Tặng 1 khóa học miễn phí cho học sinh có thành tích xuất sắc', '2025-06-15', '2025-07-15', 1, '2025-06-10 08:54:25'),
(3, 'Ưu đãi đặc biệt: Đăng ký nhóm 3 người giảm 25%', '2025-06-10', '2025-06-25', 1, '2025-06-10 08:54:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `students`
--

CREATE TABLE `students` (
  `StudentID` int(11) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Gender` enum('Nam','Nữ') NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `BirthDate` date NOT NULL,
  `ClassID` int(11) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  `AttendedClasses` int(11) DEFAULT 0,
  `AbsentClasses` int(11) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `students`
--

INSERT INTO `students` (`StudentID`, `FullName`, `Username`, `Password`, `Gender`, `Email`, `Phone`, `BirthDate`, `ClassID`, `ParentID`, `AttendedClasses`, `AbsentClasses`, `CreatedAt`) VALUES
(1, 'Phạm Minh Anh', 'minhanh', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nữ', 'minhanh@example.com', '0978901234', '2015-03-10', 1, 1, 5, 1, '2025-06-10 08:54:25'),
(2, 'Nguyễn Hoàng Nam', 'hoangnam', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nam', 'hoangnam@example.com', '0989012345', '2014-08-20', 2, 2, 6, 0, '2025-06-10 08:54:25'),
(3, 'Trần Thu Hà', 'thuha', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nữ', 'thuha@example.com', '0990123456', '2013-11-15', 3, 3, 4, 2, '2025-06-10 08:54:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teachers`
--

CREATE TABLE `teachers` (
  `TeacherID` int(11) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
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

INSERT INTO `teachers` (`TeacherID`, `FullName`, `Username`, `Password`, `Gender`, `Email`, `Phone`, `BirthDate`, `Salary`, `CreatedAt`) VALUES
(1, 'Nguyễn Thị Hương', 'huong_teacher', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nữ', 'huong@example.com', '0912345678', '1990-05-15', 10000000, '2025-06-10 08:54:25'),
(2, 'Trần Văn Nam', 'nam_teacher', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nam', 'nam@example.com', '0923456789', '1988-08-20', 12000000, '2025-06-10 08:54:25'),
(3, 'Lê Thị Thanh', 'thanh_teacher', '$2y$10$mW5.TDL6GdL/or0M5DqGY.rZ1yXE0FQTPtJ8IpWoqWoQgOL5WXAyi', 'Nữ', 'thanh@example.com', '0934567890', '1992-03-10', 11000000, '2025-06-10 08:54:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tuition`
--

CREATE TABLE `tuition` (
  `TuitionID` int(11) NOT NULL,
  `StudentID` int(11) DEFAULT NULL,
  `Amount` decimal(12,0) NOT NULL,
  `PaymentDate` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `Status` enum('Chưa đóng','Đã đóng','Trễ hạn') DEFAULT 'Chưa đóng',
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tuition`
--

INSERT INTO `tuition` (`TuitionID`, `StudentID`, `Amount`, `PaymentDate`, `DueDate`, `Status`, `Note`, `CreatedAt`) VALUES
(1, 1, 3000000, '2025-06-01', '2025-06-15', 'Đã đóng', NULL, '2025-06-10 08:54:25'),
(2, 2, 3000000, NULL, '2025-06-15', 'Chưa đóng', NULL, '2025-06-10 08:54:25'),
(3, 3, 3000000, '2025-06-05', '2025-06-15', 'Đã đóng', NULL, '2025-06-10 08:54:25');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`AdminID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Chỉ mục cho bảng `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`AttendanceID`),
  ADD KEY `idx_student` (`StudentID`),
  ADD KEY `idx_class` (`ClassID`);

--
-- Chỉ mục cho bảng `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`ClassID`),
  ADD KEY `idx_teacher` (`TeacherID`);

--
-- Chỉ mục cho bảng `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`ParentID`),
  ADD UNIQUE KEY `Username` (`Username`),
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
  ADD PRIMARY KEY (`StudentID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD KEY `idx_class` (`ClassID`),
  ADD KEY `idx_parent` (`ParentID`);

--
-- Chỉ mục cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`TeacherID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Chỉ mục cho bảng `tuition`
--
ALTER TABLE `tuition`
  ADD PRIMARY KEY (`TuitionID`),
  ADD KEY `idx_student` (`StudentID`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admin`
--
ALTER TABLE `admin`
  MODIFY `AdminID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `attendance`
--
ALTER TABLE `attendance`
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `classes`
--
ALTER TABLE `classes`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `parents`
--
ALTER TABLE `parents`
  MODIFY `ParentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `promotions`
--
ALTER TABLE `promotions`
  MODIFY `PromoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `students`
--
ALTER TABLE `students`
  MODIFY `StudentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `teachers`
--
ALTER TABLE `teachers`
  MODIFY `TeacherID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tuition`
--
ALTER TABLE `tuition`
  MODIFY `TuitionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`),
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`);

--
-- Các ràng buộc cho bảng `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`TeacherID`) REFERENCES `teachers` (`TeacherID`);

--
-- Các ràng buộc cho bảng `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`),
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`ParentID`) REFERENCES `parents` (`ParentID`);

--
-- Các ràng buộc cho bảng `tuition`
--
ALTER TABLE `tuition`
  ADD CONSTRAINT `tuition_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
