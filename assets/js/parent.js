let parentData = {};

document.addEventListener('DOMContentLoaded', function() {
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
    document.getElementById('total-children').textContent = parentData.children.length;
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
        childrenList.appendChild(childCard);
    });
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
        `;
        tbody.appendChild(tr);
    });
}

// Load messages
function loadMessages() {
    const messageList = document.querySelector('.message-list');
    messageList.innerHTML = '';

    parentData.messages.forEach((message, idx) => {
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
        };
        messageList.appendChild(messageItem);
    });
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
    message.read = true;
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

    // Here you would typically send this data to the server
    parentData.email = newEmail;
    parentData.phone = newPhone;
    parentData.zalo = newZalo;
    
    alert('Thông tin đã được cập nhật');
}

// Pay fee
function payFees() {
    document.getElementById('pay-fee-modal').classList.add('show');
    const select = document.getElementById('fee-student');
    select.innerHTML = '';
    parentData.children.forEach(child => {
        const option = document.createElement('option');
        option.value = child.id;
        option.textContent = child.name;
        select.appendChild(option);
    });

    // Gán giá trị mặc định cho số tiền đóng khi mở form
    updateFeeAmountAndNote();

    // Khi chọn con khác thì cập nhật lại số tiền đóng
    select.onchange = updateFeeAmountAndNote;
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
        // Ghi chú: note từ DB - tên con
        noteInput.value = (child.note ? child.note + ' - ' : '') + child.name;
    } else {
        amountInput.value = 0;
        noteInput.value = '';
    }
}

function hidePayFeeForm() {
    document.getElementById('pay-fee-modal').classList.remove('show');
}

// Handle form submit
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('feeForm');
    if (form) {
        form.onsubmit = function(e) {
            e.preventDefault();
            const studentId = document.getElementById('fee-student').value;
            const bank = document.getElementById('fee-bank').value;
            const amount = document.getElementById('fee-amount').value;
            const note = document.getElementById('fee-note').value;

            fetch('../php/payfee.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({
                    studentId, bank, amount, note
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {

                    // Phát triển xử lý nộp tiền thêm ở đây


                    alert('Nộp tiền thành công!');
                    hidePayFeeForm();
                    // Reload Data
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + (data.error || ''));
                }
            })
            .catch(() => alert('Không thể kết nối máy chủ!'));
        };
    }
});
