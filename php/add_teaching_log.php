<?php
require_once '../model/config.php';
session_start();

$username = $_SESSION['username'] ?? $_COOKIE['username'] ?? '';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$status = $data['status'] ?? '';
$note = $data['note'] ?? '';
$date = $data['date'] ?? date('Y-m-d');

if (!$username || !$classId || !$status) {
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

$stmt = $conn->prepare("INSERT INTO teaching_sessions (TeacherID, ClassID, SessionDate, Status, Note) VALUES (?, ?, ?, ?, ?)");
$stmt->execute([$teacherId, $classId, $date, $status, $note]);
echo json_encode(['success' => true]);