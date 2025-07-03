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
        })
        .catch(err => {
            alert('Không thể tải dữ liệu học sinh!');
            console.error(err);
        });
});

// Tải dữ liệu trang dashboard
function loadStudentDashboard() {
    document.getElementById('student-name').textContent = studentData.name || 'Học sinh';
    document.getElementById('class-name').textContent = (studentData.class && studentData.class.name && studentData.class.status != 'Đã kết thúc') ? studentData.class.name : 'Chưa trong lớp nào';
    document.getElementById('attended-sessions').textContent = (studentData.attendance && studentData.class.status != 'Đã kết thúc') ? studentData.attendance.attended : 0;
    document.getElementById('absent-sessions').textContent = (studentData.attendance && studentData.class.status != 'Đã kết thúc') ? studentData.attendance.absent : 0;

    // Đếm số bài tập chưa hoàn thành
    const newHomework = (studentData.homework && studentData.class.status != 'Đã kết thúc')
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

    // Tải thông báo
    loadStudentNotifications();
}

// Tải thông báo cho học sinh (logic giống phụ huynh và giáo viên)
function loadStudentNotifications() {
    const notificationList = document.querySelector('.notification-list');
    const notificationContent = document.querySelector('.notification-content');

    notificationContent.innerHTML = '<p style="text-align:center; color:#888;">Chọn một thông báo để xem chi tiết</p>';

    const allMessages = studentData.messages || [];
    if (allMessages.length === 0) {
        notificationList.innerHTML = '<p>Không có thông báo nào.</p>';
        const paginationContainer = document.getElementById('student-pagination-container');
        if (paginationContainer) paginationContainer.innerHTML = '';
        return;
    }

    const messagesPerPage = 3;
    let currentPage = 1;
    const totalPages = Math.ceil(allMessages.length / messagesPerPage);

    function showPage(page) {
        currentPage = page;
        notificationList.innerHTML = '';

        const startIndex = (currentPage - 1) * messagesPerPage;
        const endIndex = startIndex + messagesPerPage;
        const messagesToShow = allMessages.slice(startIndex, endIndex);

        messagesToShow.forEach(msg => {
            const item = document.createElement('div');
            item.className = `notification-item${msg.read ? '' : ' unread'}`;
            item.innerHTML = `
                <h4>${msg.subject}</h4>
                <p style="font-size:13px; color:#555;">Từ: ${msg.from}</p>
                <p style="font-size:12px; color:#888;">Ngày: ${msg.date}</p>
            `;
            item.onclick = () => {
                document.querySelectorAll('.notification-item').forEach(i => i.classList.remove('selected'));
                item.classList.add('selected');
                showStudentNotificationDetail(msg);

                if (!msg.read && msg.id) {
                    item.classList.remove('unread');
                    fetch('../php/mark_message_read.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ messageId: msg.id })
                    }).then(() => {
                        msg.read = true;
                    });
                }
            };
            notificationList.appendChild(item);
        });

        updatePaginationControls();
    }

    function updatePaginationControls() {
        const paginationContainer = document.getElementById('student-pagination-container');
        if (!paginationContainer) return;
        paginationContainer.innerHTML = '';

        const prevButton = document.createElement('button');
        prevButton.textContent = 'Trước';
        prevButton.disabled = currentPage === 1;
        prevButton.onclick = () => showPage(currentPage - 1);
        paginationContainer.appendChild(prevButton);

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
                const ellipsisSpan = document.createElement('span');
                ellipsisSpan.textContent = '...';
                paginationContainer.appendChild(ellipsisSpan);
            } else {
                const pageButton = document.createElement('button');
                pageButton.textContent = pageNumber;
                if (pageNumber === currentPage) {
                    pageButton.classList.add('active');
                }
                pageButton.onclick = () => showPage(pageNumber);
                paginationContainer.appendChild(pageButton);
            }
        });

        const nextButton = document.createElement('button');
        nextButton.textContent = 'Sau';
        nextButton.disabled = currentPage === totalPages;
        nextButton.onclick = () => showPage(currentPage + 1);
        paginationContainer.appendChild(nextButton);
    }

    showPage(1);
}

// Hiển thị thông báo chi tiết
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

// Tải thông tin lớp học
function loadClassInfo() {
    const studentClass = studentData.class || {};

    if (studentClass.status != 'Đã kết thúc') {
        document.getElementById('current-class').textContent = studentClass.name || 'không có dữ liệu';
        document.getElementById('teacher-name').textContent = studentClass.teacher || 'không có dữ liệu';
        document.getElementById('class-schedule').textContent = studentClass.schedule || 'không có dữ liệu';
        document.getElementById('class-status').textContent = studentClass.status || 'không có dữ liệu';

        const classmates = studentClass.classmates || [];

        const dataForTable = classmates.map((mate, index) => {
            return [
                index + 1,
                mate.FullName,
                mate.BirthDate || '' // Đảm bảo không có giá trị null/undefined
            ];
        });

        // Gọi hàm khởi tạo DataTables
        const table = initializeDataTable('#table-classmates');

        // Xóa dữ liệu cũ, thêm dữ liệu mới và vẽ lại bảng
        table.clear();
        table.rows.add(dataForTable);
        table.draw();
    } else {
        document.getElementById('class-information').textContent = 'Bạn đang không trong lớp nào.';
        document.getElementById('current-class').textContent = 'không có dữ liệu';
        document.getElementById('teacher-name').textContent = 'không có dữ liệu';
        document.getElementById('class-schedule').textContent = 'không có dữ liệu';
        document.getElementById('class-status').textContent = 'không có dữ liệu';
        document.getElementById('classmates-list-div').style.display = 'none';
    }
}

