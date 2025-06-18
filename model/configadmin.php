<?php
function countRow($table)
{
    try {
        $conn = connectdb();
        $sql = "SELECT COUNT(*) as total FROM " . $table . "";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo htmlspecialchars($result['total']);
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        echo "0"; // Giá trị mặc định khi có lỗi
    } catch (Exception $e) {
        error_log("General Error: " . $e->getMessage());
        echo "0";
    } finally {
        $stmt = null;
        $conn = null; // Đóng kết nối
    }
}

function showOptionTeacherName()
{
    try {
        $conn = connectdb();
        $sql = "SELECT UserID, FullName 
                FROM teachers";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (count($result) > 0) {
            foreach ($result as $row) {
                echo "<option value='" . htmlspecialchars($row['UserID']) . "'>" .
                    htmlspecialchars($row['FullName']) . "</option>";
            }
        } else {
            echo "<option value=''>Không có giáo viên</option>";
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        echo "<option value=''>Lỗi kết nối database</option>";
    } finally {
        $stmt = null;
        $conn = null;
    }
}

function showOptionClassName()
{
    try {
        $conn = connectdb();
        $sql = "SELECT ClassID, ClassName 
                FROM classes";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (count($result) > 0) {
            foreach ($result as $row) {
                echo "<option value='" . htmlspecialchars($row['ClassID']) . "'>" .
                    htmlspecialchars($row['ClassName']) . "</option>";
            }
        } else {
            echo "<option value=''>Không có lớp nào</option>";
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        echo "<option value=''>Lỗi kết nối database</option>";
    } finally {
        $stmt = null;
        $conn = null;
    }
}

function showOptionParent()
{
    try {
        $conn = connectdb();
        $sql = "SELECT UserID, FullName 
                FROM parents";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (count($result) > 0) {
            foreach ($result as $row) {
                echo "<option value='" . htmlspecialchars($row['UserID']) . "'>"
                    . htmlspecialchars($row['UserID']) . " " .
                    htmlspecialchars($row['FullName']) . "</option>";
            }
        } else {
            echo "<option value=''>Không có phụ huynh nào</option>";
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        echo "<option value=''>Lỗi kết nối database</option>";
    } finally {
        $stmt = null;
        $conn = null;
    }
}


