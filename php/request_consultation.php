<?php
require_once '../model/config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate dữ liệu
    if (
        empty($_POST['fullname']) ||
        empty($_POST['birthyear']) ||
        empty($_POST['phone']) ||
        empty($_POST['course'])
    ) {
        echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin bắt buộc']);
        exit;
    }

    $fullname = $_POST['fullname'];
    $birthyear = $_POST['birthyear'];
    $phone = $_POST['phone'];
    $email = $_POST['email'] ?? '';
    $course = $_POST['course'];
    $message = $_POST['message'] ?? '';

    $conn = connectdb();
    $stmt = $conn->prepare("INSERT INTO consulting (fullname, birthyear, phone, email, course, message) VALUES (?, ?, ?, ?, ?, ?)");
    $success = $stmt->execute([$fullname, $birthyear, $phone, $email, $course, $message]);
    echo json_encode(['status' => $success ? 'success' : 'error']);
    exit;
}
echo json_encode(['status' => 'error', 'message' => 'Phương thức không hợp lệ']);