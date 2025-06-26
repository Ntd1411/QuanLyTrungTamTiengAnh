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
            loadTeacherReceivedNotifications();
            loadTeacherSentNotifications();
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

//Popup Log Form
// Hiện popup
document.getElementById('add-log-btn').onclick = function () {
    // Đổ danh sách lớp vào select
    const select = document.getElementById('log-class-select');
    select.innerHTML = '';
    teacherData.classes.forEach(cls => {
        select.innerHTML += `<option value="${cls.ClassID}">${cls.ClassName}</option>`;
    });
    document.getElementById('log-date-input').value = new Date().toISOString().slice(0, 10);
    document.getElementById('add-log-modal').style.display = 'flex';
};

// Đóng popup
function closeAddLogModal() {
    document.getElementById('add-log-modal').style.display = 'none';
}

// Lưu nhật ký
function submitAddLog() {
    const classId = document.getElementById('log-class-select').value;
    const date = document.getElementById('log-date-input').value;
    const status = document.getElementById('log-status-select').value;
    const note = document.getElementById('log-note-input').value;

    fetch('../php/add_teaching_log.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, status, note, date })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Đã thêm nhật ký!');
                closeAddLogModal();
                // Reload teaching log nếu muốn
                location.reload();
            } else {
                alert('Thêm nhật ký thất bại!');
            }
        })
        .catch(err => {
            alert('Lỗi khi thêm nhật ký!');
            console.error(err);
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
            <span class="student-name">${student.FullName || student.name}</span>
            <div class="attendance-actions">
                <select class="attendance-status">
                    <option value="present">Có mặt</option>
                    <option value="absent">Vắng mặt</option>
                    <option value="late">Đi muộn</option>
                </select>
                <input type="text" class="attendance-note" placeholder="Ghi chú">
            </div>
        `;
        item.dataset.studentId = student.UserID || student.id;
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

    const statusMap = {
        present: 'Có mặt',
        absent: 'Vắng mặt',
        late: 'Đi muộn'
    };

    const attendanceData = [];
    document.querySelectorAll('.attendance-item').forEach(item => {
        const studentId = item.dataset.studentId;
        const statusValue = item.querySelector('.attendance-status').value;
        const status = statusMap[statusValue] || '';
        const note = item.querySelector('.attendance-note').value;
        attendanceData.push({
            studentId,
            status,
            note
        });
    });

    fetch('../php/save_attendance.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, date, attendanceData })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Điểm danh đã được lưu');
            } else {
                alert('Lưu điểm danh thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Lỗi khi lưu điểm danh!');
            console.error(err);
        });
}

// View attendance history
function viewAttendanceHistory() {
    const classId = document.getElementById('class-select').value;
    const date = document.getElementById('attendance-date').value;
    if (!classId || !date) {
        alert('Vui lòng chọn lớp và ngày');
        return;
    }

    fetch(`../php/get_attendance_history.php?classId=${classId}&date=${date}`)
        .then(res => res.json())
        .then(data => {
            const historyDiv = document.getElementById('attendance-history');
            const historyBody = document.getElementById('attendance-history-body');
            historyBody.innerHTML = '';
            if (!data || data.length === 0) {
                historyBody.innerHTML = '<tr><td colspan="3" style="text-align:center;">Không có dữ liệu điểm danh cho ngày này</td></tr>';
            } else {
                data.forEach(row => {
                    historyBody.innerHTML += `
                        <tr>
                            <td>${row.FullName}</td>
                            <td>${row.Status}</td>
                            <td>${row.Note || ''}</td>
                            <td>
                                <button class="delete-attendance-btn" data-student-id="${row.StudentID}" onclick="deleteAttendance('${row.StudentID}')">Xóa</button>
                            </td>
                        </tr>
                    `;
                });
            }
            historyDiv.style.display = 'block';
        })
        .catch(err => {
            alert('Không thể tải lịch sử điểm danh!');
            console.error(err);
        });
}

function deleteAttendance(studentId) {
    const classId = document.getElementById('class-select').value;
    const date = document.getElementById('attendance-date').value;
    if (!classId || !date || !studentId) return;
    if (!confirm('Bạn có chắc chắn muốn xóa điểm danh của học sinh này?')) return;

    fetch('../php/delete_attendance.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, date, studentId })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Đã xóa điểm danh!');
                viewAttendanceHistory(); // Refresh lại bảng
            } else {
                alert('Xóa thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Lỗi khi xóa điểm danh!');
            console.error(err);
        });
}

// Popup Notification Form
document.getElementById('send-notification-btn').onclick = function () {
    const select = document.getElementById('notification-class-select');
    select.innerHTML = '';
    teacherData.classes.forEach(cls => {
        select.innerHTML += `<option value="${cls.ClassID}">${cls.ClassName}</option>`;
    });
    document.getElementById('homework-deadline-group').style.display = 'none';
    document.getElementById('homework-deadline-input').value = '';
    document.getElementById('notification-content-input').value = '';
    document.getElementById('send-notification-modal').style.display = 'flex';
};

// Hiện/ẩn trường hạn nộp khi chọn loại thông báo
document.getElementById('notification-type-select').addEventListener('change', function () {
    const deadlineGroup = document.getElementById('homework-deadline-group');
    if (this.value === 'Bài tập về nhà') {
        deadlineGroup.style.display = 'block';
    } else {
        deadlineGroup.style.display = 'none';
    }
});

function closeSendNotificationModal() {
    document.getElementById('send-notification-modal').style.display = 'none';
}

// Send notification
function submitSendNotification() {
    const classId = document.getElementById('notification-class-select').value;
    const type = document.getElementById('notification-type-select').value;
    const content = document.getElementById('notification-content-input').value.trim();
    const deadline = document.getElementById('homework-deadline-input').value;

    if (!classId || !type || !content) {
        alert('Vui lòng nhập đầy đủ thông tin');
        return;
    }

    fetch('../php/send_notification.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, type, content })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // Nếu là bài tập về nhà, thêm vào bảng homework
                if (type === 'Bài tập về nhà') {
                    fetch('../php/add_homework.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            classId,
                            title: 'Bài tập về nhà',
                            description: content,
                            duedate: deadline // gửi hạn nộp
                        })
                    })
                        .then(res => res.json())
                        .then(hw => {
                            if (hw.success) {
                                alert('Đã gửi thông báo và thêm bài tập về nhà!');
                            } else {
                                alert('Đã gửi thông báo, nhưng thêm bài tập về nhà thất bại!');
                            }
                            closeSendNotificationModal();
                            loadTeacherSentNotifications();
                        });
                } else {
                    alert('Đã gửi thông báo!');
                    closeSendNotificationModal();
                    loadTeacherSentNotifications();
                }
            } else {
                alert('Gửi thông báo thất bại!');
            }
        })
        .catch(err => {
            alert('Lỗi khi gửi thông báo!');
            console.error(err);
        });
}

// Load received notifications
function loadTeacherReceivedNotifications() {
    const list = document.getElementById('teacher-received-list');
    const detail = document.getElementById('teacher-received-detail');
    list.innerHTML = '';
    detail.innerHTML = '<div style="color:#888;text-align:center;padding:16px;">Chọn một thông báo để xem chi tiết</div>';

    (teacherData.received_notifications || []).forEach((msg, idx) => {
        const item = document.createElement('div');
        item.className = 'message-item' + (msg.IsRead == 0 ? ' unread' : '');
        item.innerHTML = `
            <div class="message-title">${msg.Type || msg.subject}</div>
            <div class="message-meta">
                <span>${msg.sender || 'Admin'}</span> | 
                <span>${msg.SentAt || msg.date}</span>
            </div>
        `;
        item.onclick = function () {
            document.querySelectorAll('.message-item').forEach(i => i.classList.remove('selected'));
            item.classList.add('selected');
            item.classList.remove('unread'); // bỏ viền đỏ khi click
            showTeacherReceivedDetail(msg);

            // Nếu chưa đọc thì gọi API cập nhật
            if (msg.IsRead == 0 && msg.MessageID) {
                fetch('../php/mark_message_read.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ messageId: msg.MessageID })
                }).then(() => {
                    msg.IsRead = 1; // Cập nhật trạng thái trên giao diện
                });
            }
        };
        list.appendChild(item);
    });
}

function showTeacherReceivedDetail(msg) {
    const detail = document.getElementById('teacher-received-detail');
    detail.innerHTML = `
        <h3>${msg.subject || msg.Type}</h3>
        <p><strong>Từ:</strong> ${msg.from || 'Admin'}</p>
        <p><strong>Ngày:</strong> ${msg.date || msg.SentAt}</p>
        <div class="message-body">${msg.content || msg.Content}</div>
    `;
}

// Load sent notifications
function loadTeacherSentNotifications() {
    const body = document.getElementById('teacher-sent-table');
    body.innerHTML = '';
    (teacherData.sent_notifications || []).forEach(row => {
        body.innerHTML += `
            <tr>
                <td>${row.SentAt}</td>
                <td>${row.ClassName}</td>
                <td>${row.Type}</td>
                <td>${row.Content}</td>
            </tr>
        `;
    });
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
    const oldPassword = document.getElementById('profile-old-password').value;
    const email = document.getElementById('profile-email').value;

    // Regex kiểm tra
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^0\d{9}$/;
    const passwordRegex = /^[a-zA-Z0-9]{6,}$/;

    // Kiểm tra email
    if (!emailRegex.test(email)) {
        alert('Email không hợp lệ, vui lòng nhập theo định dạng example@email.domainname!');
        return;
    }
    // Kiểm tra số điện thoại
    if (!phoneRegex.test(newPhone)) {
        alert('Số điện thoại phải bắt đầu bằng 0 và đủ 10 số!');
        return;
    }
    // Kiểm tra mật khẩu mới nếu có nhập
    if (oldPassword || newPassword) {
        if (!oldPassword || !newPassword) {
            alert('Vui lòng nhập đầy đủ cả mật khẩu cũ và mật khẩu mới!');
            return;
        }
        if (!passwordRegex.test(newPassword)) {
            alert('Mật khẩu mới phải có ít nhất 6 ký tự và chỉ gồm chữ, số!');
            return;
        }
    }

    fetch('../php/update_information.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            phone: newPhone,
            email: email,
            oldPassword: oldPassword,
            newPassword: newPassword,
            role: 'teacher'
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Cập nhật thông tin thành công, vui lòng đăng nhập lại!');
                // Nếu đổi mật khẩu thành công, chuyển hướng về trang đăng nhập
                if (oldPassword && newPassword) {
                    window.location.href = './logout.php';
                }
            } else {
                alert(data.message || 'Cập nhật thất bại!');
            }
        })
        .catch(err => {
            alert('Lỗi khi cập nhật!');
            console.error(err);
        });
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
