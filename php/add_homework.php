<?php
require_once '../model/config.php';
$data = json_decode(file_get_contents('php://input'), true);

$classId = $data['classId'] ?? '';
$title = $data['title'] ?? '';
$description = $data['description'] ?? '';
$dueDate = $data['duedate'] ?? $data['deadline'] ?? null; // nhận cả duedate hoặc deadline từ JS

if (!$classId || !$title) {
    echo json_encode(['success' => false, 'message' => 'Thiếu dữ liệu']);
    exit;
}

$conn = connectdb();
$stmt = $conn->prepare("INSERT INTO homework (ClassID, Title, Description, DueDate, Status) VALUES (?, ?, ?, ?, 'Chưa hoàn thành')");
$stmt->execute([$classId, $title, $description, $dueDate]);
echo json_encode(['success' => true]);