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

function showOptionTeacherName() {
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


function addClass($className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room) {
    try {
        $conn = connectdb();
        error_log("Adding class: $className, $schoolYear, $teacherId, $startDate, $endDate, $classTime, $room");
        
        // Kiểm tra xem lớp đã tồn tại chưa
        $checkSql = "SELECT COUNT(*) FROM classes WHERE ClassName = :className";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':className' => $className]);
        if($checkStmt->fetchColumn() > 0) {
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

        if($result) {
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

function getDataFromTable($table) {
    try {
        $conn = connectdb();
        $sql = "SELECT * FROM " .$table. "";
        
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

function getTeacherName($id) {
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
