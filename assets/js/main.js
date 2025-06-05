function showElement(id) {
    // Store previous scroll position
    const previousScroll = window.pageYOffset;

    // Hide all elements first
    document.querySelectorAll('.element').forEach(element => {
        element.classList.remove('active');
    });

    const targetElement = document.getElementById(id);
    if (targetElement) {
        // For home section
        if (id === 'home') {
            targetElement.classList.add('active');
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
            return;
        }

        // For other sections
        // Add active class first to make element visible
        targetElement.classList.add('active');

        // Wait for element to be visible
        requestAnimationFrame(() => {
            const headerOffset = 50;
            const elementPosition = targetElement.getBoundingClientRect().top;
            const offsetPosition = previousScroll + elementPosition - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
        });
    }
}