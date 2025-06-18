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
                <td>${mate.attended || 0}</td>
                <td>${mate.absent || 0}</td>
                <td>${mate.participation || 0}%</td>
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

    if (Array.isArray(studentData.homework)) {
        studentData.homework.forEach(hw => {
            const card = document.createElement('div');
            card.className = `homework-card ${hw.status === 'Đã hoàn thành' ? 'done' : 'new'}`;
            card.innerHTML = `
                <h3>${hw.title}</h3>
                <p>${hw.description}</p>
                <p>Hạn nộp: ${hw.dueDate}</p>
                <p>Trạng thái: ${hw.status}</p>
            `;
            homeworkList.appendChild(card);
        });
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
