<?php
session_start();
require_once '../model/config.php';

$data = json_decode(file_get_contents('php://input'), true);
if (!$data) {
    echo json_encode(['error' => 'Dữ liệu không hợp lệ']);
    exit;
}

$studentId = $data['studentId'] ?? '';
$bank = $data['bank'] ?? '';
$amount = $data['amount'] ?? 0;
$note = $data['note'] ?? '';

if (!$studentId || !$bank || !$amount) {
    echo json_encode(['error' => 'Thiếu thông tin']);
    exit;
}

$conn = connectdb();

// Tìm bản ghi học phí chưa đóng đúng số tiền thực đã giảm giá
$sql = "SELECT TuitionID, Amount, Discount FROM tuition 
        WHERE StudentID = ? 
        AND Status = 'Chưa đóng'
        AND ABS(Amount * (100 - Discount) / 100 - ?) < 1
        ORDER BY DueDate ASC LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->execute([$studentId, $amount]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if ($row) {
    // Cập nhật trạng thái thành Đã đóng
    $sql = "UPDATE tuition SET Status = 'Đã đóng', PaymentDate = NOW(), Note = ? WHERE TuitionID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$note, $row['TuitionID']]);
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => 'Không tìm thấy khoản học phí phù hợp để đóng!']);
}
