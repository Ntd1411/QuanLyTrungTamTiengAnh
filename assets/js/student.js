let studentData = {};

document.addEventListener('DOMContentLoaded', function() {
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

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    loadStudentDashboard();
    loadClassInfo();
    loadAttendance();
    loadHomework();
    loadStudentProfile();
});

// Load dashboard data
function loadStudentDashboard() {
    document.getElementById('student-name').textContent = studentData.name;
    document.getElementById('class-name').textContent = studentData.class.name;
    document.getElementById('attended-sessions').textContent = studentData.attendance.attended;
    document.getElementById('absent-sessions').textContent = studentData.attendance.absent;
    
    const newHomework = studentData.homework.filter(hw => hw.status === 'new').length;
    document.getElementById('new-homework').textContent = newHomework;
}

// Load class information
function loadClassInfo() {
    // Hiển thị thông tin chung
    document.getElementById('current-class').textContent = studentData.class.name;
    document.getElementById('teacher-name').textContent = studentData.class.teacher;
    document.getElementById('class-schedule').textContent = studentData.class.schedule;

    // Hiển thị bảng danh sách học sinh
    const classmatesTable = document.getElementById('classmates-table');
    classmatesTable.innerHTML = '';

    studentData.class.classmates.forEach((student, index) => {
        const row = document.createElement('tr');
        const attendanceRate = ((student.attended / (student.attended + student.absent)) * 100).toFixed(1);
        let rateClass = '';
        
        if (attendanceRate >= 90) rateClass = 'rate-good';
        else if (attendanceRate >= 80) rateClass = 'rate-warning';
        else rateClass = 'rate-poor';

        row.innerHTML = `
            <td>${index + 1}</td>
            <td>${student.name}</td>
            <td>${student.attended}</td>
            <td>${student.absent}</td>
            <td><span class="attendance-rate ${rateClass}">${attendanceRate}%</span></td>
        `;
        classmatesTable.appendChild(row);
    });
}

// Load attendance history
function loadAttendance() {
    const attended = studentData.attendance.attended;
    const absent = studentData.attendance.absent;
    const total = attended + absent;

    // Update summary stats
    document.getElementById('total-sessions').textContent = total;
    document.getElementById('attended-count').textContent = attended;
    document.getElementById('absent-count').textContent = absent;

    // Update progress circle
    updateAttendanceProgress(attended, total);

    const historyBody = document.getElementById('attendance-history-body');
    historyBody.innerHTML = '';
    
    studentData.attendance.history.forEach(record => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${record.date}</td>
            <td>${record.status === 'present' ? 'Có mặt' : 'Vắng mặt'}</td>
            <td>${record.note || '-'}</td>
        `;
        historyBody.appendChild(row);
    });

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
    
    studentData.homework.forEach(hw => {
        const card = document.createElement('div');
        card.className = `homework-card ${hw.status}`;
        card.innerHTML = `
            <h3>${hw.title}</h3>
            <p>${hw.description}</p>
            <p>Hạn nộp: ${hw.dueDate}</p>
            <p>Trạng thái: ${hw.status === 'new' ? 'Chưa làm' : 'Đã hoàn thành'}</p>
        `;
        homeworkList.appendChild(card);
    });
}

// Load student profile
function loadStudentProfile() {
    document.getElementById('profile-name').value = studentData.name;
    document.getElementById('profile-class').value = studentData.class.name;
    document.getElementById('profile-email').value = studentData.email;
    document.getElementById('profile-phone').value = studentData.phone;
}

// Update profile
function updateProfile() {
    const newEmail = document.getElementById('profile-email').value;
    const newPhone = document.getElementById('profile-phone').value;
    const newPassword = document.getElementById('profile-password').value;

    // Here you would typically send this data to the server
    studentData.email = newEmail;
    studentData.phone = newPhone;
    
    alert('Thông tin đã được cập nhật');
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
