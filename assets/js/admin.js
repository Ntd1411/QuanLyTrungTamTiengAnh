// Xử lý class
document.getElementById('class-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    formData.append('action', 'addClass');

    fetch('admin.php', {
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
    fetch('admin.php?action=getClasses', {
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
document.getElementById('teacher-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    formData.append('action', 'addTeacher');

    fetch('admin.php', {
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
    fetch('admin.php?action=getTeachers', {
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
document.getElementById('student-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    formData.append('action', 'addStudent');

    fetch('admin.php', {
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
    fetch('admin.php?action=getStudents', {
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
document.getElementById('parent-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    formData.append('action', 'addParent');

    fetch('admin.php', {
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
    fetch('admin.php?action=getParents', {
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

    fetch(`admin.php?action=loadStatistics&startDate=${startDate}&endDate=${endDate}`, {
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

