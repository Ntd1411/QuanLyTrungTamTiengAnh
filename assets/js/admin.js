// Fake data storage using localStorage
let classes = JSON.parse(localStorage.getItem('classes')) || [];
let teachers = JSON.parse(localStorage.getItem('teachers')) || [];
let students = JSON.parse(localStorage.getItem('students')) || [];
let parents = JSON.parse(localStorage.getItem('parents')) || [];
let promotions = JSON.parse(localStorage.getItem('promotions')) || [];

// Show section
function showSection(sectionId) {
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });
    document.getElementById(sectionId).classList.add('active');
}

// Manage Classes
function addClass() {
    const name = document.getElementById('class-name').value;
    const year = document.getElementById('class-year').value;
    const teacher = document.getElementById('class-teacher').value;
    if (name && year && teacher) {
        classes.push({ id: Date.now(), name, year, teacher, status: 'active' });
        localStorage.setItem('classes', JSON.stringify(classes));
        updateClassTable();
        updateSelectOptions();
    }
}

function closeClass() {
    const selectedClass = document.querySelector('#class-table-body tr.selected');
    if (selectedClass) {
        const id = selectedClass.dataset.id;
        const classData = classes.find(c => c.id == id);
        classData.status = 'closed';
        localStorage.setItem('classes', JSON.stringify(classes));
        updateClassTable();
    }
}

function updateClassTable() {
    const tbody = document.getElementById('class-table-body');
    tbody.innerHTML = '';
    classes.forEach(cls => {
        const row = document.createElement('tr');
        row.dataset.id = cls.id;
        row.innerHTML = `
          <td>${cls.name}</td>
          <td>${cls.year}</td>
          <td>${cls.teacher}</td>
          <td>${cls.status}</td>
          <td>
            <div class="table-actions">
              <button onclick="selectClass(${cls.id})">Sửa</button>
              <button class="btn-delete" onclick="deleteClass(${cls.id})">Xóa</button>
            </div>
          </td>
        `;
        tbody.appendChild(row);
    });
}

function selectClass(id) {
    document.querySelectorAll('#class-table-body tr').forEach(row => {
        row.classList.remove('selected');
    });
    document.querySelector(`#class-table-body tr[data-id="${id}"]`).classList.add('selected');
}

// Manage Teachers
function addTeacher() {
    const fullName = document.getElementById('teacher-fullname').value;
    const username = document.getElementById('teacher-username').value;
    const password = document.getElementById('teacher-password').value;
    const gender = document.getElementById('teacher-gender').value;
    const email = document.getElementById('teacher-email').value;
    const phone = document.getElementById('teacher-phone').value;
    const birthdate = document.getElementById('teacher-birthdate').value;
    const salary = document.getElementById('teacher-salary').value;

    if (fullName && username && password && gender && email && phone && birthdate && salary) {
        teachers.push({
            id: Date.now(),
            fullName,
            username,
            password,
            gender,
            email,
            phone,
            birthdate,
            salary: parseFloat(salary),
            classes: []
        });
        localStorage.setItem('teachers', JSON.stringify(teachers));
        updateTeacherTable();
        updateSelectOptions();
    } else {
        alert('Vui lòng điền đầy đủ thông tin giáo viên');
    }
}

function updateTeacherTable() {
    const tbody = document.getElementById('teacher-table-body');
    tbody.innerHTML = '';
    teachers.forEach(teacher => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${teacher.fullName}</td>
            <td>${teacher.username}</td>
            <td>${teacher.gender}</td>
            <td>${teacher.email}</td>
            <td>${teacher.phone}</td>
            <td>${new Date(teacher.birthdate).toLocaleDateString('vi-VN')}</td>
            <td>${teacher.salary.toLocaleString('vi-VN')} VNĐ</td>
            <td>${teacher.classes.join(', ') || 'Chưa có lớp'}</td>
            <td>
                <div class="table-actions">
                    <button onclick="editTeacher(${teacher.id})">Sửa</button>
                    <button class="btn-delete" onclick="deleteTeacher(${teacher.id})">Xóa</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });
}

