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
$zalo = $data['zalo'] ?? '';
$oldPassword = $data['oldPassword'] ?? '';
$newPassword = $data['newPassword'] ?? '';
$username = $_SESSION['username'];

$conn = connectdb();

// Lấy UserID phụ huynh
$sql = "SELECT p.UserID, u.Password FROM parents p JOIN users u ON p.UserID = u.UserID WHERE u.Username = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$username]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    echo json_encode(['success' => false, 'message' => 'Không tìm thấy phụ huynh']);
    exit;
}

$parentId = $row['UserID'];

// Nếu có nhập mật khẩu cũ và mới thì kiểm tra và cập nhật mật khẩu
if (!empty($oldPassword) && !empty($newPassword)) {
    // Kiểm tra mật khẩu cũ
    if (!password_verify($oldPassword, $row['Password'])) {
        echo json_encode(['success' => false, 'message' => 'Mật khẩu cũ không đúng']);
        exit;
    }
    // Cập nhật mật khẩu mới
    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    $sql = "UPDATE users SET Password = ? WHERE UserID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$hashedPassword, $parentId]);
    // Sau khi đổi mật khẩu, cập nhật thông tin cá nhân như bình thường
}

// Cập nhật thông tin cá nhân
$sql = "UPDATE parents SET Email = ?, Phone = ?, ZaloID = ? WHERE UserID = ?";
$stmt = $conn->prepare($sql);
$success = $stmt->execute([$email, $phone, $zalo, $parentId]);

echo json_encode(['success' => $success]);
?>