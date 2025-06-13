document.addEventListener('DOMContentLoaded', function() {
    const filterCategory = document.getElementById('filterCategory');
    const filterAuthor = document.getElementById('filterAuthor');
    const referenceListContainer = document.getElementById('referenceList'); // Container chứa các item
    const referenceItems = document.querySelectorAll('.reference-item');

    // Hàm lọc tài liệu
    function filterReferences() {
        const selectedCategory = filterCategory.value;
        const selectedAuthor = filterAuthor.value;
        let visibleItemsCount = 0; // Đếm số lượng item hiển thị

        referenceItems.forEach(item => {
            const itemCategory = item.dataset.category;
            const itemAuthor = item.dataset.author;

            const categoryMatch = (selectedCategory === 'all' || itemCategory === selectedCategory);
            const authorMatch = (selectedAuthor === 'all' || itemAuthor === selectedAuthor);

            if (categoryMatch && authorMatch) {
                item.style.display = 'flex'; // Hiển thị item
                visibleItemsCount++;
            } else {
                item.style.display = 'none'; // Ẩn item
            }
        });

        // Xử lý thông báo "Không có tài liệu phù hợp"
        const noResultsMessageId = 'no-results-message';
        let noResultsElement = document.getElementById(noResultsMessageId);

        if (visibleItemsCount === 0) {
            if (!noResultsElement) {
                noResultsElement = document.createElement('div');
                noResultsElement.id = noResultsMessageId;
                noResultsElement.classList.add('no-results-message');
                noResultsElement.textContent = 'Không có tài liệu phù hợp với lựa chọn của bạn.';
                referenceListContainer.appendChild(noResultsElement);
            }
            noResultsElement.style.display = 'block'; // Đảm bảo thông báo hiển thị
        } else {
            if (noResultsElement) {
                noResultsElement.style.display = 'none'; // Ẩn thông báo nếu có kết quả
            }
        }
    }

    // Gắn sự kiện 'change' cho các bộ lọc
    filterCategory.addEventListener('change', filterReferences);
    filterAuthor.addEventListener('change', filterReferences);

    // Gọi hàm lọc khi trang tải lần đầu để đảm bảo hiển thị đúng
    filterReferences();

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
});