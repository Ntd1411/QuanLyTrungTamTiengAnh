# QuanLyTrungTamTiengAnh
Web quản lý trung tâm tiếng anh

# Hệ thống Quản lý Trung tâm Tiếng Anh KEC

## Mục lục
- [Giới thiệu](#giới-thiệu)
- [Tính năng chính](#tính-năng-chính)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Cài đặt](#cài-đặt)
- [Cách sử dụng](#cách-sử-dụng)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Đóng góp](#đóng-góp)
- [Liên hệ](#liên-hệ)

## Giới thiệu
Dự án **Hệ thống Quản lý Trung tâm Tiếng Anh KEC** là một ứng dụng web được thiết kế để hỗ trợ các hoạt động quản lý, đào tạo và tương tác giữa trung tâm tiếng Anh, giáo viên và học viên. Website cung cấp thông tin chi tiết về trung tâm, các khóa học, đội ngũ giảng viên và một bảng điều khiển riêng biệt dành cho giáo viên để quản lý lịch dạy, lớp học, điểm danh và thông báo.

Mục tiêu của dự án là tối ưu hóa quy trình quản lý, cung cấp một nền tảng dễ sử dụng và nâng cao trải nghiệm học tập tại trung tâm KEC.

## Tính năng chính
Dưới đây là các tính năng nổi bật của hệ thống:

### Phần công khai (Website chính)
* **Trang Chủ:** Cung cấp tổng quan về trung tâm, thông tin nổi bật.
* **Giới Thiệu:**
    * **Đội Ngũ Giảng Viên:** Giới thiệu chi tiết về các giảng viên của trung tâm.
    * **Câu Hỏi Thường Gặp (FAQ):** Giải đáp các thắc mắc phổ biến.
    * **Liên Hệ:** Cung cấp thông tin liên hệ và biểu mẫu gửi tin nhắn.
* **Đào Tạo:**
    * **Tiếng Anh cho trẻ:** Thông tin về các khóa học tiếng Anh dành cho trẻ em.
    * **IELTS:** Các cấp độ khóa học IELTS (cơ bản, 4.0-5.0, 5.0-6.0, 6.0-7.0) cùng thông tin chi tiết.
    * **TOEIC:** Các cấp độ khóa học toeic cùng thông tin chi tiết
* **Giao diện người dùng:** Thiết kế hiện đại, thoáng đãng và thân thiện, màu sắc thương hiệu nhất quán.

### Bảng điều khiển Giáo viên (Teacher Dashboard)
* **Trang Chủ Giáo Viên:** Tổng quan về các thông tin quan trọng dành cho giáo viên.
* **Lịch Dạy:** Xem và quản lý lịch dạy cá nhân.
* **Lớp Dạy:** Truy cập thông tin chi tiết về các lớp học đang phụ trách.
* **Điểm Danh:** Thực hiện điểm danh học viên trực tuyến.
* **Thông Báo:** Nhận các thông báo quan trọng từ trung tâm.
* **Tài Khoản:** Quản lý thông tin cá nhân và thay đổi mật khẩu.

## Công nghệ sử dụng
Dự án này chủ yếu được xây dựng với các công nghệ Frontend tiêu chuẩn:
* **HTML5:** Cấu trúc nội dung web.
* **CSS3:** Định kiểu và thiết kế giao diện người dùng, bao gồm responsive design.
* **JavaScript (ES6+):** Xử lý các tương tác người dùng, điều hướng và các tính năng động của giao diện (ví dụ: chuyển đổi tab, menu).
* **PHP:** Tạo kịch bản, điều hướng người dùng và bảo mật thông tin
* **MySQL** Lưu trữ dữ liệu trực quan, dễ dàng chỉnh sửa

## Yêu cầu hệ thống
Để chạy ứng dụng web này, bạn chỉ cần:
* Một máy chủ để lưu trữ source code
* Một trình duyệt web hiện đại (Chrome, Firefox, Edge, Safari...) để truy cập

## Cài đặt
Không cần cài đặt phức tạp. Bạn chỉ cần tải xuống mã nguồn và mở file HTML.

1.  **Clone hoặc tải xuống mã nguồn:**
    ```bash
    git clone https://github.com/yourusername/KEC-English-Center.git
    cd KEC-English-Center
    ```

2.  **Mở ứng dụng:**
    Mở file `index.html` trong thư mục gốc của dự án bằng trình duyệt web của bạn.
    Để truy cập Dashboard Giáo viên, bạn có thể mở trực tiếp file `view/teacher.html`.


## Cách sử dụng

### Đối với Học viên/Khách truy cập
* **Điều hướng:** Sử dụng menu ngang ở đầu trang để truy cập các phần "Trang Chủ", "Giới Thiệu" (Đội Ngũ Giảng Viên, FAQ, Liên Hệ) và "Đào Tạo" (Tiếng Anh cho trẻ, IELTS,...).
* **Tìm hiểu thông tin:** Đọc các trang giới thiệu, chi tiết khóa học, hoặc thông tin liên hệ.

### Đối với Giáo viên
* **Truy cập Dashboard:** Mở file `view/teacher.html` hoặc đăng nhập (nếu có hệ thống xác thực backend).
* **Điều hướng trong Dashboard:** Sử dụng menu bên trái trong Dashboard để chuyển đổi giữa các mục: "Trang Chủ", "Lịch Dạy", "Lớp Dạy", "Điểm Danh", "Thông Báo" và "Tài Khoản".
* **Cập nhật thông tin cá nhân:** Trong mục "Tài Khoản" -> "Hồ sơ", bạn có thể cập nhật số điện thoại và mật khẩu mới.

## Cấu trúc dự án
Dự án được tổ chức với cấu trúc thư mục sau:
```
WEBSITE QUAN LY TRUNG TAM TIENG ANH KEC
│   index.html
│   README.md
│   test.php
│
├───.vscode
│       settings.json
│
├───assets
│   ├───css
│   │       admin.css
│   │       contact.css
│   │       english_course.css
│   │       faq.css
│   │       kids_english_course.css
│   │       legal.css
│   │       news.css
│   │       news_detail.css
│   │       parent.css
│   │       reference.css
│   │       student.css
│   │       student_intro_style.css
│   │       style.css
│   │       teacher.css
│   │       teacher_intro_style.css
│   │
│   ├───icon
│   │       logo_ver3.png
│   │
│   ├───img
│   │       1750909739_admin.png
│   │       5.5_illustration.png
│   │       6.5+_illustration.png
│   │       6.5_illustration.jpg
│   │       650_illustration.jpg
│   │       800_illustration.jpg
│   │       990_illustration.jpg
│   │       admin.png
│   │       ad_6865402d30927.png
│   │       english-file-icon-intermediate-plus.gif
│   │       english_for_kids_illustration.jpg
│   │       hocTA.jpg
│   │       ielts7-5.jpg
│   │       ielts_basic_illustration.png
│   │       img1.png
│   │       img10.jpg
│   │       img2.gif
│   │       img2.png
│   │       img3.jpg
│   │       img4.jpg
│   │       img5.jpg
│   │       img6.jpg
│   │       img7.jpg
│   │       img8.jpg
│   │       img9.png
│   │       poster.jpg
│   │       student_1.jpg
│   │       student_2.png
│   │       student_3.png
│   │       student_4.jpg
│   │       student_5.png
│   │       student_6.jpg
│   │       student_7.jpg
│   │       summercamp.jpg
│   │       teacher_thanh_huong.png
│   │       teacher_thao.png
│   │       teacher_thuy.png
│   │       teacher_thu_huong.png
│   │       teacher_vi.png
│   │       teacher_yen.png
│   │       toeic.png
│   │
│   ├───js
│   │       admin.js
│   │       all_english_courses.js
│   │       contact.js
│   │       indexnews.js
│   │       main.js
│   │       news.js
│   │       parent.js
│   │       reference.js
│   │       student.js
│   │       teacher.js
│   │       update_page.js
│   │       validation.js
│   │
│   └───media
│           standee1.gif
│
├───model
│   │   config.php
│   │   configadmin.php
│   │   quanlytrungtamtienganh.sql
│   │   sendmail.php
│   │   user.php
│   │
│   └───PHPMailer
│       │   COMMITMENT
│       │   composer.json
│       │   get_oauth_token.php
│       │   LICENSE
│       │   README.md
│       │   SECURITY.md
│       │   SMTPUTF8.md
│       │   VERSION
│       │
│       ├───language
│       │       phpmailer.lang-af.php
│       │       phpmailer.lang-ar.php
│       │       phpmailer.lang-as.php
│       │       phpmailer.lang-az.php
│       │       phpmailer.lang-ba.php
│       │       phpmailer.lang-be.php
│       │       phpmailer.lang-bg.php
│       │       phpmailer.lang-bn.php
│       │       phpmailer.lang-ca.php
│       │       phpmailer.lang-cs.php
│       │       phpmailer.lang-da.php
│       │       phpmailer.lang-de.php
│       │       phpmailer.lang-el.php
│       │       phpmailer.lang-eo.php
│       │       phpmailer.lang-es.php
│       │       phpmailer.lang-et.php
│       │       phpmailer.lang-fa.php
│       │       phpmailer.lang-fi.php
│       │       phpmailer.lang-fo.php
│       │       phpmailer.lang-fr.php
│       │       phpmailer.lang-gl.php
│       │       phpmailer.lang-he.php
│       │       phpmailer.lang-hi.php
│       │       phpmailer.lang-hr.php
│       │       phpmailer.lang-hu.php
│       │       phpmailer.lang-hy.php
│       │       phpmailer.lang-id.php
│       │       phpmailer.lang-it.php
│       │       phpmailer.lang-ja.php
│       │       phpmailer.lang-ka.php
│       │       phpmailer.lang-ko.php
│       │       phpmailer.lang-ku.php
│       │       phpmailer.lang-lt.php
│       │       phpmailer.lang-lv.php
│       │       phpmailer.lang-mg.php
│       │       phpmailer.lang-mn.php
│       │       phpmailer.lang-ms.php
│       │       phpmailer.lang-nb.php
│       │       phpmailer.lang-nl.php
│       │       phpmailer.lang-pl.php
│       │       phpmailer.lang-pt.php
│       │       phpmailer.lang-pt_br.php
│       │       phpmailer.lang-ro.php
│       │       phpmailer.lang-ru.php
│       │       phpmailer.lang-si.php
│       │       phpmailer.lang-sk.php
│       │       phpmailer.lang-sl.php
│       │       phpmailer.lang-sr.php
│       │       phpmailer.lang-sr_latn.php
│       │       phpmailer.lang-sv.php
│       │       phpmailer.lang-tl.php
│       │       phpmailer.lang-tr.php
│       │       phpmailer.lang-uk.php
│       │       phpmailer.lang-ur.php
│       │       phpmailer.lang-vi.php
│       │       phpmailer.lang-zh.php
│       │       phpmailer.lang-zh_cn.php
│       │
│       └───src
│               DSNConfigurator.php
│               Exception.php
│               OAuth.php
│               OAuthTokenProvider.php
│               PHPMailer.php
│               POP3.php
│               SMTP.php
│
├───php
│       add_homework.php
│       add_teaching_log.php
│       admin.php
│       admincrud.php
│       delete_attendance.php
│       delete_teaching_log.php
│       forgotpassword.php
│       getnews.php
│       get_attendance_history.php
│       get_parent_data.php
│       get_student_data.php
│       get_teacher_data.php
│       login.php
│       logout.php
│       manageads.php
│       mark_message_read.php
│       news_detail.php
│       new_teacher_sent_data.php
│       parent.php
│       payfee.php
│       request_consultation.php
│       save_attendance.php
│       send_notification.php
│       signup.php
│       student.php
│       teacher.php
│       update_attendance.php
│       update_information.php
│
└───view
        contact.html
        english_for_kids.html
        faq.html
        ielts_4.0_5.5.html
        ielts_5.5_6.5.html
        ielts_6.5+.html
        ielts_basic.html
        news.html
        privacy-policy.html
        reference.html
        student_intro.html
        teachter_intro.html
        terms-of-service.html
        toeic_550_650.html
        toeic_650_800.html
        toeic_800+.html
```

## Đóng góp
Chúng tôi hoan nghênh mọi đóng góp để cải thiện hệ thống quản lý trung tâm tiếng Anh KEC. Nếu bạn muốn đóng góp, vui lòng làm theo các bước sau:
1.  Fork repository này.
2.  Tạo một branch mới cho tính năng hoặc sửa lỗi của bạn (`git checkout -b feature/your-feature-name`).
3.  Thực hiện thay đổi và commit (`git commit -m 'Add your commit message'`).
4.  Push branch của bạn lên remote repository (`git push origin feature/your-feature-name`).
5.  Mở một Pull Request.

Vui lòng đảm bảo mã nguồn của bạn tuân thủ các quy tắc định dạng và có các comment rõ ràng nếu cần.

## Liên hệ
Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào về dự án, vui lòng liên hệ:

* **Tác giả:** [Tên của bạn/Biệt danh của bạn]
* **Email:** [Địa chỉ email của bạn]
* **Repository GitHub:** [Liên kết đến repository GitHub của bạn]
* **Issues:** Vui lòng sử dụng mục [Issues](https://github.com/yourusername/KEC-English-Center/issues) trên GitHub để báo cáo lỗi hoặc đề xuất tính năng.

---
