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
$sql = "SELECT p.UserID, p.FullName, p.Email, p.Phone, p.ZaloID, p.UnpaidAmount, p.isShowTeacher, u.Username, u.Role
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
$sql = "SELECT 
    s.UserID, 
    s.FullName, 
    s.ClassID, 
    c.ClassName,
    CASE 
        WHEN ? = 1 THEN 
            CONCAT_WS(' - ', t.FullName, t.Phone) 
        ELSE 
            'không có thông tin giáo viên'
    END AS TeacherName
FROM 
    student_parent_keys spk
JOIN 
    students s ON spk.student_id = s.UserID
LEFT JOIN 
    classes c ON s.ClassID = c.ClassID
LEFT JOIN 
    teachers t ON c.TeacherID = t.UserID
WHERE 
    spk.parent_id = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$parent['isShowTeacher'], $parent['UserID']]);
$children = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy học phí từng con
$childrenData = [];
foreach ($children as $child) {
    // Tổng học phí
    $sql = "SELECT 
            SUM(Amount) AS fee, 
            SUM(Amount * (Discount/100)) AS discount
        FROM tuition WHERE StudentID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID']]);
    $feeData = $stmt->fetch(PDO::FETCH_ASSOC);

    // Tổng đã đóng của tất cả phụ huynh liên kết với học sinh này
    $sql = "SELECT SUM(paidAmount) AS paid
            FROM payment_history
            WHERE studentID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID']]);
    $paid = (int)($stmt->fetchColumn() ?: 0);

    // Lấy Note của khoản học phí chưa đóng gần nhất
    $sql = "SELECT Note FROM tuition WHERE StudentID = ? AND Status = 'Chưa đóng' ORDER BY DueDate ASC LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID']]);
    $noteRow = $stmt->fetch(PDO::FETCH_ASSOC);
    $note = $noteRow ? $noteRow['Note'] : '';

    // Lấy lịch sử đóng học phí cho từng con
    $sql = "SELECT ph.paymentDate AS PaymentDate, ph.paidAmount AS Amount, ph.note AS Note, p.FullName AS Payer
        FROM payment_history ph
        JOIN parents p ON ph.parentID = p.UserID
        WHERE ph.studentID = ?
        ORDER BY ph.paymentDate DESC";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID']]);
    $paymentHistory = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Đếm số buổi học trong lớp hiện tại
    $sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND ClassID = ? AND (Status = 'Có mặt' OR Status = 'Đi muộn')";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID'], $child['ClassID']]);
    $attended = (int)$stmt->fetchColumn();

    // Đếm số buổi nghỉ trong lớp hiện tại
    $sql = "SELECT COUNT(*) FROM attendance WHERE StudentID = ? AND ClassID = ? AND Status = 'Vắng mặt'";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$child['UserID'], $child['ClassID']]);
    $absent = (int)$stmt->fetchColumn();

    $childrenData[] = [
        'id' => $child['UserID'],
        'name' => $child['FullName'],
        'class' => $child['ClassName'],
        'attended' => $attended,
        'absent' => $absent,
        'teacher' => $child['TeacherName'],
        'fee' => (int)($feeData['fee'] ?? 0),
        'paid' => $paid,
        'discount' => (int)($feeData['discount'] ?? 0),
        'paymentHistory' => $paymentHistory,
        'note' => $note
    ];
}

// Đếm số lượng con
$numChildren = count($childrenData);

// Lấy tin nhắn
$sql = "SELECT m.MessageID AS id, u.Username AS `from`, m.Subject AS subject, m.Content AS content, DATE(m.SendDate) AS date, m.IsRead AS `read`
        FROM messages m
        JOIN users u ON m.SenderID = u.UserID
        WHERE m.ReceiverID = ?
        ORDER BY m.SendDate DESC";
$stmt = $conn->prepare($sql);
$stmt->execute([$parent['UserID']]);
$messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Tính tổng học phí chưa đóng của tất cả các con
$totalUnpaid = 0;
foreach ($childrenData as $child) {
    $totalUnpaid += $child['fee'] - $child['paid'] - $child['discount'];
}

// Trả về JSON
echo json_encode([
    'id' => $parent['UserID'],
    'name' => $parent['FullName'],
    'email' => $parent['Email'],
    'phone' => $parent['Phone'],
    'zalo' => $parent['ZaloID'],
    'unpaid' => $totalUnpaid,
    'numChildren' => $numChildren,
    'children' => $childrenData,
    'messages' => $messages
]);
