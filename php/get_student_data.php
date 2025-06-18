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
    $sql = "SELECT s.UserID, s.FullName,
                (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID AND (a.Status = 'Có mặt' OR a.Status = 'Đi muộn')) AS attended,
                (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID AND a.Status = 'Vắng mặt') AS absent,
                (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID) AS total
            FROM students s
            WHERE s.ClassID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$student['ClassID']]);
    $classmates = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Tính tỉ lệ tham gia cho từng bạn
    foreach ($classmates as &$mate) {
        $total = isset($mate['total']) && is_numeric($mate['total']) ? (int)$mate['total'] : 0;
        $attended = isset($mate['attended']) && is_numeric($mate['attended']) ? (int)$mate['attended'] : 0;
        $mate['participation'] = $total > 0 ? round($attended * 100 / $total, 1) : 0;
    }
    unset($mate);
}

// Lấy điểm danh của học sinh đang đăng nhập
$sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND (Status = 'Có mặt' OR Status = 'Đi muộn')";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$attended = (int)$stmt->fetchColumn();

$sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND Status = 'Vắng mặt'";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$absent = (int)$stmt->fetchColumn();

$sql = "SELECT AttendanceDate AS Date, Status, Note FROM attendance WHERE StudentID = ? ORDER BY AttendanceDate DESC LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['UserID']]);
$history = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy bài tập cho học sinh theo ClassID
$sql = "SELECT HomeworkID AS id, Title AS title, Description AS description, DueDate AS dueDate, Status AS status
        FROM homework WHERE ClassID = ? ORDER BY DueDate DESC";
$stmt = $conn->prepare($sql);
$stmt->execute([$student['ClassID']]);
$homework = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Trả về JSON đầy đủ
echo json_encode([
    'name' => $student['FullName'],
    'email' => $student['Email'],
    'phone' => $student['Phone'],
    'class' => [
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
