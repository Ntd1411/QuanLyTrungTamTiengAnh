let teacherData = {};

document.addEventListener('DOMContentLoaded', function () {
    fetch('../php/get_teacher_data.php')
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                alert(data.error);
                return;
            }
            teacherData = data;
            loadTeacherDashboard();
            loadClassSelect();
            loadTeacherProfile();
            viewSchedule();
            loadTeachingLog();
        })
        .catch(err => {
            alert('Không thể tải dữ liệu giáo viên!');
            console.error(err);
        });
});

// Load dashboard data
function loadTeacherDashboard() {
    document.getElementById('teacher-name').textContent = teacherData.name;
    document.getElementById('total-classes').textContent = teacherData.classes.length;
    const studentsListDiv = document.querySelector('.class-students-list');
    if (studentsListDiv) studentsListDiv.style.display = 'none';

    let totalStudents = teacherData.classes.reduce((sum, cls) => sum + (cls.students ? cls.students.length : 0), 0);
    document.getElementById('total-students').textContent = totalStudents;

    document.getElementById('monthly-sessions').textContent = teacherData.monthly_sessions || 0;

    const classesContainer = document.querySelector('.classes-container');
    if (classesContainer) {
        classesContainer.innerHTML = '';
        teacherData.classes.forEach(cls => {
            const classCard = document.createElement('div');
            classCard.className = 'class-card';
            classCard.innerHTML = `
                <h3>${cls.ClassName || cls.name} - ${cls.SchoolYear || cls.year || ''}</h3>
                <div class="class-info">
                <p><strong>Số học sinh:</strong> ${cls.students ? cls.students.length : 0}</p>
                <p><strong>Ngày mở lớp:</strong> ${cls.StartDate || ''}</p>
                <p><strong>Ngày đóng lớp:</strong> ${cls.EndDate || ''}</p>
                <p><strong>Lịch học:</strong> ${cls.ClassTime || ''}</p>
                <p><strong>Phòng học:</strong> ${cls.Room || ''}</p>
            </div>
            `;
            // Thêm sự kiện click để hiện danh sách học sinh
            classCard.style.cursor = 'pointer';
            classCard.onclick = () => showClassStudents(cls.ClassID || cls.id);
            classesContainer.appendChild(classCard);
        });
    }
}

// Load teaching log
function loadTeachingLog() {
    const logBody = document.getElementById('teaching-log-body');
    logBody.innerHTML = '';
    if (!teacherData.teaching_log || teacherData.teaching_log.length === 0) {
        logBody.innerHTML = '<tr><td colspan="5" style="text-align:center;">Không có dữ liệu</td></tr>';
        return;
    }
    teacherData.teaching_log.forEach((log, idx) => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${log.SessionDate}</td>
            <td>${log.ClassName}</td>
            <td>${log.Status}</td>
            <td>${log.Note || ''}</td>
        `;
        logBody.appendChild(row);
    });
}

// Load class selection
function loadClassSelect() {
    const classSelects = document.querySelectorAll('#class-select, #notification-class');
    classSelects.forEach(select => {
        select.innerHTML = '<option value="">Chọn lớp</option>';
        teacherData.classes.forEach(cls => {
            select.innerHTML += `<option value="${cls.ClassID || cls.id}">${cls.ClassName || cls.name}</option>`;
        });
    });
}

// Show class students
function showClassStudents(classId) {
    const cls = teacherData.classes.find(c => (c.ClassID || c.id) == classId);
    const studentsListDiv = document.querySelector('.class-students-list');
    const studentsTable = document.getElementById('teacher-class-students-table');
    if (!cls || !studentsListDiv || !studentsTable) return;

    // Reset trạng thái hoàn toàn
    studentsListDiv.style.display = 'none'; // Ẩn hoàn toàn
    studentsListDiv.classList.remove('active'); // Xóa lớp active
    studentsTable.innerHTML = ''; // Xóa nội dung bảng

    // Đợi DOM cập nhật trước khi hiển thị lại
    setTimeout(() => {
        studentsListDiv.style.display = 'block'; // Hiển thị lại
        // Đợi một khung hình để đảm bảo trình duyệt nhận diện thay đổi
        requestAnimationFrame(() => {
            studentsListDiv.classList.add('active'); // Kích hoạt transition
        });
    }, 50); // Tăng thời gian chờ để đảm bảo reset hoàn tất

    if (!cls.students || cls.students.length === 0) {
        studentsTable.innerHTML = '<tr><td colspan="6" style="text-align:center;">Không có học sinh</td></tr>';
        return;
    }

    cls.students.forEach((student, idx) => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${idx + 1}</td>
            <td>${student.FullName}</td>
            <td>${student.attended || 0}</td>
            <td>${student.absent || 0}</td>
            <td>${student.participation || 0}%</td>
            <td>${student.UserID}</td>
        `;
        studentsTable.appendChild(row);
    });
}

// Load attendance list
function loadAttendanceList(classId) {
    const cls = teacherData.classes.find(c => (c.ClassID || c.id) == classId);
    if (!cls) return;

    const attendanceList = document.querySelector('.attendance-list');
    if (!attendanceList) return;
    attendanceList.innerHTML = '';

    (cls.students || []).forEach(student => {
        const item = document.createElement('div');
        item.className = 'attendance-item';
        item.innerHTML = `
            <input type="checkbox" id="student-${student.UserID || student.id}">
            <label for="student-${student.UserID || student.id}">${student.FullName || student.name}</label>
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
    document.getElementById('profile-name').value = teacherData.name || '';
    document.getElementById('profile-email').value = teacherData.email || '';
    document.getElementById('profile-phone').value = teacherData.phone || '';
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

// View schedule
function viewSchedule() {
    const scheduleBody = document.getElementById('schedule-body');
    scheduleBody.innerHTML = '';

    if (!teacherData.schedule) {
        scheduleBody.innerHTML = '<tr><td colspan="8">Chưa có dữ liệu lịch dạy.</td></tr>';
        return;
    }

    teacherData.schedule.forEach(slot => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${slot.time}</td>
            <td>${formatClassCell(slot.monday)}</td>
            <td>${formatClassCell(slot.tuesday)}</td>
            <td>${formatClassCell(slot.wednesday)}</td>
            <td>${formatClassCell(slot.thursday)}</td>
            <td>${formatClassCell(slot.friday)}</td>
            <td>${formatClassCell(slot.saturday)}</td>
            <td>${formatClassCell(slot.sunday)}</td>
        `;
        scheduleBody.appendChild(row);
    });
}

// Event listeners
document.getElementById('class-select').addEventListener('change', function () {
    loadAttendanceList(this.value);
});
