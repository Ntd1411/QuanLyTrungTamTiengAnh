// Cập nhật trang khi có thay đổi
// Cách 1 - Sử dụng onpageshow và performance.navigation
// Ngăn không cho cache trang
window.onpageshow = function (event) {
    if (event.persisted) {
        window.location.reload();
    }
};
window.addEventListener('load', function () {
    if (window.performance && window.performance.navigation.type === 2) {
        // type 2 means back/forward button was used
        window.location.reload(); // reload the page
    }
});

// Hoặc cách 2 - sử dụng popstate event
window.addEventListener('popstate', function (event) {
    window.location.reload();
});