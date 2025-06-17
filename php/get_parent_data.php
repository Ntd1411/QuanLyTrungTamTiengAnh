<?php
session_start();
require_once '../model/config.php'; // Kết nối DB

$username = null;
if (isset($_SESSION['username'])) {
    $username = $_SESSION['username'];
} elseif (isset($_COOKIE['username'])) {
    $username = $_COOKIE['username'];
}

if (!$username) {
    http_response_code(401);
    echo json_encode(['error' => 'Chưa đăng nhập']);
    exit;
}

// Kết nối PDO
$conn = connectdb(); // Hàm này phải trả về PDO object

// Lấy thông tin phụ huynh
$sql = "SELECT p.UserID, p.FullName, p.Email, p.Phone, p.ZaloID, p.UnpaidAmount
        FROM parents p
        JOIN users u ON p.UserID = u.UserID
        WHERE u.Username = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$username]);
$parent = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$parent) {
    http_response_code(404);
    echo json_encode(['error' => 'Không tìm thấy phụ huynh']);
    exit;
}

// Lấy danh sách con
$sql = "SELECT s.UserID, s.FullName, c.ClassName, s.AttendedClasses, s.AbsentClasses, t.FullName AS TeacherName
        FROM students s
        LEFT JOIN classes c ON s.ClassID = c.ClassID
        LEFT JOIN teachers t ON c.TeacherID = t.UserID
        WHERE s.ParentID = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$parent['UserID']]);
$children = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy học phí từng con
$childrenData = [];
foreach ($children as $child) {
    $sql = "SELECT SUM(Amount) AS fee, SUM(CASE WHEN Status='Đã đóng' THEN Amount ELSE 0 END) AS paid
            FROM tuition WHERE StudentID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID']]);
    $feeData = $stmt->fetch(PDO::FETCH_ASSOC);

    $childrenData[] = [
        'id' => $child['UserID'],
        'name' => $child['FullName'],
        'class' => $child['ClassName'],
        'attended' => $child['AttendedClasses'],
        'absent' => $child['AbsentClasses'],
        'teacher' => $child['TeacherName'],
        'fee' => (int)($feeData['fee'] ?? 0),
        'paid' => (int)($feeData['paid'] ?? 0)
    ];
}

// Lấy tin nhắn
$sql = "SELECT m.MessageID AS id, u.Username AS `from`, m.Subject AS subject, m.Content AS content, DATE(m.SendDate) AS date, m.IsRead AS `read`
        FROM messages m
        JOIN users u ON m.SenderID = u.UserID
        WHERE m.ReceiverID = ?
        ORDER BY m.SendDate DESC";
$stmt = $conn->prepare($sql);
$stmt->execute([$parent['UserID']]);
$messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Trả về JSON
echo json_encode([
    'id' => $parent['UserID'],
    'name' => $parent['FullName'],
    'email' => $parent['Email'],
    'phone' => $parent['Phone'],
    'zalo' => $parent['ZaloID'],
    'unpaid' => $parent['UnpaidAmount'],
    'children' => $childrenData,
    'messages' => $messages
]);
?>