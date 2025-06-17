<?php
session_start();

// Xóa tất cả session
session_unset();
session_destroy();

// Xóa cookies
setcookie('is_login', '', time() - 3600, '/');
setcookie('username', '', time() - 3600, '/'); 
setcookie('role', '', time() - 3600, '/');

// Chuyển hướng về trang chủ
header("Location: ../index.html");
exit();
?>