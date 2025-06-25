<?php

session_start();
if (((isset($_COOKIE['is_login'])) && $_COOKIE['is_login'] == true) ||
    (isset($_SESSION['role'])  && $_SESSION['role'] == 0)
) {
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản được cấp quyền admin để xem trang này');</script>";
    echo "<script>window.location.href = './login.php';</script>";
    exit();
}

include "../model/config.php";



if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = $_POST['title'];
    $content = $_POST['content'];
    $excerpt = $_POST['excerpt'];
    $author = $_POST['author'];
    $date = date('Y-m-d');

    $conn = connectdb();

    // Xử lý upload ảnh
    $target_dir = "../assets/imgnews/";
    $image_name = time() . '_' . basename($_FILES["image"]["name"]);
    $target_file = $target_dir . $image_name;

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        // Thêm tin tức vào database
        try {
            $sql = "INSERT INTO news (title, content, excerpt, image, author, date) 
                VALUES (?, ?, ?, ?, ?, ?)";

            $stmt = $conn->prepare($sql);
            $result = $stmt->execute([$title, $content, $excerpt, $image_name, $author, $date]);
            if ($result) {
                echo json_encode(["status" => "success", "message" => "Đăng ảnh thành công!"]);
            } else {
                echo json_encode(["status" => "fail", "message" => "Lỗi: " . $result]);
            }
            
        } catch (PDOException $e) {
            echo json_encode(["status" => "fail", "message" => "Lỗi: " . $e->getMessage()]);
        }
    } else {
        // echo "Lỗi upload file";
        echo json_encode(["status" => "fail", "message" => "Lỗi upload file"]);
    }
}
$conn = null;
