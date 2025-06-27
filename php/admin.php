<?php
session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";
include "../model/configadmin.php";

if (((isset($_COOKIE['is_login'])) && $_COOKIE['is_login'] == true) ||
    (isset($_SESSION['role'])  && $_SESSION['role'] == 0)
) {
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản được cấp quyền admin để xem trang này');</script>";
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
    <link rel="stylesheet" href="../assets/css/admin.css">
    <title>Admin Dashboard - Trung tâm Tiếng Anh</title>
    <link rel="icon" href="../assets/icon/logo_ver3.png">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <!-- Add DataTables CSS and JS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
</head>

<body>
    <!-- Header với ảnh -->
    <header>
        <img src="../assets/img/poster.jpg" alt="Logo Website">
    </header>

    <!-- Menu ngang -->
    <nav>
        <ul class="menu">
            <li><a href="#home-admin" onclick="showElement('home-admin'); return false;">Trang Chủ</a></li>
            <li><a href="#manage-classes" onclick="showElement('manage-classes'); return false;">Lớp Học</a></li>
            <li><a href="#manage-teachers" onclick="showElement('manage-teachers'); return false;">Giáo Viên</a></li>
            <li><a href="#manage-students" onclick="showElement('manage-students'); return false;">Học Sinh</a></li>
            <li><a href="#manage-parents" onclick="showElement('manage-parents'); return false;">Phụ Huynh</a></li>
            <li><a href="#statistics" onclick="showElement('statistics'); return false;">Thống Kê</a></li>
            <li><a href="#manage-news" onclick="showElement('manage-news'); return false;">Tin tức</a></li>
            <li><a href="#noti" onclick="showElement('noti');  return false;">Thông báo</a></li>

            <li>
                <a href="#account" onclick="event.preventDefault(); return false;">Tài Khoản</a>
                <ul class="submenu">
                    <li><a href="#account-info" onclick="showElement('account-info'); return false;">Thông tin tài khoản</a>
                    </li>
                    <li><a href="./logout.php">Đăng Xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- Main Content - Giữ nguyên phần nội dung cũ -->
    <div class="main-content-admin">
        <div class="main-content-admin">
            <!-- Home Section -->
            <div id="home-admin" class="element active">
                <h2>Chào mừng đến với Admin Dashboard</h2>
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon">👨‍🏫</div>
                        <div class="stat-info">
                            <h3>Giáo viên</h3>
                            <p id="home-teachers-count">
                                <?php
                                echo countRow("teachers");
                                ?>
                            </p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">👨‍🎓</div>
                        <div class="stat-info">
                            <h3>Học sinh</h3>
                            <p id="home-students-count">
                                <?php
                                echo countRow("students");
                                ?>
                            </p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📚</div>
                        <div class="stat-info">
                            <h3>Lớp học</h3>
                            <p id="home-classes-count">
                                <?php
                                echo countRow("classes");
                                ?>
                            </p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">👥</div>
                        <div class="stat-info">
                            <h3>Phụ huynh</h3>
                            <p id="home-parents-count">
                                <?php
                                echo countRow("parents");
                                ?>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="quick-actions">
                    <h3>Thao tác nhanh</h3>
                    <div class="action-buttons">
                        <button onclick="showElement('manage-classes')">Quản lý lớp</button>
                        <button onclick="showElement('manage-teachers')">Quản lý giáo viên</button>
                        <button onclick="showElement('manage-students')">Quản lý học sinh</button>
                        <button onclick="showElement('manage-parents')">Quản lý phụ huynh</button>
                    </div>
                </div>
            </div>

            <!-- Manage Classes -->
            <div id="manage-classes" class="element">
                <h2>Quản Lý Lớp Học</h2>
                <form id="class-form" class="class-form">
                    <div class="form-group">
                        <label>Tên lớp (VD: Lớp 3.1):</label>
                        <input type="text" name="className" id="class-name" placeholder="Nhập tên lớp" required>
                    </div>
                    <div class="form-group">
                        <label>Năm học:</label>
                        <input type="number" name="schoolYear" id="class-year" placeholder="VD: 2023" required>
                    </div>
                    <div class="form-group">
                        <label>Giáo viên phụ trách:</label>
                        <select name="teacherId" class="select2-search" required>
                            <option value="">Chọn giáo viên</option>
                            <?php
                            $teachers = getDataFromTable("teachers");
                            if ($teachers) {
                                foreach ($teachers as $teacher) {
                                    echo "<option value='{$teacher['UserID']}'>{$teacher['FullName']} ({$teacher['UserID']})</option>";
                                }
                            }
                            ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ngày bắt đầu:</label>
                        <input type="date" name="startDate" id="class-start-date" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày kết thúc:</label>
                        <input type="date" name="endDate" id="class-end-date" required>
                    </div>
                    <div class="form-group">
                        <label>Giờ học: (VD: Thứ 2, 4, 6 - 18:00)</label>
                        <!-- <select id="class-time" name="classTime" required>
                            <option value="">Chọn giờ học</option>
                            <option value="07:00-09:00">07:00-09:00</option>
                            <option value="09:00-11:00">09:00-11:00</option>
                            <option value="15:00-17:00">15:00-17:00</option>
                            <option value="19:00-21:00">19:00-21:00</option>
                        </select> -->
                        <input type="text" name="classTime" required>
                    </div>
                    <div class="form-group">
                        <label>Phòng học:</label>
                        <select name="room" class="select2-search" required>
                            <option value="">Chọn phòng học</option>
                            <option value="P201">P201</option>
                            <option value="P202">P202</option>
                            <option value="P203">P203</option>
                            <option value="P204">P204</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Học phí (VNĐ):</label>
                        <input type="number" name="classTuition" id="class-tuition" placeholder="Nhập học phí">
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="document.getElementById('class-form').reset()" class="refresh">Làm mới</button>
                        <button type="submit">Thêm lớp</button>
                    </div>
                </form>

                <div class="table-container">
                    <table id="class-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên lớp</th>
                                <th>Năm học</th>
                                <th>Giáo viên</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Giờ học</th>
                                <th>Phòng học</th>
                                <th>Học phí</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="class-table-body">

                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Manage Teachers Section -->
            <div id="manage-teachers" class="element">
                <h2>Quản Lý Giáo Viên</h2>
                <form id="teacher-form" class="teacher-form">
                    <div class="form-group">
                        <label>Họ và tên:</label>
                        <input type="text" name="teacherFullName" id="teacher-fullname" required>
                    </div>
                    <div class="form-group">
                        <label>Tên đăng nhập:</label>
                        <input type="text" name="teacherUsername" id="teacher-username" required>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu:</label>
                        <input type="password" name="teacherPassword" id="teacher-password">
                    </div>
                    <div class="form-group">
                        <label>Giới tính:</label>
                        <select id="teacher-gender" name="teacherGender" required>
                            <option value="">Chọn giới tính</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="teacherEmail" id="teacher-email" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="tel" name="teacherPhone" id="teacher-phone" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh:</label>
                        <input type="date" name="teacherBirthdate" id="teacher-birthdate" required>
                    </div>
                    <div class="form-group">
                        <label>Lương (VNĐ):</label>
                        <input type="number" name="teacherSalary" id="teacher-salary" required>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="document.getElementById('teacher-form').reset()" class="refresh">Làm mới</button>
                        <button type="submit" onclick="addTeacher()">Thêm giáo viên</button>
                    </div>
                </form>

                <div class="table-container">
                    <table id="teacher-table" class="teacher-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và tên</th>
                                <th>Giới tính</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Ngày sinh</th>
                                <th>Lương</th>
                                <th>ID Lớp phụ trách</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="teacher-table-body"></tbody>
                    </table>
                </div>
            </div>

            <!-- Manage Students -->
            <div id="manage-students" class="element">
                <h2>Quản Lý Học Sinh</h2>
                <form id="student-form" class="student-form">
                    <div class="form-group">
                        <label>Họ và tên:</label>
                        <input type="text" name="studentFullName" id="student-fullname" required>
                    </div>
                    <div class="form-group">
                        <label>Tên đăng nhập:</label>
                        <input type="text" name="studentUsername" id="student-username" required>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu:</label>
                        <input type="password" name="studentPassword" id="student-password">
                    </div>
                    <div class="form-group">
                        <label>Giới tính:</label>
                        <select id="student-gender" name="studentGender" required>
                            <option value="">Chọn giới tính</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="studentEmail" id="student-email" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="tel" name="studentPhone" id="student-phone" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh:</label>
                        <input type="date" name="studentDate" id="student-birthdate" required>
                    </div>
                    <div class="form-group">
                        <label>Lớp:</label>
                        <select name="studentClass" class="select2-search">
                            <option value="">Chọn lớp</option>
                            <?php
                            $classes = getDataFromTable("classes");
                            if ($classes) {
                                foreach ($classes as $class) {
                                    if ($class['Status'] == "Đang hoạt động")
                                        echo "<option value='{$class['ClassID']}'>{$class['ClassName']} ({$class['SchoolYear']})</option>";
                                }
                            }
                            ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Phụ huynh (có thể chọn nhiều):</label>
                        <select name="parentID[]" class="select2-search" multiple>
                            <option value="">Chọn phụ huynh</option>
                            <?php
                            $parents = getDataFromTable("parents");
                            if ($parents) {
                                foreach ($parents as $parent) {
                                    echo "<option value='{$parent['UserID']}'>{$parent['FullName']} ({$parent['UserID']})</option>";
                                }
                            }
                            ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Giảm học phí (%):</label>
                        <input type="number" name="studentDiscount" id="student-discount" min="0" max="100" step="1" placeholder="0-100">
                    </div>

                    <div class="form-actions">
                        <button type="button" onclick="document.getElementById('student-form').reset()" class="refresh">Làm mới</button>
                        <button type="submit">Thêm học sinh</button>
                    </div>
                </form>

                <div class="table-container">
                    <table id="student-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và tên</th>
                                <th>Giới tính</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Ngày sinh</th>
                                <th>ID Lớp</th>
                                <th>Phụ huynh</th>
                                <th>Số buổi học</th>
                                <th>Số buổi nghỉ</th>
                                <th>Giảm học phí</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="student-table-body"></tbody>
                    </table>
                </div>
            </div>

            <!-- Manage Parents -->
            <div id="manage-parents" class="element">
                <h2>Quản Lý Phụ Huynh</h2>
                <form id="parent-form" class="parent-form">
                    <div class="form-group">
                        <label>Họ và tên:</label>
                        <input type="text" name="parentFullName" id="parent-fullname" required>
                    </div>
                    <div class="form-group">
                        <label>Tên đăng nhập:</label>
                        <input type="text" name="parentUserName" id="parent-username" required>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu:</label>
                        <input type="password" name="parentPassword" id="parent-password">
                    </div>
                    <div class="form-group">
                        <label>Giới tính:</label>
                        <select id="parent-gender" name="parentGender" required>
                            <option value="">Chọn giới tính</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="parentEmail" id="parent-email" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="tel" name="parentPhone" id="parent-phone" required>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh:</label>
                        <input type="date" name="parentBirthdate" id="parent-birthdate" required>
                    </div>
                    <div class="form-group">
                        <label>Zalo ID:</label>
                        <input type="text" name="parentZalo" id="parent-zalo" placeholder="Nhập Zalo ID">
                    </div>
                    <div class="form-group">
                        <label>Hiển thị thông tin giáo viên:</label>
                        <select name="isShowTeacher" id="parent-show-teacher">
                            <option value="0">Không cho phép xem</option>
                            <option value="1">Cho phép xem</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="document.getElementById('parent-form').reset()" class="refresh">Làm mới</button>
                        <button type="submit">Thêm phụ huynh</button>
                    </div>
                </form>

                <div class="table-container">
                    <table id="parent-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và tên</th>
                                <th>Giới tính</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Ngày sinh</th>
                                <th>Zalo ID</th>
                                <th>Con</th>
                                <th>Số tiền chưa đóng</th>
                                <th>Xem thông tin GV</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="parent-table-body"></tbody>
                    </table>
                </div>
            </div>

            <!-- Statistics -->
            <div id="statistics" class="element">
                <h2>Thống Kê</h2>
                <div class="form-group">
                    <div class="filter-type">
                        <label>Chọn cách thống kê:</label>
                        <select id="stats-filter-type" onchange="changeFilterType()">
                            <option value="month">Theo tháng</option>
                            <option value="custom">Tùy chọn</option>
                            <option value="quarter">Theo quý</option>
                            <option value="year">Theo năm</option>
                        </select>
                    </div>

                    <div id="custom-filter" class="statistics__time" style="display:none;">
                        <span>Từ</span>
                        <input type="date" id="stats-start" required>
                        <span>đến</span>
                        <input type="date" id="stats-end" required>
                    </div>

                    <div id="month-filter" class="statistics__time">
                        <select id="stats-month">
                            <?php
                            for ($i = 1; $i <= 12; $i++) {
                                echo "<option value='$i'>Tháng $i</option>";
                            }
                            ?>
                        </select>
                        <select id="stats-year-month">
                            <?php
                            $currentYear = date('Y');
                            for ($i = $currentYear - 5; $i <= $currentYear + 5; $i++) {
                                $selected = ($i == $currentYear) ? 'selected' : '';
                                echo "<option value='$i' $selected>Năm $i</option>";
                            }
                            ?>
                        </select>
                    </div>

                    <div id="quarter-filter" class="statistics__time" style="display:none;">
                        <select id="stats-quarter">
                            <option value="1">Quý 1 (Tháng 1-3)</option>
                            <option value="2">Quý 2 (Tháng 4-6)</option>
                            <option value="3">Quý 3 (Tháng 7-9)</option>
                            <option value="4">Quý 4 (Tháng 10-12)</option>
                        </select>
                        <select id="stats-year-quarter">
                            <?php
                            $currentYear = date('Y');
                            for ($i = $currentYear - 5; $i <= $currentYear + 5; $i++) {
                                $selected = ($i == $currentYear) ? 'selected' : '';
                                echo "<option value='$i' $selected>Năm $i</option>";
                            }
                            ?>
                        </select>
                    </div>

                    <div id="year-filter" class="statistics__time" style="display:none;">
                        <select id="stats-year">
                            <?php
                            $currentYear = date('Y');
                            for ($i = $currentYear - 5; $i <= $currentYear + 5; $i++) {
                                $selected = ($i == $currentYear) ? 'selected' : '';
                                echo "<option value='$i' $selected>Năm $i</option>";
                            }
                            ?>
                        </select>
                    </div>

                    <div class="button-container">
                        <button onclick="loadStatistics()">Xem thống kê</button>
                    </div>
                </div>
                <div id="stats-results">
                    <p>Tổng tiền dự kiến: <span id="total-expected">0</span> VNĐ</p>
                    <p>Tổng tiền đã thu: <span id="total-collected">0</span> VNĐ</p>
                    <p>Số học sinh tăng: <span id="students-increased">0</span></p>
                    <p>Số học sinh giảm: <span id="students-decreased">0</span></p>
                    <p>Tổng lương giáo viên: <span id="total-salary">0</span> VNĐ</p>
                    <p>Số giáo viên hiện tại: <span id="teacher-count">0</span></p>
                </div>
            </div>

            <!-- Manage-news -->
            <div id="manage-news" class="element">
                <h2>Quản lý tin tức</h2>

                <form id="newsForm" action="../../php/add_news.php" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="title">Tiêu đề tin tức:</label>
                        <input type="text" id="title" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="excerpt">Tóm tắt:</label>
                        <textarea id="excerpt" name="excerpt" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="content">Nội dung:</label>
                        <textarea id="content" name="content" style="height: 200px;" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="image">Hình ảnh:</label>
                        <input type="file" id="image" name="image" accept="image/*" onchange="previewImage(this, 'imagePreview')" required>
                        <div id="imagePreview" class="image-preview">
                            <!-- Ảnh xem trước sẽ hiển thị ở đây -->
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="author">Tác giả:</label>
                        <input type="text" id="author" name="author" required>
                    </div>

                    <button type="submit">Đăng bài</button>
                </form>
                <h2 class="existPost">Bài viết đã có</h2>
                <div id="newsList" class="newsList">

                    <!-- Danh sách tin tức sẽ được load từ database -->
                </div>
            </div>

            <!-- Notification -->
            <div id="noti" class="element">
                <h2>Gửi thông báo</h2>
                <form id="notification-form" class="notification-form">
                    <div class="form-group">
                        <label>Người nhận:</label>
                        <select name="receiverId" class="recipient-select" style="width: 100%; padding:10px 12px;" required>
                            <option value="">Chọn người nhận</option>
                            <?php
                            // Get teachers
                            $teachers = getDataFromTable("teachers");
                            if ($teachers) {
                                echo "<optgroup label='Giáo viên'>";
                                foreach ($teachers as $teacher) {
                                    echo "<option value='{$teacher['UserID']}'>{$teacher['FullName']} (GV)</option>";
                                }
                                echo "</optgroup>";
                            }

                            // Get students
                            $students = getDataFromTable("students");
                            if ($students) {
                                echo "<optgroup label='Học sinh'>";
                                foreach ($students as $student) {
                                    echo "<option value='{$student['UserID']}'>{$student['FullName']} (HS)</option>";
                                }
                                echo "</optgroup>";
                            }

                            // Get parents
                            $parents = getDataFromTable("parents");
                            if ($parents) {
                                echo "<optgroup label='Phụ huynh'>";
                                foreach ($parents as $parent) {
                                    echo "<option value='{$parent['UserID']}'>{$parent['FullName']} (PH)</option>";
                                }
                                echo "</optgroup>";
                            }
                            ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Chủ đề:</label>
                        <input type="text" name="subject" required>
                    </div>
                    <div class="form-group">
                        <label>Nội dung:</label>
                        <textarea name="content" required rows="4"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Phương thức gửi:</label>
                        <div class="send-methods">
                            <label>
                                <input type="checkbox" name="sendMethods[]" value="web" checked> Website
                            </label>
                            <label class="disabled" title="Chưa triển khai">
                                <input type="checkbox" name="sendMethods[]" value="zalo" disabled> Zalo
                            </label>
                            <label class="disabled" title="Chưa triển khai">
                                <input type="checkbox" name="sendMethods[]" value="gmail" disabled> Gmail
                            </label>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Gửi thông báo</button>
                        <button type="button" onclick="document.getElementById('notification-form').reset()" class="refresh">Làm mới</button>
                    </div>
                </form>

                <div class="message-history">
                    <h3>Lịch sử thông báo</h3>
                    <div class="table-container">
                        <table id="message-table">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Người nhận</th>
                                    <th>Chủ đề</th>
                                    <th class="message-content">Nội dung</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody id="message-table-body">
                                <!-- Will be filled by JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Add Account Info Section -->
            <div id="account-info" class="element">
                <h2>Thông Tin Tài Khoản</h2>
                <div class="admin-profile">
                    <div class="admin-header">
                        <div class="admin-avatar">
                            <img src="../assets/img/admin.png" alt="Admin Avatar">
                        </div>
                        <div class="admin-info">
                            <h3>Admin</h3>
                            <p>Quản trị viên hệ thống</p>
                            <p>Email: admin@example.com</p>
                        </div>
                    </div>

                    <div class="admin-stats">
                        <div class="stat-box">
                            <h4>Tổng số lớp</h4>
                            <p id="total-classes-count">
                                <?php
                                countRow("classes");
                                ?>
                            </p>
                        </div>
                        <div class="stat-box">
                            <h4>Tổng số giáo viên</h4>
                            <p id="total-teachers-count">
                                <?php
                                countRow("teachers");
                                ?>
                            </p>
                        </div>
                        <div class="stat-box">
                            <h4>Tổng số học sinh</h4>
                            <p id="total-students-count">
                                <?php
                                countRow("students");
                                ?>
                            </p>
                        </div>
                    </div>

                    <!-- Add password change form -->
                    <div class="password-change-form">
                        <h3>Đổi mật khẩu</h3>
                        <form id="admin-password-form">
                            <div class="form-group">
                                <label>Mật khẩu hiện tại:</label>
                                <input type="password" id="current-password" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label>Mật khẩu mới:</label>
                                <input type="password" id="new-password" name="newPassword" required>
                            </div>
                            <div class="form-group">
                                <label>Xác nhận mật khẩu mới:</label>
                                <input type="password" id="confirm-password" name="confirmPassword" required>
                            </div>
                            <div class="form-actions">
                                <button type="submit">Đổi mật khẩu</button>
                            </div>
                        </form>
                    </div>


                </div>
            </div>


        </div>
    </div>


    <!-- Pop Up-->
    <div class="popup-overlay-2"></div>

    <div class="edit-popup" id="edit-popup">
        <h3>Chỉnh sửa thông tin</h3>
        <form id="edit-form">
            <!-- Form sẽ được điền động bởi JavaScript -->
        </form>
        <form id="edit-news"></form>
        <div class="popup-buttons">
            <button type="submit" form="edit-form">Lưu</button>
            <button onclick="closePopup()">Hủy</button>
        </div>
    </div>

    <div class="confirm-popup" id="confirm-popup">
        <h3>Xác nhận xóa</h3>
        <p>Bạn có chắc chắn muốn xóa mục này?</p>
        <div class="popup-buttons">
            <button class="confirm" id="confirm-yes">Xóa</button>
            <button class="cancel" onclick="closePopup()">Hủy</button>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p><strong>Email:</strong> contact@actvn.edu.vn | <strong>Website:</strong> www.actvn.edu.vn</p>
        <h3>Học Viện Kỹ Thuật Mật Mã - 141 Chiến Thắng, Tân Triều, Thanh Trì, Hà Nội</h3>
        <p>Điện thoại: (024) 3854 2211 | Fax: (024) 3854 2344</p>
        <p>&copy; 2025 - Bản quyền thuộc về Học Viện Kỹ Thuật Mật Mã</p>
    </footer>

    <script src="../assets/js/admin.js"></script>
    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/update_page.js"></script>
    <script>
        $(document).ready(function() {
            function initializeDatatable(selector) {
                if ($.fn.DataTable.isDataTable(selector)) {
                    $(selector).DataTable().destroy();
                }
                
                return $(selector).DataTable({
                    responsive: {
                        details: {
                            type: 'column',
                            target: 'tr'
                        }
                    },
                    dom: '<"top"lf>rt<"bottom"ip><"clear">',
                    autoWidth: false,
                    scrollX: false,
                    language: {
                        emptyTable: "Không có dữ liệu",
                        info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                        infoEmpty: "Hiển thị 0 đến 0 của 0 mục",
                        infoFiltered: "(được lọc từ _MAX_ mục)",
                        thousands: ",",
                        lengthMenu: "Hiển thị _MENU_ mục",
                        loadingRecords: "Đang tải...",
                        processing: "Đang xử lý...",
                        search: "Tìm kiếm:",
                        zeroRecords: "Không tìm thấy kết quả phù hợp",
                        paginate: {
                            first: "Đầu",
                            last: "Cuối",
                            next: "Sau",
                            previous: "Trước"
                        }
                    },
                    pageLength: 5,
                    lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
                    columnDefs: [
                        {
                            className: 'control',
                            orderable: false,
                            targets: 0
                        },
                        {
                            responsivePriority: 1,
                            targets: [0, 1, -1]
                        }
                    ],
                    order: [[1, 'asc']]
                });
            }

            // Initialize tables only when they become visible
            function initializeVisibleTables() {
                $('.element:visible table').each(function() {
                    const tableId = '#' + $(this).attr('id');
                    if ($(tableId).is(':visible')) {
                        initializeDatatable(tableId);
                    }
                });
            }

            // Initial initialization
            initializeVisibleTables();

            // Initialize when switching tabs
            $('.menu a').on('click', function() {
                setTimeout(initializeVisibleTables, 100);
            });

            $('.action-buttons button').on('click', function() {
                setTimeout(initializeVisibleTables, 100);
            });

            // Initialize select2 dropdowns
            $('.select2-dropdown, .recipient-select, .select2-search').select2({
                width: '100%',
                placeholder: "Tìm kiếm...",
                allowClear: true,
                language: {
                    noResults: () => "Không tìm thấy kết quả",
                    searching: () => "Đang tìm kiếm..."
                }
            });
        });
    </script>

    <!-- Add this button right after the <body> tag -->
    <button class="menu-toggle" onclick="toggleMenu()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Add this right after the body tag -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>
</body>

</html>