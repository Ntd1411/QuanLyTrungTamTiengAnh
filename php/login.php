<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

// Initialize the session
session_start();

// Proper debug logging
$postData = file_get_contents('php://input');
error_log("Raw POST data: " . $postData);
error_log("POST contents: " . json_encode($_POST));

// Include config file
require_once "config.php";

// Check database connection
if (!$conn) {
    error_log("Database connection failed: " . mysqli_connect_error());
    die(json_encode(['success' => false, 'error' => 'Lỗi kết nối database']));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validate POST data
    if (empty($_POST['username']) || empty($_POST['password'])) {
        die(json_encode(['success' => false, 'error' => 'Thiếu thông tin đăng nhập']));
    }

    $username = mysqli_real_escape_string($conn, trim($_POST['username']));
    $password = trim($_POST['password']);
    
    // Check in each table
    $tables = ['admin', 'teachers', 'students', 'parents'];
    $found = false;
    
    foreach ($tables as $table) {
        $sql = "SELECT * FROM $table WHERE Username = ?";
        if ($stmt = mysqli_prepare($conn, $sql)) {
            mysqli_stmt_bind_param($stmt, "s", $username);
            
            if (mysqli_stmt_execute($stmt)) {
                $result = mysqli_stmt_get_result($stmt);
                
                if ($row = mysqli_fetch_assoc($result)) {
                    // Use password_verify instead of direct comparison
                    if (password_verify($password, $row['Password'])) {
                        $_SESSION["loggedin"] = true;
                        $_SESSION["id"] = $row[ucfirst($table) . 'ID'];
                        $_SESSION["username"] = $row['Username'];
                        $_SESSION["role"] = rtrim($table, 's');
                        
                        $redirect_url = "../view/" . rtrim($table, 's') . ".html";
                        
                        error_log("Login successful for user: " . $username . " in table: " . $table);

                        header("Location: ../view/admin.html");
                        
                        echo json_encode([
                            'success' => true,
                            'redirect' => $redirect_url,
                            'role' => rtrim($table, 's')
                        ]);
                        
                        mysqli_stmt_close($stmt);
                        mysqli_close($conn);
                        exit;
                    }
                    error_log("Password verification failed for user: " . $username . " in table: " . $table);
                    $found = true;
                    break;
                }
            }
            mysqli_stmt_close($stmt);
        }
    }
    
    mysqli_close($conn);
    
    if ($found) {
        echo json_encode(['success' => false, 'error' => 'Sai mật khẩu']);
    } else {
        echo json_encode(['success' => false, 'error' => 'Tài khoản không tồn tại']);
    }
    exit;
} else {
    die(json_encode(['success' => false, 'error' => 'Phương thức không hợp lệ']));
}
?>