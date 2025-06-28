const patterns = {
    username: /^[a-zA-Z][a-zA-Z0-9_]{2,}$/,
    password: /[a-zA-Z0-9]{6,}$/,
    fullname: /^[a-zA-ZÀ-ỹ\s]{2,}$/,
    email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
    phone: /^\d+^$/
};

const messages = {
    username: 'Tên đăng nhập phải bắt đầu bằng chữ cái và có ít nhất 3 ký tự',
    password: 'Mật khẩu phải có ít nhất 6 ký tự',
    fullname: 'Họ tên chỉ được chứa chữ cái',
    email: 'Email không đúng định dạng',
    phone: 'Số điện thoại chỉ được bao gồm số',
    confirm_password: 'Mật khẩu nhập lại không khớp',
    gender: 'Vui lòng chọn giới tính',
    birthdate: 'Vui lòng nhập ngày sinh và không được lớn hơn ngày hiện tại',
    role: 'Vui lòng chọn vai trò',
    check: 'Bạn phải đồng ý với điều khoản dịch vụ'
};

// Xóa các thông báo lỗi cũ
function clearErrors(form) {
    form.querySelectorAll('.error-message').forEach(el => el.remove());
    form.querySelectorAll('.error').forEach(el => el.classList.remove('error'));
}

// Hiển thị thông báo lỗi
function showError(input, message) {
    input.classList.add('error');
    const messageEl = document.createElement('div');
    messageEl.className = 'error-message';
    messageEl.textContent = message;
    if (input.type === 'checkbox' && input.id === 'check') {
        // Hiển thị lỗi dưới label
        const placeholder = document.getElementById('check-error-placeholder');
        if (placeholder) {
            placeholder.innerHTML = '';
            placeholder.appendChild(messageEl);
        }
    } else {
        // Hiển thị lỗi xuống phía dưới cùng của khối cha (signup-block hoặc signup-role)
        let parentBlock = input.closest('.signup-block') || input.closest('.signup-role');
        if (parentBlock) {
            parentBlock.appendChild(messageEl);
        } else {
            input.parentNode.appendChild(messageEl);
        }
    }
}

// Hàm kiểm tra form đăng ký
function validateSignupForm(form) {
    clearErrors(form);
    let valid = true;

    // Họ tên
    const fullname = form.querySelector('input[name="fullname"]');
    if (!patterns.fullname.test(fullname.value.trim())) {
        showError(fullname, messages.fullname);
        valid = false;
    }

    // Giới tính
    const gender = form.querySelector('select[name="gender"]');
    if (!gender.value) {
        showError(gender, messages.gender);
        valid = false;
    }

    // Ngày sinh
    const birthdate = form.querySelector('input[name="birthdate"]');
    if (!birthdate.value || new Date(birthdate.value) > new Date()) {
        showError(birthdate, messages.birthdate);
        valid = false;
    }

    // Tên đăng nhập
    const username = form.querySelector('input[name="username"]');
    if (!patterns.username.test(username.value.trim())) {
        showError(username, messages.username);
        valid = false;
    }

    // Mật khẩu
    const password = form.querySelector('input[name="password"]');
    if (!patterns.password.test(password.value)) {
        showError(password, messages.password);
        valid = false;
    }

    // Nhập lại mật khẩu
    const confirmPassword = form.querySelector('input[name="confirm_password"]');
    if (confirmPassword.value !== password.value || !confirmPassword.value) {
        showError(confirmPassword, messages.confirm_password);
        valid = false;
    }

    // Email (nếu có nhập)
    const email = form.querySelector('input[name="email"]');
    if (email.value && !patterns.email.test(email.value.trim())) {
        showError(email, messages.email);
        valid = false;
    }

    // Số điện thoại (nếu có nhập)
    const phone = form.querySelector('input[name="phone"]');
    if (phone.value && !patterns.phone.test(phone.value.trim())) {
        showError(phone, messages.phone);
        valid = false;
    }

    // Vai trò
    const role = form.querySelectorAll('input[name="role"]:checked');
    if (role.length === 0) {
        const roleBlock = form.querySelector('.signup-role');
        showError(roleBlock, messages.role);
        valid = false;
    }

    // Đồng ý điều khoản
    const check = form.querySelector('input[type="checkbox"]#check');
    const checkLabel = form.querySelector('label[for="check"]');
    if (!check.checked) {
        const messageEl = document.createElement('div');
        messageEl.className = 'error-message';
        messageEl.textContent = messages.check;
        checkLabel.insertAdjacentElement('afterend', messageEl);
        valid = false;
    }

    return valid;
}

// Gắn validate cho form đăng ký
const signupForm = document.querySelector('form[action="/signup"]');
if (signupForm) {
    signupForm.addEventListener('submit', function(e) {
        if (!validateSignupForm(signupForm)) {
            e.preventDefault();
        }
    });
}