function showElement(id) {
    document.querySelectorAll('.element').forEach(element => {
        element.classList.remove('active');
    });

    const targetElement = document.getElementById(id);
    if (targetElement) {
        targetElement.classList.add('active');
        // Cuộn đến phần tử (tùy chọn)
        targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        setTimeout(() => {
            window.scrollBy({ top: -50, left: 0, behavior: 'smooth' }); // 80px là chiều cao menu
        }, 300);
    }
}