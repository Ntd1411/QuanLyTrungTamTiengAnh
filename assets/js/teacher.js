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
            loadTeachingLog();
            loadTeacherReceivedNotifications();
            loadTeacherSentNotifications();
        })
        .catch(err => {
            alert('Không thể tải dữ liệu giáo viên!');
            console.error(err);
        });
});

// Các hàm phục vụ tải dữ liệu cho phần dashboard giáo viên

function loadTeacherDashboard() {
    document.getElementById('teacher-name').textContent = teacherData.name;

    // Hiển thị buổi dạy tiếp theo
    const nextSession = getNextTeachingSession();
    const nextSessionDiv = document.getElementById('next-session-info');
    if (nextSessionDiv) {
        if (nextSession) {
            const d = nextSession.date;
            const weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
            const thu = weekdays[d.getDay()];
            nextSessionDiv.innerHTML = `
            <strong>Ngày:</strong> ${thu}, ${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}<br>
            <strong>Giờ:</strong> ${nextSession.time} <br>
            <strong>Lớp:</strong> ${nextSession.className} - ${nextSession.schoolYear || ''} - ${nextSession.room || ''}
        `;
        } else {
            nextSessionDiv.innerHTML = 'Không có buổi dạy nào sắp tới';
        }
    }

    const studentsListDiv = document.querySelector('.class-students-list');
    if (studentsListDiv) studentsListDiv.style.display = 'none';

    let totalStudents = teacherData.classes.reduce((sum, cls) => sum + (cls.students ? cls.students.length : 0), 0);
    document.getElementById('total-students').textContent = totalStudents;

    document.getElementById('monthly-sessions').textContent = teacherData.monthly_sessions || 0;

    const classesContainer = document.querySelector('.classes-container');
    if (classesContainer && teacherData.classes.length != 0) {
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
                <p><strong>Số buổi đã dạy:</strong> ${cls.TaughtSessions || 0}</p>
            </div>
            `;
            // Thêm sự kiện click để hiện danh sách học sinh
            classCard.style.cursor = 'pointer';
            classCard.onclick = () => showClassStudents(cls.ClassID || cls.id);
            classesContainer.appendChild(classCard);
        });
    } else {
        document.getElementById('no-teaching-class').style = 'inline-block';
    }
}

// Tải nhật ký dạy
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
            <td>${log.ClassName}${log.SchoolYear ? ' - ' + log.SchoolYear : ''} - ${log.Room || ''}</td>
            <td>${log.Status}</td>
            <td>${log.Note || ''}</td>
            <td>
                <button class="delete-log-btn" onclick="deleteTeachingLog('${log.SessionID}')">Xóa</button>
            </td>
        `;
        logBody.appendChild(row);
    });

    initializeDataTable('#teaching-log');
}

// Xóa nhật ký dạy
function deleteTeachingLog(SessionID) {
    if (!confirm('Bạn có chắc chắn muốn xóa nhật ký này?')) return;
    fetch('../php/delete_teaching_log.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ logId: SessionID })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Đã xóa nhật ký!');
                location.reload();
            } else {
                alert('Xóa thất bại!');
            }
        })
        .catch(err => {
            alert('Lỗi khi xóa nhật ký!');
            console.error(err);
        });
}

// Form popup thêm nhật ký dạy
// Hiện popup
document.getElementById('add-log-btn').onclick = function () {
    // Đổ danh sách lớp vào select với cú pháp: Tên lớp - Năm học
    const select = document.getElementById('log-class-select');
    select.innerHTML = '';
    teacherData.classes.forEach(cls => {
        select.innerHTML += `<option value="${cls.ClassID}">${cls.ClassName} - ${cls.SchoolYear || ''} - ${cls.Room || ''}</option>`;
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

// Tải lớp trong select gửi thông báo
function loadClassSelect() {
    const classSelects = document.querySelectorAll('#class-select, #notification-class');
    classSelects.forEach(select => {
        select.innerHTML = '<option value="">Chọn lớp</option>';
        teacherData.classes.forEach(cls => {
            // Hiển thị: Tên lớp - Năm học
            select.innerHTML += `<option value="${cls.ClassID || cls.id}">${(cls.ClassName || cls.name) + ' - ' + (cls.SchoolYear || '') + (cls.Room ? ' - ' + cls.Room : '')}</option>`;
        });
    });
}

// Hiển thị danh sách học sinh của lớp
function showClassStudents(classId) {
    const cls = teacherData.classes.find(c => (c.ClassID || c.id) == classId);
    const studentsListDiv = document.querySelector('.class-students-list');

    if (!cls || !studentsListDiv) return;

    studentsListDiv.style.display = 'none';
    studentsListDiv.classList.remove('active');

    let studentData = [];
    if (cls.students && cls.students.length > 0) {
        studentData = cls.students.map((student, idx) => [
            idx + 1,
            student.FullName,
            student.attended || 0,
            student.absent || 0,
            `${student.participation || 0}%`,
            student.UserID
        ]);
    }
    
    const table = initializeDataTable('#student-datatable');

    table.clear();
    table.rows.add(studentData);
    table.draw();

    setTimeout(() => {
        studentsListDiv.style.display = 'block';
        requestAnimationFrame(() => {
            studentsListDiv.classList.add('active');
            $(window).trigger('resize');
        });
    }, 50);
}

// Tải danh sách điểm danh
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

// Lưu điểm danh
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
                viewAttendanceHistory();
            } else {
                alert('Lưu điểm danh thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Lỗi khi lưu điểm danh!');
            console.error(err);
        });
}

