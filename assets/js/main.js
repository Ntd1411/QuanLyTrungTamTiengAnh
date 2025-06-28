function showElement(id) {
    // Fade out tất cả elements
    document.querySelectorAll('.element').forEach(element => {
        element.style.opacity = '0';
        element.style.visibility = 'hidden';
        setTimeout(() => {
            element.classList.remove('active');
        }, 300);
    });

    // Hiển thị element được chọn
    const targetElement = document.getElementById(id);
    if (targetElement) {
        setTimeout(() => {
            targetElement.classList.add('active');
            targetElement.style.visibility = 'visible';
            
            // Force reflow
            void targetElement.offsetWidth;
            
            // Fade in
            targetElement.style.opacity = '1';
            
            // Scroll với offset để tránh bị che bởi nav
            const navHeight = document.querySelector('nav').offsetHeight;
            const offset = 0; // Khoảng cách thêm

            // resize to load responsive
            window.dispatchEvent(new Event('resize'));
            
            window.scrollTo({
                top: Math.max(0, targetElement.offsetTop - navHeight - offset),
                behavior: 'smooth'
            });
        }, 300);
    }

     // Hide menu if it's open
    const nav = document.querySelector('nav');
    const menuOverlay = document.querySelector('.menu-overlay');
    const mainContent = document.querySelector('.main-content-admin');
    
    if (nav.classList.contains('active')) {
        nav.classList.remove('active');
        menuOverlay.classList.remove('active');
        mainContent.classList.remove('pushed');
    }
}