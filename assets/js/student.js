let studentData = {};

document.addEventListener('DOMContentLoaded', function () {
    fetch('../php/get_student_data.php')
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                alert(data.error);
                return;
            }
            studentData = data;
            loadStudentDashboard();
            loadClassInfo();
            loadAttendance();
            loadHomework();
            loadStudentProfile();
            loadStudentNotifications();
        })
        .catch(err => {
            alert('Không thể tải dữ liệu học sinh!');
            console.error(err);
        });
});

// Load dashboard data
function loadStudentDashboard() {
    document.getElementById('student-name').textContent = studentData.name || 'Học sinh';
    document.getElementById('class-name').textContent = (studentData.class && studentData.class.name) ? studentData.class.name : 'Chưa trong lớp nào';
    document.getElementById('attended-sessions').textContent = studentData.attendance ? studentData.attendance.attended : 0;
    document.getElementById('absent-sessions').textContent = studentData.attendance ? studentData.attendance.absent : 0;

    // Đếm số bài tập chưa hoàn thành
    const newHomework = studentData.homework
        ? studentData.homework.filter(hw => hw.status === 'Chưa hoàn thành').length
        : 0;
    document.getElementById('new-homework').textContent = newHomework;

    // Đổi viền thành xanh lá nếu số buổi nghỉ bằng 0
    const absentElem = document.getElementById('absent-sessions');
    const absentCard = absentElem.closest('.summary-card');
    if (absentElem.textContent === "0" || absentElem.textContent === 0) {
        absentCard.classList.add('green-border');
    } else {
        absentCard.classList.remove('green-border');
    }
}

// Load student notifications
function loadStudentNotifications() {
    const notificationList = document.querySelector('.notification-list');
    const notificationContent = document.querySelector('.notification-content');
    notificationList.innerHTML = '';
    notificationContent.innerHTML = '<p>Chọn một thông báo để xem chi tiết</p>';

    if (!studentData.messages || studentData.messages.length === 0) {
        notificationList.innerHTML = '<p>Không có thông báo nào.</p>';
        return;
    }

    studentData.messages.forEach((msg, idx) => {
        const item = document.createElement('div');
        item.className = `notification-item${msg.read ? '' : ' unread'}`;
        item.innerHTML = `
            <h4>${msg.subject}</h4>
            <p>Từ: ${msg.from}</p>
            <p>Ngày: ${msg.date}</p>
        `;
        item.onclick = () => {
            document.querySelectorAll('.notification-item').forEach(i => i.classList.remove('selected'));
            item.classList.add('selected');
            showStudentNotificationDetail(msg);

            // Đánh dấu đã đọc nếu chưa đọc
            if (!msg.read && msg.id) {
                fetch('../php/mark_message_read.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ messageId: msg.id })
                }).then(() => {
                    msg.read = true;
                    item.classList.remove('unread');
                });
            } else {
                msg.read = true;
                item.classList.remove('unread');
            }
        };
        notificationList.appendChild(item);
    });
}

function showStudentNotificationDetail(msg) {
    const notificationContent = document.querySelector('.notification-content');
    notificationContent.innerHTML = `
        <h3>${msg.subject}</h3>
        <p><strong>Từ:</strong> ${msg.from}</p>
        <p><strong>Ngày:</strong> ${msg.date}</p>
        <div class="message-body">${msg.content}</div>
    `;
    // Hiệu ứng animation
    notificationContent.classList.remove('notification-content');
    void notificationContent.offsetWidth;
    notificationContent.classList.add('notification-content');
}

