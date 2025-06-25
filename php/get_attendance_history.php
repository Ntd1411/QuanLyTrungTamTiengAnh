<?php
require_once '../model/config.php';
$classId = $_GET['classId'] ?? '';
$date = $_GET['date'] ?? '';
if (!$classId || !$date) {
    echo json_encode([]);
    exit;
}
$conn = connectdb();
$stmt = $conn->prepare("
    SELECT s.FullName, a.Status, a.Note, a.StudentID
    FROM attendance a
    JOIN students s ON a.StudentID = s.UserID
    WHERE a.ClassID = ? AND a.AttendanceDate = ?
    ORDER BY s.FullName
");
$stmt->execute([$classId, $date]);
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>