// Hàm này sẽ được gọi khi Google Maps API được tải xong
function initMap() {
    // Tọa độ trung tâm của bản đồ (ví dụ: Hà Nội)
    const hanoi = { lat: 21.0278, lng: 105.8342 };

    // Tạo bản đồ
    const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 14, // Mức độ phóng to ban đầu
        center: hanoi, // Trung tâm bản đồ
    });

    // Thêm marker (điểm đánh dấu) vào bản đồ
    const marker = new google.maps.Marker({
        position: hanoi, // Vị trí của marker
        map: map, // Bản đồ mà marker sẽ hiển thị
        title: "Văn phòng của chúng tôi tại Hà Nội", // Tiêu đề khi di chuột qua marker
    });

    // Thêm cửa sổ thông tin (InfoWindow) khi click vào marker
    const infoWindow = new google.maps.InfoWindow({
        content: "<h3>Văn phòng chính</h3><p>Số 1, Phố ABC, Quận XYZ, Hà Nội</p><p>Giờ làm việc: 8:00 - 17:00</p>",
    });

    marker.addListener("click", () => {
        infoWindow.open(map, marker);
    });
}

// Xử lý gửi form liên hệ
document.addEventListener("DOMContentLoaded", () => {
    const contactForm = document.getElementById("contactForm");

    contactForm.addEventListener("submit", function(event) {
        event.preventDefault(); // Ngăn chặn hành vi gửi form mặc định

        const name = document.getElementById("name").value;
        const email = document.getElementById("email").value;
        const message = document.getElementById("message").value;

        // Đây là nơi bạn sẽ xử lý dữ liệu form.
        // Ví dụ: gửi dữ liệu này đến một API backend hoặc hiển thị thông báo.
        console.log("Dữ liệu form đã gửi:");
        console.log("Họ và tên:", name);
        console.log("Email:", email);
        console.log("Nội dung:", message);

        alert("Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.");

        // Có thể reset form sau khi gửi thành công
        contactForm.reset();
    });
});