document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const errorMessage = document.getElementById('error-message');
    const formData = new FormData(this);

    fetch('../php/login.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            window.location.href = data.redirect;
        } else {
            errorMessage.textContent = data.error;
            errorMessage.style.display = 'block';
        }
    })
    .catch(error => {
        errorMessage.textContent = 'Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại sau.';
        errorMessage.style.display = 'block';
    });
});
