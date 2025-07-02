<?php
session_start();
ob_start();

include "../model/config.php";
include "../model/user.php";
include "../model/configadmin.php";
include "../model/sendmail.php";

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
                $classTuition = $_POST['classTuition'] ?? 0;

                // Kiểm tra ngày bắt đầu phải nhỏ hơn ngày kết thúc
                if (strtotime($startDate) >= strtotime($endDate)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày bắt đầu phải nhỏ hơn ngày kết thúc'
                    ]);
                    exit;
                }

                // Validate school year (4 digits and positive)
                if (!preg_match('/^\d{4}$/', $_POST['schoolYear']) || intval($_POST['schoolYear']) <= 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Năm học phải là số dương và có 4 chữ số'
                    ]);
                    exit;
                }

                // Validate tuition (must be positive)
                $classTuition = $_POST['classTuition'] ?? 0;
                if (!is_numeric($classTuition) || floatval($classTuition) < 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Học phí phải là số dương'
                    ]);
                    exit;
                }



                $result = addClass(
                    $className,
                    $classYear,
                    $teacher,
                    $startDate,
                    $endDate,
                    $classTime,
                    $classRoom,
                    $classTuition
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

                // Validate username (chỉ chứa chữ và số)
                if (!preg_match('/^[a-zA-Z0-9]+$/', $_POST['teacherUsername'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Tên đăng nhập chỉ được chứa chữ cái và số'
                    ]);
                    exit;
                }

                // Validate password (6 ký tự)
                $teacherPassword = empty($_POST['teacherPassword']) ? "123456" : $_POST['teacherPassword'];
                if (strlen($teacherPassword) < 6) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Mật khẩu phải có ít nhất 6 ký tự'
                    ]);
                    exit;
                }

                // Validate email
                if (!filter_var($_POST['teacherEmail'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone (chỉ chứa số)
                if (!preg_match('/^[0-9]+$/', $_POST['teacherPhone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate (không lớn hơn ngày hiện tại)
                $birthdate = strtotime($_POST['teacherBirthdate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                // Validate salary (số dương)
                if (!is_numeric($_POST['teacherSalary']) || floatval($_POST['teacherSalary']) <= 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Lương phải là số dương'
                    ]);
                    exit;
                }

                // Kiểm tra username đã tồn tại
                if (isExistUsername($_POST['teacherUsername'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Tên đăng nhập đã tồn tại trong hệ thống!'
                    ]);
                    exit;
                }

                // Kiểm tra email đã tồn tại
                if (isExistEmail($_POST['teacherEmail'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email đã được sử dụng bởi người khác!'
                    ]);
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

                // Validate email format
                if (!filter_var($_POST['studentEmail'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone number (only numbers)
                if (!preg_match('/^[0-9]+$/', $_POST['studentPhone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate (not greater than current date)
                $birthdate = strtotime($_POST['studentDate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                // Validate discount
                $studentDiscount = $_POST['studentDiscount'] ?? 0;
                if (!is_numeric($studentDiscount) || $studentDiscount < 0 || $studentDiscount > 100) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Giảm giá phải là số từ 0 đến 100'
                    ]);
                    exit;
                }

                // Validate password (6 ký tự)
                $studentPassword = empty($_POST['studentPassword']) ? "123456" : $_POST['studentPassword'];
                if (strlen($studentPassword) < 6) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Mật khẩu phải có ít nhất 6 ký tự'
                    ]);
                    exit;
                }

                // Kiểm tra username đã tồn tại
                if (isExistUsername($_POST['studentUsername'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Tên đăng nhập đã tồn tại trong hệ thống!'
                    ]);
                    exit;
                }

                // Kiểm tra email đã tồn tại
                if (isExistEmail($_POST['studentEmail'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email đã được sử dụng bởi người khác!'
                    ]);
                    exit;
                }

                $studentFullName = $_POST['studentFullName'];
                $studentUsername = $_POST['studentUsername'];
                $studentPassword = empty($_POST['studentPassword']) ? "123456" : $_POST['studentPassword'];
                $studentGender = $_POST['studentGender'];
                $studentEmail = $_POST['studentEmail'];
                $studentPhone = $_POST['studentPhone'];
                $studentDate = $_POST['studentDate'];
                $studentClass = $_POST['studentClass'] ?? null;
                $parentIds = $_POST['parentID'] ?? [];

                $result = addStudent(
                    $studentFullName,
                    $studentDate,
                    $studentGender,
                    $studentUsername,
                    $studentPassword,
                    $studentEmail,
                    $studentPhone,
                    $studentClass,
                    $parentIds,
                    $studentDiscount
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

                // Validate password length (minimum 6 characters)
                $parentPassword = empty($_POST['parentPassword']) ? "123456" : $_POST['parentPassword'];
                if (strlen($parentPassword) < 6) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Mật khẩu phải có ít nhất 6 ký tự'
                    ]);
                    exit;
                }

                // Validate email format
                if (!filter_var($_POST['parentEmail'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone number (numbers only)
                if (!preg_match('/^[0-9]+$/', $_POST['parentPhone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate (not greater than current date)  
                $birthdate = strtotime($_POST['parentBirthdate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                // Kiểm tra username đã tồn tại
                if (isExistUsername($_POST['parentUserName'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Tên đăng nhập đã tồn tại trong hệ thống!'
                    ]);
                    exit;
                }

                // Kiểm tra email đã tồn tại
                if (isExistEmail($_POST['parentEmail'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email đã được sử dụng bởi người khác!'
                    ]);
                    exit;
                }

                $parentFullName = $_POST['parentFullName'];
                $parentUserName = $_POST['parentUserName'];
                $parentPassword = empty($_POST['parentPassword']) ? "123456" : $_POST['parentPassword'];
                $parentGender = $_POST['parentGender'];
                $parentEmail = $_POST['parentEmail'];
                $parentPhone = $_POST['parentPhone'];
                $parentBirthdate = $_POST['parentBirthdate'];
                $parentZalo = $_POST['parentZalo'] ?? null;
                $isShowTeacher = isset($_POST['isShowTeacher']) ? $_POST['isShowTeacher'] : 0;


                $result = addParent(
                    $parentFullName,
                    $parentBirthdate,
                    $parentGender,
                    $parentUserName,
                    $parentPassword,
                    $parentEmail,
                    $parentPhone,
                    $parentZalo,
                    $isShowTeacher
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
            case "deleteMessage":
                if (!isset($_POST['id'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID thông báo']);
                    exit;
                }

                try {
                    $conn = connectdb();
                    $sql = "DELETE FROM messages WHERE MessageID = ? AND SenderID = '0'";
                    $stmt = $conn->prepare($sql);
                    $result = $stmt->execute([$_POST['id']]);

                    if ($result) {
                        echo json_encode(['status' => 'success', 'message' => 'Xóa thông báo thành công']);
                    } else {
                        echo json_encode(['status' => 'error', 'message' => 'Không thể xóa thông báo']);
                    }
                } catch (PDOException $e) {
                    echo json_encode(['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()]);
                } finally {
                    $conn = null;
                }
                exit;
                break;

            case "updateClass":
                if (empty($_POST['id']) || empty($_POST['className']) || empty($_POST['teacherId'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Thiếu thông tin cần thiết']);
                    exit;
                }

                // Validate school year (4 digits and positive)
                if (!preg_match('/^\d{4}$/', $_POST['schoolYear']) || intval($_POST['schoolYear']) <= 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Năm học phải là số dương và có 4 chữ số'
                    ]);
                    exit;
                }

                // Validate dates
                if (strtotime($_POST['startDate']) >= strtotime($_POST['endDate'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày bắt đầu phải nhỏ hơn ngày kết thúc'
                    ]);
                    exit;
                }

                // Validate tuition
                if (!is_numeric($_POST['classTuition']) || floatval($_POST['classTuition']) < 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Học phí phải là số dương'
                    ]);
                    exit;
                }

                $result = updateClass($_POST);
                echo json_encode($result);
                exit;
                break;

            case "updateTeacher":
                // Validate required fields
                if (
                    empty($_POST['id']) || empty($_POST['fullName']) || empty($_POST['email']) ||
                    empty($_POST['gender']) || empty($_POST['phone']) || empty($_POST['birthDate']) ||
                    !isset($_POST['salary'])
                ) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }
                // Validate email format
                if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone number (only numbers)
                if (!preg_match('/^[0-9]+$/', $_POST['phone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate (not greater than current date)
                $birthdate = strtotime($_POST['birthDate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                // Validate salary (must be positive number)
                if (!is_numeric($_POST['salary']) || floatval($_POST['salary']) < 0) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Lương phải là số dương'
                    ]);
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

                // Validate email format
                if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone number (only numbers)
                if (!preg_match('/^[0-9]+$/', $_POST['phone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate
                $birthdate = strtotime($_POST['birthDate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                // Validate discount
                if (
                    !is_numeric($_POST['studentDiscount']) ||
                    $_POST['studentDiscount'] < 0 ||
                    $_POST['studentDiscount'] > 100
                ) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Giảm giá phải là số từ 0 đến 100'
                    ]);
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

                // Validate email format
                if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Email không đúng định dạng'
                    ]);
                    exit;
                }

                // Validate phone number
                if (!preg_match('/^[0-9]+$/', $_POST['phone'])) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Số điện thoại chỉ được chứa số'
                    ]);
                    exit;
                }

                // Validate birthdate
                $birthdate = strtotime($_POST['birthDate']);
                $today = strtotime(date('Y-m-d'));
                if ($birthdate > $today) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => 'Ngày sinh không thể lớn hơn ngày hiện tại'
                    ]);
                    exit;
                }

                $result = updateParent($_POST);
                echo json_encode($result);
                exit;
                break;

            case "updateAd":
                try {
                    $id = $_POST['id'];
                    $startDate = $_POST['start_date'];
                    $endDate = $_POST['end_date'];
                    $status = $_POST['status'];

                    if (strtotime($startDate) > strtotime($endDate)) {
                        throw new Exception('Ngày bắt đầu không thể sau ngày kết thúc');
                    }

                    $conn = connectdb();

                    // Check for overlapping active ads (excluding current ad)
                    if ($status === 'active') {
                        $checkSql = "SELECT COUNT(*) FROM advertisements 
                           WHERE status = 'active'
                           AND id != :id
                           AND (
                               (start_date <= :startDate AND end_date >= :startDate)
                               OR 
                               (start_date <= :endDate AND end_date >= :endDate)
                               OR
                               (start_date >= :startDate AND end_date <= :endDate)
                           )";

                        $checkStmt = $conn->prepare($checkSql);
                        $checkStmt->execute([
                            ':id' => $id,
                            ':startDate' => $startDate,
                            ':endDate' => $endDate
                        ]);

                        if ($checkStmt->fetchColumn() > 0) {
                            throw new Exception('Đã có quảng cáo hoạt động trong khoảng thời gian này');
                        }
                    }

                    $params = [
                        ':id' => $id,
                        ':subject' => $_POST['subject'],
                        ':content' => $_POST['content'],
                        ':start_date' => $startDate,
                        ':end_date' => $endDate,
                        ':status' => $status
                    ];

                    $sql = "UPDATE advertisements SET 
                    subject = :subject,
                    content = :content, 
                    start_date = :start_date,
                    end_date = :end_date,
                    status = :status";

                    // Handle image update if new image is uploaded
                    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
                        // Validate and save new image
                        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
                        $fileType = $_FILES['image']['type'];
                        if (!in_array($fileType, $allowedTypes)) {
                            throw new Exception('Chỉ chấp nhận file hình ảnh (JPG, PNG, GIF)');
                        }

                        if ($_FILES['image']['size'] > 20 * 1024 * 1024) {
                            throw new Exception('Kích thước file không được vượt quá 20MB');
                        }

                        $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
                        $filename = uniqid('ad_') . '.' . $ext;
                        $uploadPath = '../assets/img/' . $filename;

                        if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
                            $sql .= ", image = :image";
                            $params[':image'] = $filename;
                        }
                    }

                    $sql .= " WHERE id = :id";
                    $stmt = $conn->prepare($sql);
                    $result = $stmt->execute($params);

                    if ($result) {
                        echo json_encode([
                            'status' => 'success',
                            'message' => 'Cập nhật quảng cáo thành công'
                        ]);
                        exit;
                    } else {
                        throw new Exception('Không thể cập nhật quảng cáo');
                    }
                } catch (Exception $e) {
                    echo json_encode([
                        'status' => 'error',
                        'message' => $e->getMessage()
                    ]);
                    exit;
                }

            case "sendNotification":
                if (empty($_POST['recipientType']) || empty($_POST['subject']) || empty($_POST['content'])) {
                    echo json_encode(['status' => 'error', 'message' => 'Vui lòng điền đầy đủ thông tin']);
                    exit;
                }

                try {
                    $conn = connectdb();
                    $selectedMethods = isset($_POST['sendMethods']) ? json_decode($_POST['sendMethods'], true) : [];
                    $sendEmail = in_array('email', $selectedMethods);
                    $recipientType = $_POST['recipientType'];
                    $subject = $_POST['subject'];
                    $content = $_POST['content'];

                    // Get recipients based on type
                    $recipients = [];

                    switch ($recipientType) {
                        case 'individual':
                            if (empty($_POST['receiverId'])) {
                                echo json_encode(['status' => 'error', 'message' => 'Vui lòng chọn người nhận']);
                                exit;
                            }
                            $recipients[] = $_POST['receiverId'];
                            break;

                        case 'multiple':
                            $receiverIds = json_decode($_POST['receiverIds'], true);
                            if (empty($receiverIds)) {
                                echo json_encode(['status' => 'error', 'message' => 'Vui lòng chọn người nhận']);
                                exit;
                            }
                            $recipients = $receiverIds;
                            break;

                        case 'class':
                            if (empty($_POST['classId'])) {
                                echo json_encode(['status' => 'error', 'message' => 'Vui lòng chọn lớp']);
                                exit;
                            }
                            $classId = $_POST['classId'];
                            $classRecipientTypes = json_decode($_POST['classRecipientTypes'], true);

                            if (empty($classRecipientTypes)) {
                                echo json_encode(['status' => 'error', 'message' => 'Vui lòng chọn loại người nhận']);
                                exit;
                            }

                            // Get recipients from class
                            if (in_array('students', $classRecipientTypes)) {
                                $sql = "SELECT UserID FROM students WHERE ClassID = :classId";
                                $stmt = $conn->prepare($sql);
                                $stmt->execute([':classId' => $classId]);
                                $students = $stmt->fetchAll(PDO::FETCH_COLUMN);
                                $recipients = array_merge($recipients, $students);
                            }

                            if (in_array('parents', $classRecipientTypes)) {
                                $sql = "SELECT DISTINCT spk.parent_id FROM student_parent_keys spk 
                                       JOIN students s ON spk.student_id = s.UserID 
                                       WHERE s.ClassID = :classId";
                                $stmt = $conn->prepare($sql);
                                $stmt->execute([':classId' => $classId]);
                                $parents = $stmt->fetchAll(PDO::FETCH_COLUMN);
                                $recipients = array_merge($recipients, $parents);
                            }

                            if (in_array('teacher', $classRecipientTypes)) {
                                $sql = "SELECT TeacherID FROM classes WHERE ClassID = :classId";
                                $stmt = $conn->prepare($sql);
                                $stmt->execute([':classId' => $classId]);
                                $teacher = $stmt->fetchColumn();
                                if ($teacher) {
                                    $recipients[] = $teacher;
                                }
                            }
                            break;

                        case 'all-teachers':
                            $sql = "SELECT UserID FROM teachers";
                            $stmt = $conn->prepare($sql);
                            $stmt->execute();
                            $recipients = $stmt->fetchAll(PDO::FETCH_COLUMN);
                            break;

                        case 'all-parents':
                            $sql = "SELECT UserID FROM parents";
                            $stmt = $conn->prepare($sql);
                            $stmt->execute();
                            $recipients = $stmt->fetchAll(PDO::FETCH_COLUMN);
                            break;

                        case 'all-students':
                            $sql = "SELECT UserID FROM students";
                            $stmt = $conn->prepare($sql);
                            $stmt->execute();
                            $recipients = $stmt->fetchAll(PDO::FETCH_COLUMN);
                            break;

                        case 'all-everyone':
                            $sql = "SELECT UserID FROM teachers UNION SELECT UserID FROM students UNION SELECT UserID FROM parents";
                            $stmt = $conn->prepare($sql);
                            $stmt->execute();
                            $recipients = $stmt->fetchAll(PDO::FETCH_COLUMN);
                            break;

                        default:
                            echo json_encode(['status' => 'error', 'message' => 'Loại người nhận không hợp lệ']);
                            exit;
                    }

                    if (empty($recipients)) {
                        echo json_encode(['status' => 'error', 'message' => 'Không tìm thấy người nhận']);
                        exit;
                    }

                    $successCount = 0;
                    $errorCount = 0;
                    $emailErrors = [];

                    // Process each recipient
                    foreach ($recipients as $recipientId) {
                        try {
                            // Get recipient's email if email sending is enabled
                            $recipientEmail = null;
                            if ($sendEmail) {
                                $sql = "SELECT Email FROM teachers WHERE UserID = :recipientId
                                       UNION
                                       SELECT Email FROM students WHERE UserID = :recipientId  
                                       UNION
                                       SELECT Email FROM parents WHERE UserID = :recipientId";
                                $stmt = $conn->prepare($sql);
                                $stmt->execute([':recipientId' => $recipientId]);
                                $recipientEmail = $stmt->fetchColumn();
                            }

                            // Send email if requested and email exists
                            $emailSent = ['status' => 'success'];
                            if ($sendEmail && $recipientEmail) {
                                $emailSent = sendEmail($recipientEmail, $subject, $content);
                                if ($emailSent['status'] === 'fail') {
                                    $emailErrors[] = "Email to $recipientEmail: " . $emailSent['message'];
                                }
                            }

                            // Save to database (save even if email fails for record keeping)
                            $sql = "INSERT INTO messages (SenderID, ReceiverID, Subject, Content, SendDate, IsRead) 
                                    VALUES ('0', :receiverId, :subject, :content, NOW(), 0)";

                            $stmt = $conn->prepare($sql);
                            $result = $stmt->execute([
                                ':receiverId' => $recipientId,
                                ':subject' => $subject,
                                ':content' => $content
                            ]);

                            if ($result) {
                                $successCount++;
                            } else {
                                $errorCount++;
                            }
                        } catch (Exception $e) {
                            $errorCount++;
                            error_log("Error sending to recipient $recipientId: " . $e->getMessage());
                        }
                    }

                    // Prepare response message
                    $message = "✅ Đã gửi thành công cho $successCount người";
                    if ($errorCount > 0) {
                        $message .= ", thất bại $errorCount người";
                    }

                    if ($sendEmail) {
                        if (empty($emailErrors)) {
                            $message .= " (bao gồm cả email)";
                        } else {
                            $message .= ". Một số email gửi thất bại: " . implode('; ', array_slice($emailErrors, 0, 3));
                            if (count($emailErrors) > 3) {
                                $message .= "...";
                            }
                        }
                    }

                    echo json_encode([
                        'status' => 'success',
                        'message' => $message
                    ]);
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
            case "toggleConsulted":
                $id = $_POST['id'] ?? 0;
                $status = $_POST['status'] ?? 'Chưa tư vấn';
                $conn = connectdb();
                $stmt = $conn->prepare("UPDATE consulting SET status = ? WHERE id = ?");
                $success = $stmt->execute([$status, $id]);
                echo json_encode(['success' => $success]);
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
                        echo "<td>" . htmlspecialchars($teacher_name ?? 'Chưa phân công') . " (" . $class['TeacherID'] . ")" . "</td>";
                        echo "<td>" . htmlspecialchars($class['StartDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['EndDate']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['ClassTime']) . "</td>";
                        echo "<td>" . htmlspecialchars($class['Room']) . "</td>";
                        echo "<td>" . number_format($class['Tuition'], 0, ',', '.') . " VNĐ</td>";
                        echo "<td>" . htmlspecialchars($class['Status']) . "</td>";
                        echo "<td>
                        <button onclick='showEditPopup(\"Class\" ," . $class['ClassID'] . ")'><i class=\"fa-solid fa-pencil\"></i></button>
                        <button onclick='confirmDelete(\"Class\" ," . $class['ClassID'] . ")'><i class=\"fa-regular fa-trash-can\"></i></button>
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
                        echo "<td>" . number_format($teacher['Salary'], 0, ',', '.') . " VNĐ</td>";
                        echo "<td>" . htmlspecialchars($teacherClasses) . "</td>";
                        echo "<td>
                <button onclick='showEditPopup(\"Teacher\", \"" . $teacher['UserID'] . "\")'><i class=\"fa-solid fa-pencil\"></i></button>
                <button onclick='confirmDelete(\"Teacher\", \"" . $teacher['UserID'] . "\")'><i class=\"fa-regular fa-trash-can\"></i></button>
                </td>";
                        echo "</tr>";
                    }
                } else {
                    echo "<tr><td colspan='9'>Không có dữ liệu</td></tr>";
                }
                exit;
            case "getStudents":
                try {
                    $conn = connectdb();
                    // Get students with their info including tuition discount
                    $sql = "SELECT s.*, c.ClassName, c.SchoolYear,
                           GROUP_CONCAT(DISTINCT spk.parent_id SEPARATOR ', ') as Parents,
                           t.Discount as TuitionDiscount
                           FROM students s
                           LEFT JOIN classes c ON s.ClassID = c.ClassID
                           LEFT JOIN student_parent_keys spk ON s.UserID = spk.student_id
                           LEFT JOIN tuition t ON s.UserID = t.StudentID AND t.Status = 'Chưa đóng'
                           GROUP BY s.UserID";

                    $stmt = $conn->prepare($sql);
                    $stmt->execute();
                    $students = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    if ($students) {
                        foreach ($students as $student) {
                            echo "<tr>";
                            echo "<td>" . htmlspecialchars($student['UserID']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['FullName']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['Gender']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['Email']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['Phone']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['BirthDate']) . "</td>";
                            echo "<td>" . htmlspecialchars($student['ClassName']) . " (" . $student['SchoolYear'] . ")" . "</td>";
                            echo "<td>" . htmlspecialchars($student['Parents'] ?? "Chưa có phụ huynh") . "</td>";
                            echo "<td>" . htmlspecialchars($student['AttendedClasses'] ?? "0") . "</td>";
                            echo "<td>" . htmlspecialchars($student['AbsentClasses'] ?? "0") . "</td>";
                            echo "<td>" . htmlspecialchars($student['TuitionDiscount'] ? $student['TuitionDiscount'] . '%' : '0%') . "</td>";
                            echo "<td>
                                <button onclick='showEditPopup(\"Student\", \"" . $student['UserID'] . "\")'><i class=\"fa-solid fa-pencil\"></i></button>
                                <button onclick='confirmDelete(\"Student\", \"" . $student['UserID'] . "\")'><i class=\"fa-regular fa-trash-can\"></i></button>
                                </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='11'>Không có dữ liệu</td></tr>";
                    }
                } catch (PDOException $e) {
                    error_log("Error in getStudents: " . $e->getMessage());
                    echo "<tr><td colspan='11'>Lỗi khi tải dữ liệu</td></tr>";
                }
                exit;
            case "getParents":
                try {
                    $conn = connectdb();
                    $sql = "SELECT p.*, 
                            GROUP_CONCAT(DISTINCT s.UserID SEPARATOR ', ') as Children,
                            COALESCE(SUM(CASE 
                                WHEN t.Status = 'Chưa đóng' THEN t.Amount * (1 - t.Discount/100)
                                ELSE 0 
                            END), 0) as UnpaidAmount
                            FROM parents p
                            LEFT JOIN student_parent_keys spk ON p.UserID = spk.parent_id
                            LEFT JOIN students s ON spk.student_id = s.UserID
                            LEFT JOIN tuition t ON s.UserID = t.StudentID
                            GROUP BY p.UserID";

                    $stmt = $conn->prepare($sql);
                    $stmt->execute();
                    $parents = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    if ($parents) {
                        foreach ($parents as $parent) {
                            echo "<tr>";
                            echo "<td>" . htmlspecialchars($parent['UserID']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['FullName']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['Gender']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['Email']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['Phone']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['BirthDate']) . "</td>";
                            echo "<td>" . htmlspecialchars($parent['ZaloID'] ?? "Chưa có") . "</td>";
                            echo "<td>" . htmlspecialchars($parent['Children'] ?? "Chưa có con") . "</td>";
                            echo "<td>" . number_format($parent['UnpaidAmount'], 0, ',', '.') . " VNĐ" . "</td>";
                            echo "<td>" . ($parent['isShowTeacher'] ? 'Có' : 'Không') . "</td>";
                            echo "<td>
                                <button onclick='showEditPopup(\"Parent\", \"" . $parent['UserID'] . "\")'><i class=\"fa-solid fa-pencil\"></i></button>
                                <button onclick='confirmDelete(\"Parent\", \"" . $parent['UserID'] . "\")'><i class=\"fa-regular fa-trash-can\"></i></button>
                                </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='10'>Không có dữ liệu</td></tr>";
                    }
                } catch (PDOException $e) {
                    error_log("Error in getParents: " . $e->getMessage());
                    echo "<tr><td colspan='10'>Lỗi khi tải dữ liệu</td></tr>";
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
                            echo "<td>
                                <button class='btn-delete' onclick='confirmDelete(\"Message\", \"" . $message['MessageID'] . "\")' title='Xóa thông báo'>
                                    <i class=\"fa-regular fa-trash-can\"></i>
                                </button>
                                </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6'>Không có dữ liệu</td></tr>";
                    }
                } catch (Exception $e) {
                    error_log("Error loading messages: " . $e->getMessage());
                    echo "<tr><td colspan='6'>Lỗi khi tải thông báo</td></tr>";
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
            case "getConsultingList":
                $conn = connectdb();
                $stmt = $conn->prepare("SELECT * FROM consulting ORDER BY created_at DESC");
                $stmt->execute();
                $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
                foreach ($rows as $row) {
                    $checked = $row['status'] === 'Đã tư vấn' ? 'checked' : '';
                    $btn = "<input type='checkbox' class='consulted-checkbox' data-id='{$row['id']}' {$checked} title='Đánh dấu đã tư vấn'>";
                    echo "<tr>
                        <td>" . htmlspecialchars($row['fullname']) . "</td>
                        <td>" . htmlspecialchars($row['birthyear']) . "</td>
                        <td>" . htmlspecialchars($row['phone']) . "</td>
                        <td>" . htmlspecialchars($row['email']) . "</td>
                        <td>" . htmlspecialchars($row['course']) . "</td>
                        <td>" . htmlspecialchars($row['message']) . "</td>
                        <td>" . htmlspecialchars($row['created_at']) . "</td>
                        <td>{$btn}</td>
                    </tr>";
                }
                exit;
                break;

            case "getAllAds":
                try {
                    $conn = connectdb();
                    $sql = "SELECT * FROM advertisements ORDER BY created_at DESC";
                    $stmt = $conn->prepare($sql);
                    $stmt->execute();

                    $ads = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    echo json_encode([
                        "status" => "success",
                        "ads" => $ads
                    ]);
                    exit;
                } catch (PDOException $e) {
                    echo json_encode([
                        "status" => "error",
                        "message" => "Lỗi truy vấn: " . $e->getMessage()
                    ]);
                }
                exit;
                break;
            default:
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
