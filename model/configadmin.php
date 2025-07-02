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


function addClass($className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room, $classTuition)
{
    try {
        $conn = connectdb();
        error_log("Adding class: $className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room");

        // Kiểm tra xem lớp đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM classes WHERE ClassName = :className AND SchoolYear = :schoolYear";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':className' => $className, ':schoolYear' => $schoolYear]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên lớp đã tồn tại'];
        }

        // Thêm lớp mới
        $sql = "INSERT INTO classes (ClassName, SchoolYear, TeacherID, StartDate, EndDate, ClassTime, Room, Tuition, Status,  CreatedAt) 
                VALUES (:className, :schoolYear, :teacherId, :startDate, :endDate, :classTime, :room, :tuition, 'Đang hoạt động', NOW())";

        $stmt = $conn->prepare($sql);
        $params = [
            ':className' => $className,
            ':schoolYear' => $schoolYear,
            ':teacherId' => $teacherId,
            ':startDate' => $startDate,
            ':endDate' => $endDate,
            ':classTime' => $classTime,
            ':room' => $room,
            ':tuition' => $classTuition
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

        // Begin transaction
        $conn->beginTransaction();

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if ($checkStmt->fetchColumn() > 0) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Generate new teacher ID
        $counterSql = "SELECT next_id FROM id_counters WHERE role_prefix = 'GV'";
        $counterStmt = $conn->prepare($counterSql);
        $counterStmt->execute();
        $nextId = $counterStmt->fetchColumn();
        
        if (!$nextId) {
            // Initialize counter if not exists
            $initSql = "INSERT INTO id_counters (role_prefix, next_id) VALUES ('GV', 1)";
            $conn->prepare($initSql)->execute();
            $nextId = 1;
        }
        
        $teacherId = 'GV' . str_pad($nextId, 3, '0', STR_PAD_LEFT);

        // Update counter
        $updateCounterSql = "UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'GV'";
        $conn->prepare($updateCounterSql)->execute();

        // Hash password
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);

        // Insert user record
        $userSql = "INSERT INTO users (UserID, Username, Password, Role) VALUES (:userId, :username, :password, 1)";
        $userStmt = $conn->prepare($userSql);
        $userResult = $userStmt->execute([
            ':userId' => $teacherId,
            ':username' => $username,
            ':password' => $password_hashed
        ]);

        if (!$userResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo tài khoản người dùng'];
        }

        // Insert teacher record
        $teacherSql = "INSERT INTO teachers (UserID, FullName, Gender, Email, Phone, BirthDate, Salary) 
                       VALUES (:userId, :fullname, :gender, :email, :phone, :birthdate, :salary)";
        $teacherStmt = $conn->prepare($teacherSql);
        $teacherResult = $teacherStmt->execute([
            ':userId' => $teacherId,
            ':fullname' => $fullname,
            ':gender' => $gender,
            ':email' => $email,
            ':phone' => $phone,
            ':birthdate' => $birthdate,
            ':salary' => $salary
        ]);

        if (!$teacherResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo thông tin giáo viên'];
        }

        // Commit transaction
        $conn->commit();
        return ['status' => 'success', 'message' => 'Thêm giáo viên thành công'];

    } catch (PDOException $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function getTeacherClasses($teacherId) {
    try {
        if (!$teacherId) return null;

        $conn = connectdb();

        $sql = "SELECT GROUP_CONCAT(CONCAT(ClassName, ' (', SchoolYear, ')') SEPARATOR ', ') as Classes 
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


        $sql = "SELECT GROUP_CONCAT(UserID SEPARATOR ', ') as Childs
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


function addStudent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $classId, $parentIds, $discount)
{
    try {
        $conn = connectdb();
        error_log("AddStudent params: $fullname, $birthdate, $gender, $username, $email, $phone, $classId");

        // Begin transaction
        $conn->beginTransaction();

        // Generate new student ID
        $counterSql = "SELECT next_id FROM id_counters WHERE role_prefix = 'HV'";
        $counterStmt = $conn->prepare($counterSql);
        $counterStmt->execute();
        $nextId = $counterStmt->fetchColumn();
        
        if (!$nextId) {
            // Initialize counter if not exists
            $initSql = "INSERT INTO id_counters (role_prefix, next_id) VALUES ('HV', 1)";
            $conn->prepare($initSql)->execute();
            $nextId = 1;
        }
        
        $studentId = 'HV' . str_pad($nextId, 3, '0', STR_PAD_LEFT);

        // Update counter
        $updateCounterSql = "UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'HV'";
        $conn->prepare($updateCounterSql)->execute();

        // Hash password
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);

        // Insert user record
        $userSql = "INSERT INTO users (UserID, Username, Password, Role) VALUES (:userId, :username, :password, 2)";
        $userStmt = $conn->prepare($userSql);
        $userResult = $userStmt->execute([
            ':userId' => $studentId,
            ':username' => $username,
            ':password' => $password_hashed
        ]);

        if (!$userResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo tài khoản người dùng'];
        }

        // Insert student record
        $studentSql = "INSERT INTO students (UserID, FullName, Gender, Email, Phone, BirthDate, ClassID) 
                       VALUES (:userId, :fullname, :gender, :email, :phone, :birthdate, :classId)";
        $studentStmt = $conn->prepare($studentSql);
        $studentResult = $studentStmt->execute([
            ':userId' => $studentId,
            ':fullname' => $fullname,
            ':gender' => $gender,
            ':email' => $email,
            ':phone' => $phone,
            ':birthdate' => $birthdate,
            ':classId' => $classId ?: null
        ]);

        if (!$studentResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo thông tin học sinh'];
        }

        // Create tuition record if student is assigned to a class
        if (!empty($classId)) {
            // Get class tuition
            $classSql = "SELECT Tuition, ClassName FROM classes WHERE ClassID = :classId";
            $classStmt = $conn->prepare($classSql);
            $classStmt->execute([':classId' => $classId]);
            $classInfo = $classStmt->fetch(PDO::FETCH_ASSOC);

            if ($classInfo) {
                $tuitionSql = "INSERT INTO tuition (StudentID, Amount, Discount, DueDate, Status, Note) 
                              VALUES (:studentId, :amount, :discount, DATE_ADD(NOW(), INTERVAL 10 DAY), 'Chưa đóng', :note)";
                $tuitionStmt = $conn->prepare($tuitionSql);
                $tuitionResult = $tuitionStmt->execute([
                    ':studentId' => $studentId,
                    ':amount' => $classInfo['Tuition'],
                    ':discount' => $discount,
                    ':note' => 'Học phí lớp ' . $classInfo['ClassName'] . ' - ' . date('m/Y')
                ]);

                if (!$tuitionResult) {
                    $conn->rollback();
                    return ['status' => 'error', 'message' => 'Lỗi khi tạo thông tin học phí'];
                }
            }
        }

        // Thêm mối quan hệ phụ huynh - học sinh nếu có
        if (!empty($parentIds) && is_array($parentIds)) {
            $insertKeySql = "INSERT INTO student_parent_keys (student_id, parent_id) VALUES (:studentId, :parentId)";
            $keyStmt = $conn->prepare($insertKeySql);

            foreach ($parentIds as $parentId) {
                if (!empty($parentId)) {
                    $keyResult = $keyStmt->execute([
                        ':studentId' => $studentId,
                        ':parentId' => $parentId
                    ]);

                    if (!$keyResult) {
                        $conn->rollback();
                        return ['status' => 'error', 'message' => 'Lỗi khi liên kết với phụ huynh'];
                    }
                }
            }
        }

        // Commit transaction
        $conn->commit();
        return ['status' => 'success', 'message' => 'Thêm học sinh thành công'];

    } catch (PDOException $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}


function addParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $zalo, $isShowTeacher)
{
    try {
        $conn = connectdb();
        error_log("addParent params: $fullname, $birthdate, $gender, $username, $email, $phone, $zalo, $isShowTeacher");

        // Begin transaction
        $conn->beginTransaction();

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if ($checkStmt->fetchColumn() > 0) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Generate new parent ID
        $counterSql = "SELECT next_id FROM id_counters WHERE role_prefix = 'PH'";
        $counterStmt = $conn->prepare($counterSql);
        $counterStmt->execute();
        $nextId = $counterStmt->fetchColumn();
        
        if (!$nextId) {
            // Initialize counter if not exists
            $initSql = "INSERT INTO id_counters (role_prefix, next_id) VALUES ('PH', 1)";
            $conn->prepare($initSql)->execute();
            $nextId = 1;
        }
        
        $parentId = 'PH' . str_pad($nextId, 3, '0', STR_PAD_LEFT);

        // Update counter
        $updateCounterSql = "UPDATE id_counters SET next_id = next_id + 1 WHERE role_prefix = 'PH'";
        $conn->prepare($updateCounterSql)->execute();

        // Hash password
        $password_hashed = password_hash($password, PASSWORD_DEFAULT);

        // Insert user record
        $userSql = "INSERT INTO users (UserID, Username, Password, Role) VALUES (:userId, :username, :password, 3)";
        $userStmt = $conn->prepare($userSql);
        $userResult = $userStmt->execute([
            ':userId' => $parentId,
            ':username' => $username,
            ':password' => $password_hashed
        ]);

        if (!$userResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo tài khoản người dùng'];
        }

        // Insert parent record
        $parentSql = "INSERT INTO parents (UserID, FullName, Gender, Email, Phone, BirthDate, ZaloID, isShowTeacher) 
                      VALUES (:userId, :fullname, :gender, :email, :phone, :birthdate, :zalo, :isShow)";
        $parentStmt = $conn->prepare($parentSql);
        $parentResult = $parentStmt->execute([
            ':userId' => $parentId,
            ':fullname' => $fullname,
            ':gender' => $gender,
            ':email' => $email,
            ':phone' => $phone,
            ':birthdate' => $birthdate,
            ':zalo' => $zalo,
            ':isShow' => $isShowTeacher
        ]);

        if (!$parentResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi tạo thông tin phụ huynh'];
        }

        // Commit transaction
        $conn->commit();
        return ['status' => 'success', 'message' => 'Thêm phụ huynh thành công'];

    } catch (PDOException $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("Database Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } catch (Exception $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("General Error: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function getStatistics($startDate, $endDate)
{
    try {
        $conn = connectdb();
        error_log("Getting statistics from $startDate to $endDate");

        // Tổng tiền dự kiến (đã tính discount) và đã thu
        $sql = "SELECT 
                COALESCE(SUM(Amount * (1 - IFNULL(Discount, 0)/100)), 0) as ExpectedAmount,
                COALESCE(SUM(CASE 
                    WHEN Status = 'Đã đóng' THEN Amount * (1 - IFNULL(Discount, 0)/100) 
                    ELSE 0 
                END), 0) as CollectedAmount
                FROM tuition 
                WHERE DueDate BETWEEN :startDate AND :endDate";

        $stmt = $conn->prepare($sql);
        $stmt->execute([
            ':startDate' => $startDate,
            ':endDate' => $endDate
        ]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        // Tính tổng lương giáo viên và số giáo viên trong khoảng thời gian
        $sqlSalary = "SELECT 
                      COALESCE(SUM(Salary), 0) as TotalSalary,
                      COUNT(*) as TeacherCount 
                      FROM teachers 
                      WHERE DATE(CreatedAt) <= :endDate";

        $stmtSalary = $conn->prepare($sqlSalary);
        $stmtSalary->execute([
            ':endDate' => $endDate
        ]);
        $salaryStats = $stmtSalary->fetch(PDO::FETCH_ASSOC);

        // Học sinh tăng (số học sinh mới trong khoảng thời gian)
        $sqlIncrease = "SELECT COUNT(*) as Increased 
                       FROM students 
                       WHERE DATE(CreatedAt) BETWEEN :startDate AND :endDate";

        $stmtIncrease = $conn->prepare($sqlIncrease);
        $stmtIncrease->execute([
            ':startDate' => $startDate,
            ':endDate' => $endDate
        ]);
        $increased = $stmtIncrease->fetch(PDO::FETCH_ASSOC);

        // Học sinh giảm (học sinh nghỉ học hoặc chuyển lớp)
        $sqlDecrease = "SELECT COUNT(DISTINCT s.UserID) as Decreased
                       FROM students s
                       WHERE EXISTS (
                           SELECT 1 FROM attendance a 
                           WHERE a.StudentID = s.UserID
                           AND a.AttendanceDate BETWEEN :startDate AND :endDate
                           AND a.Status = 'Vắng mặt'
                           GROUP BY a.StudentID
                           HAVING COUNT(*) >= 3
                       )
                       OR EXISTS (
                           SELECT 1 FROM tuition t
                           WHERE t.StudentID = s.UserID
                           AND t.DueDate BETWEEN :startDate AND :endDate
                           AND t.Status = 'Trễ hạn'
                       )";

        $stmtDecrease = $conn->prepare($sqlDecrease);
        $stmtDecrease->execute([
            ':startDate' => $startDate,
            ':endDate' => $endDate
        ]);
        $decreased = $stmtDecrease->fetch(PDO::FETCH_ASSOC);

        return [
            'status' => 'success',
            'data' => [
                'expectedAmount' => (int)$result['ExpectedAmount'],
                'collectedAmount' => (int)$result['CollectedAmount'],
                'studentsIncreased' => (int)$increased['Increased'],
                'studentsDecreased' => (int)$decreased['Decreased'],
                'totalSalary' => (int)$salaryStats['TotalSalary'],
                'teacherCount' => (int)$salaryStats['TeacherCount']
            ]
        ];
    } catch (PDOException $e) {
        error_log("Database Error in getStatistics: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi database: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function changeAdminPassword($currentPassword, $newPassword, $confirmPassword)
{
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

function getClassById($id)
{
    try {
        $conn = connectdb();
        $sql = "SELECT * FROM classes WHERE ClassID = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);
        $class = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($class) {
            // Get teacher options
            $teachers = getDataFromTable("teachers");
            $teacherOptions = "";
            foreach ($teachers as $teacher) {
                $selected = ($teacher['UserID'] == $class['TeacherID']) ? 'selected' : '';
                $teacherOptions .= "<option value='{$teacher['UserID']}' {$selected}>{$teacher['FullName']} ({$teacher['UserID']})</option>";
            }
            $class['teacherOptions'] = $teacherOptions;
            return ['status' => 'success', 'data' => $class];
        }
        return ['status' => 'error', 'message' => 'Không tìm thấy lớp'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function getTeacherById($id)
{
    try {
        $conn = connectdb();
        $sql = "SELECT * FROM teachers WHERE UserID = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);
        $teacher = $stmt->fetch(PDO::FETCH_ASSOC);

        return $teacher ? ['status' => 'success', 'data' => $teacher] :
            ['status' => 'error', 'message' => 'Không tìm thấy giáo viên'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function getStudentById($id)
{
    try {
        $conn = connectdb();

        // Get student basic info
        $sql = "SELECT s.*, c.ClassName 
                FROM students s 
                LEFT JOIN classes c ON s.ClassID = c.ClassID 
                WHERE s.UserID = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);
        $student = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($student) {
            // Get selected parents
            $parentSql = "SELECT parent_id FROM student_parent_keys WHERE student_id = :studentId";
            $parentStmt = $conn->prepare($parentSql);
            $parentStmt->execute([':studentId' => $id]);
            $selectedParents = $parentStmt->fetchAll(PDO::FETCH_COLUMN);

            // Get class options
            $classes = getDataFromTable("classes");
            $classOptions = "";
            foreach ($classes as $class) {
                $selected = ($class['ClassID'] == $student['ClassID']) ? 'selected' : '';
                $classOptions .= "<option value='{$class['ClassID']}' {$selected}>{$class['ClassName']} ({$class['SchoolYear']})</option>";
            }
            $student['classOptions'] = $classOptions;

            // Get parent options with selected state and better display format
            $parents = getDataFromTable("parents");
            $parentOptions = "";
            foreach ($parents as $parent) {
                $selected = in_array($parent['UserID'], $selectedParents) ? 'selected' : '';
                $parentOptions .= "<option value='{$parent['UserID']}' {$selected}>{$parent['FullName']} ({$parent['UserID']})</option>";
            }
            $student['parentOptions'] = $parentOptions;

            return ['status' => 'success', 'data' => $student];
        }
        return ['status' => 'error', 'message' => 'Không tìm thấy học sinh'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function getParentById($id)
{
    try {
        $conn = connectdb();
        $sql = "SELECT * FROM parents WHERE UserID = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);
        $parent = $stmt->fetch(PDO::FETCH_ASSOC);

        return $parent ? ['status' => 'success', 'data' => $parent] :
            ['status' => 'error', 'message' => 'Không tìm thấy phụ huynh'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function updateClass($data)
{
    try {
        $conn = connectdb();
        $sql = "UPDATE classes SET 
                ClassName = :className,
                TeacherID = :teacherId,
                Room = :room,
                Tuition = :tuition,
                ClassTime = :classTime,
                StartDate = :startDate,
                EndDate = :endDate,
                SchoolYear = :schoolYear,
                Status = :status
                WHERE ClassID = :id";

        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([
            ':id' => $data['id'],
            ':className' => $data['className'],
            ':teacherId' => $data['teacherId'],
            ':room' => $data['room'],
            ':tuition' => $data['classTuition'],
            ':classTime' => $data['classTime'],
            ':startDate' => $data['startDate'],
            ':endDate' => $data['endDate'],
            ':schoolYear' => $data['schoolYear'],
            ':status' => $data['status']
        ]);

        return $result ?
            ['status' => 'success', 'message' => 'Cập nhật lớp thành công'] :
            ['status' => 'error', 'message' => 'Cập nhật lớp thất bại'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function updateTeacher($data)
{
    try {
        $conn = connectdb();
        
        // Get current teacher's email
        $getCurrentEmailSql = "SELECT Email FROM teachers WHERE UserID = :id";
        $getCurrentEmailStmt = $conn->prepare($getCurrentEmailSql);
        $getCurrentEmailStmt->execute([':id' => $data['id']]);
        $currentEmail = $getCurrentEmailStmt->fetchColumn();
        
        // Only check email existence if the new email is different from current email
        if ($data['email'] !== $currentEmail && isExistEmail($data['email'])) {
            return ([
                'status' => 'error',
                'message' => 'Email đã được sử dụng bởi người khác!'
            ]);
        }
        
        $sql = "UPDATE teachers SET 
                FullName = :fullName,
                Email = :email,
                Phone = :phone,
                Gender = :gender,
                BirthDate = :birthDate,
                Salary = :salary
                WHERE UserID = :id";

        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([
            ':id' => $data['id'],
            ':fullName' => $data['fullName'],
            ':email' => $data['email'],
            ':phone' => $data['phone'],
            ':gender' => $data['gender'],
            ':birthDate' => $data['birthDate'],
            ':salary' => $data['salary']
        ]);

        return $result ?
            ['status' => 'success', 'message' => 'Cập nhật giáo viên thành công'] :
            ['status' => 'error', 'message' => 'Cập nhật giáo viên thất bại'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function updateStudent($data)
{
    try {
        $conn = connectdb();
        
        // Get current student's email
        $getCurrentEmailSql = "SELECT Email FROM students WHERE UserID = :id";
        $getCurrentEmailStmt = $conn->prepare($getCurrentEmailSql);
        $getCurrentEmailStmt->execute([':id' => $data['id']]);
        $currentEmail = $getCurrentEmailStmt->fetchColumn();
        
        // Only check email existence if the new email is different from current email
        if ($data['email'] !== $currentEmail && isExistEmail($data['email'])) {
            return ([
                'status' => 'error',
                'message' => 'Email đã được sử dụng bởi người khác!'
            ]);
        }
        
        $conn->beginTransaction();

        // Get current student info to check for class changes
        $getCurrentSql = "SELECT ClassID FROM students WHERE UserID = :id";
        $getCurrentStmt = $conn->prepare($getCurrentSql);
        $getCurrentStmt->execute([':id' => $data['id']]);
        $currentStudent = $getCurrentStmt->fetch(PDO::FETCH_ASSOC);
        $oldClassId = $currentStudent['ClassID'];
        $newClassId = $data['classId'] ?: null;

        // Update student basic info
        $sql = "UPDATE students SET 
                FullName = :fullName,
                Email = :email,
                Phone = :phone,
                Gender = :gender,
                BirthDate = :birthDate,
                ClassID = :classId
                WHERE UserID = :id";

        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([
            ':id' => $data['id'],
            ':fullName' => $data['fullName'],
            ':email' => $data['email'],
            ':phone' => $data['phone'],
            ':gender' => $data['gender'],
            ':birthDate' => $data['birthDate'],
            ':classId' => $newClassId
        ]);

        if (!$result) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi cập nhật thông tin học sinh'];
        }

        // Handle tuition changes when class changes
        if ($oldClassId != $newClassId) {
            // Delete old unpaid tuition records
            if ($oldClassId) {
                $deleteOldTuitionSql = "DELETE FROM tuition WHERE StudentID = :studentId AND Status = 'Chưa đóng'";
                $deleteOldTuitionStmt = $conn->prepare($deleteOldTuitionSql);
                $deleteOldTuitionStmt->execute([':studentId' => $data['id']]);
            }

            // Create new tuition record if assigned to a new class
            if ($newClassId) {
                // Get new class tuition info
                $getClassSql = "SELECT Tuition, ClassName FROM classes WHERE ClassID = :classId";
                $getClassStmt = $conn->prepare($getClassSql);
                $getClassStmt->execute([':classId' => $newClassId]);
                $classInfo = $getClassStmt->fetch(PDO::FETCH_ASSOC);

                if ($classInfo) {
                    $createTuitionSql = "INSERT INTO tuition (StudentID, Amount, Discount, DueDate, Status, Note) 
                                        VALUES (:studentId, :amount, :discount, DATE_ADD(NOW(), INTERVAL 10 DAY), 'Chưa đóng', :note)";
                    $createTuitionStmt = $conn->prepare($createTuitionSql);
                    $tuitionResult = $createTuitionStmt->execute([
                        ':studentId' => $data['id'],
                        ':amount' => $classInfo['Tuition'],
                        ':discount' => $data['studentDiscount'],
                        ':note' => 'Học phí lớp ' . $classInfo['ClassName'] . ' - ' . date('m/Y')
                    ]);

                    if (!$tuitionResult) {
                        $conn->rollback();
                        return ['status' => 'error', 'message' => 'Lỗi khi tạo học phí cho lớp mới'];
                    }
                }
            }
        } else {
            // If class doesn't change, just update discount for existing unpaid tuition
            $updateDiscountSql = "UPDATE tuition SET Discount = :discount 
                                WHERE StudentID = :studentId AND Status = 'Chưa đóng'";
            $updateDiscountStmt = $conn->prepare($updateDiscountSql);
            $updateDiscountStmt->execute([
                ':discount' => $data['studentDiscount'],
                ':studentId' => $data['id']
            ]);
        }

        // Update parent relationships
        // First delete existing relationships
        $deleteSql = "DELETE FROM student_parent_keys WHERE student_id = :studentId";
        $deleteStmt = $conn->prepare($deleteSql);
        $deleteStmt->execute([':studentId' => $data['id']]);

        // Then insert new relationships
        if (!empty($data['parentIds'])) {
            $insertSql = "INSERT INTO student_parent_keys (student_id, parent_id) VALUES (:studentId, :parentId)";
            $insertStmt = $conn->prepare($insertSql);

            foreach ($data['parentIds'] as $parentId) {
                $insertResult = $insertStmt->execute([
                    ':studentId' => $data['id'],
                    ':parentId' => $parentId
                ]);

                if (!$insertResult) {
                    $conn->rollback();
                    return ['status' => 'error', 'message' => 'Lỗi khi cập nhật thông tin phụ huynh'];
                }
            }
        }

        $conn->commit();
        return ['status' => 'success', 'message' => 'Cập nhật học sinh thành công'];

    } catch (Exception $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("Error in updateStudent: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function updateParent($data)
{
    try {
        $conn = connectdb();
        
        // Get current parent's email
        $getCurrentEmailSql = "SELECT Email FROM parents WHERE UserID = :id";
        $getCurrentEmailStmt = $conn->prepare($getCurrentEmailSql);
        $getCurrentEmailStmt->execute([':id' => $data['id']]);
        $currentEmail = $getCurrentEmailStmt->fetchColumn();
        
        // Only check email existence if the new email is different from current email
        if ($data['email'] !== $currentEmail && isExistEmail($data['email'])) {
            return ([
                'status' => 'error',
                'message' => 'Email đã được sử dụng bởi người khác!'
            ]);
        }
        
        $sql = "UPDATE parents SET 
                FullName = :fullName,
                Email = :email,
                Phone = :phone,
                Gender = :gender,
                BirthDate = :birthDate,
                ZaloID = :zaloId,
                isShowTeacher = :isShowTeacher
                WHERE UserID = :id";

        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([
            ':id' => $data['id'],
            ':fullName' => $data['fullName'],
            ':email' => $data['email'],
            ':phone' => $data['phone'],
            ':gender' => $data['gender'],
            ':birthDate' => $data['birthDate'],
            ':zaloId' => $data['zaloId'],
            ':isShowTeacher' => $data['isShowTeacher']
        ]);

        return $result ?
            ['status' => 'success', 'message' => 'Cập nhật phụ huynh thành công'] :
            ['status' => 'error', 'message' => 'Cập nhật phụ huynh thất bại'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function deleteTeacher($id)
{
    try {
        $conn = connectdb();

        // Start transaction
        $conn->beginTransaction();

        // Check if teacher has active classes
        $checkClassesSql = "SELECT COUNT(*) FROM classes WHERE TeacherID = ? AND Status = 'Đang hoạt động'";
        $checkStmt = $conn->prepare($checkClassesSql);
        $checkStmt->execute([$id]);
        if ($checkStmt->fetchColumn() > 0) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Không thể xóa giáo viên đang phụ trách lớp'];
        }

        // Update classes to remove teacher reference (set to NULL for completed/suspended classes)
        $updateClassesSql = "UPDATE classes SET TeacherID = NULL WHERE TeacherID = ?";
        $updateStmt = $conn->prepare($updateClassesSql);
        $updateResult = $updateStmt->execute([$id]);

        if (!$updateResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi cập nhật thông tin lớp học'];
        }

        // Delete teacher record
        $deleteTeacherSql = "DELETE FROM teachers WHERE UserID = ?";
        $deleteTeacherStmt = $conn->prepare($deleteTeacherSql);
        $teacherResult = $deleteTeacherStmt->execute([$id]);

        if (!$teacherResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi xóa thông tin giáo viên'];
        }

        // Delete user account
        $deleteUserSql = "DELETE FROM users WHERE UserID = ?";
        $deleteUserStmt = $conn->prepare($deleteUserSql);
        $userResult = $deleteUserStmt->execute([$id]);

        if (!$userResult) {
            $conn->rollback();
            return ['status' => 'error', 'message' => 'Lỗi khi xóa tài khoản người dùng'];
        }

        // Commit transaction
        $conn->commit();
        return ['status' => 'success', 'message' => 'Xóa giáo viên thành công'];

    } catch (PDOException $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("Error in deleteTeacher: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Không thể xóa giáo viên: ' . $e->getMessage()];
    } catch (Exception $e) {
        if ($conn) {
            $conn->rollback();
        }
        error_log("General Error in deleteTeacher: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Lỗi: ' . $e->getMessage()];
    } finally {
        $conn = null;
    }
}

function deleteStudent($id)
{
    try {
        $conn = connectdb();


        try {
            // Delete messages first
            $deleteMessagesSql = "DELETE FROM messages WHERE receiver_id = ?";
            $stmt = $conn->prepare($deleteMessagesSql);
            $stmt->execute([$id]);

            // Delete attendance records
            $deleteAttendanceSql = "DELETE FROM attendance WHERE StudentID = ?";
            $stmt = $conn->prepare($deleteAttendanceSql);
            $stmt->execute([$id]);

            // Delete tuition records
            $deleteTuitionSql = "DELETE FROM tuition WHERE StudentID = ?";
            $stmt = $conn->prepare($deleteTuitionSql);
            $stmt->execute([$id]);

            // Delete parent relationships
            $deleteRelationshipsSql = "DELETE FROM student_parent_keys WHERE student_id = ?";
            $stmt = $conn->prepare($deleteRelationshipsSql);
            $stmt->execute([$id]);

            // Delete student record
            $deleteStudentSql = "DELETE FROM students WHERE UserID = ?";
            $stmt = $conn->prepare($deleteStudentSql);
            $stmt->execute([$id]);

            // Delete user account
            $deleteUserSql = "DELETE FROM users WHERE UserID = ?";
            $stmt = $conn->prepare($deleteUserSql);
            $stmt->execute([$id]);

            return ['status' => 'success', 'message' => 'Xóa học sinh thành công'];
        } catch (Exception $e) {
            throw $e;
        }
    } catch (PDOException $e) {
        error_log("Error in deleteStudent: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Không thể xóa học sinh: ' . $e->getMessage()];
    }
}

function deleteParent($id)
{
    try {
        $conn = connectdb();

        // Start transaction
        $conn->beginTransaction();

        try {
            // Delete parent-student relationships first
            $deleteRelationshipsSql = "DELETE FROM student_parent_keys WHERE parent_id = ?";
            $stmt = $conn->prepare($deleteRelationshipsSql);
            $stmt->execute([$id]);

            // Delete parent record
            $deleteParentSql = "DELETE FROM parents WHERE UserID = ?";
            $stmt = $conn->prepare($deleteParentSql);
            $stmt->execute([$id]);

            // Delete user account
            $deleteUserSql = "DELETE FROM users WHERE UserID = ?";
            $stmt = $conn->prepare($deleteUserSql);
            $stmt->execute([$id]);

            $conn->commit();
            return ['status' => 'success', 'message' => 'Xóa phụ huynh thành công'];
        } catch (Exception $e) {
            $conn->rollBack();
            throw $e;
        }
    } catch (PDOException $e) {
        error_log("Error in deleteParent: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Không thể xóa phụ huynh: ' . $e->getMessage()];
    }
}

function deleteClass($id)
{
    try {
        $conn = connectdb();

        // Start transaction
        $conn->beginTransaction();

        // Check if class has students
        $checkStudentsSql = "SELECT COUNT(*) FROM students WHERE ClassID = :id";
        $checkStmt = $conn->prepare($checkStudentsSql);
        $checkStmt->execute([':id' => $id]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Không thể xóa lớp vì còn học sinh trong lớp'];
        }

        // Check if class has attendance records
        $checkAttendanceSql = "SELECT COUNT(*) FROM attendance WHERE ClassID = :id";
        $checkStmt = $conn->prepare($checkAttendanceSql);
        $checkStmt->execute([':id' => $id]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Không thể xóa lớp vì có dữ liệu điểm danh'];
        }

        // Delete the class
        $sql = "DELETE FROM classes WHERE ClassID = :id";
        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([':id' => $id]);

        if ($result) {
            $conn->commit();
            return ['status' => 'success', 'message' => 'Xóa lớp thành công'];
        } else {
            $conn->rollBack();
            return ['status' => 'error', 'message' => 'Xóa lớp thất bại'];
        }
    } catch (Exception $e) {
        if (isset($conn)) {
            $conn->rollBack();
        }
        error_log("Error in deleteClass: " . $e->getMessage());
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}
