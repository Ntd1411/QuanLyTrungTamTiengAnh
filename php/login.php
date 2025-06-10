<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

// Initialize the session
session_start();

// Debug POST data
error_log("Raw POST data: " . file_get_contents('php://input'));
error_log("$_POST contents: " . print_r($_POST, true));

// Include config file
require_once "config.php";

// Check database connection
if (!$conn) {
    error_log("Database connection failed");
    die(json_encode(['success' => false, 'error' => 'Lỗi kết nối database']));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validate POST data
    if (!isset($_POST['username']) || !isset($_POST['password'])) {
        error_log("Missing username or password");
        die(json_encode(['success' => false, 'error' => 'Thiếu thông tin đăng nhập']));
    }

    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = $_POST['password'];

    // Debug query
    error_log("Attempting login for username: " . $username);
    
    // SQL query based on user tables
    $sql = "SELECT id, username, password, role FROM users WHERE username = ?";
    
    if ($stmt = mysqli_prepare($conn, $sql)) {
        mysqli_stmt_bind_param($stmt, "s", $username);
        
        if (!mysqli_stmt_execute($stmt)) {
            error_log("Query execution failed: " . mysqli_error($conn));
            die(json_encode(['success' => false, 'error' => 'Lỗi truy vấn database']));
        }

        mysqli_stmt_store_result($stmt);
        
        if (mysqli_stmt_num_rows($stmt) == 1) {
            mysqli_stmt_bind_result($stmt, $id, $username, $hashed_password, $role);
            
            if (mysqli_stmt_fetch($stmt)) {
                if (password_verify($password, $hashed_password)) {
                    // Store data in session variables
                    $_SESSION["loggedin"] = true;
                    $_SESSION["id"] = $id;
                    $_SESSION["username"] = $username;
                    $_SESSION["role"] = $role;
                    
                    // Return success response with redirect URL
                    $redirect_url = '';
                    switch($role) {
                        case "admin":
                            $redirect_url = '../view/admin.html';
                            break;
                        case "teacher": 
                            $redirect_url = '../view/teacher.html';
                            break;
                        case "student":
                            $redirect_url = '../view/student.html';
                            break;
                        case "parent":
                            $redirect_url = '../view/parent.html';
                            break;
                        default:
                            $redirect_url = '../view/index.html';
                            break;
                    }
                    echo json_encode([
                        'success' => true,
                        'redirect' => $redirect_url,
                        'role' => $role
                    ]);
                    exit;
                } else {
                    $login_err = "Sai tên đăng nhập hoặc mật khẩu.";
                }
            }
        } else {
            $login_err = "Sai tên đăng nhập hoặc mật khẩu.";
        }
    } else {
        error_log("Query preparation failed: " . mysqli_error($conn));
        die(json_encode(['success' => false, 'error' => 'Lỗi chuẩn bị truy vấn']));
    }
    
    mysqli_close($conn);
} else {
    die(json_encode(['success' => false, 'error' => 'Phương thức không hợp lệ']));
}
?>