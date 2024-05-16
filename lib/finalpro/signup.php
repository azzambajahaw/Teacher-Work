<?php
include 'db_connect.php';

// استقبال بيانات الحساب
$username = $_POST['username'];
$password = $_POST['password'];


// تشفير كلمة المرور
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// استعداد الاستعلام لإضافة حساب جديد إلى قاعدة البيانات
$sql = "INSERT INTO users (UserName, UserPassword, UserRole) VALUES ('$username', '$hashed_password' , 'Student')";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    echo "تم إنشاء الحساب بنجاح";
} else {
    echo "خطأ في إنشاء الحساب: " . $conn->error;
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>
