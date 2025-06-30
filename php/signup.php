<?php
session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";

if (isset($_POST['signup']) && ($_POST['signup'])) {
    $respon = array();

    if (empty($_POST['check']) || !$_POST['check']) {
        $respon['error'] = "Vui lòng đồng ý với điều khoản dịch vụ của chúng tôi!";
        echo json_encode($respon);
        exit;
    }
    $fullname = $_POST['fullname'];
    $birthdate = $_POST['birthdate'];
    $gender = $_POST['gender'];
    $username = $_POST['username'];
    $password = $_POST['password'];
    $confirmPassword = $_POST['confirm_password'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $role = $_POST['role'];

    if (
        empty($_POST['fullname']) || empty($_POST['birthdate']) || empty($_POST['gender']) ||
        empty($_POST['username']) || empty($_POST['password']) || empty($_POST['email']) || empty($_POST['confirm_password'])
    ) {
        $respon['error'] = "Không được để trống dữ liệu!";
        echo json_encode($respon);
        exit;
    }
    if (isExistUsername($_POST['username'])) {
        $respon['error'] = "Tên đăng nhập đã tồn tại!";
        echo json_encode($respon);
        exit;
    }

        // Kiểm tra email đã tồn tại
    if (isExistEmail($_POST['email'])) {
        $respon['error'] = "Email đã được sử dụng bởi người khác!";
        echo json_encode($respon);
        exit;
    }

    // Validate password length (minimum 6 characters)
    if (strlen($password) < 6) {
        $respon['error'] = "Mật khẩu phải có ít nhất 6 ký tự!";
        echo json_encode($respon);
        exit;
    }
    
    // Validate email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $respon['error'] = "Email không đúng định dạng!";
        echo json_encode($respon);
        exit;
    }
    
    // Validate phone number (only numbers)
    if (!empty($phone) && !preg_match('/^[0-9]+$/', $phone)) {
        $respon['error'] = "Số điện thoại chỉ được chứa số!";
        echo json_encode($respon);
        exit;
    }
    
    // Validate birthdate (not greater than current date)
    $birthdateTime = strtotime($birthdate);
    $today = strtotime(date('Y-m-d'));
    if ($birthdateTime > $today) {
        $respon['error'] = "Ngày sinh không thể lớn hơn ngày hiện tại!";
        echo json_encode($respon);
        exit;
    }
    if (strcmp($password, $confirmPassword) != 0) {
        $respon['error'] = "Mật khẩu nhập lại không trùng khớp!";
        echo json_encode($respon);
        exit;
    }


    addStudentOrParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $role);

    $respon['redirect'] = "login.php";
    echo json_encode($respon);
    exit;
}
?>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - KEC</title>
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
        <div class="signup">
            <div class="body">
                <h1>Đăng ký</h1>
                <form class="signup-form" id="signup-form" action="" method="post">
                    <!-- ...form đăng ký... -->

                    <div class="signup-block">
                        <h2>Họ và tên</h2>
                        <input type="text" name="fullname" placeholder="Họ và tên" required>
                    </div>

                    <div class="signup-block">
                        <h2>Giới tính</h2>
                        <select name="gender" id="gender" class="form-select" required>
                            <option value="">Chọn giới tính</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>

                    <div class="signup-block">
                        <h2>Ngày sinh</h2>
                        <input type="date" name="birthdate" required>
                    </div>

                    <div class="signup-block">
                        <h2>Tên đăng nhập</h2>
                        <input type="text" name="username" placeholder="Tên đăng nhập" required>
                    </div>

                    <div class="signup-block">
                        <h2>Mật khẩu</h2>
                        <input type="password" name="password" placeholder="Mật khẩu" required>
                    </div>

                    <div class="signup-block">
                        <h2>Nhập lại mật khẩu</h2>
                        <input type="password" placeholder="Nhập lại mật khẩu" name="confirm_password" required>
                    </div>

                    <div class="signup-block">
                        <h2>Email</h2>
                        <input type="email" placeholder="Email" name="email">
                    </div>

                    <div class="signup-block">
                        <h2>Số điện thoại</h2>
                        <input type="tel" placeholder="Số điện thoại" name="phone">
                    </div>

                    <div class="signup-role">
                        <h2>Vai trò</h2>
                        <div class="block">
                            <input type="radio" name="role" id="parent" value="3" checked>
                            <label for="parent">Phụ huynh</label>
                        </div>
                        <div class="block">
                            <input type="radio" name="role" id="student" value="2">
                            <label for="student">Học sinh</label>
                        </div>
                    </div>
                    <div>
                        <input type="checkbox" id="check" name="check">
                        <label for="check">Đồng ý với <a href="../view/terms-of-service.html">Điều khoản dịch vụ</a> và <a href="../view/privacy-policy.html">Chính sách bảo
                                mật</a></label>
                    </div>
                    
                    <div class="exist-account">
                        Đã có tài khoản? <a href="../php/login.php">Đăng nhập ngay!</a>
                    </div>
                    <div id="error-message" style="color: red; background-color: antiquewhite; margin-bottom: 5px;line-height: 2rem; width: 100%;"></div>
                    <div id="check-error-placeholder"></div>
                    <button type="submit" name="signup" id="signup" onclick="">Đăng ký</button>
                </form>
            </div>
        </div>
    </div>


    <div id="success-popup" class="popup" style="display: none;">
        <div class="popup-content">
            <h2>Đăng ký thành công!</h2>
            <p>Bạn đã đăng ký tài khoản thành công!</p>
            <button id="login-btn">Đăng nhập ngay</button>
        </div>
    </div>

    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/validation.js"></script>
    <script>
        document.getElementById('signup-form').addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            formData.append('signup', true);

            fetch('signup.php', {
                    method: 'POST',
                    body: formData
                })
                .then(respon => respon.json())
                .then(data => {
                    if (data.error) {
                        document.getElementById('error-message').textContent = data.error;
                    } else if (data.redirect) {
                        // Hiển thị popup thay vì chuyển hướng ngay
                        document.getElementById('success-popup').style.display = 'flex';
                    }
                })
                .catch(error => {
                    document.getElementById('error-message').textContent = 'Đã xảy ra lỗi, vui lòng thử lại';
                });
        });

        // Thêm sự kiện click cho nút đăng nhập trong popup
        document.getElementById('login-btn').addEventListener('click', function() {
            window.location.href = 'login.php';
        });
    </script>
</body>

</html>