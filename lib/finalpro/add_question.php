<?php
include 'db_connect.php';

// استقبال بيانات المنتج الجديد$
$StudentQeustionText = $_POST['StudentQeustionText'];
$StdentName = $_POST['StdentName'];


// استعداد الاستعلام لإضافة المنتج الجديد إلى قاعدة البيانات
$sql = "INSERT INTO StudentQeustions (StudentQeustionText,StdentName) VALUES ('$StudentQeustionText', '$StdentName')";
//$sql = "INSERT INTO homeworks (HomeWorkTitle) VALUE ('$HomeWorkTitle')";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    echo "تم إضافة السؤال بنجاح";
} else {
    echo "خطأ في إضافة السؤال: " . $conn->error;
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>
