<?php
require_once '../model/config.php';
$data = json_decode(file_get_contents('php://input'), true);

$messageId = $data['messageId'] ?? 0;
if (!$messageId) {
    echo json_encode(['success' => false, 'message' => 'Thiếu messageId']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("UPDATE messages SET IsRead = 1 WHERE MessageID = ?");
$stmt->execute([$messageId]);
echo json_encode(['success' => true]);