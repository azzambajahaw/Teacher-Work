<?php
include 'db_connect.php';

// استقبال بيانات تسجيل الدخول
$username = $_POST['username'];
$password = $_POST['password'];

// استعداد الاستعلام لاستعادة بيانات المستخدم من قاعدة البيانات
$sql = "SELECT * FROM users WHERE UserName = '$username'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['Userpassword'])) {
        // تم تسجيل الدخول بنجاح
        http_response_code(200); // Return 200 for success
        echo json_encode(array("message" => "تم تسجيل الدخول بنجاح"));
    } else {
        // كلمة المرور غير صحيحة
        http_response_code(401); // Return 401 for unauthorized
        echo json_encode(array("message" => "كلمة المرور غير صحيحة"));
    }
} else {
    // اسم المستخدم غير موجود
    http_response_code(401); // Return 401 for unauthorized
    echo json_encode(array("message" => "اسم المستخدم غير موجود"));
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();
?>
