<?php
session_start();
require_once '../model/config.php';

$data = json_decode(file_get_contents('php://input'), true);
$parentID = $_SESSION['id'] ?? $_COOKIE['id'] ?? null;
$studentID = $data['studentId'] ?? '';
$amount = isset($data['amount']) ? floatval($data['amount']) : 0;
$note = $data['note'] ?? '';
$paymentDate = date('Y-m-d');

if (empty($parentID) || empty($studentID) || $amount <= 0) {
    echo json_encode(['success' => false, 'error' => 'Thiếu thông tin']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("INSERT INTO payment_history (parentID, studentID, paidAmount, note, paymentDate) VALUES (?, ?, ?, ?, ?)");
$success = $stmt->execute([$parentID, $studentID, $amount, $note, $paymentDate]);

// Sau khi nộp tiền, kiểm tra tổng đã nộp
if ($success) {
    // Lấy tổng học phí phải nộp (đã trừ giảm giá)
    $stmt = $conn->prepare("SELECT SUM(Amount - Amount * Discount / 100) FROM tuition WHERE StudentID = ?");
    $stmt->execute([$studentID]);
    $totalFee = floatval($stmt->fetchColumn());

    // Lấy tổng đã nộp của tất cả phụ huynh cho học sinh này
    $stmt = $conn->prepare("SELECT SUM(paidAmount) FROM payment_history WHERE studentID = ?");
    $stmt->execute([$studentID]);
    $totalPaid = floatval($stmt->fetchColumn());

    // Nếu đã nộp đủ hoặc thừa, cập nhật trạng thái tuition thành 'Đã đóng'
    if ($totalPaid >= $totalFee && $totalFee > 0) {
        $stmt = $conn->prepare("UPDATE tuition SET Status = 'Đã đóng', PaymentDate = ? WHERE StudentID = ?");
        $stmt->execute([$paymentDate, $studentID]);
    }
}

echo json_encode(['success' => $success]);