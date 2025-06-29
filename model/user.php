<?php
function getRole($usernameOrEmail, $password)
{
    $conn = connectdb();
    try {
        // Tìm user theo username hoặc email (trong bảng users hoặc liên kết với các bảng teachers, students, parents)
        $sql = "SELECT u.UserID, u.Username, u.Password, u.Role
                FROM users u
                LEFT JOIN teachers t ON u.UserID = t.UserID
                LEFT JOIN students s ON u.UserID = s.UserID
                LEFT JOIN parents p ON u.UserID = p.UserID
                WHERE u.Username = :input
                   OR t.Email = :input
                   OR s.Email = :input
                   OR p.Email = :input
                LIMIT 1";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':input' => $usernameOrEmail]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['Password'])) {
            return $user['Role'];
        }
        return -1;
    } catch (PDOException $e) {
        error_log("Login error: " . $e->getMessage());
        return -1;
    } finally {
        $conn = null;
    }
}

function getUsernameByEmail($email)
{
    $conn = connectdb();
    try {
        // Tìm username qua email trong các bảng teachers, students, parents
        $sql = "SELECT u.Username, u.UserID, u.Role, 'teacher' as user_type
                FROM users u 
                JOIN teachers t ON u.UserID = t.UserID 
                WHERE t.Email = ?
                UNION
                SELECT u.Username, u.UserID, u.Role, 'student' as user_type
                FROM users u 
                JOIN students s ON u.UserID = s.UserID 
                WHERE s.Email = ?
                UNION
                SELECT u.Username, u.UserID, u.Role, 'parent' as user_type
                FROM users u 
                JOIN parents p ON u.UserID = p.UserID 
                WHERE p.Email = ?";
        
        $stmt = $conn->prepare($sql);
        $stmt->execute([$email, $email, $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            return $user['Username'];
        }
        return null; // Không tìm thấy user với email này
        
    } catch (PDOException $e) {
        error_log("Get username by email error: " . $e->getMessage());
        return null;
    } finally {
        $conn = null;
    }
}

function getUserByUsername($usernameOrEmail) {
    $conn = connectdb();
    // Lấy user theo username hoặc email (email của teacher, student, parent)
    $sql = "SELECT u.*
            FROM users u
            LEFT JOIN teachers t ON u.UserID = t.UserID
            LEFT JOIN students s ON u.UserID = s.UserID
            LEFT JOIN parents p ON u.UserID = p.UserID
            WHERE u.Username = :input
               OR t.Email = :input
               OR s.Email = :input
               OR p.Email = :input
            LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':input' => $usernameOrEmail]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function isExistUsername($username)
{
    try {
        $conn = connectdb();
        $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE Username = ?");
        $stmt->execute([$username]);
        $result = $stmt->fetchColumn();
        return $result > 0;
    } catch (PDOException $e) {
        error_log("Username check error: " . $e->getMessage());
        return false;
    } finally {
        $conn = null;
    } 
   
}

function isExistEmail($email)
{
    $conn = connectdb();
    try {
        // Kiểm tra email trong tất cả bảng: teachers, students, parents
        $sql = "SELECT COUNT(*) FROM 
                (SELECT Email FROM teachers WHERE Email = ? 
                 UNION 
                 SELECT Email FROM students WHERE Email = ? 
                 UNION 
                 SELECT Email FROM parents WHERE Email = ?) as all_emails";

        $stmt = $conn->prepare($sql);
        $stmt->execute([$email, $email, $email]);
        $result = $stmt->fetchColumn();
        $conn = null;
        return $result > 0;
    } catch (PDOException $e) {
        error_log("Email check error: " . $e->getMessage());
        $conn = null;
        return false; // Trong trường hợp lỗi, cho phép tiếp tục để không block user
    }
}

function isExistUsernameOrEmail($input)
{
    if (filter_var($input, FILTER_VALIDATE_EMAIL)) {
        return isExistEmail($input);
    } else {
        return isExistUsername($input);
    }
}


function addStudentOrParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $role)
{
    $conn = connectdb();
    $password_hashed = password_hash($password, PASSWORD_DEFAULT);
    
    try {
        $conn->beginTransaction();
        
        // Generate UserID based on role
        $userID = '';
        if ($role == 2) {
            // Student - prefix HV
            $stmt = $conn->prepare("SELECT next_id FROM id_counters WHERE role_prefix = 'HV'");
            $stmt->execute();
            $counter = $stmt->fetch(PDO::FETCH_ASSOC);
            $nextId = $counter['next_id'];
            $userID = 'HV' . str_pad($nextId, 3, '0', STR_PAD_LEFT);
            
            // Update counter
            $stmt = $conn->prepare("UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'HV'");
            $stmt->execute();
            
        } else if ($role == 3) {
            // Parent - prefix PH
            $stmt = $conn->prepare("SELECT next_id FROM id_counters WHERE role_prefix = 'PH'");
            $stmt->execute();
            $counter = $stmt->fetch(PDO::FETCH_ASSOC);
            $nextId = $counter['next_id'];
            $userID = 'PH' . str_pad($nextId, 3, '0', STR_PAD_LEFT);
            
            // Update counter
            $stmt = $conn->prepare("UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'PH'");
            $stmt->execute();
            
        } else {
            throw new Exception("Invalid role specified");
        }
        
        // Insert into users table with generated UserID
        $stmt = $conn->prepare("INSERT INTO users (UserID, Username, Password, Role) VALUES (?, ?, ?, ?)");
        $stmt->execute([$userID, $username, $password_hashed, $role]);
        
        if ($role == 2) {
            // Insert student
            $stmt = $conn->prepare("INSERT INTO students (UserID, FullName, Gender, Email, Phone, BirthDate) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$userID, $fullname, $gender, $email, $phone, $birthdate]);
        } else if ($role == 3) {
            // Insert parent
            $stmt = $conn->prepare("INSERT INTO parents (UserID, FullName, Gender, Email, Phone, BirthDate) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$userID, $fullname, $gender, $email, $phone, $birthdate]);
        }
        
        $conn->commit();
        
    } catch (Exception $e) {
        $conn->rollback();
        error_log("Add user error: " . $e->getMessage());
        echo "Có lỗi xảy ra: " . $e->getMessage();
    } finally {
        $conn = null;
    }
}