// Xem lịch sử điểm danh
function viewAttendanceHistory() {
    const classId = document.getElementById('class-select').value;
    const date = document.getElementById('attendance-date').value;
    if (!classId || !date) {
        alert('Vui lòng chọn lớp và ngày để xem lịch sử.');
        return;
    }

    const historyDiv = document.getElementById('attendance-history');
    historyDiv.style.display = 'block';

    fetch(`../php/get_attendance_history.php?classId=${classId}&date=${date}`)
        .then(res => {
            if (!res.ok) {
                throw new Error(`Lỗi mạng: ${res.statusText}`);
            }
            return res.json();
        })
        .then(data => {
            const dataForTable = data.map(row => {
                const actions = `
                    <button class="button-small" onclick="updateAttendance('${row.StudentID}', '${row.FullName}')">Sửa</button>
                    <button class="button-small delete-btn" onclick="deleteAttendance('${row.StudentID}')">Xóa</button>
                `;
                
                let statusText = row.Status;
                if (row.Status === 'present') statusText = 'Có mặt';
                else if (row.Status === 'absent') statusText = 'Vắng mặt';
                else if (row.Status === 'late') statusText = 'Đi muộn';

                return [
                    row.FullName,
                    statusText,
                    row.Note || '',
                    actions
                ];
            });

            const table = initializeDataTable('#attendance-history-table');
            table.clear();
            table.rows.add(dataForTable);
            table.draw();

            document.getElementById('view-history-btn').style.display = 'none';
            document.getElementById('hide-history-btn').style.display = 'inline-block';
            
            $(window).trigger('resize');
        })
        .catch(err => {
            alert('Không thể tải lịch sử điểm danh!');
            console.error('Lỗi khi fetch lịch sử điểm danh:', err);
            hideAttendanceHistory();
        });
}

// Ân hiện lịch sử điểm danh
function hideAttendanceHistory() {
    const historyDiv = document.getElementById('attendance-history');
    if (historyDiv) {
        historyDiv.style.display = 'none';
    }
    
    document.getElementById('view-history-btn').style.display = 'inline-block';
    document.getElementById('hide-history-btn').style.display = 'none';
}

// Sửa điểm danh
function updateAttendance(studentId, studentName) {
    // Điền dữ liệu vào form
    document.getElementById('student-name-input').value = studentName;
    document.getElementById('status-select').value = ''; // Reset trạng thái
    document.getElementById('note-input').value = '';   // Reset ghi chú
    document.getElementById('student-id-input').value = studentId; // Lưu studentId

    // Hiển thị modal
    document.getElementById('attendance-modal').style.display = 'flex';
}

// Lưu điểm danh đã sửa
function saveUpdate() {
    const studentId = document.getElementById('student-id-input').value; // Lấy từ hidden input
    const classId = document.getElementById('class-select').value;
    const date = document.getElementById('attendance-date').value;
    const status = document.getElementById('status-select').value;
    const note = document.getElementById('note-input').value;
    if (!status) {
        alert('Vui lòng chọn trạng thái!');
        return;
    }

    fetch('../php/update_attendance.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, date, studentId, status, note })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Đã cập nhật điểm danh!');
                viewAttendanceHistory(); // Refresh lại bảng
                document.getElementById('attendance-modal').style.display = 'none';
            } else {
                alert('Cập nhật thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Lỗi khi cập nhật điểm danh!');
            console.error(err);
        });
}

