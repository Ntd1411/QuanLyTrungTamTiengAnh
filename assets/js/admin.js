// Xử lý class
document.getElementById('class-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    formData.append('action', 'addClass');

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                e.target.reset();
                loadClasses(); // Gọi hàm load lại danh sách
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể thêm lớp'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm lớp: ' + error.message);
        });
});

function loadClasses() {
    fetch('admincrud.php?action=getClasses', {
        method: 'post'
    })
        .then(response => response.text())
        .then(html => {
            document.getElementById('class-table-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading classes:', error);
        });
}

// Gọi loadClasses khi trang được tải
document.addEventListener('DOMContentLoaded', loadClasses);


// Xử lý teacher
document.getElementById('teacher-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'addTeacher');

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                this.reset();
                loadTeachers();
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể thêm giáo viên'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm giáo viên: ' + error.message);
        });
});

function loadTeachers() {
    fetch('admincrud.php?action=getTeachers', {
        method: 'post'
    })
        .then(response => response.text())
        .then(html => {
            document.getElementById('teacher-table-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading teacher:', error);
        });
}

// Gọi loadTeachers khi trang được tải
document.addEventListener('DOMContentLoaded', loadTeachers);


// Xử lý students
document.getElementById('student-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'addStudent');

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                this.reset();
                loadStudents();
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể thêm học sinh'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm học sinh: ' + error.message);
        });
});

function loadStudents() {
    fetch('admincrud.php?action=getStudents', {
        method: 'post'
    })
        .then(response => response.text())
        .then(html => {
            document.getElementById('student-table-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading student:', error);
        });
}

// Gọi loadStudents khi trang được tải
document.addEventListener('DOMContentLoaded', loadStudents);

// Xử lý Parents
document.getElementById('parent-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'addParent');

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                this.reset();
                loadParents();
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể thêm phụ huynh'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm phụ huynh: ' + error.message);
        });
});

function loadParents() {
    fetch('admincrud.php?action=getParents', {
        method: 'post'
    })
        .then(response => response.text())
        .then(html => {
            document.getElementById('parent-table-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading parent:', error);
        });
}

// Gọi loadParents khi trang được tải
document.addEventListener('DOMContentLoaded', loadParents);

function loadStatistics() {
    const startDate = document.getElementById('stats-start').value;
    const endDate = document.getElementById('stats-end').value;

    if (!startDate || !endDate) {
        alert('Vui lòng chọn thời gian bắt đầu và kết thúc');
        return;
    }

    if (startDate > endDate) {
        alert('Thời gian bắt đầu không thể sau thời gian kết thúc');
        return;
    }

    fetch(`admincrud.php?action=loadStatistics&startDate=${startDate}&endDate=${endDate}`, {
        method: 'GET'
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                document.getElementById('total-expected').textContent =
                    new Intl.NumberFormat('vi-VN').format(data.data.expectedAmount);
                document.getElementById('total-collected').textContent =
                    new Intl.NumberFormat('vi-VN').format(data.data.collectedAmount);
                document.getElementById('students-increased').textContent =
                    data.data.studentsIncreased;
                document.getElementById('students-decreased').textContent =
                    data.data.studentsDecreased;
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể tải thống kê'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thống kê');
        });
}

// Add password change handler
document.getElementById('admin-password-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'changeAdminPassword');

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                this.reset();
            } else {
                alert('Lỗi: ' + (data.message || 'Không thể đổi mật khẩu'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi đổi mật khẩu');
        });
});

// Các hàm xử lý popup
function showEditPopup(type, id) {
    fetch(`admincrud.php?action=get${type}&id=${id}`)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                const overlay = document.querySelector('.popup-overlay-2');
                const popup = document.getElementById('edit-popup');
                overlay.style.display = 'block';
                overlay.style.opacity = '1';
                overlay.style.zIndex = '10001';
                popup.style.display = 'block';
                popup.style.opacity = '1';
                popup.style.zIndex = '10001';

                fillEditForm(type, data.data);
            } else {
                alert('Lỗi: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi lấy thông tin');
        });
}

