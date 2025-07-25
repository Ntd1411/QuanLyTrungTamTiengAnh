document.addEventListener('DOMContentLoaded', function() {
    const btn = document.querySelector('a.button[href="#registration"]');
    if (btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.getElementById('registration');
            const nav = document.querySelector('nav');
            const navHeight = nav ? nav.offsetHeight : 0;
            if (target) {
                // Lấy vị trí top của form so với trang
                const rect = target.getBoundingClientRect();
                const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                const targetY = rect.top + scrollTop - navHeight - 16; // -16 để có khoảng cách nhỏ phía trên
                window.scrollTo({
                    top: targetY,
                    behavior: 'smooth'
                });
            }
        });
    }
});

// Registration form validation
document.addEventListener('DOMContentLoaded', function() {
    
    // --- PHẦN CODE CUỘN TRANG (GIỮ NGUYÊN) ---
    const smoothScrollBtn = document.querySelector('a.button[href="#registration"]');
    if (smoothScrollBtn) {
        smoothScrollBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.getElementById('registration');
            const nav = document.querySelector('nav');
            const navHeight = nav ? nav.offsetHeight : 0;
            if (target) {
                const rect = target.getBoundingClientRect();
                const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                const targetY = rect.top + scrollTop - navHeight - 16;
                window.scrollTo({
                    top: targetY,
                    behavior: 'smooth'
                });
            }
        });
    }

    // --- VALIDATION ---
    const form = document.getElementById('registration-form');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            clearErrors();
            let isValid = true;

            const fullname = document.getElementById('fullname');
            const birthyear = document.getElementById('birthyear');
            const phone = document.getElementById('phone');
            const email = document.getElementById('email');
            const course = document.getElementById('course');

            if (fullname.value.trim() === '') {
                showError(fullname, 'Vui lòng nhập họ và tên.');
                isValid = false;
            }
            if (birthyear.value.trim() === '') {
                showError(birthyear, 'Vui lòng nhập năm sinh.');
                isValid = false;
            } else if (isNaN(birthyear.value.trim()) || birthyear.value.trim().length !== 4) {
                showError(birthyear, 'Năm sinh không hợp lệ (phải là 4 chữ số).');
                isValid = false;
            }
            const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})\b$/;
            if (phone.value.trim() === '') {
                showError(phone, 'Vui lòng nhập số điện thoại.');
                isValid = false;
            } else if (!phoneRegex.test(phone.value.trim())) {
                showError(phone, 'Số điện thoại không hợp lệ.');
                isValid = false;
            }
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email.value.trim() !== '' && !emailRegex.test(email.value.trim())) {
                showError(email, 'Địa chỉ email không hợp lệ.');
                isValid = false;
            }
            if (course.value === '') {
                showError(course, 'Vui lòng chọn một khoá học.');
                isValid = false;
            }

            if (isValid) {
                requestConsultation();
            }
        });
    }

    function showError(inputElement, message) {
        const errorHolder = inputElement.nextElementSibling;
        errorHolder.textContent = message;
        inputElement.classList.add('input-error');
    }

    function clearErrors() {
        document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
    }
});

// Handle form submission
function requestConsultation() {
    const form = document.getElementById('registration-form');
    const formData = new FormData(form);
    formData.append('action', 'requestConsultation');

    fetch('../php/request_consultation.php', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.status === 'success') {
            alert('Gửi thông tin tư vấn thành công!');
            form.reset();
        } else {
            alert('Lỗi: ' + (data.message || 'Không thể gửi thông tin'));
        }
    })
    .catch(err => {
        alert('Có lỗi xảy ra khi gửi thông tin!');
        console.error(err);
    });
}