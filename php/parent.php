<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/parent.css">
    <title>Parent Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
</head>
<body>
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <nav>
        <ul class="menu">
            <li><a href="#home-parent" onclick="showElement('home-parent'); return false;">Trang Chủ</a></li>
            <li><a href="#children" onclick="showElement('children'); return false;">Con</a></li>
            <li><a href="#payments" onclick="showElement('payments'); return false;">Học Phí</a></li>
            <li><a href="#messages" onclick="showElement('messages'); return false;">Tin Nhắn</a></li>
            <li>
                <a href="#account">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#profile" onclick="showElement('profile'); return false;">Thông tin cá nhân</a></li>
                    <li><a href="../index.html">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="main-content-parent">
        <!-- Home Section -->
        <div id="home-parent" class="element active">
            <h2>Chào mừng, <span id="parent-name">Phụ huynh</span></h2>
            <div class="dashboard-summary">
                <div class="summary-card">
                    <h3>Số con đang học</h3>
                    <p id="total-children">0</p>
                </div>
                <div class="summary-card warning">
                    <h3>Học phí chưa đóng</h3>
                    <p id="unpaid-amount">0 VNĐ</p>
                </div>
                <div class="summary-card">
                    <h3>Tin nhắn mới</h3>
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
                </div>
                <div class="payment-history">
                    <h3>Lịch sử đóng học phí</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Con</th>
                                <th>Số tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody id="payment-history-body"></tbody>
                    </table>
                </div>
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
    <script src="../assets/js/parent.js"></script>
</body>
</html>