function fillEditForm(type, data) {
    const form = document.getElementById('edit-form');
    let html = '';

    switch (type) {
        case 'Class':
            html = `
                <input type="hidden" name="type" value="class">
                <input type="hidden" name="action" value="updateClass">
                <input type="hidden" name="id" value="${data.ClassID}">
                <div class="form-group">
                    <label>Tên lớp:</label>
                    <input type="text" name="className" value="${data.ClassName}" required>
                </div>
                <div class="form-group">
                    <label>Năm học:</label>
                    <input type="number" name="schoolYear" value="${data.SchoolYear}" required>
                </div>
                <div class="form-group">
                    <label>Giáo viên:</label>
                    <select name="teacherId" required>
                        ${data.teacherOptions}
                    </select>
                </div>
                <div class="form-group">
                    <label>Phòng học:</label>
                    <input type="text" name="room" value="${data.Room}" required>
                </div>
                <div class="form-group">
                    <label>Giờ học:</label>
                    <input type="text" name="classTime" value="${data.ClassTime}" required>
                </div>
                <div class="form-group">
                    <label>Ngày bắt đầu:</label>
                    <input type="date" name="startDate" value="${data.StartDate}" required>
                </div>
                <div class="form-group">
                    <label>Ngày kết thúc:</label>
                    <input type="date" name="endDate" value="${data.EndDate}" required>
                </div>
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="status" required>
                        <option value="Đang hoạt động" ${data.Status === 'Đang hoạt động' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="Đã kết thúc" ${data.Status === 'Đã kết thúc' ? 'selected' : ''}>Đã kết thúc</option>
                        <option value="Tạm ngưng" ${data.Status === 'Tạm ngưng' ? 'selected' : ''}>Tạm ngưng</option>
                    </select>
                </div>`;
            break;

        case 'Teacher':
            html = `
            <input type="hidden" name="type" value="teacher">
                <input type="hidden" name="action" value="updateTeacher">
                <input type="hidden" name="id" value="${data.UserID}">
                <div class="form-group">
                    <label>Họ tên:</label>
                    <input type="text" name="fullName" value="${data.FullName}" required>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="${data.Email}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" name="phone" value="${data.Phone}" required>
                </div>
                <div class="form-group">
                    <label>Giới tính:</label>
                    <select name="gender" required>
                        <option value="Nam" ${data.Gender === 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${data.Gender === 'Nữ' ? 'selected' : ''}>Nữ</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ngày sinh:</label>
                    <input type="date" name="birthDate" value="${data.BirthDate}" required>
                </div>
                <div class="form-group">
                    <label>Lương:</label>
                    <input type="number" name="salary" value="${data.Salary}" required>
                </div>`;
            break;

        case 'Student':
            html = `
            <input type="hidden" name="type" value="student">
                <input type="hidden" name="action" value="updateStudent">
                <input type="hidden" name="id" value="${data.UserID}">
                <div class="form-group">
                    <label>Họ tên:</label>
                    <input type="text" name="fullName" value="${data.FullName}" required>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="${data.Email}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" name="phone" value="${data.Phone}" required>
                </div>
                <div class="form-group">
                    <label>Giới tính:</label>
                    <select name="gender" required>
                        <option value="Nam" ${data.Gender === 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${data.Gender === 'Nữ' ? 'selected' : ''}>Nữ</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ngày sinh:</label>
                    <input type="date" name="birthDate" value="${data.BirthDate}" required>
                </div>
                <div class="form-group">
                    <label>Lớp:</label>
                    <select name="classId" required>
                        ${data.classOptions}
                    </select>
                </div>
                <div class="form-group">
                    <label>Phụ huynh:</label>
                    <select name="parentId" required>
                        ${data.parentOptions}
                    </select>
                </div>`;
            break;

        case 'Parent':
            html = `
            <input type="hidden" name="type" value="parent">
                <input type="hidden" name="action" value="updateParent">
                <input type="hidden" name="id" value="${data.UserID}">
                <div class="form-group">
                    <label>Họ tên:</label>
                    <input type="text" name="fullName" value="${data.FullName}" required>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="${data.Email}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" name="phone" value="${data.Phone}" required>
                </div>
                <div class="form-group">
                    <label>Giới tính:</label>
                    <select name="gender" required>
                        <option value="Nam" ${data.Gender === 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${data.Gender === 'Nữ' ? 'selected' : ''}>Nữ</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ngày sinh:</label>
                    <input type="date" name="birthDate" value="${data.BirthDate}" required>
                </div>
                <div class="form-group">
                    <label>Zalo ID:</label>
                    <input type="text" name="zaloId" value="${data.ZaloID || ''}" placeholder="Nhập Zalo ID">
                </div>
                <div class="form-group">
                    <label>Số tiền chưa đóng:</label>
                    <input type="number" name="unpaidAmount" value="${data.UnpaidAmount || 0}">
                </div>`;
            break;
    }

    form.innerHTML = html;
}

function closePopup() {
    const overlay = document.querySelector('.popup-overlay-2');
    overlay.style.opacity = 0;
    overlay.style.zIndex = -100;
    const cfpopup = document.querySelector('.confirm-popup');
    cfpopup.style.display = "none";
    const popup = document.querySelector('.edit-popup');
    popup.style.opacity = 0;
    popup.style.zIndex = -100;
}

function confirmDelete(type, id) {
    const overlay = document.querySelector('.popup-overlay-2');
    const popup = document.getElementById('confirm-popup');
    overlay.style.opacity = 1;
    overlay.style.zIndex = 10000;
    popup.style.display = 'block';

    document.getElementById('confirm-yes').onclick = () => {
        deleteItem(type, id);
    };
}

function deleteItem(type, id) {
    // if (!confirm(`Bạn có chắc muốn xóa ${type} này?`)) return;

    const form = new FormData();
    form.append('action', `delete${type}`)
    form.append('type', type);
    form.append('id', id);
    fetch('admincrud.php', {
        method: 'POST',
        body: form
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                alert('Xóa thành công!');
                closePopup();
                // Reload data
                switch (type) {
                    case 'Class': loadClasses(); break;
                    case 'Teacher': loadTeachers(); break;
                    case 'Student': loadStudents(); break;
                    case 'Parent': loadParents(); break;
                }
            } else {
                alert('Lỗi: ' + data.message);
            }
        });
}

// Xử lý form edit
document.getElementById('edit-form').addEventListener('submit', function (e) {
    e.preventDefault();
    const formData = new FormData(this);
    const type = formData.get('type');
    console.log(type);

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                alert('Cập nhật thành công!');
                closePopup();
                // Reload data
                switch (type) {
                    case 'class': loadClasses(); break;
                    case 'teacher': loadTeachers(); break;
                    case 'student': loadStudents(); break;
                    case 'parent': loadParents(); break;
                }
            } else {
                alert('Lỗi: ' + data.message);
            }
        });
});

