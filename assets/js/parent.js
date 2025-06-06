// Fake data for demonstration
let parentData = {
    id: 1,
    name: "Nguyễn Văn A",
    email: "nguyenvana@example.com",
    phone: "0123456789",
    zalo: "nvana123",
    children: [
        {
            id: 1,
            name: "Nguyễn Văn B",
            class: "Lớp 3.1",
            attended: 15,
            absent: 2,
            teacher: "Cô Thanh Hương",
            fee: 1500000,
            paid: 1000000
        },
        {
            id: 2,
            name: "Nguyễn Văn C",
            class: "Lớp 5.2",
            attended: 12,
            absent: 1,
            teacher: "Cô Thu Hương",
            fee: 1500000,
            paid: 500000
        }
    ],
    messages: [
        {
            id: 1,
            from: "Cô Thanh Hương",
            subject: "Thông báo nghỉ học",
            content: "Lớp 3.1 sẽ nghỉ học ngày 20/12/2023",
            date: "2023-12-18",
            read: false
        },
        {
            id: 2,
            from: "Admin",
            subject: "Nhắc nộp học phí",
            content: "Vui lòng đóng học phí tháng 12 cho bé",
            date: "2023-12-15",
            read: true
        }
    ]
};

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    loadParentDashboard();
    loadChildren();
    loadPayments();
    loadMessages();
    loadParentProfile();
});

// Load dashboard data
function loadParentDashboard() {
    document.getElementById('parent-name').textContent = parentData.name;
    document.getElementById('total-children').textContent = parentData.children.length;
    
    const totalUnpaid = parentData.children.reduce((sum, child) => 
        sum + (child.fee - child.paid), 0);
    document.getElementById('unpaid-amount').textContent = totalUnpaid.toLocaleString() + ' VNĐ';
    
    const unreadMessages = parentData.messages.filter(msg => !msg.read).length;
    document.getElementById('new-messages').textContent = unreadMessages;
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
    const discount = 0; // Implement discount logic here
    
    document.getElementById('total-fee').textContent = totalFee.toLocaleString() + ' VNĐ';
    document.getElementById('discount-amount').textContent = discount.toLocaleString() + ' VNĐ';
    document.getElementById('paid-amount').textContent = totalPaid.toLocaleString() + ' VNĐ';
    document.getElementById('remaining-amount').textContent = (totalFee - totalPaid - discount).toLocaleString() + ' VNĐ';
}

// Load messages
function loadMessages() {
    const messageList = document.querySelector('.message-list');
    messageList.innerHTML = '';
    
    parentData.messages.forEach(message => {
        const messageItem = document.createElement('div');
        messageItem.className = `message-item ${message.read ? '' : 'unread'}`;
        messageItem.innerHTML = `
            <h4>${message.subject}</h4>
            <p>Từ: ${message.from}</p>
            <p>Ngày: ${message.date}</p>
        `;
        messageItem.onclick = () => showMessageDetail(message);
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
