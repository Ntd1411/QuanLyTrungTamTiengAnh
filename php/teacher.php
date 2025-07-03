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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/teacher.css">
    <title>Teacher Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
</head>

<body>

    <!-- Nút hiện menu cho điện thoại -->
    <button class="menu-toggle" onclick="toggleMenu()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Lớp phủ lên trang phía sau khi hiện menu -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>
    <!-- Header với ảnh -->
    <header>
        <img src="../assets/img/poster.jpg" alt="Poster Website">
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
                <a href="#account" onclick="event.preventDefault();">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#profile" onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- Nội dung chính -->
    <div class="main-content-teacher">
        <!-- Phần trang chủ -->
        <div id="home-teacher" class="element active">
            <h2>Chào mừng, giáo viên <span id="teacher-name"></span></h2>
            <div class="dashboard-summary">
                <div class="summary-card" onclick="showElement('schedule')">
                    <h3>🔜 Buổi dạy tiếp theo</h3>
                    <div id="next-session-info">Không có thông tin</div>
                </div>
                <div class="summary-card" onclick="showElement('my-classes')">
                    <h3>👨‍🎓 Tổng học sinh các lớp đang dạy</h3>
                    <p id="total-students">0</p>
                </div>
                <div class="summary-card">
                    <h3>📅 Số buổi đã dạy tháng này</h3>
                    <p id="monthly-sessions">0</p>
                </div>
            </div>
            <div class="log-header">
                <h2>Nhật ký dạy</h2>
                <button id="add-log-btn" class="add-log-btn">+ Thêm nhật ký</button>
            </div>
            <div id="add-log-modal" class="modal" style="display:none;">
                <div class="modal-content">
                    <span class="close-modal" onclick="closeAddLogModal()">&times;</span>
                    <h3 id="add-log-header">Thêm nhật ký dạy</h3>
                    <div class="form-group">
                        <label>Lớp:</label>
                        <select id="log-class-select"></select>
                    </div>
                    <div class="form-group">
                        <label>Ngày dạy:</label>
                        <input type="date" id="log-date-input" value="">
                    </div>
                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <select id="log-status-select">
                            <option value="Đã dạy">Đã dạy</option>
                            <option value="Nghỉ">Nghỉ</option>
                            <option value="Dời lịch">Dời lịch</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ghi chú:</label>
                        <input type="text" id="log-note-input">
                    </div>
                    <button onclick="submitAddLog()">Lưu nhật ký</button>
                </div>
            </div>
            <div class="teaching-log-table table-container">
                <table id="teaching-log">
                    <thead>
                        <tr>
                            <th>Ngày dạy</th>
                            <th>Lớp</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="teaching-log-body"></tbody>
                </table>
            </div>
        </div>

        <!-- Phần lịch dạy -->
        <div id="schedule" class="element">
            <h2>Lịch Dạy</h2>
            <div class="schedule-container">
                <div class="schedule-header">
                    <div class="form-group">
                        <label>Xem theo tuần:</label>
                        <input type="week" id="schedule-week">
                    </div>
                    <button id="view-schedule-btn" onclick="viewSchedule()">Xem lịch</button>
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
                            <!-- Lịch sẽ được cung cấp bởi JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Phần lớp học -->
        <div id="my-classes" class="element">
            <div class="classes-container">
                <h2 id="no-teaching-class" style="display: none; margin-top: 20px">Bạn đang không dạy lớp nào.</h2>
                <!-- Danh sách lớp sẽ được thêm vào đây bằng JavaScript -->
            </div>

            <div class="class-students-list" style="display:none;">
                <h3>Danh sách học sinh</h3>
                <div class="table-container">
                    <table id="student-datatable" class="display" style="width:100%">
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
                        <tbody>
                            <!-- Danh sách học sinh sẽ được thêm vào đây bằng JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Phần điểm danh học viên -->
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
                <div class="button-center">
                    <button onclick="submitAttendance()">Lưu điểm danh</button>
                    <button id="view-history-btn" onclick="viewAttendanceHistory()" style="margin-left:12px;">Xem lịch sử điểm danh</button>
                    <button id="hide-history-btn" onclick="hideAttendanceHistory()" style="margin-left:12px;">Ẩn lịch sử điểm danh</button>
                </div>
                <div id="attendance-history" class="table-container">
                    <table id="attendance-history-table" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Họ và tên</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Lịch sử điểm danh sẽ được thêm vào đây bằng JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Popup sửa điểm danh -->
        <div id="attendance-modal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close-modal" onclick="document.getElementById('attendance-modal').style.display='none'">X</span>
                <h3>Sửa điểm danh</h3>
                <div class="form-group">
                    <label>Tên học sinh:</label>
                    <input type="text" id="student-name-input" readonly>
                </div>
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select id="status-select">
                        <option value="Có mặt">Có mặt</option>
                        <option value="Vắng mặt">Vắng mặt</option>
                        <option value="Đi muộn">Đi muộn</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ghi chú:</label>
                    <input type="text" id="note-input">
                </div>
                <input type="hidden" id="student-id-input"> <!-- Input ẩn lưu ID học sinh -->
                <button onclick="saveUpdate()">Cập nhật</button>
                <button onclick="document.getElementById('attendance-modal').style.display='none'">Hủy</button>
            </div>
        </div>

        <!-- Phần thông báo -->
        <div id="notifications" class="element">
            <!-- Nút gửi thông báo -->
            <div class="notifications-header">
                <button id="send-notification-btn">+ Gửi thông báo cho học sinh</button>
            </div>

            <!-- Bảng thông báo đã nhận -->
            <h3>Thông báo đã nhận</h3>
            <div id="teacher-pagination-container"></div>
            <div class="message-container">
                <div class="message-list" id="teacher-received-list">
                    <!-- Danh sách thông báo đã nhận sẽ được thêm bằng JS -->
                </div>
                <div class="message-detail">
                    <div class="message-content" id="teacher-received-detail">
                        <!-- Nội dung chi tiết thông báo đã nhận -->
                    </div>
                </div>
            </div>

            <!-- Bảng thông báo đã gửi -->
            <h3>Thông báo đã gửi</h3>
            <div class="table-container">
                <table id="table-sent-notifications" class="display">
                    <thead>
                        <tr>
                            <th>Ngày gửi</th>
                            <th>Lớp</th>
                            <th>Loại</th>
                            <th>Nội dung</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Danh sách thông báo đã gửi sẽ được thêm bằng JS -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Popup gửi thông báo -->
        <div id="send-notification-modal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeSendNotificationModal()">&times;</span>
                <h3>Gửi thông báo cho học sinh</h3>
                <div class="form-group">
                    <label>Lớp:</label>
                    <select id="notification-class-select"></select>
                </div>
                <div class="form-group">
                    <label>Loại thông báo:</label>
                    <select id="notification-type-select">
                        <option value="Khác">Khác</option>
                        <option value="Bài tập về nhà">Bài tập về nhà</option>
                        <option value="Nghỉ học">Nghỉ học</option>
                        <option value="Kiểm tra">Kiểm tra</option>
                    </select>
                </div>
                <div class="form-group" id="homework-deadline-group">
                    <label>Hạn nộp bài tập:</label>
                    <input type="date" id="homework-deadline-input">
                </div>
                <div class="form-group">
                    <label>Nội dung:</label>
                    <textarea id="notification-content-input" rows="4"></textarea>
                </div>
                <button onclick="submitSendNotification()">Gửi thông báo</button>
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
                    <label>Email:</label>
                    <input type="email" id="profile-email" readonly>
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" id="profile-phone">
                </div>
                <div class="form-group">
                    <label>Mật khẩu cũ:</label>
                    <input type="password" id="profile-old-password">
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới:</label>
                    <input type="password" id="profile-new-password">
                </div>
                <button id="form-group-button" onclick="updateProfile()">Cập nhật thông tin</button>
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