function addClass($className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room)
{
    try {
        $conn = connectdb();
        error_log("Adding class: $className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room");

        // Kiểm tra xem lớp đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM classes WHERE ClassName = :className";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':className' => $className]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên lớp đã tồn tại'];
        }

        // Thêm lớp mới
        $sql = "INSERT INTO classes (ClassName, SchoolYear, TeacherID, StartDate, EndDate, ClassTime, Room, Status, CreatedAt) 
                VALUES (:className, :schoolYear, :teacherId, :startDate, :endDate, :classTime, :room, 'Đang hoạt động', NOW())";

        $stmt = $conn->prepare($sql);
        $params = [
            ':className' => $className,
            ':schoolYear' => $schoolYear,
            ':teacherId' => $teacherId,
            ':startDate' => $startDate,
            ':endDate' => $endDate,
            ':classTime' => $classTime,
            ':room' => $room
        ];

        error_log("Executing SQL with params: " . print_r($params, true));
        $result = $stmt->execute($params);

        if ($result) {
            error_log("Class added successfully");
            return ['status' => 'success', 'message' => 'Thêm lớp thành công'];
        } else {
            error_log("Failed to add class");
            return ['status' => 'error', 'message' => 'Thêm lớp thất bại'];
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function getDataFromTable($table)
{
    try {
        $conn = connectdb();
        $sql = "SELECT * FROM " . $table . "";

        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $classes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return $classes;
    } catch (Exception $e) {
        error_log("Error getting classes: " . $e->getMessage());
        return [];
    } finally {
        $conn = null;
    }
}

function getTeacherName($id)
{
    try {
        if (!$id) return null;

        $conn = connectdb();
        $sql = "SELECT FullName FROM teachers WHERE UserID = :id";

        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        return $result['FullName'];
    } catch (PDOException $e) {
        error_log("Error getting teacher name: " . $e->getMessage());
        return null;
    } finally {
        $stmt = null;
        $conn = null;
    }
}

// hàm thêm giáo viên trả về mảng kết quả
function addTeacher($fullname, $birthdate, $gender, $username, $password, $email, $phone, $salary)
{
    try {
        $conn = connectdb();
        error_log("AddTeacher params: $fullname, $birthdate, $gender, $username, $email, $phone, $salary");

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Chuẩn bị và gọi stored procedure
        $stmt = $conn->prepare("CALL AddNewTeacher(?, ?, ?, ?, ?, ?, ?, ?)");
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);

        $stmt->execute([
            $username,
            $password_hashed,
            $fullname,
            $gender,
            $email,
            $phone,
            $birthdate,
            $salary
        ]);

        return ['status' => 'success', 'message' => 'Thêm giáo viên thành công'];
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $stmt = null;
        $conn = null;
    }
}

function getTeacherClasses($teacherId)
{
    try {
        if (!$teacherId) return null;

        $conn = connectdb();


        $sql = "SELECT GROUP_CONCAT(ClassID SEPARATOR ', ') as Classes 
                FROM classes 
                WHERE TeacherID = :teacherId 
                AND Status = 'Đang hoạt động'";

        $stmt = $conn->prepare($sql);
        $stmt->execute([':teacherId' => $teacherId]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        return $result['Classes'] ?? 'Chưa có lớp phụ trách';
    } catch (PDOException $e) {
        error_log("Error getting teacher classes: " . $e->getMessage());
        return 'Lỗi khi lấy danh sách lớp';
    } finally {
        $stmt = null;
        $conn = null;
    }
}


function getchild($parentID)
{
    try {
        if (!$parentID) return null;

        $conn = connectdb();


        $sql = "SELECT GROUP_CONCAT(ClassID SEPARATOR ', ') as Childs
                FROM students 
                WHERE ParentID = :parentID";

        $stmt = $conn->prepare($sql);
        $stmt->execute([':parentID' => $parentID]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        return $result['Childs'] ?? 'Chưa có con nào';
    } catch (PDOException $e) {
        error_log("Error getting parent child: " . $e->getMessage());
        return 'Lỗi khi lấy danh sách con';
    } finally {
        $stmt = null;
        $conn = null;
    }
}


function addStudent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $classId, $parentId) {
    try {
        $conn = connectdb();
        error_log("AddStudent params: $fullname, $birthdate, $gender, $username, $email, $phone, $classId, $parentId");

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Thêm học sinh dùng stored procedure
        $stmt = $conn->prepare("CALL AddNewStudent(?, ?, ?, ?, ?, ?, ?)");
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);
        
        $stmt->execute([
            $username,
            $password_hashed, 
            $fullname,
            $gender,
            $email,
            $phone,
            $birthdate
        ]);

        // Chờ stored procedure hoàn thành
        $stmt->closeCursor();

        // Lấy UserID của học sinh vừa thêm
        $userId = $conn->query("SELECT UserID FROM users WHERE Username = '$username'")->fetch(PDO::FETCH_COLUMN);

        // Bắt đầu transaction cho phần cập nhật
        $conn->beginTransaction();

        try {
            // Cập nhật ClassID và ParentID nếu có
            if($classId != "" || $parentId != "") {
                $updateSql = "UPDATE students SET ";
                $updateParams = [];
                
                if($classId != "") {
                    $updateSql .= "ClassID = :classId";
                    $updateParams[':classId'] = $classId;
                }
                
                if($parentId != "") {
                    if($classId != "") $updateSql .= ", ";
                    $updateSql .= "ParentID = :parentId";
                    $updateParams[':parentId'] = $parentId;
                }
                
                $updateSql .= " WHERE UserID = :userId";
                $updateParams[':userId'] = $userId;
                
                $updateStmt = $conn->prepare($updateSql);
                $updateStmt->execute($updateParams);
            }

            $conn->commit();
            return ['status' => 'success', 'message' => 'Thêm học sinh thành công'];
            
        } catch (Exception $e) {
            $conn->rollBack();
            throw $e;
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}


function addParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $zalo, $unpaid) {
    try {
        $conn = connectdb();
        error_log("addParent params: $fullname, $birthdate, $gender, $username, $email, $phone, $zalo, $unpaid");

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Thêm học sinh dùng stored procedure
        $stmt = $conn->prepare("CALL AddNewParent(?, ?, ?, ?, ?, ?, ?)");
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);
        
        $stmt->execute([
            $username,
            $password_hashed, 
            $fullname,
            $gender,
            $email,
            $phone,
            $birthdate
        ]);

        // Chờ stored procedure hoàn thành
        $stmt->closeCursor();

        // Lấy UserID của phụ huynh vừa thêm
        $userId = $conn->query("SELECT UserID FROM users WHERE Username = '$username'")->fetch(PDO::FETCH_COLUMN);

        // Bắt đầu transaction cho phần cập nhật
        $conn->beginTransaction();

        try {
            // Cập nhật Zalo và Unpaid nếu có
            if($zalo != "" || $unpaid != "") {
                $updateSql = "UPDATE parents SET ";
                $updateParams = [];
                
                if($zalo != "") {
                    $updateSql .= "ZaloID = :zalo";
                    $updateParams[':zalo'] = $zalo;
                }
                
                if($unpaid != "") {
                    if($zalo != "") $updateSql .= ", ";
                    $updateSql .= "UnpaidAmount = :unpaid";
                    $updateParams[':unpaid'] = $unpaid;
                }
                
                $updateSql .= " WHERE UserID = :userId";
                $updateParams[':userId'] = $userId;
                
                $updateStmt = $conn->prepare($updateSql);
                $updateStmt->execute($updateParams);
            }

            $conn->commit();
            return ['status' => 'success', 'message' => 'Thêm phụ huynh thành công'];
            
        } catch (Exception $e) {
            $conn->rollBack();
            throw $e;
        }
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function getStatistics($startDate, $endDate) {
    try {
        $conn = connectdb();
        error_log("Getting statistics from $startDate to $endDate");

        // Tổng tiền dự kiến và đã thu
        $sql = "SELECT 
                COALESCE(SUM(Amount), 0) as ExpectedAmount,
                COALESCE(SUM(CASE WHEN Status = 'Đã đóng' THEN Amount ELSE 0 END), 0) as CollectedAmount
                FROM tuition 
                WHERE DueDate BETWEEN :startDate AND :endDate";
                
        $stmt = $conn->prepare($sql);
        $stmt->execute([
            ':startDate' => $startDate, 
            ':endDate' => $endDate
        ]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        // Số học sinh tăng giảm - sửa lại logic này
        $sqlStudents = "SELECT 
            (SELECT COUNT(*) FROM students 
             WHERE DATE(CreatedAt) BETWEEN :startDate AND :endDate) as Increased,
            (SELECT COUNT(DISTINCT s.UserID)
             FROM students s
             LEFT JOIN attendance a ON s.UserID = a.StudentID
             WHERE a.AttendanceDate BETWEEN :startDate AND :endDate 
             AND a.Status = 'Vắng mặt'
             GROUP BY s.UserID
             HAVING COUNT(*) >= 3) as Decreased";

        $stmtStudents = $conn->prepare($sqlStudents);
        $stmtStudents->execute([
            ':startDate' => $startDate,
            ':endDate' => $endDate
        ]);
        $studentStats = $stmtStudents->fetch(PDO::FETCH_ASSOC);

        error_log("Statistics result: " . print_r(array_merge($result, $studentStats), true));

        return [
            'status' => 'success',
            'data' => [
                'expectedAmount' => (int)$result['ExpectedAmount'],
                'collectedAmount' => (int)$result['CollectedAmount'], 
                'studentsIncreased' => (int)$studentStats['Increased'],
                'studentsDecreased' => (int)$studentStats['Decreased']
            ]
        ];
    } catch (PDOException $e) {
        error_log("Database Error in getStatistics: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        error_log("General Error in getStatistics: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()]; 
    } finally {
        $conn = null;
    }
}

function changeAdminPassword($currentPassword, $newPassword, $confirmPassword) {
    try {
        if ($newPassword !== $confirmPassword) {
            return ['status' => 'error', 'message' => 'Mật khẩu mới không khớp'];
        }

        $conn = connectdb();
        
        // Lấy mật khẩu hiện tại của admin
        $stmt = $conn->prepare("SELECT Password FROM users WHERE UserID = '0'");
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!password_verify($currentPassword, $result['Password'])) {
            return ['status' => 'error', 'message' => 'Mật khẩu hiện tại không đúng'];
        }
        
        // Cập nhật mật khẩu mới
        $password_hashed = password_hash($newPassword, PASSWORD_DEFAULT);
        $updateStmt = $conn->prepare("UPDATE users SET Password = :password WHERE UserID = '0'");
        $updateStmt->execute([':password' => $password_hashed]);
        
        return ['status' => 'success', 'message' => 'Đổi mật khẩu thành công'];
        
    } catch (PDOException $e) {
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}
