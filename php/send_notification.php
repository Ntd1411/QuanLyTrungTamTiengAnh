<?php
require_once '../model/config.php';
session_start();

$username = $_SESSION['username'] ?? $_COOKIE['username'] ?? '';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$type = $data['type'] ?? '';
$content = $data['content'] ?? '';

if (!$username || !$classId || !$type || !$content) {
    echo json_encode(['success' => false, 'message' => 'Thiếu dữ liệu']);
    exit;
}

$conn = connectdb();

// Lấy mã giáo viên (UserID) từ username
$stmt = $conn->prepare("
    SELECT t.UserID 
    FROM teachers t 
    JOIN users u ON t.UserID = u.UserID 
    WHERE u.Username = ?
");
$stmt->execute([$username]);
$teacher = $stmt->fetch(PDO::FETCH_ASSOC);
$teacherId = $teacher['UserID'] ?? '';

if (!$teacherId) {
    echo json_encode(['success' => false, 'message' => 'Không tìm thấy mã giáo viên']);
    exit;
}

// Lấy danh sách học sinh trong lớp
$stmt = $conn->prepare("SELECT UserID FROM students WHERE ClassID = ?");
$stmt->execute([$classId]);
$students = $stmt->fetchAll(PDO::FETCH_COLUMN);

if (!$students) {
    echo json_encode(['success' => false, 'message' => 'Không có học sinh trong lớp này']);
    exit;
}

// Gửi thông báo cho từng học sinh
foreach ($students as $studentId) {
    $stmt = $conn->prepare("INSERT INTO messages (SenderID, ReceiverID, Subject, Content, SendDate) VALUES (?, ?, ?, ?, NOW())");
    $stmt->execute([$teacherId, $studentId, $type, $content]);
}

echo json_encode(['success' => true]);