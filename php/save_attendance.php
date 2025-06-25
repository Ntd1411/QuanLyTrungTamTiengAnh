<?php
require_once '../model/config.php';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$date = $data['date'] ?? '';
$attendanceData = $data['attendanceData'] ?? [];

if (!$classId || !$date || !is_array($attendanceData)) {
    echo json_encode(['success' => false, 'message' => 'Thiếu dữ liệu']);
    exit;
}

$conn = connectdb();

foreach ($attendanceData as $row) {
    $studentId = $row['studentId'];
    $status = $row['status'];
    $note = $row['note'];

    // Xóa điểm danh cũ nếu có (đảm bảo mỗi học sinh 1 bản ghi/ngày/lớp)
    $stmt = $conn->prepare("DELETE FROM attendance WHERE StudentID = ? AND ClassID = ? AND AttendanceDate = ?");
    $stmt->execute([$studentId, $classId, $date]);

    // Thêm bản ghi mới
    $stmt = $conn->prepare("INSERT INTO attendance (StudentID, ClassID, AttendanceDate, Status, Note) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$studentId, $classId, $date, $status, $note]);
}

echo json_encode(['success' => true]);
?>