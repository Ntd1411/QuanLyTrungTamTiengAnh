<?php

session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";
include "../model/sendmail.php";

if (isset($_POST['forgot_password']) && $_POST['forgot_password']) {
    $response = array();

    if (empty($_POST['email'])) {
        $response['error'] = "Vui lòng nhập email!";
        echo json_encode($response);
        exit;
    }

    $email = $_POST['email'];

    // Validate email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['error'] = "Email không đúng định dạng!";
        echo json_encode($response);
        exit;
    }

    try {
        $conn = connectdb();
        
        // Tìm user qua email trong tất cả các bảng
        $sql = "SELECT u.UserID, u.Username, u.Role, t.FullName, t.Email, 'teacher' as user_type
                FROM users u 
                JOIN teachers t ON u.UserID = t.UserID 
                WHERE t.Email = :email
                UNION
                SELECT u.UserID, u.Username, u.Role, s.FullName, s.Email, 'student' as user_type
                FROM users u 
                JOIN students s ON u.UserID = s.UserID 
                WHERE s.Email = :email
                UNION
                SELECT u.UserID, u.Username, u.Role, p.FullName, p.Email, 'parent' as user_type
                FROM users u 
                JOIN parents p ON u.UserID = p.UserID 
                WHERE p.Email = :email";
        
        $stmt = $conn->prepare($sql);
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            $response['error'] = "Email không tồn tại trong hệ thống!";
            echo json_encode($response);
            exit;
        }

        // Tạo mật khẩu mới (8 ký tự random)
        $newPassword = substr(str_shuffle('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'), 0, 8);
        
        // Hash mật khẩu mới
        $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
        
        // Cập nhật mật khẩu trong bảng users
        $updateSql = "UPDATE users SET Password = :password WHERE UserID = :userID";
        $stmt = $conn->prepare($updateSql);
        $updateResult = $stmt->execute([
            ':password' => $hashedPassword, 
            ':userID' => $user['UserID']
        ]);

        if ($updateResult) {
            // Tạo nội dung email
            $subject = "Khôi phục mật khẩu - Trung tâm Tiếng Anh KEC";
            $content = "Xin chào " . $user['FullName'] . ",\n\n";
            $content .= "Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản: " . $user['Username'] . "\n";
            $content .= "Mật khẩu mới của bạn là: " . $newPassword . "\n\n";
            $content .= "Vui lòng đăng nhập và đổi mật khẩu ngay sau khi nhận được email này để đảm bảo an toàn.\n\n";
            $content .= "Nếu bạn không yêu cầu khôi phục mật khẩu, vui lòng liên hệ với chúng tôi ngay lập tức.\n\n";
            $content .= "Trân trọng,\nTrung tâm Tiếng Anh KEC\n";
            $content .= "Email: dungnguyenhhiii@gmail.com\n";
            $content .= "Điện thoại: 0123-456-789";

            // Gửi email
            $emailResult = sendEmail($email, $subject, $content);
            
            if ($emailResult['status'] === 'success') {
                $response['success'] = "Mật khẩu mới đã được gửi đến email của bạn! Vui lòng kiểm tra hộp thư.";
            } else {
                // Nếu gửi email thất bại, vẫn thông báo thành công để bảo mật
                // nhưng ghi log lỗi
                error_log("Failed to send password reset email to: " . $email . " - " . $emailResult['message']);
                $response['success'] = "Yêu cầu khôi phục mật khẩu đã được xử lý. Nếu email tồn tại, bạn sẽ nhận được mật khẩu mới.";
            }
        } else {
            $response['error'] = "Có lỗi xảy ra trong quá trình xử lý. Vui lòng thử lại!";
        }

    } catch (PDOException $e) {
        error_log("Database error in forgot password: " . $e->getMessage());
        $response['error'] = "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau!";
    }

    echo json_encode($response);
    exit;
}
?>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Quên mật khẩu - KEC</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="../assets/css/style.css">
    <style>
        #forgotPasswordForm input{
            width: 100%;
            line-height: 1.3rem;
            padding: 5px 10px;
            border-radius: 10px;
            border: 1px solid #ccc;
        }

        #forgotPasswordForm input:focus-visible {
            border: 1px solid #ccc;
        }
    </style>
</head>

