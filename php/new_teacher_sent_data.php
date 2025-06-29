<?php
session_start();
require_once '../model/config.php';

$data = json_decode(file_get_contents('php://input'), true);
$teacherId = $data['senderId'] ?? '';

if(!$teacherId) {
    echo json_encode(['error' => 'Thiếu mã giáo viên']);
    exit;
}

$conn = connectdb();
$sql = "
    SELECT DISTINCT m.SendDate AS SentAt, c.ClassName, c.SchoolYear, c.Room, m.Subject AS Type, m.Content
    FROM messages m
    JOIN students s ON m.ReceiverID = s.UserID
    JOIN classes c ON s.ClassID = c.ClassID
    WHERE m.SenderID = ?
    ORDER BY m.SendDate DESC
";
$stmt = $conn->prepare($sql);
$stmt->execute([$teacherId]);
$notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode(['success' => true, 'notifications' => $notifications]);
?>