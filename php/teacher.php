<?php
session_start();
ob_start();

if (((isset($_COOKIE['is_login'])) && $_COOKIE['is_login'] == true) ||
    (isset($_SESSION['role'])  && $_SESSION['role'] == 1)
) {
    $username = isset($_COOKIE['username']) ? $_COOKIE['username'] : $_SESSION['username'];
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản giáo viên để xem trang này');</script>";
    echo "<script>window.location.href = './login.php';</script>";
    exit();
}
?>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/teacher.css">
    <title>Teacher Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
</head>

<body>
    <!-- Header với ảnh -->
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <!-- Menu ngang -->
    <nav>
        <ul class="menu">
            <li><a href="#home-teacher" onclick="showElement('home-teacher'); return false;">Trang Chủ</a></li>
            <li><a href="#schedule" onclick="showElement('schedule'); return false;">Lịch Dạy</a></li>
            <li><a href="#my-classes" onclick="showElement('my-classes'); return false;">Lớp Dạy</a></li>
            <li><a href="#attendance" onclick="showElement('attendance'); return false;">Điểm Danh</a></li>
            <li><a href="#notifications" onclick="showElement('notifications'); return false;">Thông Báo</a></li>
            <li>
                <a href="#account">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#profile" onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="main-content-teacher">
        <!-- Home Section -->
        <div id="home-teacher" class="element active">
            <h2>Chào mừng, giáo viên <span id="teacher-name">Giáo viên</span></h2>
            <div class="dashboard-summary">
                <div class="summary-card" onclick="showElement('schedule')">
                    <h3>Tổng số lớp</h3>
                    <p id="total-classes">0</p>
                </div>
                <div class="summary-card" onclick="showElement('my-classes')">
                    <h3>Tổng số học sinh</h3>
                    <p id="total-students">0</p>
                </div>
                <div class="summary-card">
                    <h3>Buổi dạy tháng này</h3>
                    <p id="monthly-sessions">0</p>
                </div>
            </div>
            <h2>Nhật ký dạy tháng này</h2>
            <div class="teaching-log-table table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Ngày dạy</th>
                            <th>Lớp</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody id="teaching-log-body"></tbody>
                </table>
            </div>
        </div>

        <!-- Schedule Section -->
        <div id="schedule" class="element">
            <h2>Lịch Dạy</h2>
            <div class="schedule-container">
                <div class="schedule-header">
                    <div class="form-group">
                        <label>Xem theo tuần:</label>
                        <input type="week" id="schedule-week">
                    </div>
                    <button onclick="viewSchedule()">Xem lịch</button>
                </div>
                <div class="schedule-table-container">
                    <table class="schedule-table">
                        <thead>
                            <tr>
                                <th>Thời gian</th>
                                <th>Thứ 2</th>
                                <th>Thứ 3</th>
                                <th>Thứ 4</th>
                                <th>Thứ 5</th>
                                <th>Thứ 6</th>
                                <th>Thứ 7</th>
                                <th>Chủ nhật</th>
                            </tr>
                        </thead>
                        <tbody id="schedule-body">
                            <!-- Schedule will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- My Classes Section -->
        <div id="my-classes" class="element">
            <div class="classes-container">
                <!-- Danh sách lớp sẽ được thêm vào đây bằng JavaScript -->
            </div>
            <div class="class-students-list" style="display:none; margin-top:24px;">
                <h3>Danh sách học sinh</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Họ và tên</th>
                                <th>Số buổi học</th>
                                <th>Số buổi nghỉ</th>
                                <th>Tỷ lệ tham gia</th>
                                <th>Mã học sinh</th>
                            </tr>
                        </thead>
                        <tbody id="teacher-class-students-table"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Attendance Section -->
        <div id="attendance" class="element">
            <div class="attendance-form">
                <div class="form-group">
                    <label>Chọn lớp:</label>
                    <select id="class-select">
                        <option value="">Chọn lớp</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ngày:</label>
                    <input type="date" id="attendance-date">
                </div>
                <div class="attendance-list">
                    <!-- Danh sách điểm danh sẽ được thêm vào đây -->
                </div>
                <button onclick="submitAttendance()">Lưu điểm danh</button>
            </div>
        </div>

        <!-- Notifications Section -->
        <div id="notifications" class="element">
            <div class="notification-form">
                <div class="form-group">
                    <label>Chọn lớp:</label>
                    <select id="notification-class">
                        <option value="">Chọn lớp</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Loại thông báo:</label>
                    <select id="notification-type">
                        <option value="homework">Bài tập về nhà</option>
                        <option value="cancel">Nghỉ học</option>
                        <option value="exam">Kiểm tra</option>
                        <option value="other">Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Nội dung:</label>
                    <textarea id="notification-content" rows="4"></textarea>
                </div>
                <div class="notification-options">
                    <label><input type="checkbox" id="notify-zalo"> Gửi qua Zalo</label>
                    <label><input type="checkbox" id="notify-sms"> Gửi qua SMS</label>
                </div>
                <button onclick="sendNotification()">Gửi thông báo</button>
            </div>
        </div>

        <!-- Profile Section -->
        <div id="profile" class="element">
            <div class="profile-form">
                <div class="form-group">
                    <label>Họ và tên:</label>
                    <input type="text" id="profile-name" readonly>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" id="profile-email" readonly>
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" id="profile-phone">
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới:</label>
                    <input type="password" id="profile-new-password">
                </div>
                <button onclick="updateProfile()">Cập nhật thông tin</button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p><strong>Email:</strong> contact@actvn.edu.vn | <strong>Website:</strong> www.actvn.edu.vn</p>
        <h3>Học Viện Kỹ Thuật Mật Mã - 141 Chiến Thắng, Tân Triều, Thanh Trì, Hà Nội</h3>
        <p>Điện thoại: (024) 3854 2211 | Fax: (024) 3854 2344</p>
        <p>&copy; 2025 - Bản quyền thuộc về Học Viện Kỹ Thuật Mật Mã</p>
    </footer>

    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/teacher.js"></script>
    <script src="../assets/js/update_page.js"></script>
</body>

</html>