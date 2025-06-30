-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 29, 2025 lúc 11:38 AM
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
(33, 'HV006', 4, '2025-06-28', 'Vắng mặt', '', '2025-06-28 16:15:23'),
(34, 'HV007', 4, '2025-06-28', 'Có mặt', '', '2025-06-28 16:15:23'),
(35, 'HV008', 4, '2025-06-28', 'Có mặt', '', '2025-06-28 16:15:23'),
(36, 'HV009', 4, '2025-06-28', 'Có mặt', '', '2025-06-28 16:15:23');

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
  `Tuition` decimal(12,0) NOT NULL DEFAULT 0,
  `Status` enum('Đang hoạt động','Đã kết thúc','Tạm ngưng') DEFAULT 'Đang hoạt động',
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `classes`
--

INSERT INTO `classes` (`ClassID`, `ClassName`, `SchoolYear`, `TeacherID`, `StartDate`, `EndDate`, `ClassTime`, `Room`, `Tuition`, `Status`, `CreatedAt`) VALUES
(1, 'Lớp Tiếng Anh Căn Bản A1', 2025, 'GV002', '2025-07-01', '2025-12-30', 'Thứ 2, 4, 6 - 19:00', 'A103', 1800000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(2, 'Lớp Tiếng Anh Căn Bản A2', 2025, 'GV003', '2025-07-01', '2025-12-30', 'Thứ 3, 5, 7 - 19:00', 'A104', 1800000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(3, 'Lớp Tiếng Anh Trung Cấp B1', 2025, 'GV004', '2025-07-15', '2026-01-15', 'Thứ 2, 4, 6 - 18:30', 'B101', 2200000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(4, 'Lớp Tiếng Anh Trung Cấp B2', 2025, 'GV005', '2025-07-15', '2026-01-15', 'Thứ 3, 5, 7 - 18:30', 'B102', 2200000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(5, 'Lớp Tiếng Anh Nâng Cao C1', 2025, 'GV006', '2025-08-01', '2026-02-28', 'Thứ 2, 4, 6 - 17:30', 'C101', 2800000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(6, 'Lớp Tiếng Anh Nâng Cao C2', 2025, 'GV007', '2025-08-01', '2026-02-28', 'Thứ 3, 5, 7 - 17:30', 'C102', 2800000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(7, 'Lớp Luyện Thi IELTS 5.5+', 2025, 'GV008', '2025-07-01', '2025-10-30', 'Thứ 7, CN - 08:00', 'D101', 3500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(8, 'Lớp Luyện Thi IELTS 6.5+', 2025, 'GV009', '2025-07-01', '2025-10-30', 'Thứ 7, CN - 14:00', 'D102', 4000000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(9, 'Lớp Luyện Thi IELTS 7.0+', 2025, 'GV010', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 09:30', 'D103', 4500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(10, 'Lớp Luyện Thi TOEIC 450+', 2025, 'GV011', '2025-07-01', '2025-10-30', 'Thứ 2, 4, 6 - 20:00', 'E101', 2500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(11, 'Lớp Luyện Thi TOEIC 650+', 2025, 'GV012', '2025-07-01', '2025-10-30', 'Thứ 3, 5, 7 - 20:00', 'P201', 2800000, 'Đã kết thúc', '2025-06-28 15:34:56'),
(12, 'Lớp Luyện Thi TOEIC 850+', 2025, 'GV013', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 16:00', 'E103', 3200000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(13, 'Lớp Tiếng Anh Thiếu Nhi Starter', 2025, 'GV014', '2025-07-01', '2025-12-30', 'Thứ 3, 5, 7 - 17:00', 'F101', 1500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(14, 'Lớp Tiếng Anh Thiếu Nhi Beginner', 2025, 'GV015', '2025-07-01', '2025-12-30', 'Thứ 2, 4, 6 - 17:00', 'F102', 1500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(15, 'Lớp Tiếng Anh Thiếu Nhi Elementary', 2025, 'GV016', '2025-07-15', '2026-01-15', 'Thứ 7, CN - 08:30', 'F103', 1600000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(16, 'Lớp Giao Tiếp Tiếng Anh Cơ Bản', 2025, 'GV017', '2025-07-01', '2025-10-30', 'Thứ 2, 4 - 19:30', 'G101', 2000000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(17, 'Lớp Giao Tiếp Tiếng Anh Nâng Cao', 2025, 'GV018', '2025-07-01', '2025-10-30', 'Thứ 3, 5 - 19:30', 'G102', 2300000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(18, 'Lớp Tiếng Anh Doanh Nghiệp', 2025, 'GV019', '2025-08-01', '2025-12-30', 'Thứ 7 - 08:00', 'H101', 3000000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(19, 'Lớp Tiếng Anh Chuyên Ngành IT', 2025, 'GV020', '2025-08-01', '2025-12-30', 'CN - 08:00', 'H102', 3200000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(20, 'Lớp Tiếng Anh Cơ Bản - Khoá 1', 2024, 'GV002', '2024-01-15', '2024-06-15', 'Thứ 2, 4, 6 - 18:00', 'A105', 1600000, 'Đã kết thúc', '2025-06-28 15:34:56'),
(21, 'Lớp IELTS 6.0 - Khoá 2', 2024, 'GV008', '2024-03-01', '2024-08-30', 'Thứ 7, CN - 09:00', 'D104', 3800000, 'Đã kết thúc', '2025-06-28 15:34:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `consulting`
--

CREATE TABLE `consulting` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `birthyear` varchar(10) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `course` varchar(100) NOT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Chưa tư vấn','Đã tư vấn') NOT NULL DEFAULT 'Chưa tư vấn'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `consulting`
--

INSERT INTO `consulting` (`id`, `fullname`, `birthyear`, `phone`, `email`, `course`, `message`, `created_at`, `status`) VALUES
(1, 'Hihi', '2000', '0361172245', 'dungnguyentuan582@gmail.com', 'Khóa học IELTS', 'jkhhjkjkh', '2025-06-28 15:52:04', 'Chưa tư vấn'),
(2, 'urtủ··891273', '1000', '0361172245', 'dungnguyentuan582@gmail.com', 'Khóa học Tiếng Anh cho trẻ em', 'fgfgdd', '2025-06-28 15:53:12', 'Chưa tư vấn');

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
(4, 4, 'Bài tập về nhà', 'fdgdf', '2025-06-28', 'Chưa hoàn thành');

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
('GV', 25),
('HV', 55),
('PH', 32);

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
  `IsRead` tinyint(1) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `messages`
--

INSERT INTO `messages` (`MessageID`, `SenderID`, `ReceiverID`, `Subject`, `Content`, `SendDate`, `IsRead`, `CreatedAt`) VALUES
(41, '0', 'GV002', 'test', 'gdfgfd', '2025-06-28 22:57:31', 0, '2025-06-28 15:57:31'),
(42, 'GV005', 'HV006', 'Bài tập về nhà', 'fdgdf', '2025-06-28 23:12:01', 0, '2025-06-28 16:12:01'),
(43, 'GV005', 'HV007', 'Bài tập về nhà', 'fdgdf', '2025-06-28 23:12:01', 1, '2025-06-28 16:12:01'),
(44, 'GV005', 'HV008', 'Bài tập về nhà', 'fdgdf', '2025-06-28 23:12:01', 0, '2025-06-28 16:12:01'),
(45, 'GV005', 'HV009', 'Bài tập về nhà', 'fdgdf', '2025-06-28 23:12:01', 0, '2025-06-28 16:12:01'),
(46, 'GV005', 'HV006', 'Nghỉ học', 'jkk', '2025-06-28 23:12:45', 0, '2025-06-28 16:12:45'),
(47, 'GV005', 'HV007', 'Nghỉ học', 'jkk', '2025-06-28 23:12:45', 1, '2025-06-28 16:12:45'),
(48, 'GV005', 'HV008', 'Nghỉ học', 'jkk', '2025-06-28 23:12:45', 0, '2025-06-28 16:12:45'),
(49, 'GV005', 'HV009', 'Nghỉ học', 'jkk', '2025-06-28 23:12:45', 0, '2025-06-28 16:12:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `excerpt` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `author` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `news`
--

INSERT INTO `news` (`id`, `title`, `content`, `excerpt`, `image`, `author`, `date`, `created_at`) VALUES
(12, 'Khai giảng Trại hè Tiếng Anh 2025 - Vui học, vui khám phá!', 'Trại hè Tiếng Anh KEC 2025 chính thức khai giảng, mang đến một mùa hè sôi động, bổ ích với vô vàn hoạt động lý thú kết hợp học tập và trải nghiệm thực tế...', 'Trại hè Tiếng Anh KEC 2025 chính thức khai giảng, mang đến một mùa hè sôi động, bổ ích với vô vàn hoạt động lý thú kết hợp học tập và trải nghiệm thực tế...', 'summercamp.jpg', 'KEC Team', '2025-06-10', '2025-06-28 15:47:52'),
(13, 'Chúc mừng học viên Nguyễn Văn A đạt IELTS 7.5 Overall!', 'KEC xin gửi lời chúc mừng chân thành nhất đến học viên Nguyễn Văn A đã xuất sắc đạt 7.5 IELTS chỉ sau 6 tháng học tại trung tâm. Cùng tìm hiểu bí quyết thành công của bạn...', 'KEC xin gửi lời chúc mừng chân thành nhất đến học viên Nguyễn Văn A đã xuất sắc đạt 7.5 IELTS chỉ sau 6 tháng học tại trung tâm. Cùng tìm hiểu bí quyết thành công của bạn...', 'ielts7-5.jpg', 'Ban Tuyển sinh', '2025-06-05', '2025-06-28 15:47:52'),
(14, '5 mẹo học từ vựng tiếng Anh hiệu quả không thể bỏ qua', 'Bạn gặp khó khăn khi ghi nhớ từ vựng? Đừng lo, bài viết này sẽ chia sẻ 5 chiến lược đã được kiểm chứng giúp bạn mở rộng vốn từ nhanh chóng và hiệu quả...', 'Bạn gặp khó khăn khi ghi nhớ từ vựng? Đừng lo, bài viết này sẽ chia sẻ 5 chiến lược đã được kiểm chứng giúp bạn mở rộng vốn từ nhanh chóng và hiệu quả...', 'hocTA.jpg', 'Cô Lan Anh', '2025-06-01', '2025-06-28 15:47:52'),
(15, 'Cập nhật cấu trúc đề thi TOEIC Reading mới nhất 2025', 'Những thay đổi quan trọng trong phần thi Reading của kỳ thi TOEIC năm 2025 mà bạn cần biết để chuẩn bị tốt nhất cho bài thi của mình...', 'Những thay đổi quan trọng trong phần thi Reading của kỳ thi TOEIC năm 2025 mà bạn cần biết để chuẩn bị tốt nhất cho bài thi của mình...', 'toeic.png', 'Thầy Duy Hưng', '2025-05-28', '2025-06-28 15:47:52');

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
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UnpaidAmount` decimal(12,0) DEFAULT 0,
  `isShowTeacher` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `parents`
--

INSERT INTO `parents` (`UserID`, `FullName`, `Gender`, `Email`, `Phone`, `BirthDate`, `ZaloID`, `CreatedAt`, `UnpaidAmount`, `isShowTeacher`) VALUES
('PH002', 'Nguyễn Văn Bình', 'Nam', 'nguyenvanbinhph@email.com', '0912345678', '1975-03-20', 'nguyenvanbinh75', '2025-06-28 15:43:08', 0, 1),
('PH003', 'Trần Thị Lan', 'Nữ', 'tranthilanph@email.com', '0912345679', '1978-07-15', 'tranthilan78', '2025-06-28 15:43:08', 0, 0),
('PH004', 'Lê Văn Hùng', 'Nam', 'levanhungph@email.com', '0912345680', '1973-11-08', 'levanhung73', '2025-06-28 15:43:08', 0, 1),
('PH005', 'Phạm Thị Mai', 'Nữ', 'phamthimaiph@email.com', '0912345681', '1980-02-14', 'phamthimai80', '2025-06-28 15:43:08', 0, 0),
('PH006', 'Hoàng Văn Đức', 'Nam', 'hoangvanducph@email.com', '0912345682', '1977-06-30', 'hoangvanduc77', '2025-06-28 15:43:08', 0, 1),
('PH007', 'Vũ Thị Hoa', 'Nữ', 'vuthihoaph@email.com', '0912345683', '1979-09-12', 'vuthihoa79', '2025-06-28 15:43:08', 0, 0),
('PH008', 'Đỗ Văn Thành', 'Nam', 'dovanthanhph@email.com', '0912345684', '1974-04-25', 'dovanthanh74', '2025-06-28 15:43:08', 0, 1),
('PH009', 'Bùi Thị Nga', 'Nữ', 'buithingaph@email.com', '0912345685', '1981-12-03', 'buithinga81', '2025-06-28 15:43:08', 0, 0),
('PH010', 'Ngô Văn Quang', 'Nam', 'ngovanquangph@email.com', '0912345686', '1976-08-17', 'ngovanquang76', '2025-06-28 15:43:08', 0, 1),
('PH011', 'Lý Thị Thu', 'Nữ', 'lythithuph@email.com', '0912345687', '1982-01-28', 'lythithu82', '2025-06-28 15:43:08', 0, 0),
('PH012', 'Đinh Văn Tùng', 'Nam', 'dinhvantungph@email.com', '0912345688', '1975-05-11', 'dinhvantung75', '2025-06-28 15:43:08', 0, 1),
('PH013', 'Võ Thị Phượng', 'Nữ', 'vothiphuongph@email.com', '0912345689', '1978-10-20', 'vothiphuong78', '2025-06-28 15:43:08', 0, 0),
('PH014', 'Đặng Văn Dũng', 'Nam', 'dangvandungph@email.com', '0912345690', '1973-03-07', 'dangvandung73', '2025-06-28 15:43:08', 0, 1),
('PH015', 'Tạ Thị Bích', 'Nữ', 'tathibichph@email.com', '0912345691', '1980-07-15', 'tathibich80', '2025-06-28 15:43:08', 0, 0),
('PH016', 'Chu Văn Khang', 'Nam', 'chuvankhangph@email.com', '0912345692', '1977-11-23', 'chuvankhang77', '2025-06-28 15:43:08', 0, 1),
('PH017', 'Dương Thị Linh', 'Nữ', 'duongthilinhph@email.com', '0912345693', '1979-02-18', 'duongthilinh79', '2025-06-28 15:43:08', 0, 0),
('PH018', 'Mai Văn Tuấn', 'Nam', 'maivantuanph@email.com', '0912345694', '1974-09-05', 'maivantuan74', '2025-06-28 15:43:08', 3200000, 0),
('PH019', 'Lưu Thị Yến', 'Nữ', 'luuthiyenph@email.com', '0912345695', '1981-12-12', 'luuthiyen81', '2025-06-28 15:43:08', 0, 0),
('PH020', 'Phan Văn Nam', 'Nam', 'phanvannamph@email.com', '0912345696', '1976-04-09', 'phanvannam76', '2025-06-28 15:43:08', 0, 1),
('PH021', 'Trịnh Thị Uyên', 'Nữ', 'trinhthiuyenph@email.com', '0912345697', '1982-08-26', 'trinhthiuyen82', '2025-06-28 15:43:08', 0, 0),
('PH022', 'Lương Văn Việt', 'Nam', 'luongvanvietph@email.com', '0912345698', '1975-06-14', 'luongvanviet75', '2025-06-28 15:43:08', 0, 1),
('PH023', 'Hồ Thị Xuân', 'Nữ', 'hothixuanph@email.com', '0912345699', '1978-10-31', 'hothixuan78', '2025-06-28 15:43:08', 0, 0),
('PH024', 'Cao Văn Yên', 'Nam', 'caovanyenph@email.com', '0912345700', '1973-02-28', 'caovanyen73', '2025-06-28 15:43:08', 0, 1),
('PH025', 'Kiều Thị Ý', 'Nữ', 'kieuthiyph@email.com', '0912345701', '1980-07-08', 'kieuthiy80', '2025-06-28 15:43:08', 0, 0),
('PH026', 'Trương Văn Ấn', 'Nam', 'truongvananph@email.com', '0912345702', '1977-03-20', 'truongvanan77', '2025-06-28 15:43:08', 0, 1),
('PH027', 'Nguyễn Thị Ấm', 'Nữ', 'nguyenthiamph@email.com', '0912345703', '1979-11-15', 'nguyenthiam79', '2025-06-28 15:43:08', 0, 0),
('PH028', 'Lê Văn Đức', 'Nam', 'levanducph@email.com', '0912345704', '1974-05-22', 'levanduc74', '2025-06-28 15:43:08', 0, 1),
('PH029', 'Phạm Thị Nga', 'Nữ', 'phamthingaph@email.com', '0912345705', '1981-09-18', 'phamthinga81', '2025-06-28 15:43:08', 0, 0),
('PH030', 'NGUYEN TUAN DUNG', 'Nam', 'dungnguyentuandd582@gmail.com', '0361172245', '2000-12-11', NULL, '2025-06-29 08:25:22', 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payment_history`
--

CREATE TABLE `payment_history` (
  `paymentID` int(11) NOT NULL,
  `studentID` varchar(10) NOT NULL,
  `parentID` varchar(10) NOT NULL,
  `paidAmount` decimal(12,0) NOT NULL,
  `note` text DEFAULT NULL,
  `paymentDate` date NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `payment_history`
--

INSERT INTO `payment_history` (`paymentID`, `studentID`, `parentID`, `paidAmount`, `note`, `paymentDate`, `createdAt`) VALUES
(1, 'HV036', 'PH018', 2000000, 'Học phí lớp Lớp Luyện Thi TOEIC 850+ - 06/2025 - Đỗ Văn Mạnh - Nộp 2000000 VNĐ', '2025-06-28', '2025-06-28 16:24:12'),
(2, 'HV036', 'PH018', 1200000, 'Học phí lớp Lớp Luyện Thi TOEIC 850+ - 06/2025 - Đỗ Văn Mạnh - Nộp 1200000 VNĐ', '2025-06-28', '2025-06-28 16:25:36');

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
  `AttendedClasses` int(11) DEFAULT 0,
  `AbsentClasses` int(11) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `students`
--

INSERT INTO `students` (`UserID`, `FullName`, `Gender`, `Email`, `Phone`, `BirthDate`, `ClassID`, `AttendedClasses`, `AbsentClasses`, `CreatedAt`) VALUES
('HV006', 'Nguyễn Văn An', 'Nam', 'anvureala31102004@gmail.com', '0901234567', '2010-03-15', 1, 0, 0, '2025-06-28 15:40:05'),
('HV007', 'Trần Thị Bảo', 'Nữ', 'tranthbao@email.com', '0901234568', '2009-07-22', 4, 0, 0, '2025-06-28 15:40:05'),
('HV008', 'Lê Hoàng Cường', 'Nam', 'lehoangcuong@email.com', '0901234569', '2011-01-08', 4, 0, 0, '2025-06-28 15:40:05'),
('HV009', 'Phạm Thị Dung', 'Nữ', 'phamthidung@email.com', '0901234570', '2010-11-14', 4, 0, 0, '2025-06-28 15:40:05'),
('HV010', 'Hoàng Văn Em', 'Nam', 'hoangvanem@email.com', '0901234571', '2009-05-30', 5, 0, 0, '2025-06-28 15:40:05'),
('HV011', 'Vũ Thị Phương', 'Nữ', 'vuthiphuong@email.com', '0901234572', '2010-09-12', 5, 0, 0, '2025-06-28 15:40:05'),
('HV012', 'Đỗ Minh Giang', 'Nam', 'dominhhgiang@email.com', '0901234573', '2011-04-25', 5, 0, 0, '2025-06-28 15:40:05'),
('HV013', 'Bùi Thị Hạnh', 'Nữ', 'buithihanh@email.com', '0901234574', '2009-12-03', 5, 0, 0, '2025-06-28 15:40:05'),
('HV014', 'Ngô Văn Ích', 'Nam', 'ngovanic@email.com', '0901234575', '2008-08-17', 6, 0, 0, '2025-06-28 15:40:05'),
('HV015', 'Lý Thị Khánh', 'Nữ', 'lythikhanh@email.com', '0901234576', '2007-01-28', 6, 0, 0, '2025-06-28 15:40:05'),
('HV016', 'Đinh Văn Lâm', 'Nam', 'dinhvanlam@email.com', '0901234577', '2008-05-11', 6, 0, 0, '2025-06-28 15:40:05'),
('HV017', 'Võ Thị Mai', 'Nữ', 'vothimai@email.com', '0901234578', '2007-10-20', 6, 0, 0, '2025-06-28 15:40:05'),
('HV018', 'Đặng Văn Nam', 'Nam', 'dangvannam@email.com', '0901234579', '2008-03-07', 7, 0, 0, '2025-06-28 15:40:05'),
('HV019', 'Tạ Thị Oanh', 'Nữ', 'tathioanh@email.com', '0901234580', '2007-07-15', 7, 0, 0, '2025-06-28 15:40:05'),
('HV020', 'Chu Văn Phúc', 'Nam', 'chuvanphuc@email.com', '0901234581', '2008-11-23', 7, 0, 0, '2025-06-28 15:40:05'),
('HV021', 'Dương Thị Quỳnh', 'Nữ', 'duongthiquynh@email.com', '0901234582', '2007-02-18', 7, 0, 0, '2025-06-28 15:40:05'),
('HV022', 'Mai Văn Rồng', 'Nam', 'maivanrong@email.com', '0901234583', '2006-09-05', 8, 0, 0, '2025-06-28 15:40:05'),
('HV023', 'Lưu Thị Sáng', 'Nữ', 'luuthisang@email.com', '0901234584', '2005-12-12', 8, 0, 0, '2025-06-28 15:40:05'),
('HV024', 'Phan Văn Tài', 'Nam', 'phanvantai@email.com', '0901234585', '2006-04-09', 8, 0, 0, '2025-06-28 15:40:05'),
('HV025', 'Trịnh Thị Uyên', 'Nữ', 'trinhthiuyen@email.com', '0901234586', '2005-08-26', 8, 0, 0, '2025-06-28 15:40:05'),
('HV026', 'Lương Văn Việt', 'Nam', 'luongvanviet@email.com', '0901234587', '2006-06-14', 9, 0, 0, '2025-06-28 15:40:05'),
('HV027', 'Hồ Thị Xuân', 'Nữ', 'hothixuan@email.com', '0901234588', '2005-10-31', 9, 0, 0, '2025-06-28 15:40:05'),
('HV028', 'Cao Văn Yên', 'Nam', 'caovanyen@email.com', '0901234589', '2006-02-28', 9, 0, 0, '2025-06-28 15:40:05'),
('HV029', 'Kiều Thị Ý', 'Nữ', 'kieuthiy@email.com', '0901234590', '2005-07-08', 9, 0, 0, '2025-06-28 15:40:05'),
('HV030', 'Trương Văn Ấn', 'Nam', 'truongvanan@email.com', '0901234591', '2004-03-20', 10, 0, 0, '2025-06-28 15:40:05'),
('HV031', 'Nguyễn Thị Ấm', 'Nữ', 'nguyenthiam@email.com', '0901234592', '2003-11-15', 10, 0, 0, '2025-06-28 15:40:05'),
('HV032', 'Lê Văn Đức', 'Nam', 'levanduc@email.com', '0901234593', '2004-05-22', 10, 0, 0, '2025-06-28 15:40:05'),
('HV033', 'Phạm Thị Nga', 'Nữ', 'phamthinga@email.com', '0901234594', '2003-09-18', 11, 0, 0, '2025-06-28 15:40:05'),
('HV034', 'Hoàng Văn Hùng', 'Nam', 'hoangvanhung@email.com', '0901234595', '2004-01-25', 11, 0, 0, '2025-06-28 15:40:05'),
('HV035', 'Vũ Thị Linh', 'Nữ', 'vuthilinh@email.com', '0901234596', '2003-06-30', 11, 0, 0, '2025-06-28 15:40:05'),
('HV036', 'Đỗ Văn Mạnh', 'Nam', 'dovanmanh@email.com', '0901234597', '2002-12-10', 12, 0, 0, '2025-06-28 15:40:05'),
('HV037', 'Bùi Thị Oanh', 'Nữ', 'buithioanh@email.com', '0901234598', '2003-04-16', 12, 0, 0, '2025-06-28 15:40:05'),
('HV038', 'Ngô Văn Phong', 'Nam', 'ngovanphong@email.com', '0901234599', '2004-08-23', 13, 0, 0, '2025-06-28 15:40:05'),
('HV039', 'Lý Thị Quân', 'Nữ', 'lythiquan@email.com', '0901234600', '2003-02-14', 13, 0, 0, '2025-06-28 15:40:05'),
('HV040', 'Đinh Văn Sơn', 'Nam', 'dinhvanson@email.com', '0901234601', '2004-10-05', 13, 0, 0, '2025-06-28 15:40:05'),
('HV041', 'Võ Thị Thảo', 'Nữ', 'vothithao@email.com', '0901234602', '2003-07-12', 14, 0, 0, '2025-06-28 15:40:05'),
('HV042', 'Đặng Văn Tuấn', 'Nam', 'dangvantuan@email.com', '0901234603', '2004-03-28', 14, 0, 0, '2025-06-28 15:40:05'),
('HV043', 'Tạ Thị Uyên', 'Nữ', 'tathiuyen@email.com', '0901234604', '2003-11-19', 14, 0, 0, '2025-06-28 15:40:05'),
('HV044', 'Chu Văn Vinh', 'Nam', 'chuvanvinh@email.com', '0901234605', '2002-05-07', 15, 0, 0, '2025-06-28 15:40:05'),
('HV045', 'Dương Thị Xuân', 'Nữ', 'duongthixuan@email.com', '0901234606', '2003-09-24', 15, 0, 0, '2025-06-28 15:40:05'),
('HV046', 'Mai Văn Yến', 'Nam', 'maivanyen@email.com', '0901234607', '2012-01-11', 16, 0, 0, '2025-06-28 15:40:05'),
('HV047', 'Lưu Thị Anh', 'Nữ', 'luuthianh@email.com', '0901234608', '2013-06-18', 16, 0, 0, '2025-06-28 15:40:05'),
('HV048', 'Phan Văn Bình', 'Nam', 'phanvanbinh@email.com', '0901234609', '2012-10-25', 16, 0, 0, '2025-06-28 15:40:05'),
('HV049', 'Trịnh Thị Cúc', 'Nữ', 'trinhthicuc@email.com', '0901234610', '2013-04-02', 17, 0, 0, '2025-06-28 15:40:05'),
('HV051', 'NGUYEN TUAN DUNG', 'Nam', 'dungnguyentuan582@gmail.com', '0361172245', '2000-12-11', NULL, 0, 0, '2025-06-29 08:24:21'),
('HV052', 'dfgdfgdf', 'Nam', 'dfgdfgdfg@dgfjd.dff', '34324234', '2025-06-25', 2, 0, 0, '2025-06-29 08:52:28'),
('HV053', 'vdxfgdf', 'Nam', 'gfdgd@fdfj.dd', '4534', '2025-06-25', 4, 0, 0, '2025-06-29 08:57:42'),
('HV054', 'fdfsdfs', 'Nam', 'dfsdfdxx@dfdf.ddd', '534534', '2025-06-16', 1, 0, 0, '2025-06-29 09:02:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `student_parent_keys`
--

CREATE TABLE `student_parent_keys` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `parent_id` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `student_parent_keys`
--

INSERT INTO `student_parent_keys` (`id`, `student_id`, `parent_id`, `created_at`) VALUES
(132, 'HV007', 'PH002', '2025-06-28 15:46:44'),
(133, 'HV008', 'PH003', '2025-06-28 15:46:44'),
(134, 'HV009', 'PH003', '2025-06-28 15:46:44'),
(135, 'HV010', 'PH004', '2025-06-28 15:46:44'),
(136, 'HV011', 'PH004', '2025-06-28 15:46:44'),
(137, 'HV012', 'PH005', '2025-06-28 15:46:44'),
(138, 'HV013', 'PH005', '2025-06-28 15:46:44'),
(139, 'HV014', 'PH006', '2025-06-28 15:46:44'),
(140, 'HV015', 'PH006', '2025-06-28 15:46:44'),
(141, 'HV016', 'PH007', '2025-06-28 15:46:44'),
(142, 'HV017', 'PH007', '2025-06-28 15:46:44'),
(143, 'HV018', 'PH008', '2025-06-28 15:46:44'),
(144, 'HV019', 'PH008', '2025-06-28 15:46:44'),
(145, 'HV020', 'PH009', '2025-06-28 15:46:44'),
(146, 'HV021', 'PH009', '2025-06-28 15:46:44'),
(147, 'HV022', 'PH010', '2025-06-28 15:46:44'),
(148, 'HV023', 'PH010', '2025-06-28 15:46:44'),
(149, 'HV024', 'PH011', '2025-06-28 15:46:44'),
(150, 'HV025', 'PH011', '2025-06-28 15:46:44'),
(151, 'HV026', 'PH012', '2025-06-28 15:46:44'),
(152, 'HV027', 'PH012', '2025-06-28 15:46:44'),
(153, 'HV028', 'PH013', '2025-06-28 15:46:44'),
(154, 'HV029', 'PH013', '2025-06-28 15:46:44'),
(155, 'HV030', 'PH014', '2025-06-28 15:46:44'),
(156, 'HV031', 'PH014', '2025-06-28 15:46:44'),
(157, 'HV032', 'PH015', '2025-06-28 15:46:44'),
(158, 'HV033', 'PH016', '2025-06-28 15:46:44'),
(159, 'HV034', 'PH016', '2025-06-28 15:46:44'),
(160, 'HV036', 'PH017', '2025-06-28 15:46:44'),
(161, 'HV036', 'PH018', '2025-06-28 15:46:44'),
(162, 'HV037', 'PH018', '2025-06-28 15:46:44'),
(163, 'HV038', 'PH019', '2025-06-28 15:46:44'),
(164, 'HV039', 'PH019', '2025-06-28 15:46:44'),
(165, 'HV040', 'PH020', '2025-06-28 15:46:44'),
(166, 'HV041', 'PH021', '2025-06-28 15:46:44'),
(167, 'HV042', 'PH021', '2025-06-28 15:46:44'),
(168, 'HV043', 'PH022', '2025-06-28 15:46:44'),
(169, 'HV044', 'PH023', '2025-06-28 15:46:44'),
(170, 'HV045', 'PH023', '2025-06-28 15:46:44'),
(171, 'HV046', 'PH024', '2025-06-28 15:46:44'),
(172, 'HV047', 'PH024', '2025-06-28 15:46:44'),
(173, 'HV048', 'PH025', '2025-06-28 15:46:44'),
(175, 'HV052', 'PH006', '2025-06-29 08:52:28'),
(176, 'HV052', 'PH007', '2025-06-29 08:52:28'),
(177, 'HV053', 'PH004', '2025-06-29 08:57:42'),
(178, 'HV053', 'PH007', '2025-06-29 08:57:42'),
(182, 'HV006', 'PH002', '2025-06-29 09:17:29');

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
('GV002', 'Nguyễn Thị Lan', 'Nữ', 'gv002@email.com', '0123456781', '1985-03-15', 8000000, '2025-06-28 15:32:53'),
('GV003', 'Trần Văn Minh', 'Nam', 'gv003@email.com', '0123456782', '1988-07-22', 7500000, '2025-06-28 15:32:53'),
('GV004', 'Lê Thị Hương', 'Nữ', 'gv004@email.com', '0123456783', '1990-11-08', 7200000, '2025-06-28 15:32:53'),
('GV005', 'Phạm Đức Anh', 'Nam', 'gv005@email.com', '0123456999', '1987-02-14', 8500000, '2025-06-28 15:32:53'),
('GV006', 'Hoàng Thị Mai', 'Nữ', 'gv006@email.com', '0123456785', '1992-06-30', 7800000, '2025-06-28 15:32:53'),
('GV007', 'Vũ Văn Hải', 'Nam', 'gv007@email.com', '0123456786', '1984-09-12', 9000000, '2025-06-28 15:32:53'),
('GV008', 'Đỗ Thị Linh', 'Nữ', 'gv008@email.com', '0123456787', '1989-04-25', 7600000, '2025-06-28 15:32:53'),
('GV009', 'Bùi Văn Thành', 'Nam', 'gv009@email.com', '0123456788', '1991-12-03', 7300000, '2025-06-28 15:32:53'),
('GV010', 'Ngô Thị Nga', 'Nữ', 'gv010@email.com', '0123456789', '1986-08-17', 8200000, '2025-06-28 15:32:53'),
('GV011', 'Lý Văn Quang', 'Nam', 'gv011@email.com', '0123456790', '1993-01-28', 7000000, '2025-06-28 15:32:53'),
('GV012', 'Đinh Thị Thu', 'Nữ', 'gv012@email.com', '0123456791', '1988-05-11', 7700000, '2025-06-28 15:32:53'),
('GV013', 'Võ Văn Tùng', 'Nam', 'gv013@email.com', '0123456792', '1985-10-20', 8800000, '2025-06-28 15:32:53'),
('GV014', 'Đặng Thị Phượng', 'Nữ', 'gv014@email.com', '0123456793', '1990-03-07', 7400000, '2025-06-28 15:32:53'),
('GV015', 'Tạ Văn Dũng', 'Nam', 'gv015@email.com', '0123456794', '1987-07-15', 8100000, '2025-06-28 15:32:53'),
('GV016', 'Chu Thị Hoa', 'Nữ', 'gv016@email.com', '0123456795', '1989-11-23', 7900000, '2025-06-28 15:32:53'),
('GV017', 'Dương Văn Khang', 'Nam', 'gv017@email.com', '0123456796', '1992-02-18', 7500000, '2025-06-28 15:32:53'),
('GV018', 'Mai Thị Bích', 'Nữ', 'gv018@email.com', '0123456797', '1986-09-05', 8300000, '2025-06-28 15:32:53'),
('GV019', 'Lưu Văn Tuấn', 'Nam', 'gv019@email.com', '0123456798', '1988-12-12', 7600000, '2025-06-28 15:32:53'),
('GV020', 'Phan Thị Yến', 'Nữ', 'gv020@email.com', '0123456799', '1991-04-09', 7800000, '2025-06-28 15:32:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teaching_sessions`
--

CREATE TABLE `teaching_sessions` (
  `SessionID` int(11) NOT NULL,
  `TeacherID` varchar(10) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `SessionDate` date NOT NULL,
  `Status` enum('Đã dạy','Nghỉ','Dời lịch') DEFAULT 'Đã dạy',
  `Note` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teaching_sessions`
--

INSERT INTO `teaching_sessions` (`SessionID`, `TeacherID`, `ClassID`, `SessionDate`, `Status`, `Note`, `CreatedAt`) VALUES
(1, 'GV002', 1, '2025-06-28', 'Đã dạy', '', '2025-06-28 16:04:39'),
(2, 'GV002', 1, '2025-07-06', 'Đã dạy', '', '2025-06-28 16:04:47'),
(4, 'GV002', 20, '2025-06-28', 'Đã dạy', '', '2025-06-28 16:05:17'),
(5, 'GV005', 4, '2025-06-28', 'Đã dạy', 'uhg', '2025-06-28 16:13:40');

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
(56, 'HV007', 2200000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Trung Cấp B2 - 06/2025', '2025-06-28 15:40:05'),
(57, 'HV008', 2200000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Trung Cấp B2 - 06/2025', '2025-06-28 15:40:05'),
(58, 'HV009', 2200000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Trung Cấp B2 - 06/2025', '2025-06-28 15:40:05'),
(59, 'HV010', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C1 - 06/2025', '2025-06-28 15:40:05'),
(60, 'HV011', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C1 - 06/2025', '2025-06-28 15:40:05'),
(61, 'HV012', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C1 - 06/2025', '2025-06-28 15:40:05'),
(62, 'HV013', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C1 - 06/2025', '2025-06-28 15:40:05'),
(63, 'HV014', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C2 - 06/2025', '2025-06-28 15:40:05'),
(64, 'HV015', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C2 - 06/2025', '2025-06-28 15:40:05'),
(65, 'HV016', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C2 - 06/2025', '2025-06-28 15:40:05'),
(66, 'HV017', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Nâng Cao C2 - 06/2025', '2025-06-28 15:40:05'),
(67, 'HV018', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(68, 'HV019', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(69, 'HV020', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(70, 'HV021', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(71, 'HV022', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(72, 'HV023', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(73, 'HV024', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(74, 'HV025', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(75, 'HV026', 4500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 7.0+ - 06/2025', '2025-06-28 15:40:05'),
(76, 'HV027', 4500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 7.0+ - 06/2025', '2025-06-28 15:40:05'),
(77, 'HV028', 4500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 7.0+ - 06/2025', '2025-06-28 15:40:05'),
(78, 'HV029', 4500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 7.0+ - 06/2025', '2025-06-28 15:40:05'),
(79, 'HV030', 2500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 450+ - 06/2025', '2025-06-28 15:40:05'),
(80, 'HV031', 2500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 450+ - 06/2025', '2025-06-28 15:40:05'),
(81, 'HV032', 2500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 450+ - 06/2025', '2025-06-28 15:40:05'),
(82, 'HV033', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 650+ - 06/2025', '2025-06-28 15:40:05'),
(83, 'HV034', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 650+ - 06/2025', '2025-06-28 15:40:05'),
(84, 'HV035', 2800000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 650+ - 06/2025', '2025-06-28 15:40:05'),
(85, 'HV036', 3200000, 0.00, '2025-06-28', '2025-06-30', 'Đã đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 850+ - 06/2025', '2025-06-28 15:40:05'),
(86, 'HV037', 3200000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 850+ - 06/2025', '2025-06-28 15:40:05'),
(87, 'HV038', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 06/2025', '2025-06-28 15:40:05'),
(88, 'HV039', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 06/2025', '2025-06-28 15:40:05'),
(89, 'HV040', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 06/2025', '2025-06-28 15:40:05'),
(90, 'HV041', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Beginner - 06/2025', '2025-06-28 15:40:05'),
(91, 'HV042', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Beginner - 06/2025', '2025-06-28 15:40:05'),
(92, 'HV043', 1500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Beginner - 06/2025', '2025-06-28 15:40:05'),
(93, 'HV044', 1600000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Elementary - 06/2025', '2025-06-28 15:40:05'),
(94, 'HV045', 1600000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Elementary - 06/2025', '2025-06-28 15:40:05'),
(95, 'HV046', 2000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Giao Tiếp Tiếng Anh Cơ Bản - 06/2025', '2025-06-28 15:40:05'),
(96, 'HV047', 2000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Giao Tiếp Tiếng Anh Cơ Bản - 06/2025', '2025-06-28 15:40:05'),
(97, 'HV048', 2000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Giao Tiếp Tiếng Anh Cơ Bản - 06/2025', '2025-06-28 15:40:05'),
(98, 'HV049', 2300000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Giao Tiếp Tiếng Anh Nâng Cao - 06/2025', '2025-06-28 15:40:05'),
(99, 'HV052', 1800000, 50.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Căn Bản A2 - 06/2025', '2025-06-29 08:52:28'),
(100, 'HV053', 2200000, 10.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Trung Cấp B2 - 06/2025', '2025-06-29 08:57:42'),
(102, 'HV006', 1800000, 0.00, NULL, '2025-07-09', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Căn Bản A1 - 06/2025', '2025-06-29 09:09:24'),
(103, 'HV054', 1800000, 0.00, NULL, '2025-07-09', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Căn Bản A1 - 06/2025', '2025-06-29 09:12:11');

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
('0', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 0, '2025-06-17 01:22:54'),
('GV001', 'teacher01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV002', 'teacher02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV003', 'teacher03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV004', 'teacher04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV005', 'teacher05', '$2y$10$cC.GOaqlqoGY5erm68nDtumZBznFyO1wajWFemBDABfjAje3EPpH6', 1, '2025-06-28 15:29:46'),
('GV006', 'teacher06', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV007', 'teacher07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV008', 'teacher08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV009', 'teacher09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV010', 'teacher10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV011', 'teacher11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV012', 'teacher12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV013', 'teacher13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV014', 'teacher14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV015', 'teacher15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV016', 'teacher16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV017', 'teacher17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV018', 'teacher18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV019', 'teacher19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('GV020', 'teacher20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2025-06-28 15:29:46'),
('HV001', 'student01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV002', 'student02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV003', 'student03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV004', 'student04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV005', 'student05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV006', 'student06', '$2y$10$.ZqGMsdd.7IjJJlJDmH5R./VgOyYQUJ7E1bjam2BJ/Y0sYCsJ/62y', 2, '2025-06-28 15:29:46'),
('HV007', 'student07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV008', 'student08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV009', 'student09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV010', 'student10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV011', 'student11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV012', 'student12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV013', 'student13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV014', 'student14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV015', 'student15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV016', 'student16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV017', 'student17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV018', 'student18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV019', 'student19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV020', 'student20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV021', 'student21', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV022', 'student22', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV023', 'student23', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV024', 'student24', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV025', 'student25', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV026', 'student26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV027', 'student27', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV028', 'student28', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV029', 'student29', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV030', 'student30', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV031', 'student31', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV032', 'student32', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV033', 'student33', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV034', 'student34', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV035', 'student35', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV036', 'student36', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV037', 'student37', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV038', 'student38', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV039', 'student39', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV040', 'student40', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV041', 'student41', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV042', 'student42', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV043', 'student43', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV044', 'student44', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV045', 'student45', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV046', 'student46', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV047', 'student47', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV048', 'student48', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV049', 'student49', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV050', 'student50', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV051', 'dungngye', '$2y$10$3ODNAJeiBRfW57Gjo/Di7OTIogjygysR1OoZ.9xhVI2uRF1f8pATK', 2, '2025-06-29 08:24:21'),
('HV052', 'gdfgdfgdf', '$2y$10$afGU8EptbVzi9q9WTeTxm.LRt0NSuTRV9rNtmu8GnxYn7l//iQY7i', 2, '2025-06-29 08:52:28'),
('HV053', 'gdfgdfgdffdf', '$2y$10$s9qGnVfOkwHV4asWgcAFIOxTBJClsBR2cvOnbz2haVFKwoExw8XQC', 2, '2025-06-29 08:57:42'),
('HV054', 'fsdfsdsf', '$2y$10$9Ct5E9GNW4b9juif0/4H7eOWYBDNVx8dkSyQnfEkfm8HsYlaoM3LK', 2, '2025-06-29 09:02:29'),
('PH001', 'parent01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH002', 'parent02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH003', 'parent03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH004', 'parent04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH005', 'parent05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH006', 'parent06', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH007', 'parent07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH008', 'parent08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH009', 'parent09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH010', 'parent10', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH011', 'parent11', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH012', 'parent12', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH013', 'parent13', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH014', 'parent14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH015', 'parent15', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH016', 'parent16', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH017', 'parent17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH018', 'parent18', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH019', 'parent19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH020', 'parent20', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH021', 'parent21', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH022', 'parent22', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH023', 'parent23', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH024', 'parent24', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH025', 'parent25', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH026', 'parent26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH027', 'parent27', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH028', 'parent28', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH029', 'parent29', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, '2025-06-28 15:29:46'),
('PH030', 'djjfjk', '$2y$10$PLAxUfnW2wxOCGJFaIJ6TOy8d3Trkee1XqGj5d1lL4G6BHu18LAEa', 3, '2025-06-29 08:25:22');

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
-- Chỉ mục cho bảng `consulting`
--
ALTER TABLE `consulting`
  ADD PRIMARY KEY (`id`);

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
-- Chỉ mục cho bảng `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Chỉ mục cho bảng `payment_history`
--
ALTER TABLE `payment_history`
  ADD PRIMARY KEY (`paymentID`),
  ADD KEY `parentID` (`parentID`);

--
-- Chỉ mục cho bảng `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD KEY `ClassID` (`ClassID`);

--
-- Chỉ mục cho bảng `student_parent_keys`
--
ALTER TABLE `student_parent_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_key` (`student_id`,`parent_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Chỉ mục cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Chỉ mục cho bảng `teaching_sessions`
--
ALTER TABLE `teaching_sessions`
  ADD PRIMARY KEY (`SessionID`),
  ADD KEY `TeacherID` (`TeacherID`),
  ADD KEY `ClassID` (`ClassID`);

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
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT cho bảng `classes`
--
ALTER TABLE `classes`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT cho bảng `consulting`
--
ALTER TABLE `consulting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `homework`
--
ALTER TABLE `homework`
  MODIFY `HomeworkID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `messages`
--
ALTER TABLE `messages`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `payment_history`
--
ALTER TABLE `payment_history`
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `student_parent_keys`
--
ALTER TABLE `student_parent_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=184;

--
-- AUTO_INCREMENT cho bảng `teaching_sessions`
--
ALTER TABLE `teaching_sessions`
  MODIFY `SessionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `tuition`
--
ALTER TABLE `tuition`
  MODIFY `TuitionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

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
-- Các ràng buộc cho bảng `payment_history`
--
ALTER TABLE `payment_history`
  ADD CONSTRAINT `payment_history_ibfk_1` FOREIGN KEY (`parentID`) REFERENCES `parents` (`UserID`);

--
-- Các ràng buộc cho bảng `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`);

--
-- Các ràng buộc cho bảng `student_parent_keys`
--
ALTER TABLE `student_parent_keys`
  ADD CONSTRAINT `student_parent_keys_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_parent_keys_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`UserID`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Các ràng buộc cho bảng `teaching_sessions`
--
ALTER TABLE `teaching_sessions`
  ADD CONSTRAINT `teaching_sessions_ibfk_1` FOREIGN KEY (`TeacherID`) REFERENCES `teachers` (`UserID`),
  ADD CONSTRAINT `teaching_sessions_ibfk_2` FOREIGN KEY (`ClassID`) REFERENCES `classes` (`ClassID`);

--
-- Các ràng buộc cho bảng `tuition`
--
ALTER TABLE `tuition`
  ADD CONSTRAINT `tuition_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
