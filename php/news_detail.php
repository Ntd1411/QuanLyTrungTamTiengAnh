<?php
  $id = $_GET['id'];

  require_once '../model/config.php';
  $conn = connectdb();
  
  $sql = 'SELECT * FROM news WHERE id = ?';

  $stmt = $conn->prepare($sql);
  $stmt->execute([$id]);
  $news = $stmt->fetch(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" href="../assets/icon/logo_ver3.png" />
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/news_detail.css" />
    <title>Chi tiết Tin tức - KEC</title>
  </head>

  <body>
    <!-- Add menu toggle button -->
    <button class="menu-toggle" onclick="toggleMenu()">
      <i class="fas fa-bars"></i>
    </button>

    <!-- Add menu overlay -->
    <div class="menu-overlay" onclick="toggleMenu()"></div>
    <!-- Header với ảnh -->
    <header>
      <img src="../assets/img/poster.jpg" alt="Logo Website" />
    </header>

    <!-- Menu đa cấp -->
    <nav>
      <ul class="menu">
        <li>
          <a href="../index.html">Trang Chủ</a>
        </li>
        <li>
          <a href="#" onclick="event.preventDefault()">Giới Thiệu</a>
          <ul class="submenu">
            <li>
              <a href="../view/teachter_intro.html">Đội Ngũ Giảng Viên</a>
            </li>
            <li><a href="../view/faq.html">Câu Hỏi Thường Gặp (FAQ)</a></li>
            <li><a href="../view/contact.html">Liên Hệ</a></li>
          </ul>
        </li>
        <li>
          <a href="#" onclick="event.preventDefault()">Đào Tạo</a>
          <ul class="submenu">
            <li>
              <a href="../view/english_for_kids.html">Tiếng Anh cho trẻ</a>
            </li>
            <li>
              <a href="" onclick="event.preventDefault()">IELTS</a>
              <ul class="sub-submenu">
                <li><a href="../view/ielts_basic.html">IELTS cơ bản</a></li>
                <li><a href="../view/ielts_4.0_5.5.html">IELTS 4.0-5.5</a></li>
                <li><a href="../view/ielts_5.5_6.5.html">IELTS 5.5-6.5</a></li>
                <li><a href="../view/ielts_6.5+.html">IELTS 6.5+</a></li>
              </ul>
            </li>
            <li>
              <a href="#" onclick="event.preventDefault()">TOEIC</a>
              <ul class="sub-submenu">
                <li><a href="../view/toeic_550_650.html">550-650 TOEIC</a></li>
                <li><a href="../view/toeic_650_800.html">650-800 TOEIC</a></li>
                <li><a href="../view/toeic_800+.html">800+ TOEIC</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li>
          <a href="../view/reference.html">Thư viện</a>
        </li>
        <li>
          <a href="#" onclick="event.preventDefault()">Tin Tức</a>
          <ul class="submenu">
            <li><a href="../view/news.html">Sự Kiện</a></li>
            <li><a href="../view/student_intro.html">Học Viên Xuất Sắc</a></li>
          </ul>
        </li>
        <li>
          <a href="#" onclick="event.preventDefault()">Tài Khoản</a>
          <ul class="submenu">
            <li><a href="../php/login.php">Đăng Nhập</a></li>
            <li><a href="../php/signup.php">Đăng Ký</a></li>
          </ul>
        </li>
      </ul>
    </nav>

    <div class="element active">
      <main class="main-content">
        <div class="news-detail-container">
          <h1 id="article-title" class="news-detail-title"><?php echo $news['title']?></h1>
          <p class="news-detail-meta">
            <span id="article-author"><?php echo $news['author']?></span> |
            <span id="article-date"><?php echo $news['date']?></span>
          </p>
          <div class="news-detail-image-wrapper">
            <img
              id="article-image"
              src="../assets/img/<?php echo $news['image']?>"
              alt="Hình ảnh bài viết"
              class="news-detail-image"
            />
          </div>
          <div id="article-content" class="news-detail-content"><?php echo $news['content']?></div>
          <div class="news-detail-back-link">
            <a href="../view/news.html">&laquo; Quay lại danh sách tin tức</a>
          </div>
        </div>
      </main>
      <footer>
        <p>
          <strong>Email:</strong> contact@actvn.edu.vn |
          <strong>Website:</strong> www.actvn.edu.vn
        </p>
        <h3>
          Học Viện Kỹ Thuật Mật Mã - 141 Chiến Thắng, Tân Triều, Thanh Trì, Hà
          Nội
        </h3>
        <p>Điện thoại: 9876 543 210 | 0123 456 789</p>
        <p>&copy; 2025 - Bản quyền thuộc về Học Viện Kỹ Thuật Mật Mã</p>
      </footer>
    </div>

    <script src="../assets/js/main.js"></script>
  </body>
</html>

<!--
             

-->
