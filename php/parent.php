<?php
session_start();
ob_start();

if (
    (isset($_COOKIE['is_login']) && $_COOKIE['is_login'] == true && isset($_COOKIE['role']) && $_COOKIE['role'] == 3 && isset($_COOKIE['username']))
    || (isset($_SESSION['role']) && $_SESSION['role'] == 3 && isset($_SESSION['username']))
) {
    $username = isset($_SESSION['username']) ? $_SESSION['username'] : $_COOKIE['username'];
    $role = isset($_SESSION['role']) ? $_SESSION['role'] : $_COOKIE['role'];
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản phụ huynh để xem trang này');</script>";
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
    <link rel="stylesheet" href="../assets/css/parent.css">
    <title>Parent Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
</head>

<body>

    <!-- Add menu toggle button -->
    <button class="menu-toggle" onclick="toggleMenu()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Add menu overlay -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>
    
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <nav>
        <ul class="menu">
            <li><a onclick="showElement('home-parent'); return false;">Trang Chủ</a></li>
            <li><a onclick="showElement('children'); return false;">Con</a></li>
            <li><a onclick="showElement('payments'); return false;">Học Phí</a></li>
            <li><a onclick="showElement('messages'); return false;">Thông báo</a></li>
            <li>
                <a onclick="event.preventDefault();">Tài Khoản</a>
                <ul class="submenu">
                    <li><a onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="main-content-parent">
        <!-- Home Section -->
        <div id="home-parent" class="element active">
            <h2>Chào mừng phụ huynh <span id="parent-name"></span></h2>
            <div class="dashboard-summary">
                <div class="summary-card" onclick="showElement('children')">
                    <h3>Số con đang học</h3>
                    <p id="total-children">0</p>
                </div>
                <div class="summary-card warning" onclick="showElement('payments')">
                    <h3>Học phí chưa đóng</h3>
                    <p id="unpaid-amount">0 VNĐ</p>
                </div>
                <div class="summary-card" onclick="showElement('messages')">
                    <h3>Thông báo mới</h3>
                    <p id="new-messages">0</p>
                </div>
            </div>
        </div>

        <!-- Children Section -->
        <div id="children" class="element">
            <div class="children-list">
                <!-- Danh sách con sẽ được thêm vào đây bằng JavaScript -->
            </div>
        </div>

        <!-- Payments Section -->
        <div id="payments" class="element">
            <div class="payment-summary">
                <h3>Tổng quan</h3>
                <div class="payment-info">
                    <p>Tổng học phí: <span id="total-fee">0 VNĐ</span></p>
                    <p>Đã giảm: <span id="discount-amount">0 VNĐ</span></p>
                    <p>Đã đóng: <span id="paid-amount">0 VNĐ</span></p>
                    <p>Còn nợ: <span id="remaining-amount">0 VNĐ</span></p>
                    <button onclick="payFees()">Đóng học phí</button>
                </div>
                <div class="payment-history">
                    <h3>Lịch sử đóng học phí</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Con</th>
                                <th>Số tiền đóng</th>
                                <th>Ghi chú</th>
                                <th>Người đóng</th>
                            </tr>
                        </thead>
                        <tbody id="payment-history-body"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Popup Modal Form -->
        <div id="pay-fee-modal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="hidePayFeeForm()">&times;</span>
                <form id="feeForm">
                    <label>Chọn con:
                        <select id="fee-student" required></select>
                    </label><br>
                    <label>Số tài khoản ngân hàng:
                        <input type="text" id="fee-bank" required>
                    </label><br>
                    <label>Số tiền đóng:
                        <input type="number" id="fee-amount" min="1" required>
                    </label><br>
                    <label>Ghi chú:
                        <input type="text" id="fee-note">
                    </label><br>
                    <button type="submit">Nộp tiền</button>
                    <button type="button" onclick="hidePayFeeForm()">Hủy</button>
                </form>
            </div>
        </div>

        <!-- Messages Section -->
        <div id="messages" class="element">
            <div class="message-container">
                <div class="message-list">
                    <!-- Danh sách tin nhắn sẽ được thêm vào đây -->
                </div>
                <div class="message-detail">
                    <div class="message-content">
                        <!-- Nội dung tin nhắn chi tiết -->
                    </div>
                </div>
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
                    <input type="email" id="profile-email">
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" id="profile-phone">
                </div>
                <div class="form-group">
                    <label>Zalo ID:</label>
                    <input type="text" id="profile-zalo">
                </div>
                <div class="form-group">
                    <label>Mật khẩu cũ:</label>
                    <input type="password" id="profile-old-password">
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới:</label>
                    <input type="password" id="profile-new-password">
                </div>
                <button class="btn-update" onclick="updateProfile()">Cập nhật thông tin</button>
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
    <script src="../assets/js/parent.js"></script>
    <script src="../assets/js/update_page.js"></script>
</body>

</html>