// Load class information
function loadClassInfo() {
    document.getElementById('current-class').textContent = (studentData.class && studentData.class.name) ? studentData.class.name : '';
    document.getElementById('teacher-name').textContent = (studentData.class && studentData.class.teacher) ? studentData.class.teacher : '';
    document.getElementById('class-schedule').textContent = (studentData.class && studentData.class.schedule) ? studentData.class.schedule : '';

    // Hiển thị bảng danh sách học sinh
    const classmatesTable = document.getElementById('classmates-table');
    classmatesTable.innerHTML = '';

    if (studentData.class && Array.isArray(studentData.class.classmates)) {
        studentData.class.classmates.forEach((mate, index) => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${index + 1}</td>
                <td>${mate.FullName}</td>
                <td>${mate.BirthDate ? mate.BirthDate : ''}</td>
            `;
            classmatesTable.appendChild(row);
        });
    }
}

// Load attendance history
function loadAttendance() {
    const attended = studentData.attendance ? studentData.attendance.attended : 0;
    const absent = studentData.attendance ? studentData.attendance.absent : 0;
    const total = attended + absent;

    document.getElementById('total-sessions').textContent = total;
    document.getElementById('attended-count').textContent = attended;
    document.getElementById('absent-count').textContent = absent;

    // Update progress circle
    updateAttendanceProgress(attended, total);

    const historyBody = document.getElementById('attendance-history-body');
    historyBody.innerHTML = '';

    if (studentData.attendance && Array.isArray(studentData.attendance.history)) {
        studentData.attendance.history.forEach(record => {
            const row = document.createElement('tr');
            let statusText = '-';
            if (record.Status === 'Có mặt') statusText = 'Có mặt';
            else if (record.Status === 'Vắng mặt') statusText = 'Vắng mặt';
            else if (record.Status === 'Đi muộn') statusText = 'Đi muộn';
            row.innerHTML = `
                <td>${record.Date}</td>
                <td>${statusText}</td>
                <td>${record.Note || '-'}</td>
                <td>${studentData.class && studentData.class.teacher ? studentData.class.teacher : '-'}</td>
            `;
            historyBody.appendChild(row);
        });
    }

    updateAttendanceRate();
}

function updateAttendanceProgress(attended, total) {
    const rate = (attended / total) * 100;
    const progress = (rate / 100) * 360; // Convert to degrees

    const progressCircle = document.querySelector('.progress-circle');
    const progressValue = progressCircle.querySelector('.progress-value');

    // Create progress element if it doesn't exist
    let progressElement = progressCircle.querySelector('.progress');
    if (!progressElement) {
        progressElement = document.createElement('div');
        progressElement.className = 'progress';
        progressCircle.appendChild(progressElement);
    }

    // Update progress and value
    progressCircle.style.setProperty('--progress', progress + 'deg');

    // Animate the percentage
    let currentValue = 0;
    const step = rate / 30; // Divide animation into 30 steps

    const animateValue = () => {
        if (currentValue < rate) {
            currentValue += step;
            if (currentValue > rate) currentValue = rate;
            progressValue.textContent = Math.round(currentValue) + '%';
            requestAnimationFrame(animateValue);
        }
    };

    animateValue();
}

// Load homework
function loadHomework() {
    const homeworkList = document.getElementById('homework-list');
    homeworkList.innerHTML = '';

    if (Array.isArray(studentData.homework) && studentData.homework.length > 0) {
        studentData.homework.forEach(hw => {
            let statusClass = 'new';
            if (hw.status === 'Đã hoàn thành') statusClass = 'done';
            else if (hw.status === 'Chưa hoàn thành') statusClass = 'unfinished';

            const card = document.createElement('div');
            card.className = `homework-card ${statusClass} flex-row`;
            card.innerHTML = `
                <div class="homework-info">
                    <h3>${hw.title}</h3>
                    <p>${hw.description}</p>
                    <p>Hạn nộp: ${hw.dueDate}</p>
                    <p>Trạng thái: ${hw.status}</p>
                </div>
                <div class="homework-submit">
                    <input type="file" class="homework-file" accept=".pdf,.doc,.docx,.jpg,.png">
                    <button class="submit-btn" disabled>Nộp</button>
                </div>
            `;

            // Chỉ cho nộp bài nếu bài tập chưa hoàn thành
            if (hw.status === 'Chưa hoàn thành') {
                const fileInput = card.querySelector('.homework-file');
                const submitBtn = card.querySelector('.submit-btn');
                fileInput.addEventListener('change', function () {
                    submitBtn.disabled = !fileInput.files.length;
                    if (submitBtn.disabled) {
                        submitBtn.classList.remove('active');
                    } else {
                        submitBtn.classList.add('active');
                    }
                });
                // Xử lý sự kiện submit
            }

            homeworkList.appendChild(card);
        });
    } else {
        // Nếu không có bài tập nào
        homeworkList.innerHTML = '<h2>Không có bài tập nào.<h2>';
    }
}

// Load student profile
function loadStudentProfile() {
    document.getElementById('profile-name').value = studentData.name || '';
    document.getElementById('profile-class').value = (studentData.class && studentData.class.name) ? studentData.class.name : '';
    document.getElementById('profile-email').value = studentData.email || '';
    document.getElementById('profile-phone').value = studentData.phone || '';
}

// Update profile
function updateProfile() {
    const newEmail = document.getElementById('profile-email').value;
    const newPhone = document.getElementById('profile-phone').value;
    const oldPassword = document.getElementById('old-password').value;
    const newPassword = document.getElementById('new-password').value;

    // Kiểm tra định dạng
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^0\d{9}$/;
    const passwordRegex = /^[a-zA-Z0-9]{6,}$/;

    if (!emailRegex.test(newEmail)) {
        alert('Email không hợp lệ!');
        return;
    }
    if (!phoneRegex.test(newPhone)) {
        alert('Số điện thoại phải bắt đầu bằng 0 và đủ 10 số!');
        return;
    }
    if ((oldPassword || newPassword) && !passwordRegex.test(newPassword)) {
        alert('Mật khẩu mới phải có ít nhất 6 ký tự và chỉ gồm chữ, số!');
        return;
    }

    fetch('../php/update_student_data.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email: newEmail,
            phone: newPhone,
            oldPassword: oldPassword,
            newPassword: newPassword
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Cập nhật thông tin thành công!');
                if (oldPassword && newPassword) {
                    window.location.href = '../index.html';
                }
            } else {
                alert('Cập nhật thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Có lỗi xảy ra khi cập nhật!');
            console.error(err);
        });
}

function updateAttendanceRate() {
    const attended = studentData.attendance.attended;
    const total = attended + studentData.attendance.absent;
    const rate = Math.round((attended / total) * 100);

    // Cập nhật biểu đồ tròn
    const progressCircle = document.getElementById('attendance-rate');
    progressCircle.style.setProperty('--progress', rate + '%');

    // Cập nhật giá trị
    const progressValue = progressCircle.querySelector('.progress-value');
    progressValue.textContent = rate + '%';

    // Hiệu ứng số đếm
    let currentValue = 0;
    const duration = 1000;
    const increment = rate / (duration / 16);

    const animate = () => {
        if (currentValue < rate) {
            currentValue += increment;
            if (currentValue > rate) currentValue = rate;
            progressValue.textContent = Math.round(currentValue) + '%';
            requestAnimationFrame(animate);
        }
    };

    animate();
}