// Tải lịch sử điểm danh
function loadAttendance() {
    if (studentData.class.status != 'Đã kết thúc') {
        const attendanceData = studentData.attendance || {};
        const attended = attendanceData.attended || 0;
        const absent = attendanceData.absent || 0;
        const total = attended + absent;

        document.getElementById('total-sessions').textContent = total;
        document.getElementById('attended-count').textContent = attended;
        document.getElementById('absent-count').textContent = absent;

        updateAttendanceProgress(attended, total);

        const history = attendanceData.history || [];
        const teacherName = (studentData.class && studentData.class.teacher) ? studentData.class.teacher : '-';

        const dataForTable = history.map(record => {
            let statusText = record.Status || '-'; // Mặc định là trạng thái gốc
            if (statusText === 'present') statusText = 'Có mặt';
            else if (statusText === 'absent') statusText = 'Vắng mặt';
            else if (statusText === 'late') statusText = 'Đi muộn';

            return [
                record.Date,
                statusText,
                record.Note || '-',
                teacherName
            ];
        });

        // Gọi hàm khởi tạo DataTables
        const table = initializeDataTable('#table-attendance-history');

        // Kiểm tra và cập nhật dữ liệu
        if (table) {
            table.clear();
            table.rows.add(dataForTable);
            table.draw();
        }
    }
}

function updateAttendanceProgress(attended, total) {
    // Đầu vào (attended, total) giờ đây đã được đảm bảo là số
    const rate = total > 0 ? (attended / total) * 100 : 0;
    const progress = (rate / 100) * 360;

    const progressCircle = document.querySelector('.progress-circle');
    if (!progressCircle) {
        console.error("Không tìm thấy element '.progress-circle'");
        return;
    }
    const progressValue = progressCircle.querySelector('.progress-value');
    if (!progressValue) {
        console.error("Không tìm thấy element '.progress-value'");
        return;
    }

    // Tạo vòng tròn quá trình nếu chưa có
    let progressElement = progressCircle.querySelector('.progress');
    if (!progressElement) {
        progressElement = document.createElement('div');
        progressElement.className = 'progress';
        progressCircle.appendChild(progressElement);
    }

    // Cập nhật giao diện vòng tròn
    progressCircle.style.setProperty('--progress', progress + 'deg');

    // Đặt giá trị cuối cùng ngay lập tức để đảm bảo hiển thị đúng
    progressValue.textContent = Math.round(rate) + '%';

    // Animation
    let currentValue = 0;
    const animationDuration = 500;
    const framesPerSecond = 60;
    const totalFrames = (animationDuration / 1000) * framesPerSecond;
    // Đảm bảo step không phải là 0 để tránh vòng lặp vô hạn nếu rate rất nhỏ
    const step = rate > 0 ? rate / totalFrames : 0;

    if (step > 0) {
        const animateValue = () => {
            currentValue += step;
            if (currentValue >= rate) {
                progressValue.textContent = Math.round(rate) + '%';
                return;
            }
            progressValue.textContent = Math.round(currentValue) + '%';
            requestAnimationFrame(animateValue);
        };
        progressValue.textContent = '0%';
        animateValue();
    }
}

// Tải btvn
function loadHomework() {
    const homeworkList = document.getElementById('homework-list');
    homeworkList.innerHTML = '';

    if (studentData.class.status != 'Đã kết thúc') {
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

                    // Xử lý sự kiện submit bài tập (chưa phát triển)
                }

                homeworkList.appendChild(card);
            });
        } else {
            // Nếu không có bài tập nào
            homeworkList.innerHTML = '<h2>Chưa có bài tập nào.<h2>';
        }
    } else {
        homeworkList.innerHTML = '<h2>Bạn đang không trong lớp nào.<h2>';
    }
}

// Tải thông tin cá nhân học sinh
function loadStudentProfile() {
    document.getElementById('profile-name').value = studentData.name || '';
    document.getElementById('profile-class').value = (studentData.class && studentData.class.name) ? studentData.class.name : '';
    document.getElementById('profile-email').value = studentData.email || '';
    document.getElementById('profile-phone').value = studentData.phone || '';
}

// Cập nhật thông tin cá nhân
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
            email: newEmail,
            phone: newPhone,
            oldPassword: oldPassword,
            newPassword: newPassword,
            role: 'student'
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (!confirm('Bạn có chắc chắn muốn cập nhật thông tin?')) return;
                alert('Cập nhật thông tin thành công!');
                if (oldPassword && newPassword) {
                    window.location.href = './logout.php';
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