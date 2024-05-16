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
        echo "تم تسجيل الدخول بنجاح";
    } else {
        echo "كلمة المرور أو اسم المستخدم غير صحيح";
    }
} else {
    echo "كلمة المرور أو اسم المستخدم غير صحيح";
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>




