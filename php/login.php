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

    $usernameOrEmail = $_POST['username'];
    $password = $_POST['password'];
    $remember = $_POST['remember'] ?? "";

    $user = getUserByUsername($usernameOrEmail);

    if (!$user || !password_verify($password, $user['Password'])) {
        $response['error'] = "Sai tên đăng nhập hoặc mật khẩu";
        echo json_encode($response);
        exit;
    }
    $role = getRole($usernameOrEmail, $password);
    $actualUsername = $usernameOrEmail;

    // Nếu đăng nhập bằng email, chuyển về username
    if (filter_var($usernameOrEmail, FILTER_VALIDATE_EMAIL)) {
        $actualUsername = getUsernameByEmail($usernameOrEmail);
    }

    $_SESSION['role'] = $role;

    if (isset($_SESSION['role'])) {
        switch ($role) {
            case 0:
                $response['redirect'] = "admin.php";
                $_SESSION['username'] = $actualUsername;
                $_SESSION['role'] = $role;
                if (isset($remember) && $remember) {
                    setcookie('is_login', true, time() + 3600 * 24, '/');
                    setcookie('username', $actualUsername, time() + 3600 * 24, '/');
                    setcookie('role', $role, time() + 3600 * 24, '/');
                }
                break;
            case 1:
                $response['redirect'] = "teacher.php";
                $_SESSION['role'] = $role;
                $_SESSION['username'] = $actualUsername;
                if (isset($remember) && $remember) {
                    setcookie('is_login', true, time() + 3600 * 24, '/');
                    setcookie('username', $actualUsername, time() + 3600 * 24, '/');
                    setcookie('role', $role, time() + 3600 * 24, '/');
                }
                break;
            case 2:
                $response['redirect'] = "student.php";
                $_SESSION['role'] = $role;
                $_SESSION['username'] = $actualUsername;
                if (isset($remember) && $remember) {
                    setcookie('is_login', true, time() + 3600 * 24, '/');
                    setcookie('username', $actualUsername, time() + 3600 * 24, '/');
                    setcookie('role', $role, time() + 3600 * 24, '/');
                }
                break;
            case 3:
                $response['redirect'] = "parent.php";
                $_SESSION['username'] = $actualUsername;
                $_SESSION['id'] = $user['UserID'];
                if (isset($remember) && $remember) {
                    setcookie('is_login', true, time() + 3600 * 24, '/');
                    setcookie('username', $actualUsername, time() + 3600 * 24, '/');
                    setcookie('role', $role, time() + 3600 * 24, '/');
                    setcookie('id', $user['UserID'], time() + 3600 * 24, '/');
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - KEC</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
</head>

<body>

    <!-- Add menu toggle button -->
    <button class="menu-toggle" onclick="toggleMenu()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Add menu overlay -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>
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
                <h1>Đăng nhập</h1>
                <form id="loginForm" method="post">
                    <div class="block">
                        <h2>Tài khoản</h2>
                        <input type="text" title="Tên đăng nhập" name="username" placeholder="Tài khoản hoặc email" required>
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

                    <a id="forgot-password" href="forgotpassword.php">Quên mật khẩu?</a>

                    <button type="submit" name="login" id="login">Đăng nhập</button>
                </form>
            </div>
        </div>
    </div>

    <script src="../assets/js/main.js"></script>
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