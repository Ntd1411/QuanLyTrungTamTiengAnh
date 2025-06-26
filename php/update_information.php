<?php
session_start();
require_once '../model/config.php';

if (!isset($_SESSION['username'])) {
    echo json_encode(['success' => false, 'message' => 'Chưa đăng nhập']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$role = $data['role'] ?? '';
$email = $data['email'] ?? '';
$phone = $data['phone'] ?? '';
$zalo = $data['zalo'] ?? '';
$oldPassword = $data['oldPassword'] ?? '';
$newPassword = $data['newPassword'] ?? '';
$username = $_SESSION['username'];

$conn = connectdb();

if ($role === 'student') {
    $sql = "SELECT s.UserID, u.Password FROM students s JOIN users u ON s.UserID = u.UserID WHERE u.Username = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$username]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        echo json_encode(['success' => false, 'message' => 'Không tìm thấy học sinh']);
        exit;
    }
    $userId = $row['UserID'];
    // Đổi mật khẩu nếu có nhập
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
        $stmt = $conn->prepare("UPDATE users SET Password = ? WHERE UserID = ?");
        $stmt->execute([$hashedPassword, $userId]);
    }
    // Cập nhật thông tin cá nhân
    $stmt = $conn->prepare("UPDATE students SET Email = ?, Phone = ? WHERE UserID = ?");
    $success = $stmt->execute([$email, $phone, $userId]);
    echo json_encode(['success' => $success]);
    exit;
} else if ($role === 'teacher') {
    $sql = "SELECT t.UserID, u.Password FROM teachers t JOIN users u ON t.UserID = u.UserID WHERE u.Username = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$username]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        echo json_encode(['success' => false, 'message' => 'Không tìm thấy giáo viên']);
        exit;
    }
    $userId = $row['UserID'];
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
        $stmt = $conn->prepare("UPDATE users SET Password = ? WHERE UserID = ?");
        $stmt->execute([$hashedPassword, $userId]);
    }
    $stmt = $conn->prepare("UPDATE teachers SET Email = ?, Phone = ? WHERE UserID = ?");
    $success = $stmt->execute([$email, $phone, $userId]);
    echo json_encode(['success' => $success]);
    exit;
} else if ($role === 'parent') {
    $sql = "SELECT p.UserID, u.Password FROM parents p JOIN users u ON p.UserID = u.UserID WHERE u.Username = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$username]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        echo json_encode(['success' => false, 'message' => 'Không tìm thấy phụ huynh']);
        exit;
    }
    $userId = $row['UserID'];
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
        $stmt = $conn->prepare("UPDATE users SET Password = ? WHERE UserID = ?");
        $stmt->execute([$hashedPassword, $userId]);
    }
    $stmt = $conn->prepare("UPDATE parents SET Email = ?, Phone = ?, ZaloID = ? WHERE UserID = ?");
    $success = $stmt->execute([$email, $phone, $zalo, $userId]);
    echo json_encode(['success' => $success]);
    exit;
} else {
    echo json_encode(['success' => false, 'message' => 'Vai trò không hợp lệ']);
}

$conn = null; // Đóng kết nối
?>