// Xóa điểm danh
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

// Form popup gửi thông báo
document.getElementById('send-notification-btn').onclick = function () {
    const select = document.getElementById('notification-class-select');
    select.innerHTML = '';
    teacherData.classes.forEach(cls => {
        select.innerHTML += `<option value="${cls.ClassID}">${cls.ClassName} - ${cls.SchoolYear || ''} - ${cls.Room || ''}</option>`;
    });
    document.getElementById('homework-deadline-group').style.display = 'none';
    document.getElementById('notification-type-select').value = '';
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

// Gửi thông báo
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

                    if (!deadline) {
                        alert('Vui lòng nhập hạn nộp bài tập');
                        return;
                    }

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
                            fetchTeacherSentNotifications();
                            // Cập nhật lại danh sách thông báo đã gửi
                        });
                } else {
                    alert('Đã gửi thông báo!');
                    closeSendNotificationModal();
                    fetchTeacherSentNotifications();
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

// Tải thông báo đã nhận
function loadTeacherReceivedNotifications() {
    const list = document.getElementById('teacher-received-list');
    const detail = document.getElementById('teacher-received-detail');
    
    // Đặt nội dung mặc định ban đầu
    detail.innerHTML = '<div style="color:#888;text-align:center;padding:16px;">Chọn một thông báo để xem chi tiết</div>';

    // Lấy dữ liệu và kiểm tra
    const allMessages = teacherData.received_notifications || [];
    if (allMessages.length === 0) {
        list.innerHTML = '<div style="color:#888;padding:16px;">Không có thông báo nào.</div>';
        // Xóa các nút phân trang cũ nếu có
        const paginationContainer = document.getElementById('teacher-pagination-container');
        if (paginationContainer) paginationContainer.innerHTML = '';
        return;
    }
    
    // Biến cho việc phân trang
    const messagesPerPage = 5; // Số lượng thông báo trên mỗi trang
    let currentPage = 1;
    const totalPages = Math.ceil(allMessages.length / messagesPerPage);

    // Hàm hiển thị một trang cụ thể
    function showPage(page) {
        currentPage = page;
        list.innerHTML = ''; // Xóa danh sách cũ

        const startIndex = (currentPage - 1) * messagesPerPage;
        const endIndex = startIndex + messagesPerPage;
        const messagesToShow = allMessages.slice(startIndex, endIndex);

        messagesToShow.forEach(msg => {
            const item = document.createElement('div');
            // Dùng IsRead == 0 để xác định chưa đọc
            item.className = 'message-item' + (msg.IsRead == 0 ? ' unread' : '');
            
            // Sử dụng các thuộc tính của teacherData
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
                showTeacherReceivedDetail(msg); // Gọi hàm hiển thị chi tiết có sẵn

                // Nếu chưa đọc, gọi API cập nhật
                if (msg.IsRead == 0 && msg.MessageID) {
                    item.classList.remove('unread');
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

        updatePaginationControls(); // Cập nhật lại các nút phân trang
    }

    // --- Hàm cập nhật các nút điều khiển phân trang ---
    function updatePaginationControls() {
        const paginationContainer = document.getElementById('teacher-pagination-container');
        if (!paginationContainer) return;

        paginationContainer.innerHTML = '';

        // Nút "Trước"
        const prevButton = document.createElement('button');
        prevButton.textContent = 'Trước';
        prevButton.disabled = currentPage === 1;
        prevButton.onclick = () => showPage(currentPage - 1);
        paginationContainer.appendChild(prevButton);

        // Các nút số trang (logic phức tạp để hiển thị "...")
        // ... (Sao chép logic từ hàm của phụ huynh)
        let pageNumbers = [];
        if (totalPages <= 7) {
            for (let i = 1; i <= totalPages; i++) pageNumbers.push(i);
        } else {
            if (currentPage <= 3) {
                pageNumbers.push(1, 2, 3, 4, '...', totalPages);
            } else if (currentPage >= totalPages - 2) {
                pageNumbers.push(1, '...', totalPages - 3, totalPages - 2, totalPages - 1, totalPages);
            } else {
                pageNumbers.push(1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages);
            }
        }
        
        pageNumbers.forEach(pageNumber => {
            if (pageNumber === '...') {
                // Nếu phần tử mảng là dấu ...

                const ellipsisSpan = document.createElement('span');
                ellipsisSpan.textContent = '...';
                paginationContainer.appendChild(ellipsisSpan);
            } else {
                // Nếu phần tử mảng là 1 con số

                const pageButton = document.createElement('button');
                pageButton.textContent = pageNumber;
                if (pageNumber === currentPage) {
                    pageButton.classList.add('active');
                }
                pageButton.onclick = () => showPage(pageNumber);
                paginationContainer.appendChild(pageButton);
            }
        });

        // Nút "Sau"
        const nextButton = document.createElement('button');
        nextButton.textContent = 'Sau';
        nextButton.disabled = currentPage === totalPages;
        nextButton.onclick = () => showPage(currentPage + 1);
        paginationContainer.appendChild(nextButton);
    }

    // Bắt đầu bằng cách hiển thị trang đầu tiên
    showPage(1);
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

// Fetch lại dữ liệu thông báo sau khi gửi thành công để làm mới bảng
function fetchTeacherSentNotifications() {
    fetch('../php/new_teacher_sent_data.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ senderId: teacherData.id })
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                teacherData.sent_notifications = data.notifications; // Cập nhật dữ liệu
                loadTeacherSentNotifications(); // Làm mới bảng
            } else {
                alert('Không thể tải danh sách thông báo!');
            }
        })
        .catch(err => {
            alert('Lỗi khi tải danh sách thông báo!');
            console.error(err);
        });
}

// Tải thông báo đã gửi
function loadTeacherSentNotifications() {
    const notifications = teacherData.sent_notifications || [];

    const dataForTable = notifications.map(row => {
        const className = `${row.ClassName}${row.SchoolYear ? ' - ' + row.SchoolYear : ''}${row.Room ? ' - ' + row.Room : ''}`;
        return [
            row.SentAt,
            className,
            row.Type,
            row.Content
        ];
    });

    const table = initializeDataTable('#table-sent-notifications');
    table.clear();
    table.rows.add(dataForTable);
    table.draw();
}

// Tải thông tin cá nhân của giáo viên
function loadTeacherProfile() {
    document.getElementById('profile-name').value = teacherData.name || '';
    document.getElementById('profile-email').value = teacherData.email || '';
    document.getElementById('profile-phone').value = teacherData.phone || '';
}

// Cập nhật thông tin cá nhân
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
                if (!confirm('Bạn có chắc chắn muốn cập nhật thông tin?')) return;
                alert('Cập nhật thông tin thành công!');
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

// Xem lịch dạy (rất phức tạp)
document.getElementById('view-schedule-btn').onclick = viewSchedule;
function viewSchedule() {
    const scheduleBody = document.getElementById('schedule-body');
    scheduleBody.innerHTML = '';

    // Lấy tuần được chọn
    const weekInput = document.getElementById('schedule-week').value;
    if (!weekInput) {
        alert('Vui lòng chọn tuần để xem lịch!');
        return; // Không hiển thị gì nếu chưa chọn tuần
    }
    let weekStart = null, weekEnd = null;
    if (weekInput) {
        const [year, week] = weekInput.split('-W');
        const firstDay = new Date(year, 0, 1 + (week - 1) * 7);
        weekStart = new Date(firstDay.setDate(firstDay.getDate() - (firstDay.getDay() === 0 ? 6 : firstDay.getDay() - 1)));
        weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);
    }

    // Tạo map: { time: [thứ 2,...,CN] }
    const timeSlots = {};
    (teacherData.classes || []).forEach(cls => {
        // Lọc theo tuần
        const start = new Date(cls.StartDate);
        const end = new Date(cls.EndDate);
        if (weekStart && weekEnd && (end < weekStart || start > weekEnd)) return;

        const { days, time } = parseClassTime(cls.ClassTime);
        if (!time) return;
        if (!timeSlots[time]) timeSlots[time] = [null, null, null, null, null, null, null];
        days.forEach(day => {
            const idx = day === 8 ? 6 : day - 2;
            if (idx >= 0 && idx < 7) {
                timeSlots[time][idx] = cls.ClassName + ' - ' + (cls.SchoolYear || cls.year || '') + (cls.Room ? ' - ' + cls.Room : '');
            }
        });
    });

    // Hiển thị lịch
    Object.keys(timeSlots)
        .sort((a, b) => {
            const [ah, am] = a.split(':').map(Number);
            const [bh, bm] = b.split(':').map(Number);
            return ah * 60 + am - (bh * 60 + bm);
        })
        .forEach(time => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${time}</td>
                ${[0, 1, 2, 3, 4, 5, 6].map(i => `<td>${timeSlots[time][i] || ''}</td>`).join('')}
            `;
            scheduleBody.appendChild(row);
        });
}

function parseClassTime(classTime) {
    // Ví dụ: "Thứ 2,4,6 - 18:00"
    if (!classTime) return { days: [], time: '' };
    const [daysPart, timePart] = classTime.split(' - ');
    const days = daysPart.replace('Thứ ', '').split(',').map(d => parseInt(d.trim()));
    return { days, time: timePart };
}

// Lấy buổi học tiếp theo trong 3 tuần tới
function getNextTeachingSession() {
    const now = new Date();
    let nextSession = null;

    (teacherData.classes || []).forEach(cls => {
        const { days, time } = parseClassTime(cls.ClassTime);
        if (!days || !time) return;

        // Lấy ngày bắt đầu và kết thúc lớp
        const startDate = new Date(cls.StartDate);
        const endDate = new Date(cls.EndDate);

        // Duyệt 21 ngày tới (3 tuần), tìm buổi gần nhất hợp lệ
        for (let i = 0; i < 21; i++) {
            const d = new Date(now);
            d.setDate(now.getDate() + i);
            if (d < startDate || d > endDate) continue;

            // JS: Chủ nhật là 0, Thứ 2 là 1, ... Thứ 7 là 6
            let jsDay = d.getDay(); // 0-6
            let thu = jsDay === 0 ? 8 : jsDay + 1; // Quy đổi về Thứ 2-8 (CN)
            if (!days.includes(thu)) continue;

            // Ghép giờ học
            const [h, m] = time.split(':').map(Number);
            d.setHours(h, m, 0, 0);

            if (d > now && (!nextSession || d < nextSession.date)) {
                nextSession = {
                    date: new Date(d),
                    className: cls.ClassName,
                    time: time,
                    schoolYear: cls.SchoolYear || cls.year || '',
                    room: cls.Room || ''
                };
            }
        }
    });

    return nextSession;
}

// Hiển thị lịch dạy của buổi dạy tiếp theo khi click vào thẻ tóm tắt
document.querySelector('.summary-card[onclick*="showElement(\'schedule\')"]').onclick = function () {
    const nextSession = getNextTeachingSession();
    if (nextSession && nextSession.date) {
        // Tính tuần ISO
        const d = nextSession.date;
        const year = d.getFullYear();
        // Lấy số thứ tự tuần ISO
        const temp = new Date(d.getTime());
        temp.setHours(0, 0, 0, 0);
        // Thứ 2 là ngày đầu tuần ISO
        temp.setDate(temp.getDate() + 4 - (temp.getDay() || 7));
        const yearStart = new Date(temp.getFullYear(), 0, 1);
        const weekNo = Math.ceil((((temp - yearStart) / 86400000) + 1) / 7);

        // Set giá trị cho input week
        const weekStr = `${year}-W${weekNo.toString().padStart(2, '0')}`;
        document.getElementById('schedule-week').value = weekStr;
    } else {
        alert("Không có lịch dạy để xem!");
        return;
    }
    showElement('schedule');
    setTimeout(viewSchedule, 0); // Đảm bảo DOM đã chuyển tab
};

// Event listeners
document.getElementById('class-select').addEventListener('change', function () {
    loadAttendanceList(this.value);
});

// Hàm khởi tạo bảng
function initializeDataTable(tableId) {
    try {
        if ($.fn.DataTable.isDataTable(tableId)) {
            $(tableId).DataTable().destroy();
        }

        return $(tableId).DataTable({
            responsive: {
                details: {
                    display: $.fn.dataTable.Responsive.display.modal({
                        header: function (row) {
                            return '';
                        }
                    }),
                    renderer: $.fn.dataTable.Responsive.renderer.tableAll()
                }
            },
            language: {
                emptyTable: "Không có dữ liệu",
                info: "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                infoEmpty: "Hiển thị 0 đến 0 của 0 mục",
                infoFiltered: "(được lọc từ _MAX_ mục)",
                infoPostFix: "",
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
            pageLength: 10,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
            columnDefs: [
                { responsivePriority: 1, targets: 0 },
                { responsivePriority: 2, targets: -1 },
                { responsivePriority: 3, targets: 1 }
            ],
            drawCallback: function () {
                // Đảm bảo responsive được kích hoạt sau khi vẽ lại bảng
                $(tableId).css('width', '100%');
                $(window).trigger('resize');
            }
        });
    } catch (error) {
        console.error('Error initializing DataTable:', error);
    }
}