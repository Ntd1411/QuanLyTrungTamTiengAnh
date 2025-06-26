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
                loadStudents();
                loadParents();
                loadTeachers();
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
                loadStudents();
                loadParents();
                loadClasses();
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
                loadParents();
                loadClasses();
                loadTeachers();
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
                loadStudents();
                loadParents();
                loadClasses();
                loadTeachers();
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

function changeFilterType() {
    const filterType = document.getElementById('stats-filter-type').value;
    
    // Hide all filters first
    document.getElementById('custom-filter').style.display = 'none';
    document.getElementById('month-filter').style.display = 'none';
    document.getElementById('quarter-filter').style.display = 'none';
    document.getElementById('year-filter').style.display = 'none';
    
    // Show selected filter
    document.getElementById(`${filterType}-filter`).style.display = 'flex';
}

function loadStatistics() {
    const filterType = document.getElementById('stats-filter-type').value;
    let startDate, endDate;
    
    switch(filterType) {
        case 'custom':
            startDate = document.getElementById('stats-start').value;
            endDate = document.getElementById('stats-end').value;
            break;
            
        case 'month':
            const month = parseInt(document.getElementById('stats-month').value);
            const yearMonth = document.getElementById('stats-year-month').value;
            // Start date is first day of month
            startDate = `${yearMonth}-${month.toString().padStart(2, '0')}-01`;
            // End date is last day of month
            const lastDay = new Date(yearMonth, month, 0).getDate();
            endDate = `${yearMonth}-${month.toString().padStart(2, '0')}-${lastDay}`;
            break;
            
        case 'quarter':
            const quarter = parseInt(document.getElementById('stats-quarter').value);
            const yearQuarter = document.getElementById('stats-year-quarter').value;
            const startMonth = ((quarter - 1) * 3 + 1).toString().padStart(2, '0');
            const endMonth = (quarter * 3).toString().padStart(2, '0');
            startDate = `${yearQuarter}-${startMonth}-01`;
            // End date is last day of the last month in quarter
            const lastDayQuarter = new Date(yearQuarter, quarter * 3, 0).getDate();
            endDate = `${yearQuarter}-${endMonth}-${lastDayQuarter}`;
            break;
            
        case 'year':
            const year = document.getElementById('stats-year').value;
            startDate = `${year}-01-01`;
            endDate = `${year}-12-31`;
            break;
    }

    if (!startDate || !endDate) {
        alert('Vui lòng chọn thời gian thống kê');
        return;
    }

    console.log(startDate);
    console.log(endDate);

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
                    <select name="teacherId" class="select2-edit" required>
                        ${data.teacherOptions}
                    </select>
                </div>
                <div class="form-group">
                    <label>Phòng học:</label>
                    <select name="room" class="select2-edit" required>
                        <option value="P201" ${data.Room === 'P201' ? 'selected' : ''}>P201</option>
                        <option value="P202" ${data.Room === 'P202' ? 'selected' : ''}>P202</option>
                        <option value="P203" ${data.Room === 'P203' ? 'selected' : ''}>P203</option>
                        <option value="P204" ${data.Room === 'P204' ? 'selected' : ''}>P204</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Học phí:</label>
                    <input type="number" name="classTuition" value="${data.Tuition}" required>
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

            // Initialize Select2 after form content is set
            setTimeout(() => {
                $('.select2-edit').select2({
                    width: '100%',
                    dropdownParent: $('.edit-popup'),
                    placeholder: "Tìm kiếm...",
                    allowClear: true,
                    language: {
                        noResults: function() {
                            return "Không tìm thấy kết quả";
                        },
                        searching: function() {
                            return "Đang tìm kiếm...";
                        }
                    }
                });
                
                // Prevent dropdown from being cut off
                $('.edit-popup .select2-container').css('z-index', 100000);
            }, 100);
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
                <select name="classId" class="select2-edit" required>
                    ${data.classOptions}
                </select>
            </div>
            <div class="form-group">
                <label>Phụ huynh:</label>
                <select name="parentIds[]" class="select2-multiple" multiple>
                    ${data.parentOptions}
                </select>
            </div>
            <div class="form-group">
                <label>Giảm học phí (%):</label>
                <input type="number" name="studentDiscount" min="0" max="100" step="1" value="${data.TuitionDiscount || 0}" required>
            </div>`;

            // Initialize Select2 after form content is set
            setTimeout(() => {
                $('.select2-multiple').select2({
                    width: '100%',
                    placeholder: 'Chọn phụ huynh...',
                    allowClear: true,
                    dropdownParent: $('#edit-popup')
                });
                $('.select2-edit').select2({
                    width: '100%',
                    placeholder: 'Chọn lớp...',
                    allowClear: true,
                    dropdownParent: $('#edit-popup')
                });
            }, 100);
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
                    <label>Hiển thị thông tin giáo viên:</label>
                    <select name="isShowTeacher">
                        <option value="1" ${data.isShowTeacher == 1 ? 'selected' : ''}>Cho phép xem</option>
                        <option value="0" ${data.isShowTeacher == 0 ? 'selected' : ''}>Không cho phép xem</option> 
                    </select>
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
        .then (data => {
            if (data.status === 'success') {
                alert('Xóa thành công!');
                closePopup();
                // Reload data
                loadStudents();
                loadParents();
                loadClasses();
                loadTeachers();
                loadNews();
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
                loadStudents();
                loadParents();
                loadClasses();
                loadTeachers();
                loadNews();
            } else {
                alert('Lỗi: ' + data.message);
            }
        });
});

// Add notification form handler
document.getElementById('notification-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'sendNotification');

    // Lấy các phương thức gửi đã chọn
    const selectedMethods = Array.from(document.querySelectorAll('input[name="sendMethods[]"]:checked'))
        .map(checkbox => checkbox.value);

    // Thêm vào formData dưới dạng JSON string
    formData.append('sendMethods', JSON.stringify(selectedMethods));

    fetch('admincrud.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                alert(data.message);
                this.reset();
                loadMessages();
                $('.recipient-select').val(null).trigger('change');
            } else {
                alert('Lỗi: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi gửi thông báo');
        });
});

function loadMessages() {
    fetch('admincrud.php?action=getMessages')
        .then(response => response.text())
        .then(html => {
            document.getElementById('message-table-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading messages:', error);
        });
}

// Load messages when page loads 
document.addEventListener('DOMContentLoaded', loadMessages);

// Initialize Select2 when document is ready
$(document).ready(function () {
    $('.select2-dropdown').select2({
        placeholder: 'Tìm kiếm người nhận...',
        allowClear: true,
        width: '100%',
        language: {
            noResults: function () {
                return "Không tìm thấy kết quả";
            }
        }
    });
});


document.getElementById('newsForm').addEventListener('submit', function (e) {
    e.preventDefault();

    const form = new FormData(this);
    form.append('action', 'addPost');

    fetch('admincrud.php', {
        method: 'post',
        body: form
    }
    )
        .then(response => response.json())
        .then(data => {
            if (data.status === "success") {
                alert(data.message);
                loadNews();
            } else if (data.status === "fail") {
                alert(data.message);
            }

        })
        .catch(error => alert("Có lỗi xảy ra khi đăng bài!"))
})

function loadNews() {
    fetch('getnews.php')
        .then(response => response.json())
        .then(news => {
            const newsContainer = document.querySelector('.newsList');
            // console.log(newsContainer);
            newsContainer.innerHTML = '';

            news.forEach(item => {
                const newsHtml = `
                    <div class="news-item">
                        <img src="../assets/img/${item.image}" alt="${item.title}" class="news-img">
                        <div class="news-info">
                            <h3><a href="#" class="news-title-link">${item.title}</a></h3>
                            <p class="news-meta">
                                <span class="news-date">${formatDate(item.date)}</span> | 
                                <span class="news-author">${item.author}</span>
                            </p>
                            <p class="news-excerpt">${item.excerpt}</p>
                            <div class="button-group">
                                <a href="#" class="news-change" onclick="showEditNews(${item.id}); event.preventDefault(); return false;">
                                    <i class="fa-solid fa-wrench"></i> Sửa bài viết
                                </a>
                                <a href="#" class="news-change" onclick="confirmDelete('news' ,${item.id}); event.preventDefault(); return false;">
                                    <i class="fa-solid fa-trash-can"></i> Xóa
                                </a>
                            </div>
                        </div>
                    </div>
                `;
                newsContainer.innerHTML += newsHtml;
            });
        })
        .catch(error => console.error('Error:', error));
}

function formatDate(dateString) {
    // Kiểm tra nếu ngày đã ở định dạng dd/mm/yyyy
    if (dateString.includes('/')) {
        return dateString; // Trả về nguyên bản vì đã đúng định dạng
    }

    // Nếu là định dạng yyyy-mm-dd thì chuyển sang dd/mm/yyyy
    const date = new Date(dateString);
    if (isNaN(date)) return 'Ngày không hợp lệ';

    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();

    return `${day}/${month}/${year}`;
}

document.addEventListener('DOMContentLoaded', loadNews);

function previewImage(input, idcontainer) {
    const preview = document.getElementById(idcontainer);

    // Xóa ảnh cũ nếu có
    preview.innerHTML = '';

    if (input.files && input.files[0]) {
        const reader = new FileReader();

        reader.onload = function (e) {
            // Tạo element img
            const img = document.createElement('img');
            img.src = e.target.result;

            // Thêm ảnh vào preview
            preview.appendChild(img);
            preview.classList.add('has-image');
        }

        reader.readAsDataURL(input.files[0]);
    } else {
        // Nếu không có file được chọn
        preview.innerHTML = 'Chọn ảnh để xem trước';
        preview.classList.remove('has-image');
    }
}

// Thêm validate cho file ảnh
document.getElementById('image').addEventListener('change', function (e) {
    const file = e.target.files[0];
    const fileType = file.type;
    const validImageTypes = ['image/jpeg', 'image/png', 'image/gif'];

    if (!validImageTypes.includes(fileType)) {
        alert('Vui lòng chọn file ảnh hợp lệ (JPEG, PNG, GIF)');
        this.value = ''; // Xóa file đã chọn
        const preview = document.getElementById('imagePreview');
        preview.innerHTML = 'Chọn ảnh để xem trước';
        preview.classList.remove('has-image');
        return;
    }

    // Kiểm tra kích thước file (ví dụ: max 5MB)
    if (file.size > 20 * 1024 * 1024) {
        alert('Kích thước file không được vượt quá 20MB');
        this.value = '';
        const preview = document.getElementById('imagePreview');
        preview.innerHTML = 'Chọn ảnh để xem trước';
        preview.classList.remove('has-image');
        return;
    }
});

function showEditNews(id) {
    const form = new FormData();
    form.append('action', 'getNews');
    form.append('id', id);
    fetch(`admincrud.php`,
        {
            method: 'post',
            body: form
        }
    )
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                const overlay = document.querySelector('.popup-overlay-2');
                const popup = document.getElementById('edit-popup');
                overlay.style.opacity = 1;
                overlay.style.zIndex = 10001;
                popup.style.display = 'block';
                popup.style.opacity = 1;
                popup.style.zIndex = 10001;

                // Fill form with news data
                document.getElementById('edit-form').innerHTML = `
                <div class="news-edit-form">
                    <input type="hidden" name="type" value="news">
                    <input type="hidden" name="action" value="updateNews">
                    <input type="hidden" name="id" value="${data.news.id}">
                    <div class="form-group">
                        <label for="edit-title">Tiêu đề tin tức:</label>
                        <input type="text" id="edit-title" name="title" value="${data.news.title}" required>
                    </div>

                    <div class="form-group">
                        <label for="edit-excerpt">Tóm tắt:</label>
                        <textarea id="edit-excerpt" name="excerpt" required>${data.news.excerpt}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="edit-content">Nội dung:</label>
                        <textarea id="edit-content" style="height: 200px;"  name="content" required>${data.news.content}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="edit-image">Chọn hình ảnh mới (để trống nếu không thay đổi):</label>
                        <input type="file" id="edit-image" name="image" accept="image/*" onchange="previewImage(this, 'edit-image-preview')">
                        <div id="edit-image-preview" class="image-preview">
                            <img src="../assets/img/${data.news.image}" alt="${data.news.title}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-author">Tác giả:</label>
                        <input type="text" id="edit-author" name="author" value="${data.news.author}" required>
                    </div>
                </div>`;
            } else {
                alert('Lỗi: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi lấy thông tin bài viết');
        });
}





