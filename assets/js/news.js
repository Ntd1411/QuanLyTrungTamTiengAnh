document.addEventListener('DOMContentLoaded', function() {
    // Hàm showElement (được dùng trong menu nav và sidebar, có thể cần di chuyển nếu có nhiều script chung)
    // Tạm thời để đây để đảm bảo không bị lỗi reference nếu hàm này chỉ có ở index.html gốc.
    // Nếu hàm này là chung cho nhiều trang, nên đặt nó vào một file script chung (ví dụ: common.js)
    window.showElement = function(elementId) {
        console.log("Hàm showElement được gọi cho ID:", elementId);
        //alert("Chức năng này cần được triển khai để hiển thị các phần tử tương ứng. Hiện tại, nó chỉ là một placeholder.");
        // Ví dụ: Tìm và ẩn/hiện các phần tử
        document.querySelectorAll('.element').forEach(el => {
            if (el.id === elementId) {
                el.classList.add('active'); // Giả sử 'active' hiển thị
                el.style.display = 'block'; // Hoặc block/flex tùy thuộc vào display ban đầu
            } else {
                el.classList.remove('active');
                el.style.display = 'none'; // Ẩn các phần tử khác
            }
        });
    };

    // --- Các chức năng khác cho trang News (hiện tại không có JS phức tạp) ---
    // Ví dụ, nếu bạn muốn phân trang động hoặc tải bài viết qua AJAX,
    // bạn sẽ thêm logic vào đây.

    // Hiện tại, trang news.html chủ yếu là static HTML/CSS.
    // Nếu bạn muốn triển khai phân trang hoặc chức năng "xem thêm",
    // bạn sẽ cần JavaScript để quản lý hiển thị các bài viết.
    // Ví dụ đơn giản cho phân trang (chưa xử lý động):
    const pageLinks = document.querySelectorAll('.page-link');
    pageLinks.forEach(link => {
        link.addEventListener('click', function(event) {
            event.preventDefault(); // Ngăn chặn hành vi mặc định của link
            // Logic để thay đổi trang hoặc tải nội dung mới
            console.log("Clicked on page:", this.textContent);

            // Gỡ bỏ active từ tất cả và thêm vào link được click
            pageLinks.forEach(p => p.classList.remove('active'));
            this.classList.add('active');

            // Ở đây bạn sẽ thêm logic tải bài viết cho trang tương ứng
            // (Hiện tại chỉ là placeholder log ra console)
            alert("Chức năng phân trang động chưa được triển khai đầy đủ. Click để chuyển trang sẽ tải nội dung mới (nếu có).");
        });
    });

});