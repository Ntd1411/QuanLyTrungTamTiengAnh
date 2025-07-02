<?php
include "../model/config.php";
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if ($_GET['action'] === "getAds") {
        try {
            date_default_timezone_set('Asia/Ho_Chi_Minh');
            $today = date('Y-m-d');

            $conn = connectdb();

            // Chuẩn bị câu truy vấn
            $sql = "SELECT * FROM advertisements 
                   WHERE status = 'active' 
                   AND start_date <= :today 
                   AND end_date >= :today 
                   ORDER BY created_at DESC 
                   LIMIT 1";

            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':today', $today);
            $stmt->execute();

            // Kiểm tra và trả về kết quả
            if ($stmt->rowCount() > 0) {
                $ad = $stmt->fetch(PDO::FETCH_ASSOC);
                echo json_encode([
                    "status" => "success",
                    "data" => $ad
                ]);
            } else {
                echo json_encode([
                    "status" => "error",
                    "message" => "Đã có lỗi xảy ra"
                ]);
            }
        } catch (PDOException $e) {
            echo json_encode([
                "status" => "error",
                "message" => "Lỗi truy vấn: " . $e->getMessage()
            ]);
        }
    }  else if ($_GET['action'] === "getAd") {
        try {
            $id = $_GET['id'];
            $conn = connectdb();
            $sql = "SELECT * FROM advertisements WHERE id = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([':id' => $id]);
            
            $ad = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($ad) {
                echo json_encode([
                    "status" => "success",
                    "ad" => $ad
                ]);
            } else {
                echo json_encode([
                    "status" => "error",
                    "message" => "Không tìm thấy quảng cáo"
                ]); 
            }
        } catch (PDOException $e) {
            echo json_encode([
                "status" => "error", 
                "message" => "Lỗi truy vấn: " . $e->getMessage()
            ]);
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($_POST['action'] === 'setAds') {
        try {
            // Validate image 
            if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
                throw new Exception('Vui lòng chọn hình ảnh');
            }

            // Get form data
            $startDate = $_POST['start_date'];
            $endDate = $_POST['end_date'];
            $status = $_POST['status'];

            // Validate dates
            if (strtotime($startDate) > strtotime($endDate)) {
                throw new Exception('Ngày bắt đầu không thể sau ngày kết thúc');
            }

            $conn = connectdb();

            // Check for overlapping active ads
            if ($status === 'active') {
                $checkSql = "SELECT COUNT(*) FROM advertisements 
                           WHERE status = 'active'
                           AND (
                               (start_date <= :startDate AND end_date >= :startDate)
                               OR 
                               (start_date <= :endDate AND end_date >= :endDate)
                               OR
                               (start_date >= :startDate AND end_date <= :endDate)
                           )";
                
                $checkStmt = $conn->prepare($checkSql);
                $checkStmt->execute([
                    ':startDate' => $startDate,
                    ':endDate' => $endDate
                ]);

                if ($checkStmt->fetchColumn() > 0) {
                    throw new Exception('Đã có quảng cáo hoạt động trong khoảng thời gian này');
                }
            }

            // Validate file type
            $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
            $fileType = $_FILES['image']['type'];
            if (!in_array($fileType, $allowedTypes)) {
                throw new Exception('Chỉ chấp nhận file hình ảnh (JPG, PNG, GIF)');
            }

            // Validate file size (max 20MB)
            if ($_FILES['image']['size'] > 20 * 1024 * 1024) {
                throw new Exception('Kích thước file không được vượt quá 20MB');
            }

            // Generate unique filename
            $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
            $filename = uniqid('ad_') . '.' . $ext;
            $uploadPath = '../assets/img/' . $filename;

            // Create directory if it doesn't exist
            if (!file_exists('../assets/img/')) {
                mkdir('../assets/img/', 0777, true);
            }

            // Move uploaded file
            if (!move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
                throw new Exception('Không thể lưu file');
            }

            $sql = "INSERT INTO advertisements (subject, content, image, start_date, end_date, status, created_at) 
                    VALUES (:subject, :content, :image_url, :start_date, :end_date, :status, NOW())";

            $stmt = $conn->prepare($sql);
            $result = $stmt->execute([
                ':subject' => $_POST['subject'],
                ':content' => $_POST['content'],
                ':image_url' => $filename,
                ':start_date' => $_POST['start_date'],
                ':end_date' => $_POST['end_date'],
                ':status' => $_POST['status']
            ]);

            if ($result) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Thêm quảng cáo thành công'
                ]);
            } else {
                throw new Exception('Không thể thêm quảng cáo');
            }

        } catch (Exception $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }
}
