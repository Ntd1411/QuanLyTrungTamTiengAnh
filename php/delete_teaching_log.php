<?php
session_start();
require_once '../model/config.php';

$data = json_decode(file_get_contents('php://input'), true);
$sessionId = $data['logId'] ?? '';

if (!$sessionId) {
    echo json_encode(['success' => false, 'message' => 'Thiếu mã nhật ký']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("DELETE FROM teaching_sessions WHERE SessionID = ?");
$success = $stmt->execute([$sessionId]);
echo json_encode(['success' => $success]);