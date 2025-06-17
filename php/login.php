<?php
session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";

if (isset($_POST['login']) && ($_POST['login'])) {
    $response = array();
    
    if (empty($_POST['username']) || empty($_POST['password'])) {
        $response['error'] = "Thiếu thông tin đăng nhập";
        echo json_encode($response);
        exit;
    }

    $username = $_POST['username'];
    $password = $_POST['password'];
    $remember = $_POST['remember'] ?? "";

    $role = getRole($username, $password);
    $_SESSION['role'] = $role;
    
    if (isset($_SESSION['role'])) {
        switch ($role) {
            case 0:
                $response['redirect'] = "admin.php";
                $_SESSION['username'] = $username;
                if(isset($remember) && $remember){
                    setcookie('is_login', true, time() + 3600*24*7, '/');
                    setcookie('role', $role, time()+ 3600*24*7, '/');
                }
                break;
            case 1:
                $response['redirect'] = "teacher.php";
                $_SESSION['username'] = $username;
                if(isset($remember) && $remember){
                    setcookie('is_login', true, time()+ 3600*24*7, '/');
                    setcookie('username', $username, time()+ 3600*24*7, '/');
                    setcookie('role', $role, time()+ 3600*24*7, '/');
                }
                break;
            case 2:
                $response['redirect'] = "student.php";
                $_SESSION['username'] = $username;
                 if(isset($remember) && $remember){
                    setcookie('is_login', true, time()+ 3600*24*7, '/');
                    setcookie('username', $username, time()+ 3600*24*7, '/');
                    setcookie('role', $role, time()+ 3600*24*7, '/');
                }
                break;
            case 3:
                $response['redirect'] = "parent.php";
                $_SESSION['username'] = $username;
                 if(isset($remember) && $remember){
                    setcookie('is_login', true, time()+ 3600*24*7, '/');
                    setcookie('username', $username, time()+ 3600*24*7, '/');
                    setcookie('role', $role, time()+ 3600*24*7, '/');
                }
                break;
            default:
                $response['error'] = "Sai tên đăng nhập hoặc mật khẩu";
                break;
        }
    }
    $conn = null;
    echo json_encode($response);
    exit;
}

?>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Đăng nhập - KEC</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <link rel="stylesheet" href="../assets/css/style.css">
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
                <a href="#" onclick="event.preventDefault()">Thư viện</a>
                <ul class="submenu">
                    <li><a href="#ielts-library">IELTS</a></li>
                    <li><a href="#toeic-library">TOEIC</a></li>
                </ul>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Tin Tức</a>
                <ul class="submenu">
                    <li><a href="#academic-news">Sự Kiện</a></li>
                    <li><a href="#student-news">Học Viên Xuất Sắc</a></li>
                </ul>
            </li>
            <li>
                <a href="#" onclick="event.preventDefault()">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="">Đăng Nhập</a></li>
                    <li><a href="../view/signup.html">Đăng Ký</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="login">
        <div class="body">
            <h1>Đăng nhập</h1>
            <form id="loginForm" method="post">
                <div class="block">
                    <h2>Tài khoản</h2>
                    <input type="text" title="Tên đăng nhập" name="username" placeholder="Tài khoản" required>
                </div>

                <div class="block">
                    <h2>Mật khẩu</h2>
                    <input type="password" title="Mật khẩu" name="password" placeholder="Mật khẩu" required>
                </div>

                <div id="error-message" style="color: red;"></div>

                <div class="remember">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Ghi nhớ đăng nhập</label>
                </div>

                <a href="#">Quên mật khẩu?</a>

                <button type="submit" name="login" id="login">Đăng nhập</button>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            formData.append('login', true);

            fetch('login.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    document.getElementById('error-message').textContent = data.error;
                } else if (data.redirect) {
                    window.location.href = data.redirect;
                }
            })
            .catch(error => {
                document.getElementById('error-message').textContent = 'Đã xảy ra lỗi, vui lòng thử lại';
            });
        });
    </script>
</body>
</html>