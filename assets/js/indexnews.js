
let allNews = []; // Store all news items
let currentIndex = 0;
const itemsPerLoad = 3;

function loadNews() {
    fetch('php/getnews.php')
        .then(response => response.json())
        .then(news => {
            allNews = news.sort((a, b) => new Date(b.date) - new Date(a.date));
            displayNews(true);

            // Show/hide load more button based on remaining items
            const loadMoreBtn = document.getElementById('load-more-news');
            loadMoreBtn.style.display = currentIndex < allNews.length ? 'block' : 'none';
        })
        .catch(error => console.error('Error:', error));
}

function displayNews(isInitial = false) {
    const newsContainer = document.querySelector('.news-list-grid');

    if (isInitial) {
        newsContainer.innerHTML = '';
        currentIndex = 0;
    }

    const itemsToShow = allNews.slice(currentIndex, currentIndex + itemsPerLoad);

    itemsToShow.forEach(item => {
        const newsHtml = `
                <div class="news-item">
                    <img src="assets/img/${item.image}" alt="${item.title}" class="news-img">
                    <div class="news-info">
                        <h3><a href="php/news_detail.php?id=${item.id}" class="news-title-link">${item.title}</a></h3>
                        <p class="news-meta">
                            <span class="news-date">${formatDate(item.date)}</span> | 
                            <span class="news-author">${item.author}</span>
                        </p>
                    </div>
                </div>
            `;
        newsContainer.innerHTML += newsHtml;
    });

    currentIndex += itemsPerLoad;

    // Update load more button visibility
    const loadMoreBtn = document.getElementById('load-more-news');
    loadMoreBtn.style.display = currentIndex < allNews.length ? 'block' : 'none';
}

// Add event listener for load more button
document.getElementById('load-more-news').addEventListener('click', () => displayNews());

function formatDate(dateString) {
    // Kiểm tra nếu ngày đã ở định dạng dd/mm/yyyy
    if (dateString.includes('/')) {
        return dateString; // Trả về nguyên bản vì đã đúng định dạng
    }

    // Nếu là định dạng yyyy-mm-dd thì chuyển sang dd/mm/yyyy
    const date = new Date(dateString);
    if (isNaN(date)) return 'Ngày không hợp lệ';

    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();

    return `${day}/${month}/${year}`;
}
loadNews();
// Update the initialization
setTimeout(() => {
    loadAd();
}, 1000);
