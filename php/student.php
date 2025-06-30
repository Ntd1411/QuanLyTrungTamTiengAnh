<?php
session_start();
ob_start();

if (
    ((isset($_COOKIE['is_login']) && $_COOKIE['is_login'] == true && isset($_COOKIE['role']) && $_COOKIE['role'] == 2 && isset($_COOKIE['username']))
        || (isset($_SESSION['role']) && $_SESSION['role'] == 2 && isset($_SESSION['username']))
    )
) {
    $username = isset($_SESSION['username']) ? $_SESSION['username'] : $_COOKIE['username'];
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản học sinh để xem trang này');</script>";
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
    <link rel="stylesheet" href="../assets/css/student.css">
    <title>Student Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
</head>

<body>
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <nav>
        <ul class="menu">
            <li><a href="#home-student" onclick="showElement('home-student'); return false;">Trang Chủ</a></li>
            <li><a href="#my-class" onclick="showElement('my-class'); return false;">Lớp Học</a></li>
            <li><a href="#attendance" onclick="showElement('attendance'); return false;">Điểm Danh</a></li>
            <li><a href="#homework" onclick="showElement('homework'); return false;">Bài Tập</a></li>
            <li>
                <a href="#account" onclick="event.preventDefault()">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#profile" onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="main-content-student">
        <!-- Home Section -->
        <div id="home-student" class="element active">
            <h2>Chào mừng, <span id="student-name">Học sinh</span></h2>
            <div class="dashboard-summary">
                <div class="summary-card" onclick="showElement('my-class')">
                    <h3>Lớp học</h3>
                    <p id="class-name">Chưa trong lớp nào</p>
                </div>
                <div class="summary-card" onclick="showElement('attendance')">
                    <h3>Buổi đã học</h3>
                    <p id="attended-sessions">0</p>
                </div>
                <div class="summary-card warning" onclick="showElement('attendance')">
                    <h3>Buổi nghỉ</h3>
                    <p id="absent-sessions">0</p>
                </div>
                <div class="summary-card" onclick="showElement('homework')">
                    <h3>Bài tập mới</h3>
                    <p id="new-homework">0</p>
                </div>
            </div>
            <h2>Thông báo</h2>
            <!-- Bảng thông báo -->
            <div id="student-notifications" class="notification-container">
                <div class="notification-list">
                    <!-- Danh sách thông báo sẽ được thêm vào đây bằng JavaScript -->
                </div>
                <div class="notification-detail">
                    <div class="notification-content">
                        <!-- Nội dung chi tiết thông báo -->
                    </div>
                </div>
            </div>
        </div>

        <!-- My Class Section -->
        <div id="my-class" class="element">
            <div class="class-info-card">
                <div class="info-group">
                    <h3>Thông tin lớp học</h3>
                    <p>Lớp: <span id="current-class"></span></p>
                    <p>Giảng Viên: <span id="teacher-name"></span></p>
                    <p>Lịch Học: <span id="class-schedule"></span></p>
                </div>
                <div class="classmates-list">
                    <h3>Danh sách học sinh trong lớp</h3>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Họ và tên</th>
                                    <th>Ngày sinh</th>
                                </tr>
                            </thead>
                            <tbody id="classmates-table"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Attendance Section -->
        <div id="attendance" class="element">
            <div class="attendance-overview">
                <div class="stats-card">
                    <h3>Tỷ lệ đi học</h3>
                    <div class="progress-circle-container">
                        <div class="progress-circle" id="attendance-rate">
                            <div class="progress-value"></div>
                        </div>
                        <div class="progress-label">Tỷ lệ tham gia</div>
                    </div>
                </div>
                <div class="stats-summary">
                    <div class="stat-item">
                        <span class="stat-value" id="total-sessions">0</span>
                        <span class="stat-label">Tổng số buổi</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-value attended" id="attended-count">0</span>
                        <span class="stat-label">Đã tham gia</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-value absent" id="absent-count">0</span>
                        <span class="stat-label">Vắng mặt</span>
                    </div>
                </div>
            </div>
            <div class="attendance-history">
                <div class="history-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Người điểm danh</th>
                            </tr>
                        </thead>
                        <tbody id="attendance-history-body"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Homework Section -->
        <div id="homework" class="element">
            <div class="homework-list" id="homework-list">
                <!-- Danh sách bài tập sẽ được thêm vào đây bằng JavaScript -->
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
                    <label>Lớp:</label>
                    <input type="text" id="profile-class" readonly>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" id="profile-email">
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" id="profile-phone">
                </div>
                <div class="form-group">
                    <label>Mật khẩu cũ:</label>
                    <input type="password" id="old-password">
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới:</label>
                    <input type="password" id="new-password">
                </div>
                <button onclick="updateProfile()">Cập nhật thông tin</button>
            </div>
        </div>
    </div>

    <footer>
        <p><strong>Email:</strong> contact@actvn.edu.vn | <strong>Website:</strong> www.actvn.edu.vn</p>
        <h3>Học Viện Kỹ Thuật Mật Mã - 141 Chiến Thắng, Tân Triều, Thanh Trì, Hà Nội</h3>
        <p>Điện thoại: (024) 3854 2211 | Fax: (024) 3854 2344</p>
        <p>&copy; 2025 - Bản quyền thuộc về Học Viện Kỹ Thuật Mật Mã</p>
    </footer>

    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/student.js"></script>
    <script src="../assets/js/update_page.js"></script>
</body>

</html>