<body>
    <!-- Header với ảnh -->
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <!-- Menu đa cấp -->
    <nav>
        <ul class="menu">
            <li>
                <a href="../index.html">Trang Chủ</a>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Giới Thiệu</a>
                <ul class="submenu">
                    <li><a href="../view/teachter_intro.html">Đội Ngũ Giảng Viên</a></li>
                    <li><a href="../view/faq.html">Câu Hỏi Thường Gặp (FAQ)</a></li>
                    <li><a href="../view/contact.html">Liên Hệ</a></li>
                </ul>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Đào Tạo</a>
                <ul class="submenu">
                    <li><a href="../view/english_for_kids.html">Tiếng Anh cho trẻ</a></li>
                    <li><a href="#" onclick="event.preventDefault()">IELTS</a>
                        <ul class="sub-submenu">
                            <li><a href="../view/ielts_basic.html">IELTS cơ bản</a></li>
                            <li><a href="../view/ielts_4.0_5.5.html">IELTS 4.0-5.5</a></li>
                            <li><a href="../view/ielts_5.5_6.5.html">IELTS 5.5-6.5</a></li>
                            <li><a href="../view/ielts_6.5+.html">IELTS 6.5+</a></li>
                        </ul>
                    </li>
                    <li><a href="#" onclick="event.preventDefault()">TOEIC</a>
                        <ul class="sub-submenu">
                            <li><a href="../view/toeic_550_650.html">550-650 TOEIC</a></li>
                            <li><a href="../view/toeic_650_800.html">650-800 TOEIC</a></li>
                            <li><a href="../view/toeic_800+.html">800+ TOEIC</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>
                <a href="../view/reference.html">Thư viện</a>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Tin Tức</a>
                <ul class="submenu">
                    <li><a href="../view/news.html">Sự Kiện</a></li>
                    <li><a href="../view/student_intro.html">Học Viên Xuất Sắc</a></li>
                </ul>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="../php/login.php">Đăng Nhập</a></li>
                    <li><a href="../php/signup.php">Đăng Ký</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="element active">
        <div class="login">
            <div class="body">
                <h1>Quên mật khẩu</h1>
                
                <form id="forgotPasswordForm" method="post">
                    <div class="block">
                        <h2 style="font-size: 1rem;">Email</h2>
                        <input type="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>

                    <div id="error-message" style="color: red; margin-bottom: 10px; text-align: center;"></div>
                    <div id="success-message" style="color: green; margin-bottom: 10px; text-align: center;"></div>

                    <button type="submit" name="forgot_password" id="forgot_password" style="margin-bottom: 15px;">
                        Gửi mật khẩu mới
                    </button>
                    
                    <div style="text-align: center;">
                        <a href="login.php" style="color: #007bff; text-decoration: none; font-size: 14px;">
                            ← Quay lại đăng nhập
                        </a>
                    </div>
                </form>

                <!-- Thông tin hỗ trợ -->
                <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; font-size: 13px; color: #666;">
                    <h3 style="margin: 0 0 10px 0; font-size: 14px; color: #333;">Lưu ý:</h3>
                    <ul style="margin: 0; padding-left: 20px; line-height: 1.5;">
                        <li>Vui lòng kiểm tra cả hộp thư spam/junk</li>
                        <li>Email có thể mất 1-2 phút để được gửi đến</li>
                        <li>Nếu không nhận được email, vui lòng liên hệ hỗ trợ</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            formData.append('forgot_password', true);

            // Clear previous messages
            document.getElementById('error-message').textContent = '';
            document.getElementById('success-message').textContent = '';

            // Disable submit button
            const submitBtn = document.getElementById('forgot_password');
            const originalText = submitBtn.textContent;
           
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            submitBtn.disabled = true;
            submitBtn.style.opacity = 0.6;
            submitBtn.style.cursor = "not-allowed";

            fetch('forgotpassword.php', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        document.getElementById('error-message').textContent = data.error;
                    } else if (data.success) {
                        document.getElementById('success-message').textContent = data.success;
                        // Clear form after success
                        document.getElementById('forgotPasswordForm').reset();
                    }
                })
                .catch(error => {
                    document.getElementById('error-message').textContent = 'Đã xảy ra lỗi, vui lòng thử lại';
                })
                .finally(() => {
                    // Re-enable submit button
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                    submitBtn.style.opacity = '1'; // Khôi phục opacity
                    submitBtn.style.cursor = 'pointer';
                });
        });
    </script>
</body>

</html>