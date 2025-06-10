<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "quanlytrungtamtienganh";
global $conn;

// Attempt to connect to MySQL database
$conn = mysqli_connect($servername, $username, $password, $database);

// Check connection
if($conn === false){
    die("ERROR: Could not connect. " . mysqli_connect_error());
}

mysqli_select_db($conn, $database);
?>
