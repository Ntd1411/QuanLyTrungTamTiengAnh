<?php
session_start();
require_once '../model/config.php';

if (!isset($_SESSION['username'])) {
    echo json_encode(['success' => false, 'message' => 'Chưa đăng nhập']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';
$phone = $data['phone'] ?? '';
$oldPassword = $data['oldPassword'] ?? '';
$newPassword = $data['newPassword'] ?? '';
$username = $_SESSION['username'];

$conn = connectdb();

// Lấy UserID học sinh
$sql = "SELECT s.UserID, u.Password FROM students s JOIN users u ON s.UserID = u.UserID WHERE u.Username = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$username]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    echo json_encode(['success' => false, 'message' => 'Không tìm thấy học sinh']);
    exit;
}

$studentId = $row['UserID'];

// Nếu có nhập mật khẩu cũ và mới thì kiểm tra và cập nhật mật khẩu
if (!empty($oldPassword) && !empty($newPassword)) {
    if (!password_verify($oldPassword, $row['Password'])) {
        echo json_encode(['success' => false, 'message' => 'Mật khẩu cũ không đúng']);
        exit;
    }
    if (!preg_match('/^[a-zA-Z0-9]{6,}$/', $newPassword)) {
        echo json_encode(['success' => false, 'message' => 'Mật khẩu mới không hợp lệ']);
        exit;
    }
    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    $sql = "UPDATE users SET Password = ? WHERE UserID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$hashedPassword, $studentId]);
}

// Cập nhật thông tin cá nhân
$sql = "UPDATE students SET Email = ?, Phone = ? WHERE UserID = ?";
$stmt = $conn->prepare($sql);
$success = $stmt->execute([$email, $phone, $studentId]);

echo json_encode(['success' => $success]);
exit;
?>