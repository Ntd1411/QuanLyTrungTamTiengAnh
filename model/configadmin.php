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

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if ($checkStmt->fetchColumn() > 0) {
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

        // Lấy UserID của học sinh vừa thêm
        $userId = $conn->query("SELECT UserID FROM users WHERE Username = '$username'")->fetch(PDO::FETCH_COLUMN);

        // Cập nhật ClassID nếu có
        if ($classId != "") {
            $updateSql = "UPDATE students SET ClassID = :classId WHERE UserID = :userId";
            $updateStmt = $conn->prepare($updateSql);
            $updateStmt->execute([
                ':classId' => $classId,
                ':userId' => $userId
            ]);
        }

        // Cập nhật giảm giá học phí
        if ($classId != "") {
            $updateSql = "UPDATE tuition SET Discount = :discount 
                         WHERE StudentID = :userId AND Status = 'Chưa đóng'";
            $updateStmt = $conn->prepare($updateSql);
            $updateStmt->execute([
                ':discount' => $discount,
                ':userId' => $userId
            ]);
        }

        // Thêm mối quan hệ phụ huynh - học sinh nếu có
        if (!empty($parentIds) && is_array($parentIds)) {
            $insertKeySql = "INSERT INTO student_parent_keys (student_id, parent_id) VALUES (:studentId, :parentId)";
            $keyStmt = $conn->prepare($insertKeySql);

            foreach ($parentIds as $parentId) {
                if (!empty($parentId)) {
                    $keyStmt->execute([
                        ':studentId' => $userId,
                        ':parentId' => $parentId
                    ]);
                }
            }
        }

        return ['status' => 'success', 'message' => 'Thêm học sinh thành công'];
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


function addParent($fullname, $birthdate, $gender, $username, $password, $email, $phone, $zalo, $isShowTeacher) {
    try {
        $conn = connectdb();
        error_log("addParent params: $fullname, $birthdate, $gender, $username, $email, $phone, $zalo, $isShowTeacher");

        // Kiểm tra username đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM users WHERE Username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':username' => $username]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Tên đăng nhập đã tồn tại'];
        }

        // Thêm phụ huynh dùng stored procedure
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
            // Cập nhật Zalo và isShowTeacher
            $updateSql = "UPDATE parents SET ZaloID = :zalo, isShowTeacher = :isShow WHERE UserID = :userId";
            $updateStmt = $conn->prepare($updateSql);
            $updateStmt->execute([
                ':zalo' => $zalo,
                ':isShow' => $isShowTeacher,
                ':userId' => $userId
            ]);

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
    }
}

function updateStudent($data)
{
    try {
        $conn = connectdb();
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
            ':classId' => $data['classId']
        ]);

        // Update tuition discount
        $updateDiscountSql = "UPDATE tuition SET Discount = :discount 
                            WHERE StudentID = :studentId AND Status = 'Chưa đóng'";
        $updateDiscountStmt = $conn->prepare($updateDiscountSql);
        $updateDiscountStmt->execute([
            ':discount' => $data['studentDiscount'],
            ':studentId' => $data['id']
        ]);

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
                $insertStmt->execute([
                    ':studentId' => $data['id'],
                    ':parentId' => $parentId
                ]);
            }
        }


        return ['status' => 'success', 'message' => 'Cập nhật học sinh thành công'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

function updateParent($data) {
    try {
        $conn = connectdb();
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
    }
}

function deleteTeacher($id)
{
    try {
        $conn = connectdb();

        // Check if teacher has classes
        $checkClassesSql = "SELECT COUNT(*) FROM classes WHERE TeacherID = ? AND Status = 'Đang hoạt động'";
        $checkStmt = $conn->prepare($checkClassesSql);
        $checkStmt->execute([$id]);
        if ($checkStmt->fetchColumn() > 0) {
            return ['status' => 'error', 'message' => 'Không thể xóa giáo viên đang phụ trách lớp'];
        }

        // Call the stored procedure
        $sql = "CALL DeleteTeacher(?)";
        $stmt = $conn->prepare($sql);
        $result = $stmt->execute([$id]);

        if ($result) {
            return ['status' => 'success', 'message' => 'Xóa giáo viên thành công'];
        } else {
            return ['status' => 'error', 'message' => 'Xóa giáo viên thất bại'];
        }
    } catch (PDOException $e) {
        error_log("Error in deleteTeacher: " . $e->getMessage());
        return ['status' => 'error', 'message' => 'Không thể xóa giáo viên: ' . $e->getMessage()];
    }
}

function deleteStudent($id)
{
    try {
        $conn = connectdb();


        try {
            // Delete attendance records first
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

function deleteParent($id) {
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