function editTeacher(id) {
    const teacher = teachers.find(t => t.id === id);
    if (teacher) {
        document.getElementById('teacher-fullname').value = teacher.fullName;
        document.getElementById('teacher-username').value = teacher.username;
        document.getElementById('teacher-gender').value = teacher.gender;
        document.getElementById('teacher-email').value = teacher.email;
        document.getElementById('teacher-phone').value = teacher.phone;
        document.getElementById('teacher-birthdate').value = teacher.birthdate;
        document.getElementById('teacher-salary').value = teacher.salary;
        
        // Change button action to update
        const addButton = document.querySelector('button[onclick="addTeacher()"]');
        addButton.textContent = 'Cập nhật';
        addButton.onclick = () => updateTeacherInfo(id);
    }
}

function updateTeacherInfo(id) {
    const teacher = teachers.find(t => t.id === id);
    if (teacher) {
        teacher.fullName = document.getElementById('teacher-fullname').value;
        teacher.username = document.getElementById('teacher-username').value;
        teacher.gender = document.getElementById('teacher-gender').value;
        teacher.email = document.getElementById('teacher-email').value;
        teacher.phone = document.getElementById('teacher-phone').value;
        teacher.birthdate = document.getElementById('teacher-birthdate').value;
        teacher.salary = parseFloat(document.getElementById('teacher-salary').value);

        localStorage.setItem('teachers', JSON.stringify(teachers));
        updateTeacherTable();

        // Reset form and button
        document.getElementById('teacher-form').reset();
        const addButton = document.querySelector('button[onclick="updateTeacherInfo(' + id + ')"]');
        addButton.textContent = 'Thêm giáo viên';
        addButton.onclick = addTeacher;
    }
}

// Manage Students
function addStudent() {
    const fullName = document.getElementById('student-fullname').value;
    const username = document.getElementById('student-username').value;
    const password = document.getElementById('student-password').value;
    const gender = document.getElementById('student-gender').value;
    const email = document.getElementById('student-email').value;
    const phone = document.getElementById('student-phone').value;
    const birthdate = document.getElementById('student-birthdate').value;
    const classId = document.getElementById('student-class').value;
    const parentId = document.getElementById('student-parent').value;

    if (fullName && username && password && gender && email && phone && birthdate && classId && parentId) {
        const newStudent = {
            id: Date.now(),
            fullName,
            username,
            password,
            gender,
            email,
            phone,
            birthdate,
            classId,
            parentId,
            attended: 0,
            absent: 0
        };
        
        students.push(newStudent);
        localStorage.setItem('students', JSON.stringify(students));
        
        document.getElementById('student-form').reset();
        updateStudentTable();
        updateAdminStats();
        
        alert('Thêm học sinh thành công!');
    } else {
        alert('Vui lòng điền đầy đủ thông tin học sinh');
    }
}

