<?php
require_once '../model/config.php';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$date = $data['date'] ?? '';
$studentId = $data['studentId'] ?? '';

if (!$classId || !$date || !$studentId) {
    echo json_encode(['success' => false, 'message' => 'Thiếu dữ liệu']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("DELETE FROM attendance WHERE StudentID = ? AND ClassID = ? AND AttendanceDate = ?");
$stmt->execute([$studentId, $classId, $date]);
$deleted = $stmt->rowCount();

echo json_encode(['success' => $deleted > 0, 'deleted' => $deleted]);