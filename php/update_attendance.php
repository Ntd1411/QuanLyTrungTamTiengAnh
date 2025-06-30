<?php
require_once '../model/config.php';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$date = $data['date'] ?? '';
$studentId = $data['studentId'] ?? '';
$status = $data['status'] ?? '';
$note = $data['note'] ?? '';

if (!$classId || !$date || !$studentId) {
    echo json_encode(['success' => false, 'message' => 'Thiếu dữ liệu']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("UPDATE attendance SET Status = ?, Note = ? WHERE StudentID = ? AND ClassID = ? AND AttendanceDate = ?");
$stmt->execute([$status, $note, $studentId, $classId, $date]);
$updated = $stmt->rowCount();

echo json_encode(['success' => $updated > 0, 'updated' => $updated]);