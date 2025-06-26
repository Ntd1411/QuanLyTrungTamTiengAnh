<?php
session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";
include "../model/configadmin.php";

if (((isset($_COOKIE['is_login'])) && $_COOKIE['is_login'] == true) ||
    (isset($_SESSION['role'])  && $_SESSION['role'] == 0)
) {

    $username = isset($_COOKIE['username']) ? $_COOKIE['username'] : $_SESSION['username'];
    if (isset($_POST['action'])) {
        $response = array();

        switch ($_POST['action']) {
            case "addClass":
                if (
                    empty($_POST['className']) || empty($_POST['schoolYear']) ||
                    empty($_POST['teacherId']) || empty($_POST['startDate']) ||
                    empty($_POST['endDate']) || empty($_POST['classTime']) ||
                    empty($_POST['room'])
                ) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                $className = $_POST['className'];
                $classYear = $_POST['schoolYear'];
                $teacher = $_POST['teacherId'];
                $startDate = $_POST['startDate'];
                $endDate = $_POST['endDate'];
                $classTime = $_POST['classTime'];
                $classRoom = $_POST['room'];

                $result = addClass(
                    $className,
                    $classYear,
                    $teacher,
                    $startDate,
                    $endDate,
                    $classTime,
                    $classRoom
                );
                echo json_encode($result);
                exit;
                break;
            case "addTeacher":
                if (
                    empty($_POST['teacherFullName']) || empty($_POST['teacherUsername']) ||
                    empty($_POST['teacherGender']) || empty($_POST['teacherEmail']) ||
                    empty($_POST['teacherPhone']) || empty($_POST['teacherBirthdate'] || empty($_POST['teacherSalary']))
                ) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                $teacherFullName = $_POST['teacherFullName'];
                $teacherUsername = $_POST['teacherUsername'];
                $teacherPassword = empty($_POST['teacherPassword']) ? "123456" : $_POST['teacherPassword'];
                $teacherGender = $_POST['teacherGender'];
                $teacherEmail = $_POST['teacherEmail'];
                $teacherPhone = $_POST['teacherPhone'];
                $teacherBirthdate = $_POST['teacherBirthdate'];
                $teacherSalary = $_POST['teacherSalary'];

                $result = addTeacher(
                    $teacherFullName,
                    $teacherBirthdate,
                    $teacherGender,
                    $teacherUsername,
                    $teacherPassword,
                    $teacherEmail,
                    $teacherPhone,
                    $teacherSalary
                );
                echo json_encode($result);
                exit;
                break;
            case "addStudent":
                if (
                    empty($_POST['studentFullName']) || empty($_POST['studentUsername']) ||
                    empty($_POST['studentGender']) || empty($_POST['studentEmail']) ||
                    empty($_POST['studentPhone']) || empty($_POST['studentDate'])
                ) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                $studentFullName = $_POST['studentFullName'];
                $studentUsername = $_POST['studentUsername'];
                $studentPassword = empty($_POST['studentPassword']) ? "123456" : $_POST['studentPassword'];
                $studentGender = $_POST['studentGender'];
                $studentEmail = $_POST['studentEmail'];
                $studentPhone = $_POST['studentPhone'];
                $studentDate = $_POST['studentDate'];
                $studentClass = $_POST['studentClass'] ?? "Chưa có dữ liệu";
                $studentParentID = $_POST['parentID'] ?? "Chưa có dữ liệu";

                $result = addStudent(
                    $studentFullName,
                    $studentDate,
                    $studentGender,
                    $studentUsername,
                    $studentPassword,
                    $studentEmail,
                    $studentPhone,
                    $studentClass,
                    $studentParentID
                );
                echo json_encode($result);
                exit;
                break;
            case "addParent":
                if (
                    empty($_POST['parentFullName']) || empty($_POST['parentUserName']) ||
                    empty($_POST['parentGender']) || empty($_POST['parentEmail']) ||
                    empty($_POST['parentPhone']) || empty($_POST['parentBirthdate'])
                ) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                $parentFullName = $_POST['parentFullName'];
                $parentUserName = $_POST['parentUserName'];
                $parentPassword = empty($_POST['parentPassword']) ? "123456" : $_POST['parentPassword'];
                $parentGender = $_POST['parentGender'];
                $parentEmail = $_POST['parentEmail'];
                $parentPhone = $_POST['parentPhone'];
                $parentBirthdate = $_POST['parentBirthdate'];
                $parentZalo = $_POST['parentZalo'] ?? "Chưa có dữ liệu";
                $parentUnpaid = $_POST['parentUnpaid'] ?? "0";


                $result = addParent(
                    $parentFullName,
                    $parentBirthdate,
                    $parentGender,
                    $parentUserName,
                    $parentPassword,
                    $parentEmail,
                    $parentPhone,
                    $parentZalo,
                    $parentUnpaid
                );
                echo json_encode($result);
                exit;
                break;
            case "changeAdminPassword":
                if (empty($_POST['currentPassword']) || empty($_POST['newPassword']) || empty($_POST['confirmPassword'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                $result = changeAdminPassword($_POST['currentPassword'], $_POST['newPassword'], $_POST['confirmPassword']);
                echo json_encode($result);
                exit;
                break;




            case "deleteClass":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = deleteClass($_POST['id']);
                echo json_encode($result);
                exit;
                break;
            case "deleteTeacher":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = deleteTeacher($_POST['id']);
                echo json_encode($result);
                exit;
                break;
            case "deleteParent":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = deleteParent($_POST['id']);
                echo json_encode($result);
                exit;
                break;
            case "deleteStudent":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = deleteStudent($_POST['id']);
                echo json_encode($result);
                exit;
                break;

            case "updateClass":
                if (empty($_POST['id']) || empty($_POST['className']) || empty($_POST['teacherId'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }
                $result = updateClass($_POST);
                echo json_encode($result);
                exit;
                break;

            case "updateTeacher":
                if (empty($_POST['id']) || empty($_POST['fullName']) || empty($_POST['email'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }
                $result = updateTeacher($_POST);
                echo json_encode($result);
                exit;
                break;

            case "updateStudent":
                if (empty($_POST['id']) || empty($_POST['fullName']) || empty($_POST['email'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }
                $result = updateStudent($_POST);
                echo json_encode($result);
                exit;
                break;

            case "updateParent":
                if (empty($_POST['id']) || empty($_POST['fullName']) || empty($_POST['email'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }
                $result = updateParent($_POST);
                echo json_encode($result);
                exit;
                break;

            case "sendNotification":
                if (empty($_POST['receiverId']) || empty($_POST['subject']) || empty($_POST['content']) || empty($_POST['sendMethods'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                try {
                    $conn = connectdb();
                    $selectedMethods = json_decode($_POST['sendMethods'], true);
                    if ($selectedMethods == []) {
                        echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                        exit;
                    }


                    // Insert notification into messages table
                    $sql = "INSERT INTO messages (SenderID, ReceiverID, Subject, Content, SendDate, IsRead) 
                            VALUES ('0', :receiverId, :subject, :content, NOW(), 0)";

                    $stmt = $conn->prepare($sql);
                    $result = $stmt->execute([
                        ':receiverId' => $_POST['receiverId'],
                        ':subject' => $_POST['subject'],
                        ':content' => $_POST['content']
                    ]);

                    if ($result) {
                        $successMethods = [];
                        if (!empty($selectedMethods)) {
                            foreach ($selectedMethods as $method) {
                                switch ($method) {
                                    case 'web':
                                        $successMethods[] = 'Website';
                                        break;
                                    case 'zalo':
                                        $successMethods[] = 'Zalo';
                                        break;
                                    case 'gmail':
                                        $successMethods[] = 'Gmail';
                                        break;
                                }
                            }
                        }

                        echo json_encode([
                            'status' => 'success',
                            'message' => 'Thông báo đã được gửi thành công qua ' . implode(', ', $successMethods)
                        ]);
                    } else {
                        echo json_encode([
                            'status' => 'error',
                            'message' => 'Không thể gửi thông báo'
                        ]);
                    }
                } catch (Exception $e) {
                    error_log("Error sending notification: " . $e->getMessage());
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Lỗi hệ thống: ' . $e->getMessage()
                    ]);
                }
                exit;
                break;

            case 'updateNews':
                if (empty($_POST['id']) || empty($_POST['title']) || empty($_POST['content']) || empty($_POST['excerpt'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }

                try {
                    $conn = connectdb();

                    // Nếu có upload ảnh mới
                    if (isset($_FILES['image']) && $_FILES['image']['size'] > 0) {
                        $target_dir = "../assets/img/";
                        $image_name = time() . '_' . basename($_FILES["image"]["name"]);
                        $target_file = $target_dir . $image_name;

                        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
                            // Lấy tên ảnh cũ để xóa
                            $sql = "SELECT image FROM news WHERE id = ?";
                            $stmt = $conn->prepare($sql);
                            $stmt->execute([$_POST['id']]);
                            $old_image = $stmt->fetchColumn();

                            // Cập nhật với ảnh mới
                            $sql = "UPDATE news SET title=?, content=?, excerpt=?, image=?, author=? WHERE id=?";
                            $stmt = $conn->prepare($sql);
                            $result = $stmt->execute([
                                $_POST['title'],
                                $_POST['content'],
                                $_POST['excerpt'],
                                $image_name,
                                $_POST['author'],
                                $_POST['id']
                            ]);

                            // Xóa ảnh cũ
                            if ($result && $old_image && file_exists("../assets/img/" . $old_image)) {
                                unlink("../assets/img/" . $old_image);
                            }
                        } else {
                            echo json_encode(['status' => 'error', 'message' => 'Lỗi upload file']);
                            exit;
                        }
                    } else {
                        // Cập nhật không có ảnh mới
                        $sql = "UPDATE news SET title=?, content=?, excerpt=?, author=? WHERE id=?";
                        $stmt = $conn->prepare($sql);
                        $result = $stmt->execute([
                            $_POST['title'],
                            $_POST['content'],
                            $_POST['excerpt'],
                            $_POST['author'],
                            $_POST['id']
                        ]);
                    }

                    if ($result) {
                        echo json_encode(['status' => 'success', 'message' => 'Cập nhật tin tức thành công']);
                    } else {
                        echo json_encode(['status' => 'error', 'message' => 'Cập nhật tin tức thất bại']);
                    }
                } catch (PDOException $e) {
                    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
                } finally {
                    $conn = null;
                }
                exit;
                break;

            case "deletenews":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID tin tức']);
                    exit;
                }

                try {
                    $conn = connectdb();

                    // Lấy tên file ảnh để xóa
                    $sql = "SELECT image FROM news WHERE id = ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->execute([$_POST['id']]);
                    $image = $stmt->fetchColumn();

                    // Xóa tin tức từ database
                    $sql = "DELETE FROM news WHERE id = ?";
                    $stmt = $conn->prepare($sql);
                    $result = $stmt->execute([$_POST['id']]);

                    if ($result) {
                        // Xóa file ảnh nếu tồn tại
                        if ($image && file_exists("../assets/img/" . $image)) {
                            unlink("../assets/img/" . $image);
                        }
                        echo json_encode(['status' => 'success', 'message' => 'Xóa tin tức thành công']);
                    } else {
                        echo json_encode(['status' => 'error', 'message' => 'Không thể xóa tin tức']);
                    }
                } catch (PDOException $e) {
                    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
                } finally {
                    $conn = null;
                }
                exit;
                break;
            case "addPost":
                $title = $_POST['title'];
                $content = $_POST['content'];
                $excerpt = $_POST['excerpt'];
                $author = $_POST['author'];
                $date = date('Y-m-d');

                $conn = connectdb();

                // Xử lý upload ảnh
                $target_dir = "../assets/img/";
                $image_name = time() . '_' . basename($_FILES["image"]["name"]);
                $target_file = $target_dir . $image_name;

                if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
                    // Thêm tin tức vào database
                    try {
                        $sql = "INSERT INTO news (title, content, excerpt, image, author, date) 
                VALUES (?, ?, ?, ?, ?, ?)";

                        $stmt = $conn->prepare($sql);
                        $result = $stmt->execute([$title, $content, $excerpt, $image_name, $author, $date]);
                        if ($result) {
                            echo json_encode(["status" => "success", "message" => "Đăng ảnh thành công!"]);
                        } else {
                            echo json_encode(["status" => "fail", "message" => "Lỗi: " . $result]);
                        }
                    } catch (PDOException $e) {
                        echo json_encode(["status" => "fail", "message" => "Lỗi: " . $e->getMessage()]);
                    } finally {
                        $conn = null;
                    }
                } else {
                    // echo "Lỗi upload file";
                    echo json_encode(["status" => "fail", "message" => "Lỗi upload file"]);
                }
                exit;
                break;

            case "getNews":
                if (isset($_POST['id'])) {
                    $id = $_POST['id'];

                    try {
                        $conn = connectdb();

                        $sql = 'SELECT * FROM news WHERE id = ?';
                        $stmt = $conn->prepare($sql);
                        $result = $stmt->execute([$id]);

                        if ($result) {
                            $news = $stmt->fetch(PDO::FETCH_ASSOC);
                            echo json_encode(['status' => 'success', 'news' => $news]);
                        } else {
                            echo json_encode(['status' => 'fail', 'message' => 'Không thể lấy thông tin!']);
                        }
                    } catch (PDOException $e) {
                        echo json_encode(['status' => 'fail', 'message' => $e->getMessage()]);
                    } finally {
                        $conn = null;
                    }
                }
                exit;
                break;
            
        }
    }

    // Thêm xử lý GET request để hiển thị dữ liệu ra các bảng
    if (isset($_GET['action'])) {  // Kiểm tra GET parameter
        switch ($_GET['action']) {
            case "getClasses":
                $classes = getDataFromTable("classes");
                if ($classes != []) {
                    foreach ($classes as $class) {
                        $teacher_name = getTeacherName($class['TeacherID']);
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($class['ClassID']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['ClassName']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['SchoolYear']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher_name ?? 'Chưa phân công') . "</td>";
                        echo "<td>" . htmlspecialchars($class['StartDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['EndDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['ClassTime']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['Room']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['Status']) . "</td>";
                        echo "<td>
                        <button onclick='showEditPopup(\"Class\" ," . $class['ClassID'] . ")'>Sửa</button>
                        <button onclick='confirmDelete(\"Class\" ," . $class['ClassID'] . ")'>Xóa</button>
                      </td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='9'>Không có dữ liệu</td></tr>";
                }
                exit;
            case "getTeachers":
                $teachers = getDataFromTable("teachers");
                if ($teachers != []) {
                    foreach ($teachers as $teacher) {
                        $teacherClasses = getTeacherClasses($teacher['UserID']);
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($teacher['UserID']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['FullName']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['Gender']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['Email']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['Phone']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['BirthDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacher['Salary']) . "</td>";
                        echo "<td>" . htmlspecialchars($teacherClasses) . "</td>";
                        echo "<td>
                <button onclick='showEditPopup(\"Teacher\", \"" . $teacher['UserID'] . "\")'>Sửa</button>
                <button onclick='confirmDelete(\"Teacher\", \"" . $teacher['UserID'] . "\")'>Xóa</button>
                </td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='9'>Không có dữ liệu</td></tr>";
                }
                exit;
            case "getStudents":
                $students = getDataFromTable("students");
                if ($students != []) {
                    foreach ($students as $student) {
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($student['UserID']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['FullName']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['Gender']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['Email']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['Phone']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['BirthDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($student['ClassID'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>" . htmlspecialchars($student['ParentID'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>" . htmlspecialchars($student['AttendedClasses'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>" . htmlspecialchars($student['AbsentClasses'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>
                <button onclick='showEditPopup(\"Student\", \"" . $student['UserID'] . "\")'>Sửa</button>
                <button onclick='confirmDelete(\"Student\", \"" . $student['UserID'] . "\")'>Xóa</button>
                </td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='9'>Không có dữ liệu</td></tr>";
                }
                exit;
            case "getParents":
                $parents = getDataFromTable("parents");
                if ($parents != []) {
                    foreach ($parents as $parent) {
                        $parentChild = getChild($parent['UserID']);
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($parent['UserID']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['FullName']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['Gender']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['Email']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['Phone']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['BirthDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['ZaloID'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>" . htmlspecialchars($parentChild) . "</td>";
                        echo "<td>" . htmlspecialchars($parent['UnpaidAmount'] ?? "Chưa có dữ liệu") . "</td>";
                        echo "<td>
                <button onclick='showEditPopup(\"Parent\", \"" . $parent['UserID'] . "\")'>Sửa</button>
                <button onclick='confirmDelete(\"Parent\", \"" . $parent['UserID'] . "\")'>Xóa</button>
                </td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='9'>Không có dữ liệu</td></tr>";
                }
                exit;
            case "loadStatistics":
                if (!isset($_GET['startDate']) || !isset($_GET['endDate'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin ngày thống kê']);
                    exit;
                }
                $startDate = $_GET['startDate'];
                $endDate = $_GET['endDate'];

                if ($startDate > $endDate) {
                    echo json_encode(['status' => 'error', 'message' => 'Ngày bắt đầu không thể sau ngày kết thúc']);
                    exit;
                }

                $result = getStatistics($startDate, $endDate);
                echo json_encode($result);
                exit;
                break;

            case "getMessages":
                try {
                    $conn = connectdb();
                    // Join with teachers, students, and parents tables to get receiver's name
                    $sql = "SELECT m.*, 
                            CASE 
                                WHEN t.FullName IS NOT NULL THEN CONCAT(t.FullName, ' (', m.ReceiverID , ')')
                                WHEN s.FullName IS NOT NULL THEN CONCAT(s.FullName, ' (', m.ReceiverID , ')')
                                WHEN p.FullName IS NOT NULL THEN CONCAT(p.FullName, ' (', m.ReceiverID , ')')
                            END as ReceiverName
                            FROM messages m
                            LEFT JOIN teachers t ON m.ReceiverID = t.UserID
                            LEFT JOIN students s ON m.ReceiverID = s.UserID
                            LEFT JOIN parents p ON m.ReceiverID = p.UserID
                            WHERE m.SenderID = '0'
                            ORDER BY m.SendDate DESC";

                    $stmt = $conn->prepare($sql);
                    $stmt->execute();
                    $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    if ($messages != []) {
                        foreach ($messages as $message) {
                            echo "<tr>";
                            echo "<td>" . htmlspecialchars($message['SendDate']) . "</td>";
                            echo "<td>" . htmlspecialchars($message['ReceiverName']) . "</td>";
                            echo "<td>" . htmlspecialchars($message['Subject']) . "</td>";
                            echo "<td class='message-content'>" . htmlspecialchars($message['Content']) . "</td>";
                            echo "<td>" . htmlspecialchars($message['IsRead'] == 0 ? "Chưa đọc" : "Đã đọc") . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>Không có dữ liệu</td></tr>";
                    }
                } catch (Exception $e) {
                    error_log("Error loading messages: " . $e->getMessage());
                    echo "<tr><td colspan='5'>Lỗi khi tải thông báo</td></tr>";
                }
                exit;
                break;

            case "getClass":
                if (!isset($_GET['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = getClassById($_GET['id']);
                echo json_encode($result);
                exit;
                break;
            case "getTeacher":
                if (!isset($_GET['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = getTeacherById($_GET['id']);
                echo json_encode($result);
                exit;
                break;

            case "getStudent":
                if (!isset($_GET['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = getStudentById($_GET['id']);
                echo json_encode($result);
                exit;
                break;

            case "getParent":
                if (!isset($_GET['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID']);
                    exit;
                }
                $result = getParentById($_GET['id']);
                echo json_encode($result);
                exit;
                break;
            default : 
                echo json_encode(["status" => 'error', 'message' => "Đã có lỗi xảy ra"]);
                exit;
                break;
        }
    }
} else {
    echo "<script>alert('Vui lòng đăng nhập vào tài khoản được cấp quyền admin để xem trang này');</script>";
    echo "<script>window.location.href = './login.php';</script>";
    exit();
}
