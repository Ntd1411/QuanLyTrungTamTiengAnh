const patterns = {
    username: /^[a-zA-Z][a-zA-Z0-9_]{2,}$/,
    password: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/,
    fullname: /^[a-zA-ZÀ-ỹ\s]{2,}$/,
    email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
    phone: /^0\d{9}$/
};

const messages = {
    username: 'Tên đăng nhập phải bắt đầu bằng chữ cái và có ít nhất 3 ký tự',
    password: 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số',
    fullname: 'Họ tên chỉ được chứa chữ cái',
    email: 'Email không đúng định dạng',
    phone: 'Số điện thoại phải có 10 số và bắt đầu bằng số 0'
};

function addValidation(input, pattern, message) {
    // Thêm message element sau input
    const messageEl = document.createElement('div');
    messageEl.className = 'error-message';
    messageEl.textContent = message;
    input.parentNode.insertBefore(messageEl, input.nextSibling);

    // Validate khi nhập
    input.addEventListener('input', function() {
        if (!pattern.test(this.value)) {
            this.classList.add('error');
            messageEl.style.display = 'block';
        } else {
            this.classList.remove('error');
            messageEl.style.display = 'none';
        }
    });
}

// Thêm validation cho form đăng nhập
document.querySelector('form[action="/login"]').querySelectorAll('input').forEach(input => {
    if (patterns[input.name]) {
        addValidation(input, patterns[input.name], messages[input.name]);
    }
});

// Thêm validation cho form đăng ký 
document.querySelector('form[action="/signup"]').querySelectorAll('input').forEach(input => {
    if (patterns[input.name]) {
        addValidation(input, patterns[input.name], messages[input.name]);
    }
});

// Validate confirm password
const signupForm = document.querySelector('form[action="/signup"]');
const confirmPassword = signupForm.querySelector('input[name="confirm_password"]');
const password = signupForm.querySelector('input[name="password"]');

const messageEl = document.createElement('div');
messageEl.className = 'error-message';
messageEl.textContent = 'Mật khẩu nhập lại không khớp';
confirmPassword.parentNode.insertBefore(messageEl, confirmPassword.nextSibling);

confirmPassword.addEventListener('input', function() {
    if (this.value !== password.value) {
        this.classList.add('error');
        messageEl.style.display = 'block';
    } else {
        this.classList.remove('error');
        messageEl.style.display = 'none';
    }
});

// Submit form chỉ khi không có lỗi
document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const hasErrors = form.querySelectorAll('.error').length > 0;
        if (!hasErrors) {
            this.submit();
        }
    });
});