function updateStudentTable() {
    const tbody = document.getElementById('student-table-body');
    tbody.innerHTML = '';
    students.forEach(student => {
        const cls = classes.find(c => c.id == student.classId);
        const parent = parents.find(p => p.id == student.parentId);
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${student.fullName}</td>
            <td>${student.username}</td>
            <td>${student.gender}</td>
            <td>${student.email}</td>
            <td>${student.phone}</td>
            <td>${new Date(student.birthdate).toLocaleDateString('vi-VN')}</td>
            <td>${cls ? cls.name : 'Không có'}</td>
            <td>${parent ? parent.name : 'Không có'}</td>
            <td>${student.attended}</td>
            <td>${student.absent}</td>
            <td>
                <div class="table-actions">
                    <button onclick="editStudent(${student.id})">Sửa</button>
                    <button class="btn-delete" onclick="deleteStudent(${student.id})">Xóa</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Manage Parents
function addParent() {
    const name = document.getElementById('parent-name').value;
    const phone = document.getElementById('parent-phone').value;
    const zalo = document.getElementById('parent-zalo').value;
    if (name && phone && zalo) {
        parents.push({ id: Date.now(), name, phone, zalo, unpaid: 0 });
        localStorage.setItem('parents', JSON.stringify(parents));
        updateParentTable();
        updateSelectOptions();
    }
}

function updateParentTable() {
    const tbody = document.getElementById('parent-table-body');
    tbody.innerHTML = '';
    parents.forEach(parent => {
        const children = students.filter(s => s.parentId == parent.id).map(s => s.name).join(', ');
        const row = document.createElement('tr');
        row.dataset.id = parent.id;
        row.innerHTML = `
          <td>${parent.name}</td>
          <td>${parent.phone}</td>
          <td>${parent.zalo}</td>
          <td>${children || 'Chưa có'}</td>
          <td>${parent.unpaid} VNĐ</td>
          <td>
            <div class="table-actions">
              <button onclick="selectParent(${parent.id})">Chọn</button>
              <button class="btn-delete" onclick="deleteParent(${parent.id})">Xóa</button>
            </div>
          </td>
        `;
        tbody.appendChild(row);
    });
}

function sendNotification() {
    const parentId = document.querySelector('#parent-table-body tr.selected')?.dataset.id;
    if (parentId) {
        const parent = parents.find(p => p.id == parentId);
        console.log(`Gửi thông báo tới ${parent.name} qua Zalo: ${parent.zalo}`);
        // Thay bằng API Zalo/Facebook thực tế
    }
}

// Statistics
function loadStatistics() {
    const month = document.getElementById('stats-month').value;
    let totalExpected = 0;
    let totalCollected = 0;
    let studentsIncreased = 0;
    let studentsDecreased = 0;

    students.forEach(student => {
        totalExpected += student.attended * 100000; // Giả sử 100k/buổi
        totalCollected += (student.attended * 100000) - (parents.find(p => p.id == student.parentId)?.unpaid || 0);
    });

    document.getElementById('total-expected').textContent = totalExpected;
    document.getElementById('total-collected').textContent = totalCollected;
    document.getElementById('students-increased').textContent = studentsIncreased;
    document.getElementById('students-decreased').textContent = studentsDecreased;
}

// Promotions
function addPromotion() {
    const content = document.getElementById('promo-content').value;
    if (content) {
        promotions.push({ id: Date.now(), content });
        localStorage.setItem('promotions', JSON.stringify(promotions));
        updatePromoList();
        showPopup(content);
    }
}

function updatePromoList() {
    const promoList = document.getElementById('promo-list');
    promoList.innerHTML = '';
    promotions.forEach(promo => {
        const div = document.createElement('div');
        div.textContent = promo.content;
        div.style.padding = '10px';
        div.style.borderBottom = '1px solid #d1d5db';
        promoList.appendChild(div);
    });
}

function showPopup(content) {
    document.getElementById('popup-content').textContent = content;
    document.getElementById('popup').style.display = 'block';
    document.getElementById('popup-overlay').style.display = 'block';
}

function closePopup() {
    document.getElementById('popup').style.display = 'none';
    document.getElementById('popup-overlay').style.display = 'none';
}

// Update select options
function updateSelectOptions() {
    const classSelect = document.getElementById('student-class');
    const teacherSelect = document.getElementById('class-teacher');
    const parentSelect = document.getElementById('student-parent');

    classSelect.innerHTML = '<option value="">Chọn lớp</option>';
    teacherSelect.innerHTML = '<option value="">Chọn giáo viên</option>';
    parentSelect.innerHTML = '<option value="">Chọn phụ huynh</option>';

    classes.forEach(cls => {
        classSelect.innerHTML += `<option value="${cls.id}">${cls.name} (${cls.year})</option>`;
    });
    teachers.forEach(teacher => {
        teacherSelect.innerHTML += `<option value="${teacher.name}">${teacher.name}</option>`;
    });
    parents.forEach(parent => {
        parentSelect.innerHTML += `<option value="${parent.id}">${parent.name}</option>`;
    });
}

// Dummy edit functions (to be implemented)
function editStudent(id) {
    alert('Chức năng sửa học sinh chưa được triển khai.');
}

// Delete functions
function deleteClass(id) {
    if (confirm('Bạn có chắc muốn xóa lớp này?')) {
        classes = classes.filter(c => c.id != id);
        localStorage.setItem('classes', JSON.stringify(classes));
        updateClassTable();
        updateSelectOptions();
        updateAdminStats();
    }
}

function deleteTeacher(id) {
    if (confirm('Bạn có chắc muốn xóa giáo viên này?')) {
        teachers = teachers.filter(t => t.id != id);
        localStorage.setItem('teachers', JSON.stringify(teachers));
        updateTeacherTable();
        updateSelectOptions();
        updateAdminStats();
    }
}

// Update admin stats
function updateAdminStats() {
    document.getElementById('total-classes-count').textContent = classes.length;
    document.getElementById('total-teachers-count').textContent = teachers.length;
    document.getElementById('total-students-count').textContent = students.length;
}

// Initial load
updateClassTable();
updateTeacherTable();
updateStudentTable();
updateParentTable();
updatePromoList();
updateSelectOptions();

// Initialize admin stats
document.addEventListener('DOMContentLoaded', function() {
    updateAdminStats();
});