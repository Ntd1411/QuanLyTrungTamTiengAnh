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
        method: 'get'
    })
    .then(response => response.text())
    .then(html => {
        document.getElementById('student-table-body').innerHTML = html;
    })
    .catch(error => {
        console.error('Error loading teacher:', error);
    });
}

// Gọi loadStudents khi trang được tải
document.addEventListener('DOMContentLoaded', loadStudents);

