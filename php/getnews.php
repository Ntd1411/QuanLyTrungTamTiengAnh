
<?php
require_once '../model/config.php';
$conn = connectdb();

try {
    // Chuẩn bị và thực thi câu truy vấn
    $sql = "SELECT * FROM news ORDER BY date DESC";
    $stmt = $conn->prepare($sql);
    $stmt->execute();

    // Lấy tất cả kết quả
    $news = $stmt->fetchAll();

    // Định dạng lại dữ liệu trước khi trả về
    $formattedNews = array_map(function ($item) {
        return array(
            'id' => $item['id'],
            'title' => htmlspecialchars($item['title']),
            'content' => htmlspecialchars($item['content']),
            'excerpt' => htmlspecialchars($item['excerpt']),
            'image' => htmlspecialchars($item['image']),
            'author' => htmlspecialchars($item['author']),
            'date' => date('d/m/Y', strtotime($item['date']))
        );
    }, $news);

    // Trả về dữ liệu dạng JSON
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($formattedNews, JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    // Xử lý lỗi
    header('HTTP/1.1 500 Internal Server Error');
    echo json_encode(array('error' => 'Database error: ' . $e->getMessage()));
} catch (Exception $e) {
    // Xử lý các lỗi khác
    header('HTTP/1.1 500 Internal Server Error');
    echo json_encode(array('error' => 'Server error: ' . $e->getMessage()));
} finally {
    // Đóng kết nối
    $conn = null;
}
?>