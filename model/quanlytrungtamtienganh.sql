-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th7 02, 2025 lúc 08:43 PM
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteStudent` (IN `p_UserID` VARCHAR(10))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStudent` (IN `p_UserID` VARCHAR(10), IN `p_FullName` VARCHAR(100), IN `p_Gender` ENUM('Nam','Nữ'), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(15), IN `p_BirthDate` DATE, IN `p_ClassID` INT)   BEGIN
    UPDATE students 
    SET FullName = p_FullName,
        Gender = p_Gender,
        Email = p_Email,
        Phone = p_Phone,
        BirthDate = p_BirthDate,
        ClassID = p_ClassID
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
-- Cấu trúc bảng cho bảng `advertisements`
--

CREATE TABLE `advertisements` (
  `id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `advertisements`
--

INSERT INTO `advertisements` (`id`, `subject`, `content`, `image`, `start_date`, `end_date`, `status`, `created_at`) VALUES
(1, 'Ưu đãi cực sốc cho khóa IELTS cơ bản', 'Đăng ký ngay để được giảm 30% học phí', 'ad_6865402d30927.png', '2025-07-02', '2025-07-31', 'active', '2025-07-01 16:40:35'),
(2, 'test', 'hihihihi', 'ad_686416ab0c6a7.png', '2025-07-03', '2025-07-03', 'inactive', '2025-07-01 17:11:07');

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
(40, 'HV013', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(41, 'HV017', 13, '2025-07-01', 'Vắng mặt', 'Có phép', '2025-07-02 18:28:26'),
(42, 'HV030', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(43, 'HV036', 13, '2025-07-01', 'Vắng mặt', 'Không phép', '2025-07-02 18:28:26'),
(44, 'HV038', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(45, 'HV039', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(46, 'HV040', 13, '2025-07-01', 'Vắng mặt', 'Có phép', '2025-07-02 18:28:26'),
(47, 'HV049', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(48, 'HV056', 13, '2025-07-01', 'Có mặt', '', '2025-07-02 18:28:26'),
(49, 'HV013', 13, '2025-07-03', 'Đi muộn', 'Kẹt xe', '2025-07-02 18:29:36'),
(50, 'HV017', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(51, 'HV030', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(52, 'HV036', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(53, 'HV038', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(54, 'HV039', 13, '2025-07-03', 'Vắng mặt', 'Ngã gãy chân', '2025-07-02 18:29:36'),
(55, 'HV040', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(56, 'HV049', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(57, 'HV056', 13, '2025-07-03', 'Có mặt', '', '2025-07-02 18:29:36'),
(58, 'HV011', 8, '2025-07-03', 'Đi muộn', 'Quên mang cặp', '2025-07-02 18:30:50'),
(59, 'HV012', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(60, 'HV014', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(61, 'HV015', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(62, 'HV016', 8, '2025-07-03', 'Vắng mặt', 'Việc gia đình', '2025-07-02 18:30:50'),
(63, 'HV018', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(64, 'HV020', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(65, 'HV022', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(66, 'HV023', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(67, 'HV024', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(68, 'HV025', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(69, 'HV026', 8, '2025-07-03', 'Có mặt', 'Sớm nhất lớp, tuyên dương', '2025-07-02 18:30:50'),
(70, 'HV027', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(71, 'HV029', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(72, 'HV033', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50'),
(73, 'HV057', 8, '2025-07-03', 'Có mặt', '', '2025-07-02 18:30:50');

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
(7, 'Lớp Luyện Thi IELTS 5.5+', 2025, 'GV008', '2025-07-01', '2025-10-30', 'Thứ 7, CN - 08:00', 'D101', 3500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(8, 'Lớp Luyện Thi IELTS 6.5+', 2025, 'GV026', '2025-07-01', '2025-10-30', 'Thứ 7, 8 - 14:00', 'P201', 4000000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(9, 'Lớp Luyện Thi IELTS 7.0+', 2025, 'GV010', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 09:30', 'D103', 4500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(10, 'Lớp Luyện Thi TOEIC 450+', 2025, 'GV011', '2025-07-01', '2025-10-30', 'Thứ 2, 4, 6 - 20:00', 'E101', 2500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(11, 'Lớp Luyện Thi TOEIC 650+', 2025, 'GV012', '2025-07-01', '2025-10-30', 'Thứ 3, 5, 7 - 20:00', 'P201', 2800000, 'Đã kết thúc', '2025-06-28 15:34:56'),
(12, 'Lớp Luyện Thi TOEIC 850+', 2025, 'GV013', '2025-07-15', '2025-11-15', 'Thứ 7, CN - 16:00', 'E103', 3200000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(13, 'Lớp Tiếng Anh Thiếu Nhi Starter', 2025, 'GV026', '2025-07-01', '2025-12-30', 'Thứ 3, 5, 7 - 17:00', 'P201', 1500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(14, 'Lớp Tiếng Anh Thiếu Nhi Beginner', 2025, 'GV015', '2025-07-01', '2025-12-30', 'Thứ 2, 4, 6 - 17:00', 'F102', 1500000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(15, 'Lớp Tiếng Anh Thiếu Nhi Elementary', 2025, 'GV016', '2025-07-15', '2026-01-15', 'Thứ 7, CN - 08:30', 'F103', 1600000, 'Đang hoạt động', '2025-06-28 15:34:56'),
(16, 'Lớp Giao Tiếp Tiếng Anh Cơ Bản', 2025, 'GV017', '2025-07-01', '2025-10-30', 'Thứ 2, 4 - 19:30', 'G101', 2000000, 'Đang hoạt động', '2025-06-28 15:34:56');

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
(1, 'Nguyễn Tuấn Dũng', '2000', '0361172245', 'ntd@gmail.com', 'Khóa học Tiếng Anh cho trẻ', 'Tôi muốn tìm một khóa học tiếng Anh trẻ em cho bé nhà tôi', '2025-06-28 15:52:04', 'Chưa tư vấn'),
(2, 'Hoàng Vũ Trúc Anh', '1000', '0361172245', 'hvta@gmail.com', 'Khóa học IELTS', 'Tôi muốn tìm một khóa học IELTS cho con trai', '2025-06-28 15:53:12', 'Chưa tư vấn');

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
(5, 8, 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-04', 'Chưa hoàn thành'),
(6, 8, 'Bài tập về nhà', 'Các em làm bài tập trang 15 giáo trình', '2025-07-05', 'Chưa hoàn thành'),
(7, 8, 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-08', 'Chưa hoàn thành'),
(8, 13, 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-05', 'Chưa hoàn thành'),
(9, 13, 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-07', 'Chưa hoàn thành'),
(10, 13, 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-11', 'Chưa hoàn thành');

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
('GV', 27),
('HV', 58),
('PH', 34);

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
(56, '0', 'GV026', 'Chào giáo viên', 'Chào cô, buổi dạy hôm nay của cô thế nào?', '2025-07-03 00:10:18', 0, '2025-07-02 17:10:18'),
(57, '0', 'GV026', 'Trả lương', 'Ngày mai mời giáo viên lên phòng giám đốc để nhận lương tháng trước, trân trọng', '2025-07-03 00:13:12', 0, '2025-07-02 17:13:12'),
(58, '0', 'GV026', 'Thông báo mở lớp', 'Lớp tiếng anh cho trẻ chuẩn bị đi vào hoạt động, giáo viên quan tâm có thể chủ động đăng ký dạy dự bị phòng khi giáo viên chính không lên lớp', '2025-07-03 00:15:13', 0, '2025-07-02 17:15:13'),
(59, '0', 'GV026', 'Học sinh mới', 'Sẽ có một học sinh mới chuyển sang lớp học IELTS 6.5 do giáo viên phụ trách, giáo viên chú ý tiếp nhận thông báo', '2025-07-03 00:16:16', 0, '2025-07-02 17:16:16'),
(61, '0', 'GV002', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(62, '0', 'GV003', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(63, '0', 'GV004', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(64, '0', 'GV006', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(65, '0', 'GV007', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(66, '0', 'GV008', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(67, '0', 'GV009', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(68, '0', 'GV010', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(69, '0', 'GV011', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(70, '0', 'GV012', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(71, '0', 'GV013', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(72, '0', 'GV014', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(73, '0', 'GV015', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(74, '0', 'GV016', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(75, '0', 'GV017', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(76, '0', 'GV018', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(77, '0', 'GV019', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(78, '0', 'GV020', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(79, '0', 'GV005', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(80, '0', 'GV026', 'Thông báo về cuộc họp', 'Kính gửi thầy/cô,\r\nXin thông báo về cuộc họp định kỳ vào lúc 7h sáng ngày 4/7 tại phòng số 105 trung tâm ngoại ngữ KMA. Nội dung chính: bàn bạc về việc mở lớp mới và phân công giáo viên phụ trách. Kính mong thầy/cô sắp xếp thời gian tham dự.\r\nTrân trọng.', '2025-07-03 00:23:45', 0, '2025-07-02 17:23:45'),
(81, '0', 'GV026', 'Yêu cầu nộp báo cáo', 'Kính gửi thầy/cô,\r\nXin phép được nhắc nhở về việc nộp báo cáo quá trình giảng dạy vào ngày 5/7. Vui lòng gửi báo cáo về địa chỉ email kec@edu.vn hoặc nộp trực tiếp cho giám đốc trung tâm. Xin chân thành cảm ơn sự hợp tác của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:25:26', 0, '2025-07-02 17:25:26'),
(82, '0', 'GV026', 'Yêu cầu cập nhật thông tin điểm danh', 'Yêu cầu giáo viên cập nhật thông tin điểm danh cho học sinh vào ngày 2/7, trân trọng', '2025-07-03 00:27:07', 1, '2025-07-02 17:27:07'),
(83, '0', 'GV002', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(84, '0', 'GV003', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(85, '0', 'GV004', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(86, '0', 'GV006', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(87, '0', 'GV007', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(88, '0', 'GV008', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(89, '0', 'GV009', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(90, '0', 'GV010', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(91, '0', 'GV011', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(92, '0', 'GV012', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(93, '0', 'GV013', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(94, '0', 'GV014', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(95, '0', 'GV015', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(96, '0', 'GV016', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(97, '0', 'GV017', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(98, '0', 'GV018', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(99, '0', 'GV019', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(100, '0', 'GV020', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(101, '0', 'GV005', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(102, '0', 'GV026', 'Mời tham gia đào tạo/bồi dưỡng', 'Kính gửi thầy/cô,\r\nTrung tâm trân trọng mời thầy/cô tham gia khóa đào tạo/bồi dưỡng kỹ năng tương tác với học viên nhằm nâng cao kỹ năng giảng dạy. Thời gian và địa điểm: Trung tâm ngoại ngữ KMA phòng 106 8h ngày 8/7/2025. Vui lòng đăng ký trước ngày 7/7. Xin cảm ơn sự quan tâm của thầy/cô.\r\nTrân trọng.', '2025-07-03 00:31:34', 0, '2025-07-02 17:31:34'),
(103, '0', 'GV002', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(104, '0', 'GV003', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(105, '0', 'GV004', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(106, '0', 'GV006', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(107, '0', 'GV007', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(108, '0', 'GV008', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(109, '0', 'GV009', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(110, '0', 'GV010', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(111, '0', 'GV011', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(112, '0', 'GV012', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(113, '0', 'GV013', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(114, '0', 'GV014', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(115, '0', 'GV015', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(116, '0', 'GV016', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(117, '0', 'GV017', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(118, '0', 'GV018', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(119, '0', 'GV019', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(120, '0', 'GV020', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(121, '0', 'GV005', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 0, '2025-07-02 17:34:36'),
(122, '0', 'GV026', 'Yêu cầu phản hồi về chương trình/tài liệu', 'Kính gửi thầy/cô,\r\nRất mong nhận được ý kiến đóng góp của thầy/cô về chương trình/tài liệu \"Giao tiếp như người bản xứ chỉ trong 100 ngày\". Phản hồi của thầy/cô sẽ giúp chúng tôi cải thiện và nâng cao chất lượng giảng dạy. Vui lòng gửi phản hồi về địa chỉ email kec@edu.vn. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:34:36', 1, '2025-07-02 17:34:36'),
(123, '0', 'GV026', 'Chúc mừng/Ghi nhận thành tích', 'Kính gửi cô Nguyễn Thu Hương,\r\nXin chúc mừng cô đã có đóng góp to lớn trong việc xây dựng khóa học nâng cao kỹ năng giao tiếp cho học viên của KEC. Sự đóng góp của cô là rất quan trọng đối với sự thành công của trung tâm. Xin chân thành cảm ơn.\r\nTrân trọng.', '2025-07-03 00:37:32', 0, '2025-07-02 17:37:32'),
(124, '0', 'GV002', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(125, '0', 'GV003', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(126, '0', 'GV004', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(127, '0', 'GV006', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(128, '0', 'GV007', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(129, '0', 'GV008', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(130, '0', 'GV009', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(131, '0', 'GV010', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(132, '0', 'GV011', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(133, '0', 'GV012', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(134, '0', 'GV013', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(135, '0', 'GV014', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(136, '0', 'GV015', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(137, '0', 'GV016', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(138, '0', 'GV017', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(139, '0', 'GV018', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(140, '0', 'GV019', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(141, '0', 'GV020', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(142, '0', 'GV005', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(143, '0', 'GV026', 'Đề xuất hỗ trợ về chuyên môn', 'Kính gửi thầy/cô,\r\nNếu thầy/cô có bất kỳ yêu cầu hỗ trợ nào về chuyên môn (ví dụ: tài liệu, phương pháp giảng dạy,...) xin vui lòng cho chúng tôi biết. Chúng tôi luôn sẵn sàng hỗ trợ để thầy/cô có thể hoàn thành tốt công việc giảng dạy. Xin cảm ơn.\r\nTrân trọng.', '2025-07-03 00:38:32', 0, '2025-07-02 17:38:32'),
(144, '0', 'PH033', 'Thông báo về việc chuyển lớp', 'Kính gửi phụ huynh, chúng tôi đã chuyển em Hoàng Đình Nam vào lớp IELTS 6.5+ như đã bàn bạc.\r\nTrân trọng.', '2025-07-03 00:42:59', 0, '2025-07-02 17:42:59'),
(145, '0', 'PH032', 'Thông báo đóng học phí', 'Kính gửi phụ huynh, vui lòng đóng học phí cho con Hoàng Đình Nam trong thời gian sớm nhất, xin cảm ơn', '2025-07-03 00:44:21', 0, '2025-07-02 17:44:21'),
(146, '0', 'PH033', 'Thông báo đóng học phí', 'Kính gửi phụ huynh, vui lòng đóng học phí cho con Hoàng Đình Nam trong thời gian sớm nhất, xin cảm ơn', '2025-07-03 00:44:21', 1, '2025-07-02 17:44:21'),
(147, '0', 'PH032', 'Thông báo về học phí', 'Kính gửi phụ huynh, vui lòng đóng học phí cho con Thanh Thư trong thời gian sớm nhất. Xin trân trọng cảm ơn', '2025-07-03 00:45:21', 0, '2025-07-02 17:45:21'),
(148, '0', 'PH033', 'Thông báo về học phí', 'Kính gửi phụ huynh, vui lòng đóng học phí cho con Thanh Thư trong thời gian sớm nhất. Xin trân trọng cảm ơn', '2025-07-03 00:45:21', 0, '2025-07-02 17:45:21'),
(149, '0', 'HV056', 'Chào con', 'Chào mừng con đến với Trung Tâm Anh Ngữ KMA!', '2025-07-03 00:48:20', 0, '2025-07-02 17:48:20'),
(150, '0', 'HV057', 'Chào con', 'Chào mừng con đến với Trung Tâm Anh Ngữ KMA!', '2025-07-03 00:48:20', 0, '2025-07-02 17:48:20'),
(151, '0', 'HV056', 'Hỏi về buổi học đầu tiên', 'Chào con, buổi học đầu tiên ở lớp mới thế nào? Nếu có vấn đề gì hãy liên hệ ngay với trung tâm để nhận được sự hỗ trợ sớm nhất nhé!', '2025-07-03 00:49:39', 0, '2025-07-02 17:49:39'),
(152, '0', 'HV057', 'Hỏi về buổi học đầu tiên', 'Chào con, buổi học đầu tiên ở lớp mới thế nào? Nếu có vấn đề gì hãy liên hệ ngay với trung tâm để nhận được sự hỗ trợ sớm nhất nhé!', '2025-07-03 00:49:39', 0, '2025-07-02 17:49:39'),
(153, '0', 'PH032', 'Thông báo về tình hình học tập của con', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về tình hình học tập của con Đình Nam trong tuần qua. Học viên làm quen với lớp mới rất nhanh và rất chủ động trong cac hoạt động. Rất mong nhận được sự phối hợp của quý vị để con có thể học tập tốt hơn. Nếu có bất kỳ thắc mắc nào, xin vui lòng liên hệ với trung tâm để nhận được sự hỗ trợ đầy đủ nhất!\r\nTrân trọng.', '2025-07-03 00:52:07', 0, '2025-07-02 17:52:07'),
(154, '0', 'PH033', 'Thông báo về tình hình học tập của con', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về tình hình học tập của con Đình Nam trong tuần qua. Học viên làm quen với lớp mới rất nhanh và rất chủ động trong cac hoạt động. Rất mong nhận được sự phối hợp của quý vị để con có thể học tập tốt hơn. Nếu có bất kỳ thắc mắc nào, xin vui lòng liên hệ với trung tâm để nhận được sự hỗ trợ đầy đủ nhất!\r\nTrân trọng.', '2025-07-03 00:52:07', 1, '2025-07-02 17:52:07'),
(155, '0', 'PH002', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(156, '0', 'PH003', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(157, '0', 'PH004', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(158, '0', 'PH005', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(159, '0', 'PH006', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(160, '0', 'PH007', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(161, '0', 'PH008', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(162, '0', 'PH009', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(163, '0', 'PH010', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(164, '0', 'PH011', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(165, '0', 'PH012', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(166, '0', 'PH013', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(167, '0', 'PH014', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(168, '0', 'PH015', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(169, '0', 'PH016', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(170, '0', 'PH017', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(171, '0', 'PH018', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(172, '0', 'PH019', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(173, '0', 'PH020', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(174, '0', 'PH021', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(175, '0', 'PH022', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(176, '0', 'PH023', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(177, '0', 'PH024', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(178, '0', 'PH025', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(179, '0', 'PH026', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(180, '0', 'PH027', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(181, '0', 'PH028', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(182, '0', 'PH029', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(183, '0', 'PH032', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(184, '0', 'PH033', 'Thông báo về sự kiện/hoạt động', 'Kính gửi quý phụ huynh,\r\nTrung tâm xin thông báo về hoạt động 1 ngày cắm trại với người ngoại quốc sẽ diễn ra vào ngày chủ nhât, 6/7/2025. Phụ huynh quan tâm có thể đăng ký trước ngày 5/7/2025. Rất mong nhận được sự tham gia của quý vị và con em.\r\nTrân trọng.', '2025-07-03 00:54:39', 0, '2025-07-02 17:54:39'),
(185, '0', 'PH002', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(186, '0', 'PH003', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(187, '0', 'PH004', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(188, '0', 'PH005', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(189, '0', 'PH006', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(190, '0', 'PH007', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(191, '0', 'PH008', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(192, '0', 'PH009', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31');
INSERT INTO `messages` (`MessageID`, `SenderID`, `ReceiverID`, `Subject`, `Content`, `SendDate`, `IsRead`, `CreatedAt`) VALUES
(193, '0', 'PH010', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(194, '0', 'PH011', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(195, '0', 'PH012', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(196, '0', 'PH013', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(197, '0', 'PH014', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(198, '0', 'PH015', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(199, '0', 'PH016', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(200, '0', 'PH017', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(201, '0', 'PH018', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(202, '0', 'PH019', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(203, '0', 'PH020', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(204, '0', 'PH021', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(205, '0', 'PH022', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(206, '0', 'PH023', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(207, '0', 'PH024', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(208, '0', 'PH025', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(209, '0', 'PH026', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(210, '0', 'PH027', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(211, '0', 'PH028', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(212, '0', 'PH029', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(213, '0', 'PH032', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 0, '2025-07-02 17:57:31'),
(214, '0', 'PH033', 'Mời tham gia các sự kiện khai giảng của trung tâm', 'Trung tâm trân trọng kính mời quý vị tham gia sự kiện khai giảng lớp tiếng anh thiếu nhi mới vào lúc 7h sáng ngày thử 7, 5/7/2025 tại Trung tâm anh ngữ KMA. Rất mong nhận được sự quan tâm và tham gia của quý vị.\r\nTrân trọng.', '2025-07-03 00:57:31', 1, '2025-07-02 17:57:31'),
(215, 'GV026', 'HV011', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(216, 'GV026', 'HV012', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(217, 'GV026', 'HV014', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(218, 'GV026', 'HV015', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(219, 'GV026', 'HV016', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(220, 'GV026', 'HV018', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(221, 'GV026', 'HV020', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(222, 'GV026', 'HV022', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(223, 'GV026', 'HV023', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(224, 'GV026', 'HV024', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(225, 'GV026', 'HV025', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(226, 'GV026', 'HV026', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(227, 'GV026', 'HV027', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(228, 'GV026', 'HV029', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(229, 'GV026', 'HV033', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 0, '2025-07-02 18:00:02'),
(230, 'GV026', 'HV057', 'Bài tập về nhà', 'Các em làm bài tập trang 10 giáo trình', '2025-07-03 01:00:02', 1, '2025-07-02 18:00:02'),
(231, 'GV026', 'HV011', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(232, 'GV026', 'HV012', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(233, 'GV026', 'HV014', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(234, 'GV026', 'HV015', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(235, 'GV026', 'HV016', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(236, 'GV026', 'HV018', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(237, 'GV026', 'HV020', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(238, 'GV026', 'HV022', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(239, 'GV026', 'HV023', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(240, 'GV026', 'HV024', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(241, 'GV026', 'HV025', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(242, 'GV026', 'HV026', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(243, 'GV026', 'HV027', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(244, 'GV026', 'HV029', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(245, 'GV026', 'HV033', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 0, '2025-07-02 18:00:37'),
(246, 'GV026', 'HV057', 'Kiểm tra', 'Chúng ta sẽ làm 1 bài kiểm tra năng lực vào buổi học tới, các em chuẩn bị ôn bài đầy đủ', '2025-07-03 01:00:37', 1, '2025-07-02 18:00:37'),
(247, 'GV026', 'HV011', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(248, 'GV026', 'HV012', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(249, 'GV026', 'HV014', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(250, 'GV026', 'HV015', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(251, 'GV026', 'HV016', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(252, 'GV026', 'HV018', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(253, 'GV026', 'HV020', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(254, 'GV026', 'HV022', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(255, 'GV026', 'HV023', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(256, 'GV026', 'HV024', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(257, 'GV026', 'HV025', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(258, 'GV026', 'HV026', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(259, 'GV026', 'HV027', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(260, 'GV026', 'HV029', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(261, 'GV026', 'HV033', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(262, 'GV026', 'HV057', 'Bài tập về nhà', 'Các em làm bài tập trang 15 SGK', '2025-07-03 01:01:01', 0, '2025-07-02 18:01:01'),
(263, 'GV026', 'HV011', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(264, 'GV026', 'HV012', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(265, 'GV026', 'HV014', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(266, 'GV026', 'HV015', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(267, 'GV026', 'HV016', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(268, 'GV026', 'HV018', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(269, 'GV026', 'HV020', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(270, 'GV026', 'HV022', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(271, 'GV026', 'HV023', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(272, 'GV026', 'HV024', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(273, 'GV026', 'HV025', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(274, 'GV026', 'HV026', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(275, 'GV026', 'HV027', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(276, 'GV026', 'HV029', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(277, 'GV026', 'HV033', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 0, '2025-07-02 18:03:12'),
(278, 'GV026', 'HV057', 'Nghỉ học', 'Các em nghỉ học tham gia sự kiện cắm trại 1 ngày với người ngoại quốc, mỗi em sẽ làm 1 bài luận kể lại câu chuyện của buổi cắm trại. Chúc các em có một buổi cắm trại vui vẻ', '2025-07-03 01:03:12', 1, '2025-07-02 18:03:12'),
(279, 'GV026', 'HV011', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(280, 'GV026', 'HV012', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(281, 'GV026', 'HV014', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(282, 'GV026', 'HV015', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(283, 'GV026', 'HV016', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(284, 'GV026', 'HV018', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(285, 'GV026', 'HV020', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(286, 'GV026', 'HV022', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(287, 'GV026', 'HV023', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(288, 'GV026', 'HV024', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(289, 'GV026', 'HV025', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(290, 'GV026', 'HV026', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(291, 'GV026', 'HV027', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(292, 'GV026', 'HV029', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(293, 'GV026', 'HV033', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(294, 'GV026', 'HV057', 'Bài tập về nhà', 'Các em viết bài luận 200 chữ về 1 ngày cắm trại với người ngoại quốc', '2025-07-03 01:03:50', 0, '2025-07-02 18:03:50'),
(295, 'GV026', 'HV011', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(296, 'GV026', 'HV012', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(297, 'GV026', 'HV014', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(298, 'GV026', 'HV015', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(299, 'GV026', 'HV016', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(300, 'GV026', 'HV018', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(301, 'GV026', 'HV020', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(302, 'GV026', 'HV022', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(303, 'GV026', 'HV023', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(304, 'GV026', 'HV024', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(305, 'GV026', 'HV025', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(306, 'GV026', 'HV026', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(307, 'GV026', 'HV027', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(308, 'GV026', 'HV029', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(309, 'GV026', 'HV033', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 0, '2025-07-02 18:05:56'),
(310, 'GV026', 'HV057', 'Khác', 'Chúng ta sẽ học bù online cho ngày chủ nhật vào tối thứ 7 tuần sau. Các em chủ động sắp xếp thời gian.', '2025-07-03 01:05:56', 1, '2025-07-02 18:05:56'),
(311, 'GV026', 'HV013', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(312, 'GV026', 'HV017', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(313, 'GV026', 'HV030', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(314, 'GV026', 'HV036', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(315, 'GV026', 'HV038', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(316, 'GV026', 'HV039', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(317, 'GV026', 'HV040', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(318, 'GV026', 'HV049', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(319, 'GV026', 'HV056', 'Bài tập về nhà', 'Các em tập giao tiếp chào hỏi bằng tiếng Anh với cha mẹ', '2025-07-03 01:06:57', 0, '2025-07-02 18:06:57'),
(320, 'GV026', 'HV013', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(321, 'GV026', 'HV017', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(322, 'GV026', 'HV030', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(323, 'GV026', 'HV036', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(324, 'GV026', 'HV038', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(325, 'GV026', 'HV039', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(326, 'GV026', 'HV040', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(327, 'GV026', 'HV049', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(328, 'GV026', 'HV056', 'Kiểm tra', 'Chúng ta sẽ kiểm tra giao tiếp phần chào hỏi vào buổi học tiếp theo, các em chủ động luyện tập.', '2025-07-03 01:07:49', 0, '2025-07-02 18:07:49'),
(329, 'GV026', 'HV013', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(330, 'GV026', 'HV017', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(331, 'GV026', 'HV030', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(332, 'GV026', 'HV036', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(333, 'GV026', 'HV038', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(334, 'GV026', 'HV039', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(335, 'GV026', 'HV040', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(336, 'GV026', 'HV049', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(337, 'GV026', 'HV056', 'Bài tập về nhà', 'Các em luyện tập giao tiếp phần hỏi thăm sức khỏe với cha mẹ.', '2025-07-03 01:09:31', 0, '2025-07-02 18:09:31'),
(354, 'GV026', 'HV013', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(355, 'GV026', 'HV017', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(356, 'GV026', 'HV030', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(357, 'GV026', 'HV036', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(358, 'GV026', 'HV038', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(359, 'GV026', 'HV039', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(360, 'GV026', 'HV040', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(361, 'GV026', 'HV049', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(362, 'GV026', 'HV056', 'Nghỉ học', 'Các em nghỉ học do trung tâm tổ chức sự kiện. Lớp ta sẽ học bù vào tuần sau', '2025-07-03 01:15:05', 0, '2025-07-02 18:15:05'),
(363, 'GV026', 'HV013', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(364, 'GV026', 'HV017', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(365, 'GV026', 'HV030', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(366, 'GV026', 'HV036', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(367, 'GV026', 'HV038', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(368, 'GV026', 'HV039', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(369, 'GV026', 'HV040', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(370, 'GV026', 'HV049', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(371, 'GV026', 'HV056', 'Bài tập về nhà', 'Các em tự tìm hiểu thêm và thực hành các mẫu câu hỏi thăm sức khỏe mới ở trang 10 sách giáo khoa.', '2025-07-03 01:16:39', 0, '2025-07-02 18:16:39'),
(372, 'GV026', 'HV013', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(373, 'GV026', 'HV017', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(374, 'GV026', 'HV030', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(375, 'GV026', 'HV036', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(376, 'GV026', 'HV038', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(377, 'GV026', 'HV039', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(378, 'GV026', 'HV040', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(379, 'GV026', 'HV049', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07'),
(380, 'GV026', 'HV056', 'Khác', 'Các em học bù vào 8h sáng chủ nhật tuần sau dưới hình thức online qua google meet. Các em chủ động vào học đúng giờ', '2025-07-03 01:18:07', 0, '2025-07-02 18:18:07');

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
('PH002', 'Nguyễn Văn Bình', 'Nữ', 'nguyenvanbinhph@email.com', '0912345678', '1975-03-20', 'nguyenvanbinh75', '2025-06-28 15:43:08', 0, 1),
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
('PH032', 'Hoàng Vũ Trúc Anh', 'Nữ', 'hvta@gmail.com', '0987564321', '2025-06-23', '1111', '2025-07-02 13:43:53', 0, 1),
('PH033', 'Nguyễn Tuấn Dũng', 'Nam', 'ntd@gmail.com', '0987654321', '2004-11-14', '2222', '2025-07-02 15:07:05', 0, 0);

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
(2, 'HV036', 'PH018', 1200000, 'Học phí lớp Lớp Luyện Thi TOEIC 850+ - 06/2025 - Đỗ Văn Mạnh - Nộp 1200000 VNĐ', '2025-06-28', '2025-06-28 16:25:36'),
(3, 'HV057', 'PH032', 600000, 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025 - Nguyễn Thị Thanh Thư - Nộp 600000 VNĐ', '2025-07-02', '2025-07-02 18:39:16'),
(4, 'HV056', 'PH033', 500000, 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025 - Hoàng Đình Nam - Nộp 500000 VNĐ', '2025-07-02', '2025-07-02 18:40:11'),
(5, 'HV057', 'PH033', 2000000, 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025 - Nguyễn Thị Thanh Thư - Nộp 2000000 VNĐ', '2025-07-02', '2025-07-02 18:40:39'),
(6, 'HV056', 'PH032', 500000, 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025 - Hoàng Đình Nam - Nộp 500000 VNĐ', '2025-07-02', '2025-07-02 18:41:24');

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
('HV011', 'Vũ Thị Phương', 'Nữ', 'vuthiphuong@email.com', '0901234572', '2010-09-12', 8, 0, 0, '2025-06-28 15:40:05'),
('HV012', 'Đỗ Minh Giang', 'Nam', 'dominhhgiang@email.com', '0901234573', '2011-04-25', 8, 0, 0, '2025-06-28 15:40:05'),
('HV013', 'Bùi Thị Hạnh', 'Nữ', 'buithihanh@email.com', '0901234574', '2009-12-03', 13, 0, 0, '2025-06-28 15:40:05'),
('HV014', 'Ngô Văn Ích', 'Nam', 'ngovanic@email.com', '0901234575', '2008-08-17', 8, 0, 0, '2025-06-28 15:40:05'),
('HV015', 'Lý Thị Khánh', 'Nữ', 'lythikhanh@email.com', '0901234576', '2007-01-28', 8, 0, 0, '2025-06-28 15:40:05'),
('HV016', 'Đinh Văn Lâm', 'Nam', 'dinhvanlam@email.com', '0901234577', '2008-05-11', 8, 0, 0, '2025-06-28 15:40:05'),
('HV017', 'Võ Thị Mai', 'Nữ', 'vothimai@email.com', '0901234578', '2014-02-04', 13, 0, 0, '2025-06-28 15:40:05'),
('HV018', 'Đặng Văn Nam', 'Nam', 'dangvannam@email.com', '0901234579', '2008-03-07', 8, 0, 0, '2025-06-28 15:40:05'),
('HV019', 'Tạ Thị Oanh', 'Nữ', 'tathioanh@email.com', '0901234580', '2007-07-15', 7, 0, 0, '2025-06-28 15:40:05'),
('HV020', 'Chu Văn Phúc', 'Nam', 'chuvanphuc@email.com', '0901234581', '2009-12-23', 8, 0, 0, '2025-06-28 15:40:05'),
('HV021', 'Dương Thị Quỳnh', 'Nữ', 'duongthiquynh@email.com', '0901234582', '2007-02-18', 7, 0, 0, '2025-06-28 15:40:05'),
('HV022', 'Mai Văn Rồng', 'Nam', 'maivanrong@email.com', '0901234583', '2006-09-05', 8, 0, 0, '2025-06-28 15:40:05'),
('HV023', 'Lưu Thị Sáng', 'Nữ', 'luuthisang@email.com', '0901234584', '2005-12-12', 8, 0, 0, '2025-06-28 15:40:05'),
('HV024', 'Phan Văn Tài', 'Nam', 'phanvantai@email.com', '0901234585', '2006-04-09', 8, 0, 0, '2025-06-28 15:40:05'),
('HV025', 'Trịnh Thị Uyên', 'Nữ', 'trinhthiuyen@email.com', '0901234586', '2005-08-26', 8, 0, 0, '2025-06-28 15:40:05'),
('HV026', 'Lương Văn Việt', 'Nam', 'luongvanviet@email.com', '0901234587', '2006-06-14', 8, 0, 0, '2025-06-28 15:40:05'),
('HV027', 'Hồ Thị Xuân', 'Nữ', 'hothixuan@email.com', '0901234588', '2005-10-31', 8, 0, 0, '2025-06-28 15:40:05'),
('HV028', 'Cao Văn Yên', 'Nam', 'caovanyen@email.com', '0901234589', '2006-02-28', 9, 0, 0, '2025-06-28 15:40:05'),
('HV029', 'Kiều Thị Ý', 'Nữ', 'kieuthiy@email.com', '0901234590', '2013-10-30', 8, 0, 0, '2025-06-28 15:40:05'),
('HV030', 'Trương Văn Ấn', 'Nam', 'truongvanan@email.com', '0901234591', '2012-09-17', 13, 0, 0, '2025-06-28 15:40:05'),
('HV031', 'Nguyễn Thị Ấm', 'Nữ', 'nguyenthiam@email.com', '0901234592', '2003-11-15', 10, 0, 0, '2025-06-28 15:40:05'),
('HV032', 'Lê Văn Đức', 'Nam', 'levanduc@email.com', '0901234593', '2004-05-22', 10, 0, 0, '2025-06-28 15:40:05'),
('HV033', 'Phạm Thị Nga', 'Nữ', 'phamthinga@email.com', '0901234594', '2003-09-18', 8, 0, 0, '2025-06-28 15:40:05'),
('HV034', 'Hoàng Văn Hùng', 'Nam', 'hoangvanhung@email.com', '0901234595', '2004-01-25', 11, 0, 0, '2025-06-28 15:40:05'),
('HV035', 'Vũ Thị Linh', 'Nữ', 'vuthilinh@email.com', '0901234596', '2003-06-30', 11, 0, 0, '2025-06-28 15:40:05'),
('HV036', 'Đỗ Văn Mạnh', 'Nam', 'dovanmanh@email.com', '0901234597', '2014-03-10', 13, 0, 0, '2025-06-28 15:40:05'),
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
('HV049', 'Trịnh Thị Cúc', 'Nữ', 'trinhthicuc@email.com', '0901234610', '2013-04-02', 13, 0, 0, '2025-06-28 15:40:05'),
('HV056', 'Hoàng Đình Nam', 'Nam', 'nam@gmail.com', '111111111', '2015-06-03', 13, 0, 0, '2025-07-02 15:08:42'),
('HV057', 'Nguyễn Thị Thanh Thư', 'Nữ', 'thu@gmail.com', '00000000', '2006-08-17', 8, 0, 0, '2025-07-02 15:10:29');

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
(144, 'HV019', 'PH008', '2025-06-28 15:46:44'),
(146, 'HV021', 'PH009', '2025-06-28 15:46:44'),
(148, 'HV023', 'PH010', '2025-06-28 15:46:44'),
(149, 'HV024', 'PH011', '2025-06-28 15:46:44'),
(153, 'HV028', 'PH013', '2025-06-28 15:46:44'),
(156, 'HV031', 'PH014', '2025-06-28 15:46:44'),
(157, 'HV032', 'PH015', '2025-06-28 15:46:44'),
(159, 'HV034', 'PH016', '2025-06-28 15:46:44'),
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
(188, 'HV056', 'PH032', '2025-07-02 15:08:59'),
(189, 'HV056', 'PH033', '2025-07-02 15:08:59'),
(190, 'HV057', 'PH032', '2025-07-02 15:10:29'),
(191, 'HV057', 'PH033', '2025-07-02 15:10:29'),
(192, 'HV011', 'PH004', '2025-07-02 16:27:57'),
(193, 'HV012', 'PH005', '2025-07-02 16:28:21'),
(194, 'HV018', 'PH008', '2025-07-02 16:28:35'),
(195, 'HV022', 'PH010', '2025-07-02 16:28:44'),
(196, 'HV029', 'PH013', '2025-07-02 16:29:29'),
(197, 'HV030', 'PH014', '2025-07-02 16:29:53'),
(198, 'HV036', 'PH017', '2025-07-02 16:30:21'),
(199, 'HV036', 'PH018', '2025-07-02 16:30:21'),
(200, 'HV020', 'PH009', '2025-07-02 16:31:12'),
(201, 'HV026', 'PH012', '2025-07-02 16:34:20'),
(202, 'HV025', 'PH011', '2025-07-02 16:34:31'),
(203, 'HV027', 'PH012', '2025-07-02 16:34:43'),
(204, 'HV033', 'PH016', '2025-07-02 16:35:01'),
(205, 'HV013', 'PH005', '2025-07-02 16:42:57'),
(206, 'HV014', 'PH006', '2025-07-02 16:43:09'),
(207, 'HV015', 'PH006', '2025-07-02 16:43:28'),
(208, 'HV016', 'PH007', '2025-07-02 16:43:40'),
(209, 'HV017', 'PH007', '2025-07-02 16:44:43');

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
('GV002', 'Nguyễn Thị Lan', 'Nam', 'gv002@email.com', '0123456781', '1985-03-15', 8000000, '2025-06-28 15:32:53'),
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
('GV020', 'Phan Thị Yến', 'Nữ', 'gv020@email.com', '0123456799', '1991-04-09', 7800000, '2025-06-28 15:32:53'),
('GV026', 'Nguyễn Thu Hương', 'Nữ', 'teacher@gmail.com', '0987654433', '1994-06-15', 3000000, '2025-07-02 15:13:05');

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
(12, 'GV026', 13, '2025-07-01', 'Đã dạy', 'Học hỏi thăm chào hỏi', '2025-07-02 18:23:42'),
(15, 'GV026', 13, '2025-07-03', 'Đã dạy', 'Học hỏi thăm sức khỏe', '2025-07-02 18:24:45'),
(16, 'GV026', 8, '2025-07-05', 'Đã dạy', '', '2025-07-02 18:25:05'),
(19, 'GV026', 8, '2025-07-06', 'Nghỉ', 'Tham gia cắm trại với người ngoại quốc', '2025-07-02 18:26:34'),
(20, 'GV026', 13, '2025-07-05', 'Dời lịch', 'Trung tâm tổ chức sự kiện', '2025-07-02 18:27:22');

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
(68, 'HV019', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(70, 'HV021', 3500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 5.5+ - 06/2025', '2025-06-28 15:40:05'),
(71, 'HV022', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(72, 'HV023', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(73, 'HV024', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(74, 'HV025', 4000000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 06/2025', '2025-06-28 15:40:05'),
(77, 'HV028', 4500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 7.0+ - 06/2025', '2025-06-28 15:40:05'),
(80, 'HV031', 2500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 450+ - 06/2025', '2025-06-28 15:40:05'),
(81, 'HV032', 2500000, 0.00, NULL, '2025-06-30', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi TOEIC 450+ - 06/2025', '2025-06-28 15:40:05'),
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
(105, 'HV056', 1500000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 15:08:42'),
(106, 'HV057', 4000000, 10.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 15:10:29'),
(107, 'HV011', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:27:57'),
(108, 'HV012', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:28:21'),
(109, 'HV018', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:28:35'),
(110, 'HV029', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:29:29'),
(111, 'HV030', 1500000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 16:29:53'),
(112, 'HV036', 1500000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 16:30:21'),
(113, 'HV020', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:31:12'),
(114, 'HV026', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:34:20'),
(115, 'HV027', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:34:43'),
(116, 'HV033', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:35:01'),
(117, 'HV049', 1500000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 16:36:42'),
(118, 'HV013', 1500000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 16:42:57'),
(119, 'HV014', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:43:09'),
(120, 'HV015', 4000000, 0.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:43:28'),
(121, 'HV016', 4000000, 5.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Luyện Thi IELTS 6.5+ - 07/2025', '2025-07-02 16:43:40'),
(122, 'HV017', 1500000, 10.00, NULL, '2025-07-12', 'Chưa đóng', 'Học phí lớp Lớp Tiếng Anh Thiếu Nhi Starter - 07/2025', '2025-07-02 16:44:43');

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
('GV026', 'teacher', '$2y$10$KWvR8yyRhdoJIftGaP7hf.W/ipopm9RBgxDt50Wk9pIr5mTV3hfwu', 1, '2025-07-02 15:13:05'),
('HV001', 'student01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV002', 'student02', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV003', 'student03', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV004', 'student04', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV005', 'student05', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
('HV006', 'student06', '$2y$10$.ZqGMsdd.7IjJJlJDmH5R./VgOyYQUJ7E1bjam2BJ/Y0sYCsJ/62y', 2, '2025-06-28 15:29:46'),
('HV007', 'student07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, '2025-06-28 15:29:46'),
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
('HV056', 'student_second', '$2y$10$FGbs6KzoihtVGT7ri9KXjuhL2dGCXr.fqsucmN2OF7iLMaFmq3rOy', 2, '2025-07-02 15:08:42'),
('HV057', 'student', '$2y$10$LMKw.PIfzj5xKT5pIIN.AucZvBknpMkLlSBhwwS7Rt82U8EMUi8iG', 2, '2025-07-02 15:10:29'),
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
('PH030', 'djjfjk', '$2y$10$PLAxUfnW2wxOCGJFaIJ6TOy8d3Trkee1XqGj5d1lL4G6BHu18LAEa', 3, '2025-06-29 08:25:22'),
('PH032', 'parent1', '$2y$10$GWhuEpX7VJhGKAZox5IxSOb0cMmpprjxSyGUx206eGMP64N5/p7he', 3, '2025-07-02 13:43:53'),
('PH033', 'parent', '$2y$10$9Q1UJsUqOEjoWCvXHnSzK.JBppXjdEmH.7uY8ZHB6DesOmeBIaGvK', 3, '2025-07-02 15:07:05');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT cho bảng `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `attendance`
--
ALTER TABLE `attendance`
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT cho bảng `classes`
--
ALTER TABLE `classes`
  MODIFY `ClassID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT cho bảng `consulting`
--
ALTER TABLE `consulting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `homework`
--
ALTER TABLE `homework`
  MODIFY `HomeworkID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `messages`
--
ALTER TABLE `messages`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=381;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `payment_history`
--
ALTER TABLE `payment_history`
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `student_parent_keys`
--
ALTER TABLE `student_parent_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- AUTO_INCREMENT cho bảng `teaching_sessions`
--
ALTER TABLE `teaching_sessions`
  MODIFY `SessionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `tuition`
--
ALTER TABLE `tuition`
  MODIFY `TuitionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

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
