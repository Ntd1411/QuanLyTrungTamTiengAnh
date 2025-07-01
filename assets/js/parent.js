let parentData = {};

document.addEventListener('DOMContentLoaded', function () {
    fetch('../php/get_parent_data.php')
        .then(res => res.json())
        .then(data => {
            parentData = data;
            loadParentDashboard();
            loadChildren();
            loadPayments();
            loadMessages();
            loadParentProfile();
        })
        .catch(err => {
            alert('Không thể tải dữ liệu phụ huynh!');
            console.error(err);
        });
});

// Load dashboard data
function loadParentDashboard() {
    document.getElementById('parent-name').textContent = parentData.name;
    document.getElementById('total-children').textContent = parentData.numChildren;
    document.getElementById('unpaid-amount').textContent = parentData.unpaid.toLocaleString() + ' VNĐ';
    document.getElementById('new-messages').textContent = parentData.messages.filter(m => !m.read).length;

    // Đổi màu summary-card warning nếu học phí chưa đóng là 0
    const unpaidCard = document.querySelector('.summary-card.warning');
    if (parentData.unpaid == 0) {
        unpaidCard.classList.remove('warning');
        unpaidCard.classList.add('success');
    } else {
        unpaidCard.classList.remove('success');
        unpaidCard.classList.add('warning');
    }
}

// Load children information
function loadChildren() {
    const childrenList = document.querySelector('.children-list');
    childrenList.innerHTML = '';

    parentData.children.forEach(child => {
        const childCard = document.createElement('div');
        childCard.className = 'child-card';
        childCard.innerHTML = `
            <h3>${child.name}</h3>
            <p>Lớp: ${child.class}</p>
            <p>Giáo viên: ${child.teacher}</p>
            <p>Số buổi học: ${child.attended}</p>
            <p>Số buổi nghỉ: ${child.absent}</p>
            <p>Học phí: ${child.fee.toLocaleString()} VNĐ</p>
            <p>Đã đóng: ${child.paid.toLocaleString()} VNĐ</p>
        `;

        // Hiển thị lịch sử đi học khi click
        childCard.style.cursor = 'pointer';
        childCard.onclick = () => showAttendanceHistoryOfChild(child.id);

        childrenList.appendChild(childCard);
    });
}

/**
 * Hiển thị lịch sử điểm danh bằng cách sử dụng API của DataTables.
 * Đây là cách làm đúng chuẩn và hiệu quả nhất.
 *
 * @param {string|number} childId ID của bé.
 */
function showAttendanceHistoryOfChild(childId) {
    const child = parentData.children.find(c => c.id == childId);
    const historyDiv = document.querySelector('.attendance-history-list');

    if (!child || !historyDiv) {
        console.error("Không tìm thấy thông tin của con hoặc div lịch sử.");
        return;
    }

    historyDiv.style.display = 'none';
    historyDiv.classList.remove('active');

    document.getElementById('attendance-history-title').textContent = `Lịch sử điểm danh: ${child.name}`;

    // Bước 1: Chuẩn bị dữ liệu dạng mảng các mảng
    let dataForTable = [];
    if (child.attendanceList && child.attendanceList.length > 0) {
        dataForTable = child.attendanceList.map((session, idx) => {
            return [
                idx + 1,
                session.AttendanceDate,
                session.Status,
                session.Note || 'Không có'
            ];
        });
    }

    // Bước 2: Lấy instance DataTable và cập nhật dữ liệu
    // Sử dụng hàm initializeDataTable an toàn (có destroy)
    const table = initializeDataTable('#attendance-history-table');

    // Dùng API để xóa dữ liệu cũ và thêm dữ liệu mới
    table.clear(); // Xóa tất cả các hàng hiện tại
    table.rows.add(dataForTable); // Thêm dữ liệu mới
    table.draw(); // Vẽ lại bảng

    // Bước 3: Hiển thị lại div chứa bảng
    setTimeout(() => {
        historyDiv.style.display = 'block';
        requestAnimationFrame(() => {
            historyDiv.classList.add('active');
        });
    }, 50);
}

