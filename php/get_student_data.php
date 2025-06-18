<?php
session_start();
require_once '../model/config.php';

$username = null;
if (isset($_SESSION['username'])) {
    $username = $_SESSION['username'];
} elseif (isset($_COOKIE['username'])) {
    $username = $_COOKIE['username'];
}

if (!$username) {
    http_response_code(401);
    echo json_encode(['error' => 'Chưa đăng nhập']);
    exit;
}

$conn = connectdb(); // PDO

// Lấy thông tin học sinh
$sql = "SELECT s.UserID, s.FullName, s.Email, s.Phone, s.ClassID, c.ClassName, t.FullName AS TeacherName, c.ClassTime
        FROM students s
        JOIN users u ON s.UserID = u.UserID
        LEFT JOIN classes c ON s.ClassID = c.ClassID
        LEFT JOIN teachers t ON c.TeacherID = t.UserID
        WHERE u.Username = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$username]);
$student = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$student) {
    http_response_code(404);
    echo json_encode(['error' => 'Không tìm thấy học sinh']);
    exit;
}

// Lấy danh sách bạn cùng lớp
$classmates = [];
if ($student['ClassID']) {
    $sql = "SELECT FullName FROM students WHERE ClassID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$student['ClassID']]);
    $classmates = $stmt->fetchAll(PDO::FETCH_COLUMN);
}

// Lấy điểm danh
$sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND Status = 'present'";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$attended = (int)$stmt->fetchColumn();

$sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND Status = 'absent'";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$absent = (int)$stmt->fetchColumn();

$sql = "SELECT AttendanceDate AS Date, Status, Note FROM attendance WHERE StudentID = ? ORDER BY AttendanceDate DESC LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$history = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy bài tập
$sql = "SELECT HomeworkID AS id, Title AS title, Description AS description, DueDate AS dueDate, Status AS status
        FROM homework WHERE StudentID = ? ORDER BY DueDate DESC";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$homework = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Trả về JSON
echo json_encode([
    'id' => $student['UserID'],
    'name' => $student['FullName'],
    'email' => $student['Email'],
    'phone' => $student['Phone'],
    'class' => [
        'id' => $student['ClassID'],
        'name' => $student['ClassName'],
        'teacher' => $student['TeacherName'],
        'schedule' => $student['ClassTime'],
        'classmates' => $classmates
    ],
    'attendance' => [
        'attended' => $attended,
        'absent' => $absent,
        'history' => $history
    ],
    'homework' => $homework
]);
?>