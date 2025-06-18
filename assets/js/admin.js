document.getElementById('class-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    formData.append('action', 'addClass');

    fetch('admin.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            alert(data.message);
            e.target.reset();
            loadClasses(); // Gọi hàm load lại danh sách
        } else {
            alert('Lỗi: ' + (data.message || 'Không thể thêm lớp'));
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi thêm lớp: ' + error.message);
    });
});

function loadClasses() {
    fetch('admin.php?action=getClasses', {
        method: 'post'
    })
    .then(response => response.text())
    .then(html => {
        document.getElementById('class-table-body').innerHTML = html;
    })
    .catch(error => {
        console.error('Error loading classes:', error);
    });
}

// Gọi loadClasses khi trang được tải
document.addEventListener('DOMContentLoaded', loadClasses);