function hideAttendanceHistoryOfChild(childId) {
    const historyDiv = document.querySelector('.attendance-history-list');
    if (historyDiv) {
        historyDiv.style.display = 'none';
        historyDiv.classList.remove('active');
    }
}

// Load payment information
function loadPayments() {
    const totalFee = parentData.children.reduce((sum, child) => sum + child.fee, 0);
    const totalPaid = parentData.children.reduce((sum, child) => sum + child.paid, 0);
    const discount = parentData.children.reduce((sum, child) => sum + (child.discount || 0), 0);

    document.getElementById('total-fee').textContent = totalFee.toLocaleString() + ' VNĐ';
    document.getElementById('discount-amount').textContent = discount.toLocaleString() + ' VNĐ';
    document.getElementById('paid-amount').textContent = totalPaid.toLocaleString() + ' VNĐ';
    document.getElementById('remaining-amount').textContent = (totalFee - totalPaid - discount).toLocaleString() + ' VNĐ';

    // --- Thêm đoạn này để hiển thị lịch sử đóng học phí ---
    const tbody = document.getElementById('payment-history-body');
    tbody.innerHTML = '';
    // Gom tất cả lịch sử của các con vào một mảng
    let allPayments = [];
    parentData.children.forEach(child => {
        (child.paymentHistory || []).forEach(payment => {
            allPayments.push({
                ...payment,
                childName: child.name
            });
        });
    });
    // Sắp xếp theo ngày mới nhất lên đầu
    allPayments.sort((a, b) => new Date(b.PaymentDate) - new Date(a.PaymentDate));
    // Render từng dòng
    allPayments.forEach(payment => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${payment.PaymentDate || ''}</td>
            <td>${payment.childName || ''}</td>
            <td>${Number(payment.Amount).toLocaleString()} VNĐ</td>
            <td>${payment.Note || ''}</td>
            <td>${payment.Payer || ''}</td>
        `;
        tbody.appendChild(tr);
    });

    initializeDataTable('#payment-history');
}

// Load messages
function loadMessages() {
    const messageList = document.querySelector('.message-list');
    messageList.innerHTML = ''; // Clear the list

    // Pagination variables
    const messagesPerPage = 5; // Set default messages per page
    let currentPage = 1; // Start on page 1
    const totalMessages = parentData.messages.length;
    const totalPages = Math.ceil(totalMessages / messagesPerPage);

    function showPage(page) {
        currentPage = page;
        messageList.innerHTML = ''; // Clear the list

        const startIndex = (currentPage - 1) * messagesPerPage;
        const endIndex = startIndex + messagesPerPage;
        const messagesToShow = parentData.messages.slice(startIndex, endIndex);

        messagesToShow.forEach((message, idx) => {
            const messageItem = document.createElement('div');
            messageItem.className = `message-item ${message.read ? 'read' : 'unread'}`;
            messageItem.innerHTML = `
                <h4>${message.subject}</h4>
                <p>Từ: ${message.from}</p>
                <p>Ngày: ${message.date}</p>
            `;
            messageItem.onclick = () => {
                // Xóa class selected khỏi tất cả message-item
                document.querySelectorAll('.message-item').forEach(item => item.classList.remove('selected'));
                // Thêm class selected cho item được click
                messageItem.classList.add('selected');
                showMessageDetail(message);
                // Đánh dấu tin nhắn là đã đọc
                if (!message.read && message.id) {
                    fetch('../php/mark_message_read.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ messageId: message.id })
                    }).then(() => {
                        message.read = true;
                        messageItem.classList.remove('unread');
                        // Cập nhật số thông báo chưa đọc trên dashboard
                        loadParentDashboard();
                    });
                }
            };
            messageList.appendChild(messageItem);
        });

        // Update pagination controls
        updatePaginationControls();
    }

    function updatePaginationControls() {
        const paginationContainer = document.getElementById('pagination-container');
        if (!paginationContainer) {
            return; // Exit if pagination container doesn't exist
        }

        paginationContainer.innerHTML = ''; // Clear existing controls

        // Previous button
        const prevButton = document.createElement('button');
        prevButton.textContent = 'Trước';
        prevButton.disabled = currentPage === 1;
        prevButton.addEventListener('click', () => {
            if (currentPage > 1) {
                showPage(currentPage - 1);
            }
        });
        paginationContainer.appendChild(prevButton);

        // Calculate page numbers to display
        let pageNumbers = [];
        if (totalPages <= 7) { // Show all pages if total pages is less than or equal to 7
            for (let i = 1; i <= totalPages; i++) {
                pageNumbers.push(i);
            }
        } else {
            // Show first three pages, ellipsis, current page, and last page
            if (currentPage <= 3) {
                for (let i = 1; i <= 4; i++) {
                    pageNumbers.push(i);
                }
                pageNumbers.push('...');
                pageNumbers.push(totalPages);
            }
            // Show last three pages, ellipsis, current page, and first page
            else if (currentPage >= totalPages - 2) {
                pageNumbers.push(1);
                pageNumbers.push('...');
                for (let i = totalPages - 3; i <= totalPages; i++) {
                    pageNumbers.push(i);
                }
            } else {
                // Show first page, ellipsis, current page, and last page
                pageNumbers.push(1);
                pageNumbers.push('...');
                pageNumbers.push(currentPage - 1);
                pageNumbers.push(currentPage);
                pageNumbers.push(currentPage + 1);
                pageNumbers.push('...');
                pageNumbers.push(totalPages);
            }
        }

        // Page numbers
        pageNumbers.forEach(pageNumber => {
            if (pageNumber === '...') {
                const ellipsisSpan = document.createElement('span');
                ellipsisSpan.textContent = '...';
                paginationContainer.appendChild(ellipsisSpan);
            } else {
                const pageButton = document.createElement('button');
                pageButton.textContent = pageNumber;
                pageButton.classList.add('page-button');
                if (pageNumber === currentPage) {
                    pageButton.classList.add('active');
                }
                pageButton.addEventListener('click', () => {
                    showPage(pageNumber);
                });
                paginationContainer.appendChild(pageButton);
            }
        });

        // Next button
        const nextButton = document.createElement('button');
        nextButton.textContent = 'Sau';
        nextButton.disabled = currentPage === totalPages;
        nextButton.addEventListener('click', () => {
            if (currentPage < totalPages) {
                showPage(currentPage + 1);
            }
        });
        paginationContainer.appendChild(nextButton);
    }

    showPage(currentPage);
}

// Show message detail
function showMessageDetail(message) {
    const messageContent = document.querySelector('.message-content');
    messageContent.innerHTML = `
        <h3>${message.subject}</h3>
        <p><strong>Từ:</strong> ${message.from}</p>
        <p><strong>Ngày:</strong> ${message.date}</p>
        <div class="message-body">${message.content}</div>
    `;
    // Thêm lại class để kích hoạt animation
    messageContent.classList.remove('message-content');
    void messageContent.offsetWidth; // trigger reflow
    messageContent.classList.add('message-content');
    loadParentDashboard(); // Update unread count
}

// Load parent profile
function loadParentProfile() {
    document.getElementById('profile-name').value = parentData.name;
    document.getElementById('profile-email').value = parentData.email;
    document.getElementById('profile-phone').value = parentData.phone;
    document.getElementById('profile-zalo').value = parentData.zalo;
}

// Update profile
function updateProfile() {
    const newEmail = document.getElementById('profile-email').value;
    const newPhone = document.getElementById('profile-phone').value;
    const newZalo = document.getElementById('profile-zalo').value;
    const oldPassword = document.getElementById('profile-old-password').value;
    const newPassword = document.getElementById('profile-new-password').value;

    // Regex kiểm tra
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^0\d{9}$/;
    const passwordRegex = /^[a-zA-Z0-9]{6,}$/;

    // Kiểm tra email
    if (!emailRegex.test(newEmail)) {
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
            email: newEmail,
            phone: newPhone,
            zalo: newZalo,
            oldPassword: oldPassword,
            newPassword: newPassword,
            role: 'parent'
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
                alert('Cập nhật thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(err => {
            alert('Có lỗi xảy ra khi cập nhật!');
            console.error(err);
        });
}

// Pay fee
function payFees() {
    document.getElementById('pay-fee-modal').classList.add('show');
    const select = document.getElementById('fee-student');
    select.innerHTML = '';
    // Lọc chỉ những con còn nợ học phí
    const unpaidChildren = parentData.children.filter(child => (child.fee - child.paid - (child.discount || 0)) > 0);
    unpaidChildren.forEach(child => {
        const option = document.createElement('option');
        option.value = child.id;
        option.textContent = child.name;
        select.appendChild(option);
    });

    // Nếu không còn con nào nợ học phí, disable form
    if (unpaidChildren.length === 0) {
        select.innerHTML = '<option>Không có con nào còn nợ học phí</option>';
        document.getElementById('fee-amount').value = 0;
        document.getElementById('fee-amount').readOnly = true;
        document.getElementById('fee-note').value = '';
    } else {
        // Gán giá trị mặc định cho số tiền đóng khi mở form
        updateFeeAmountAndNote();
        select.onchange = updateFeeAmountAndNote;
    }
}

function updateFeeAmountAndNote() {
    const select = document.getElementById('fee-student');
    const amountInput = document.getElementById('fee-amount');
    const noteInput = document.getElementById('fee-note');
    const child = parentData.children.find(c => c.id === select.value);
    if (child) {
        // Số tiền cần đóng = fee - paid - discount
        const unpaid = child.fee - child.paid - (child.discount || 0);
        amountInput.value = unpaid > 0 ? unpaid : 0;
        // Ghi chú: note từ DB - tên con - số tiền nộp
        noteInput.value =
            (child.note ? child.note + ' - ' : '') +
            child.name + ' - Nộp ' + amountInput.value.toLocaleString() + ' VNĐ';

        // Gán lại sự kiện oninput mỗi lần chọn con khác
        amountInput.oninput = function () {
            // Lấy lại child mới nhất theo select
            const currentChild = parentData.children.find(c => c.id === select.value);
            noteInput.value =
                (currentChild && currentChild.note ? currentChild.note + ' - ' : '') +
                (currentChild ? currentChild.name : '') + ' - Nộp ' + amountInput.value.toLocaleString() + ' VNĐ';
        };
    } else {
        amountInput.value = 0;
        noteInput.value = '';
        amountInput.oninput = null;
    }
}

function hidePayFeeForm() {
    document.getElementById('pay-fee-modal').classList.remove('show');
}

// Handle form submit
document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('feeForm');
    if (form) {
        form.onsubmit = function (e) {
            e.preventDefault();
            const studentId = document.getElementById('fee-student').value;
            const bank = document.getElementById('fee-bank').value;
            const amount = parseFloat(document.getElementById('fee-amount').value);
            const note = document.getElementById('fee-note').value;

            // Lấy số tiền còn nợ của học sinh này
            const child = parentData.children.find(c => c.id === studentId);
            const unpaid = child ? (child.fee - child.paid - (child.discount || 0)) : 0;

            if (amount > unpaid) {
                alert('Số tiền nộp lớn hơn số tiền còn nợ của học phí!');
                return;
            }
            if (amount <= 0) {
                alert('Số tiền nộp phải lớn hơn 0!');
                return;
            }

            fetch('../php/payfee.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    studentId, bank, amount, note
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert('Nộp tiền thành công!');
                        hidePayFeeForm();
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra: ' + (data.error || ''));
                    }
                })
                .catch(() => alert('Không thể kết nối máy chủ!'));
        };
    }
});

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