<?php
function getRole($username, $password)
{
    $conn = connectdb();
    try {
        $sql = "SELECT * FROM users WHERE Username = ?";
        $stmt = $conn->prepare($sql);
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        $conn = null;
        if ($user && password_verify($password, $user['Password'])) {

            return $user['Role'];
        }
        return -1;
    } catch (PDOException $e) {
        error_log("Login error: " . $e->getMessage());
        return -1;
    }
}

function isExistUsername($username){
    $conn = connectdb();
    $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE Username = ?");
    $stmt->execute([$username]);
    $result = $stmt->fetchColumn();
    $conn = null;
    return $result > 0;
}


function addStudentOrParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $role)
{
    $conn = connectdb();
    $password_hashed = password_hash($password, PASSWORD_DEFAULT);
    if ($role == 2) {
        $stmt = $conn->prepare("CALL AddNewStudent(
            '" . $username . "', '" . $password_hashed . "', '" . $fullname . "', '" . $gender . "',
            '" . $email . "', '" . $phone . "', '" . $birthdate . "' )");
        $stmt->execute();
    } else if ($role == 3) {
        $stmt = $conn->prepare("CALL AddNewParent(
            '" . $username . "', '" . $password_hashed . "', '" . $fullname . "', '" . $gender . "',
            '" . $email . "', '" . $phone . "', '" . $birthdate . "' )");
        $stmt->execute();
    } else {
        echo "Có lỗi xảy ra!";
    }

    $conn = null;
}

