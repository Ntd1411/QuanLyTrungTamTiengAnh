<?php
session_start();
require_once '../model/config.php';

$username = $_SESSION['username'] ?? $_COOKIE['username'] ?? null;
if (!$username) {
    echo json_encode(['error' => 'Chưa đăng nhập']);
    exit;
}

$conn = connectdb();

// Lấy thông tin giáo viên
$sql = "SELECT t.UserID, t.FullName, t.Email, t.Phone
        FROM teachers t
        JOIN users u ON t.UserID = u.UserID
        WHERE u.Username = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$username]);
$teacher = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$teacher) {
    echo json_encode(['error' => 'Không tìm thấy giáo viên']);
    exit;
}

// Lấy danh sách lớp giáo viên phụ trách
$sql = "SELECT
    c.ClassID,
    c.ClassName,
    c.SchoolYear,
    c.StartDate,
    c.EndDate,
    c.ClassTime,
    c.Room,
    -- Dùng COUNT(ts.SessionID) để chỉ đếm các buổi dạy thực sự tồn tại sau khi JOIN
    COUNT(ts.SessionID) AS TaughtSessions
FROM
    classes c
-- Sử dụng LEFT JOIN để vẫn hiển thị lớp học dù chưa có buổi dạy nào
LEFT JOIN
    teaching_sessions ts
    ON c.ClassID = ts.ClassID
    AND ts.Status = 'Đã dạy'
WHERE
    c.TeacherID = ?
GROUP BY
    c.ClassID,
    c.ClassName,
    c.SchoolYear,
    c.StartDate,
    c.EndDate,
    c.ClassTime,
    c.Room;";
$stmt = $conn->prepare($sql);
$stmt->execute([$teacher['UserID']]);
$classes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy học sinh từng lớp
foreach ($classes as &$class) {
    $stmt2 = $conn->prepare("
        SELECT 
            s.UserID, s.FullName,
            (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID AND (a.Status = 'Có mặt' OR a.Status = 'Đi muộn')) AS attended,
            (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID AND a.Status = 'Vắng mặt') AS absent,
            (SELECT COUNT(*) FROM attendance a WHERE a.StudentID = s.UserID) AS total
        FROM students s
        WHERE s.ClassID = ?
    ");
    $stmt2->execute([$class['ClassID']]);
    $students = $stmt2->fetchAll(PDO::FETCH_ASSOC);

    // Tính tỷ lệ tham gia
    foreach ($students as &$st) {
        $total = isset($st['total']) && is_numeric($st['total']) ? (int)$st['total'] : 0;
        $attended = isset($st['attended']) && is_numeric($st['attended']) ? (int)$st['attended'] : 0;
        $st['participation'] = $total > 0 ? round($attended * 100 / $total, 1) : 0;
    }
    unset($st);

    $class['students'] = $students;
}
unset($class);

// Lấy số buổi dạy tháng này từ bảng teaching_sessions
$sql = "SELECT COUNT(*) AS monthly_sessions
        FROM teaching_sessions
        WHERE TeacherID = ?
        AND MONTH(SessionDate) = MONTH(CURDATE())
        AND YEAR(SessionDate) = YEAR(CURDATE())
        AND Status = 'Đã dạy'";
$stmt = $conn->prepare($sql);
$stmt->execute([$teacher['UserID']]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);
$monthly_sessions = $row ? (int)$row['monthly_sessions'] : 0;

// Lấy nhật ký dạy trong năm
$sql = "SELECT ts.SessionID, ts.SessionDate, c.ClassName, c.SchoolYear, c.Room, ts.Status, ts.Note
        FROM teaching_sessions ts
        JOIN classes c ON ts.ClassID = c.ClassID
        WHERE ts.TeacherID = ?
        AND YEAR(ts.SessionDate) = YEAR(CURDATE())
        ORDER BY ts.SessionDate DESC";
$stmt = $conn->prepare($sql);
$stmt->execute([$teacher['UserID']]);
$teaching_log = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy danh sách thông báo đã nhận
$stmt = $conn->prepare("
    SELECT m.MessageID, m.SendDate AS SentAt, m.Subject AS Type, m.Content, u.Username AS sender, m.IsRead
    FROM messages m
    JOIN users u ON m.SenderID = u.UserID
    WHERE m.ReceiverID = ?
    ORDER BY m.SendDate DESC
");
$stmt->execute([$teacher['UserID']]);
$received_notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Lấy danh sách thông báo đã gửi
$stmt = $conn->prepare("
    SELECT DISTINCT m.SendDate AS SentAt, c.ClassName, c.SchoolYear, c.Room, m.Subject AS Type, m.Content
    FROM messages m
    JOIN students s ON m.ReceiverID = s.UserID
    JOIN classes c ON s.ClassID = c.ClassID
    WHERE m.SenderID = ?
    ORDER BY m.SendDate DESC
");
$stmt->execute([$teacher['UserID']]);
$sent_notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Trả về JSON
echo json_encode([
    'id' => $teacher['UserID'],
    'name' => $teacher['FullName'],
    'email' => $teacher['Email'],
    'phone' => $teacher['Phone'],
    'classes' => $classes,
    'monthly_sessions' => $monthly_sessions,
    'teaching_log' => $teaching_log,
    'received_notifications' => $received_notifications,
    'sent_notifications' => $sent_notifications
]);
