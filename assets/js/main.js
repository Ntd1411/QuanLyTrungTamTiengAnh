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
    
    if (window.innerWidth <= 992) { // Chỉ đóng menu khi ở chế độ mobile
        nav.classList.remove('active');
        menuOverlay.classList.remove('active');
    }
}

// Add menu toggle function
function toggleMenu() {
    const nav = document.querySelector('nav');
    const menuOverlay = document.querySelector('.menu-overlay');
    // Check if we're on admin page
    const mainContentAdmin = document.querySelector('.main-content-admin');
    const mainContentStudent = document.querySelector('.main-content-student');

    menuOverlay.classList.toggle('active');
    nav.classList.toggle('active');
    
    // Only toggle pushed class if on admin page
    if (mainContentAdmin) {
        mainContentAdmin.classList.toggle('pushed');
    }
    if (mainContentStudent) {
        mainContentStudent.classList.toggle('pushed');
    }
}

// Close menu when clicking outside
document.addEventListener('click', function (e) {
    const nav = document.querySelector('nav');
    const menuToggle = document.querySelector('.menu-toggle');
    const menuOverlay = document.querySelector('.menu-overlay');

    if (nav.classList.contains('active') &&
        !nav.contains(e.target) &&
        !menuToggle.contains(e.target)) {
        nav.classList.remove('active');
        menuOverlay.classList.remove('active');
        // Check if we're on admin page before removing pushed class
        const mainContent = document.querySelector('.main-content-admin');
        if (mainContent) {
            mainContent.classList.remove('pushed');
        }
    }
});

function loadAd(){
    fetch("php/manageads.php?action=getAds")
        .then(response => response.json())
        .then(data => {
            if(data.status === "success"){
                const html = `
                <div class="ad-popup-content">
                    <span class="ad-close-btn" onclick="closeAdPopup()">&times;</span>
                    <h2>${data.data.subject}</h2>
                    <p>${data.data.content}</p>
                    <img src="assets/img/${data.data.image}" alt="${data.data.content}">
                    <button class="ad-cta-btn" onclick="window.location.href='./php/signup.php'">Đăng Ký Ngay</button>
                </div>
                `;

                document.getElementById('ad-popup').innerHTML = html;
                document.getElementById('ad-popup').style.display = "flex";
            } else {
                // console.log("Lỗi load quảng cáo: ", data.message);
            }
        })
        .catch(error => {
            console.log("Lỗi: " , error);
        })
}

function closeAdPopup() {
    document.getElementById('ad-popup').style.display = 'none';
}
