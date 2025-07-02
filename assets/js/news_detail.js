document.addEventListener('DOMContentLoaded', function() {
    // Hàm để lấy parameter từ URL
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }

    const articleId = getUrlParameter('id'); // Lấy ID bài viết từ URL (?id=...)

    // --- DỮ LIỆU GIẢ LẬP TỪ CƠ SỞ DỮ LIỆU ---
    // Trong một ứng dụng thực tế, bạn sẽ gửi một yêu cầu AJAX (fetch API)
    // đến một API backend (ví dụ: /api/news?id=...) để lấy dữ liệu này.
    const mockDatabase = [
        {
            id: 1,
            title: "Khai giảng Trại hè Tiếng Anh 2025 - Vui học, vui khám phá!",
            content: `
                <p>KMA English Center (KEC) hân hạnh thông báo chính thức khai giảng "Trại hè Tiếng Anh 2025" với chủ đề "Vui học, Vui khám phá!" Đây là cơ hội tuyệt vời để các em học sinh có một mùa hè sôi động, bổ ích, kết hợp hoàn hảo giữa học tập và trải nghiệm thực tế.</p>
                <h3>Mục tiêu của Trại hè:</h3>
                <ul>
                    <li>Nâng cao toàn diện 4 kỹ năng Nghe, Nói, Đọc, Viết.</li>
                    <li>Phát triển kỹ năng mềm: làm việc nhóm, tư duy phản biện, thuyết trình.</li>
                    <li>Khơi gợi niềm đam mê với tiếng Anh thông qua các hoạt động vui nhộn.</li>
                    <li>Trải nghiệm văn hóa đa dạng.</li>
                </ul>
                <h3>Hoạt động nổi bật:</h3>
                <p>Trại hè 2025 được thiết kế với chương trình học tập và vui chơi đa dạng, phù hợp với mọi lứa tuổi:</p>
                <ol>
                    <li>Các buổi học tiếng Anh sáng tạo với giáo viên bản ngữ và Việt Nam giàu kinh nghiệm, sử dụng phương pháp giảng dạy tương tác, hấp dẫn.</li>
                    <li>Workshop "Khoa học vui" bằng tiếng Anh, giúp các em vừa học tiếng Anh, vừa khám phá thế giới khoa học.</li>
                    <li>Hoạt động ngoại khóa: Dã ngoại, trò chơi lớn, team building, biểu diễn văn nghệ.</li>
                    <li>CLB Điện ảnh tiếng Anh: Xem phim và thảo luận bằng tiếng Anh.</li>
                    <li>Dự án "Little Entrepreneur": Các em sẽ được thử sức kinh doanh và thuyết trình sản phẩm bằng tiếng Anh.</li>
                </ol>
                <h3>Thời gian và Địa điểm:</h3>
                <p>Trại hè sẽ diễn ra từ ngày <strong>15/07/2025 đến 15/08/2025</strong> tại cơ sở chính của KEC.</p>
                <p>Để biết thêm thông tin chi tiết về lịch trình, học phí và cách đăng ký, vui lòng liên hệ trực tiếp với chúng tôi hoặc truy cập trang Đăng ký Trại hè trên website.</p>
                <p>Hãy để KEC giúp con bạn có một mùa hè đáng nhớ, vừa học vừa chơi, và phát triển toàn diện bản thân!</p>
            `,
            excerpt: "Trại hè Tiếng Anh KEC 2025 chính thức khai giảng, mang đến một mùa hè sôi động, bổ ích với vô vàn hoạt động lý thú kết hợp học tập và trải nghiệm thực tế...",
            image: "../assets/img/news_summer_camp.jpg",
            author: "KEC Team",
            date: "10/06/2025"
        },
        {
            id: 2,
            title: "Chúc mừng học viên Nguyễn Văn A đạt IELTS 7.5 Overall!",
            content: `
                <p>KEC xin trân trọng chúc mừng học viên Nguyễn Văn A đã xuất sắc đạt điểm IELTS 7.5 Overall trong kỳ thi IELTS gần đây nhất. Đây là một thành tích đáng ngưỡng mộ, minh chứng cho sự nỗ lực không ngừng của bạn A và chất lượng đào tạo tại KEC.</p>
                <h3>Hành trình chinh phục IELTS 7.5:</h3>
                <p>Nguyễn Văn A bắt đầu khóa học IELTS tại KEC với mục tiêu đạt 6.5. Với sự hướng dẫn tận tình từ đội ngũ giáo viên giàu kinh nghiệm và chương trình học được cá nhân hóa, bạn A đã có những bước tiến vượt bậc chỉ sau 6 tháng.</p>
                <ul>
                    <li><strong>Kỹ năng Reading:</strong> Từ 6.0 lên 8.0</li>
                    <li><strong>Kỹ năng Listening:</strong> Từ 6.5 lên 7.5</li>
                    <li><strong>Kỹ năng Speaking:</strong> Từ 5.5 lên 6.5</li>
                    <li><strong>Kỹ năng Writing:</strong> Từ 5.0 lên 6.5</li>
                </ul>
                <p>Tổng điểm Overall của bạn A là 7.5, vượt xa mục tiêu ban đầu. Chia sẻ về bí quyết thành công, bạn A cho biết: "Em rất biết ơn các thầy cô tại KEC đã luôn động viên và chỉ ra những điểm yếu cần cải thiện. Phương pháp luyện đề và tips làm bài hiệu quả là chìa khóa giúp em tự tin hơn rất nhiều."</p>
                <h3>Lời chúc từ KEC:</h3>
                <p>Thành công của Nguyễn Văn A là niềm tự hào của KEC. Chúng tôi tin rằng với khả năng tiếng Anh vượt trội, bạn A sẽ mở ra nhiều cơ hội học tập và phát triển sự nghiệp trong tương lai.</p>
                <p>KEC luôn cam kết đồng hành cùng học viên trên hành trình chinh phục tiếng Anh. Hãy đến với KEC để biến ước mơ IELTS của bạn thành hiện thực!</p>
            `,
            excerpt: "KEC xin gửi lời chúc mừng chân thành nhất đến học viên Nguyễn Văn A đã xuất sắc đạt 7.5 IELTS chỉ sau 6 tháng học tại trung tâm...",
            image: "../assets/img/news_ielts_success.jpg",
            author: "Ban Tuyển sinh",
            date: "05/06/2025"
        },
        {
            id: 3,
            title: "5 mẹo học từ vựng tiếng Anh hiệu quả không thể bỏ qua",
            content: `
                <p>Từ vựng là nền tảng của mọi ngôn ngữ. Nếu bạn đang gặp khó khăn trong việc ghi nhớ và sử dụng từ vựng tiếng Anh, hãy tham khảo 5 mẹo hiệu quả dưới đây từ các chuyên gia của KEC!</p>
                <h3>1. Học từ vựng theo chủ đề:</h3>
                <p>Thay vì học các từ riêng lẻ, hãy nhóm chúng lại theo chủ đề (ví dụ: du lịch, công việc, ẩm thực, sức khỏe). Khi bạn học các từ liên quan đến nhau, não bộ sẽ dễ dàng tạo liên kết và ghi nhớ tốt hơn.</p>
                <h3>2. Sử dụng Flashcards thông minh:</h3>
                <p>Flashcards vẫn là công cụ hiệu quả. Hãy viết từ mới ở một mặt và định nghĩa, ví dụ, cách phát âm (IPA) ở mặt còn lại. Sử dụng các ứng dụng flashcards như Quizlet hoặc Anki để ôn tập thường xuyên và theo phương pháp lặp lại ngắt quãng (spaced repetition).</p>
                <h3>3. Đặt từ vào ngữ cảnh:</h3>
                <p>Học một từ mới mà không biết cách dùng sẽ rất khó nhớ. Hãy luôn cố gắng đặt từ đó vào các câu ví dụ, hoặc tốt hơn nữa, tự tạo câu ví dụ của riêng bạn. Đọc sách, báo, nghe podcast sẽ giúp bạn thấy từ vựng được sử dụng trong ngữ cảnh thực tế.</p>
                <h3>4. Kết hợp đa giác quan:</h3>
                <p>Hãy sử dụng cả mắt, tai, miệng, và thậm chí là cảm xúc khi học từ vựng. Nghe phát âm, lặp lại từ, viết từ ra giấy, tìm hình ảnh minh họa, hoặc liên tưởng đến một kỷ niệm nào đó. Sự kết hợp này giúp thông tin được mã hóa sâu hơn vào trí nhớ dài hạn.</p>
                <h3>5. Ôn tập thường xuyên và kiên trì:</h3>
                <p>Việc học từ vựng không phải là một lần rồi xong. Hãy dành thời gian ôn tập mỗi ngày, ngay cả khi chỉ 15-20 phút. Sự kiên trì là chìa khóa để xây dựng vốn từ vựng khổng lồ.</p>
                <p>Áp dụng những mẹo này và bạn sẽ thấy vốn từ vựng tiếng Anh của mình tăng lên đáng kể. Chúc bạn học tốt!</p>
            `,
            excerpt: "Bạn gặp khó khăn khi ghi nhớ từ vựng? Đừng lo, bài viết này sẽ chia sẻ 5 chiến lược đã được kiểm chứng giúp bạn mở rộng vốn từ nhanh chóng và hiệu quả...",
            image: "../assets/img/news_english_tips.jpg",
            author: "Cô Lan Anh",
            date: "01/06/2025"
        },
        {
            id: 4,
            title: "Cập nhật cấu trúc đề thi TOEIC Reading mới nhất 2025",
            content: `
                <p>Kỳ thi TOEIC luôn có những cập nhật nhỏ về cấu trúc và dạng câu hỏi để phù hợp với xu hướng sử dụng tiếng Anh trong môi trường làm việc quốc tế. Năm 2025 mang đến một số thay đổi đáng chú ý trong phần thi Reading mà các thí sinh cần nắm vững.</p>
                <h3>Điểm chính cần lưu ý:</h3>
                <ul>
                    <li>**Phần 6 (Text Completion):** Số lượng câu hỏi có thể thay đổi, tập trung nhiều hơn vào khả năng hiểu ngữ cảnh và từ nối.</li>
                    <li>**Phần 7 (Reading Comprehension):**
                        <ul>
                            <li>Xuất hiện nhiều đoạn văn bản kép hoặc ba, yêu cầu thí sinh phải tổng hợp thông tin từ nhiều nguồn.</li>
                            <li>Các câu hỏi suy luận và liên kết thông tin giữa các đoạn văn có thể tăng lên.</li>
                            <li>Nội dung văn bản sẽ đa dạng hơn, bao gồm email, quảng cáo, bài báo, tin nhắn văn bản, v.v., mô phỏng tình huống công việc thực tế.</li>
                        </ul>
                    </li>
                </ul>
                <h3>Lời khuyên từ KEC:</h3>
                <p>Để đạt điểm cao trong phần Reading TOEIC với cấu trúc mới, KEC khuyên bạn:</p>
                <ol>
                    <li>**Luyện tập đọc hiểu đa dạng:** Đọc nhiều loại văn bản khác nhau, không chỉ trong sách luyện thi mà còn từ báo chí, tài liệu công việc.</li>
                    <li>**Cải thiện kỹ năng đọc lướt và đọc quét:** Khả năng tìm kiếm thông tin nhanh chóng và nắm bắt ý chính là rất quan trọng khi đối mặt với nhiều đoạn văn bản.</li>
                    <li>**Tăng cường vốn từ vựng và ngữ pháp chuyên ngành:** Đặc biệt là các từ vựng thường dùng trong môi trường kinh doanh và công sở.</li>
                    <li>**Giải đề thi thử theo format mới:** Đây là cách tốt nhất để làm quen với áp lực thời gian và dạng câu hỏi mới.</li>
                </ol>
                <p>KEC liên tục cập nhật chương trình học TOEIC để phù hợp với những thay đổi mới nhất của đề thi. Hãy đăng ký khóa học TOEIC tại KEC để nhận được lộ trình học tập hiệu quả nhất!</p>
            `,
            excerpt: "Những thay đổi quan trọng trong phần thi Reading của kỳ thi TOEIC năm 2025 mà bạn cần biết để chuẩn bị tốt nhất...",
            image: "../assets/img/news_toeic_update.jpg",
            author: "Thầy Duy Hưng",
            date: "28/05/2025"
        }
    ];
    // --- KẾT THÚC DỮ LIỆU GIẢ LẬP ---

    const article = mockDatabase.find(item => item.id == articleId); // Tìm bài viết theo ID

    if (article) {
        // Đổ dữ liệu vào các phần tử HTML
        document.getElementById('article-title').textContent = article.title;
        document.getElementById('article-author').textContent = article.author;
        document.getElementById('article-date').textContent = article.date;
        document.getElementById('article-image').src = article.image;
        document.getElementById('article-content').innerHTML = article.content; // Dùng innerHTML vì content có thể chứa thẻ HTML
        document.title = article.title + " - KEC"; // Cập nhật tiêu đề trang
    } else {
        // Hiển thị thông báo nếu không tìm thấy bài viết
        document.getElementById('article-title').textContent = "Bài viết không tồn tại.";
        document.getElementById('article-meta').innerHTML = ""; // Xóa thông tin meta
        document.getElementById('article-image').style.display = "none"; // Ẩn ảnh
        document.getElementById('article-content').innerHTML = "<p>Rất tiếc, bài viết bạn đang tìm không có sẵn hoặc đã bị xóa.</p>";
        document.title = "Không tìm thấy - KEC";
    }
});

// Hàm showElement (Nếu có trong các script chung, có thể bỏ qua ở đây)
// Giữ lại để đảm bảo chức năng navigation menu nếu không có script.js chung
window.showElement = function(elementId) {
    // Đây là hàm giả định để làm việc với menu/sidebar của bạn
    // Cần phải đảm bảo rằng các phần tử có lớp 'element' và 'active' được xử lý đúng
    console.log("Hàm showElement được gọi cho ID:", elementId);
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