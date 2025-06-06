// Fake data for demonstration
let teacherData = {
    id: 1,
    name: "Nguyễn Thanh Hương",
    email: "huong.nt@example.com",
    phone: "0123456789",
    classes: [
        {
            id: 1,
            name: "Lớp 3.1",
            year: 2023,
            students: [
                { id: 1, name: "Nguyễn Văn A", attended: 15, absent: 2 },
                { id: 2, name: "Trần Thị B", attended: 14, absent: 3 },
            ]
        },
        {
            id: 2,
            name: "Lớp 4.2",
            year: 2023,
            students: [
                { id: 3, name: "Lê Văn C", attended: 16, absent: 1 },
                { id: 4, name: "Phạm Thị D", attended: 15, absent: 2 },
            ]
        }
    ]
};

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    loadTeacherDashboard();
    loadClassSelect();
    loadTeacherProfile();
});

// Load dashboard data
function loadTeacherDashboard() {
    document.getElementById('teacher-name').textContent = teacherData.name;
    document.getElementById('total-classes').textContent = teacherData.classes.length;
    
    let totalStudents = teacherData.classes.reduce((sum, cls) => sum + cls.students.length, 0);
    document.getElementById('total-students').textContent = totalStudents;
    
    let monthlySessions = teacherData.classes.reduce((sum, cls) => 
        sum + cls.students.reduce((s, student) => s + student.attended, 0), 0);
    document.getElementById('monthly-sessions').textContent = monthlySessions;

    // Load classes
    const classesContainer = document.querySelector('.classes-container');
    classesContainer.innerHTML = '';
    
    teacherData.classes.forEach(cls => {
        const classCard = document.createElement('div');
        classCard.className = 'class-card';
        classCard.innerHTML = `
            <h3>${cls.name} - ${cls.year}</h3>
            <div class="class-info">
                <p>Số học sinh: ${cls.students.length}</p>
                <p>Tổng số buổi: ${cls.students.reduce((sum, student) => sum + student.attended + student.absent, 0)}</p>
            </div>
        `;
        classesContainer.appendChild(classCard);
    });
}

// Load class selection
function loadClassSelect() {
    const classSelects = document.querySelectorAll('#class-select, #notification-class');
    classSelects.forEach(select => {
        select.innerHTML = '<option value="">Chọn lớp</option>';
        teacherData.classes.forEach(cls => {
            select.innerHTML += `<option value="${cls.id}">${cls.name}</option>`;
        });
    });
}

// Load attendance list
function loadAttendanceList(classId) {
    const cls = teacherData.classes.find(c => c.id == classId);
    if (!cls) return;

    const attendanceList = document.querySelector('.attendance-list');
    attendanceList.innerHTML = '';
    
    cls.students.forEach(student => {
        const item = document.createElement('div');
        item.className = 'attendance-item';
        item.innerHTML = `
            <input type="checkbox" id="student-${student.id}">
            <label for="student-${student.id}">${student.name}</label>
        `;
        attendanceList.appendChild(item);
    });
}

// Submit attendance
function submitAttendance() {
    const classId = document.getElementById('class-select').value;
    const date = document.getElementById('attendance-date').value;
    
    if (!classId || !date) {
        alert('Vui lòng chọn lớp và ngày');
        return;
    }

    const attendanceData = [];
    document.querySelectorAll('.attendance-item input[type="checkbox"]').forEach(checkbox => {
        attendanceData.push({
            studentId: checkbox.id.split('-')[1],
            present: checkbox.checked
        });
    });

    // Here you would typically send this data to the server
    console.log('Attendance submitted:', { classId, date, attendanceData });
    alert('Điểm danh đã được lưu');
}

// Send notification
function sendNotification() {
    const classId = document.getElementById('notification-class').value;
    const type = document.getElementById('notification-type').value;
    const content = document.getElementById('notification-content').value;
    const sendZalo = document.getElementById('notify-zalo').checked;
    const sendSMS = document.getElementById('notify-sms').checked;

    if (!classId || !content) {
        alert('Vui lòng chọn lớp và nhập nội dung');
        return;
    }

    // Here you would typically send this data to the server
    console.log('Notification sent:', { classId, type, content, sendZalo, sendSMS });
    alert('Thông báo đã được gửi');
}

// Load teacher profile
function loadTeacherProfile() {
    document.getElementById('profile-name').value = teacherData.name;
    document.getElementById('profile-email').value = teacherData.email;
    document.getElementById('profile-phone').value = teacherData.phone;
}

// Update profile
function updateProfile() {
    const newPhone = document.getElementById('profile-phone').value;
    const newPassword = document.getElementById('profile-new-password').value;

    // Here you would typically send this data to the server
    teacherData.phone = newPhone;
    console.log('Profile updated:', { newPhone, newPassword });
    alert('Thông tin đã được cập nhật');
}

// Event listeners
document.getElementById('class-select').addEventListener('change', function() {
    loadAttendanceList(this.value);
});
