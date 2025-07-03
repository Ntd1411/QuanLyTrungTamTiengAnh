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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/student.css">
    <title>Student Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
</head>

<body>


    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <nav>
        <ul class="menu">
            <li><a onclick="showElement('home-student'); event.preventDefault();">Trang Chủ</a></li>
            <li><a onclick="showElement('my-class'); event.preventDefault();">Lớp Học</a></li>
            <li><a onclick="showElement('attendance'); event.preventDefault();">Điểm Danh</a></li>
            <li><a onclick="showElement('homework'); event.preventDefault();">Bài Tập</a></li>
            <li>
                <a onclick="event.preventDefault()">Tài Khoản</a>
                <ul class="submenu">
                    <li><a onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="main-content-student">
        <!-- Phần trang chủ -->
        <div id="home-student" class="element active">
            <h2>Chào mừng, <span id="student-name">Học sinh</span></h2>
            <div class="dashboard-summary">
                <div class="summary-card" onclick="showElement('my-class')">
                    <h3>📚 Lớp học</h3>
                    <p id="class-name">Chưa trong lớp nào</p>
                </div>
                <div class="summary-card" onclick="showElement('attendance')">
                    <h3>✅ Buổi đã học</h3>
                    <p id="attended-sessions">0</p>
                </div>
                <div class="summary-card warning" onclick="showElement('attendance')">
                    <h3>❌ Buổi nghỉ</h3>
                    <p id="absent-sessions">0</p>
                </div>
                <div class="summary-card" onclick="showElement('homework')">
                    <h3>📝 Bài tập chưa làm</h3>
                    <p id="new-homework">0</p>
                </div>
            </div>
            <h2>Thông báo</h2>
            <!-- Phân trang cho thông báo -->
            <div id="student-pagination-container"></div>
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

        <!-- Phần lớp học -->
        <div id="my-class" class="element">
            <div class="class-info-card">
                <div class="info-group">
                    <h3 id="class-information">Thông tin lớp học</h3>
                    <p>Lớp: <span id="current-class"></span></p>
                    <p>Giảng Viên: <span id="teacher-name"></span></p>
                    <p>Lịch Học: <span id="class-schedule"></span></p>
                    <p>Trạng thái: <span id="class-status"></span></p>
                </div>
                <div class="classmates-list" id="classmates-list-div">
                    <h3>Danh sách học sinh trong lớp</h3>

                    <div class="table-container">
                        <table id="table-classmates" class="display" style="width:100%">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Họ và tên</th>
                                    <th>Ngày sinh</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- DataTables sẽ điền dữ liệu vào đây -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Phần điểm danh -->
        <div id="attendance" class="element">
            <div class="attendance-overview">
                <div class="stats-card">
                    <h3>Tỷ lệ đi học</h3>
                    <div class="progress-circle-container">
                        <div class="progress-circle" id="attendance-rate">
                            <div class="progress-value">0%</div>
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
                <h3>Lịch sử điểm danh</h3>

                <div class="table-container">
                    <table id="table-attendance-history" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Người điểm danh</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Phần btvn -->
        <div id="homework" class="element">
            <div class="homework-list" id="homework-list">
                <!-- Danh sách bài tập sẽ được thêm vào đây bằng JavaScript -->
            </div>
        </div>

        <!-- Phần thông tin cá nhân -->
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
                <button class="btn-update-student" onclick="updateProfile()">Cập nhật thông tin</button>
            </div>
        </div>
    </div>

    <footer>
        <p><strong>Email:</strong> contact@actvn.edu.vn | <strong>Website:</strong> www.actvn.edu.vn</p>
        <h3>Học Viện Kỹ Thuật Mật Mã - 141 Chiến Thắng, Tân Triều, Thanh Trì, Hà Nội</h3>
        <p>Điện thoại: (024) 3854 2211 | Fax: (024) 3854 2344</p>
        <p>&copy; 2025 - Bản quyền thuộc về Học Viện Kỹ Thuật Mật Mã</p>
    </footer>

        <!-- Nút hiện menu cho màn hình nhỏ -->
    <button class="menu-toggle" onclick="toggleMenu()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Lớp phủ menu -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>

    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/student.js"></script>
    <script src="../assets/js/update_page.js"></script>
</body>

</html>