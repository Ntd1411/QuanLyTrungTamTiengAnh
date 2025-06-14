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
                <a href="#account">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#profile" onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="../index.html">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="main-content-student">
        <!-- Home Section -->
        <div id="home-student" class="element active">
            <h2>Chào mừng, <span id="student-name">Học sinh</span></h2>
            <div class="dashboard-summary">
                <div class="summary-card">
                    <h3>Lớp học</h3>
                    <p id="class-name">Lớp 3.1</p>
                </div>
                <div class="summary-card">
                    <h3>Buổi đã học</h3>
                    <p id="attended-sessions">0</p>
                </div>
                <div class="summary-card warning">
                    <h3>Buổi nghỉ</h3>
                    <p id="absent-sessions">0</p>
                </div>
                <div class="summary-card">
                    <h3>Bài tập mới</h3>
                    <p id="new-homework">0</p>
                </div>
            </div>
        </div>

        <!-- My Class Section -->
        <div id="my-class" class="element">
            <div class="class-info-card">
                <div class="info-group">
                    <h3>Thông tin chung</h3>
                    <p>Lớp: <span id="current-class">Lớp 3.1</span></p>
                    <p>Giáo viên: <span id="teacher-name">Cô Thanh Hương</span></p>
                    <p>Thời gian học: <span id="class-schedule">Thứ 2-4-6 (18:00-19:30)</span></p>
                </div>
                <div class="classmates-list">
                    <h3>Danh sách học sinh trong lớp</h3>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Họ và tên</th>
                                    <th>Số buổi học</th>
                                    <th>Số buổi nghỉ</th>
                                    <th>Tỷ lệ tham gia</th>
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
                <div class="history-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Giáo viên</th>
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
                    <label>Mật khẩu mới:</label>
                    <input type="password" id="profile-password">
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
</body>
</html>
