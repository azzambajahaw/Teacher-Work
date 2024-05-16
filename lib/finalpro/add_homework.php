<?php
include 'db_connect.php';

// استقبال بيانات المنتج الجديد$
$HomeWorkTitle = $_POST['HomeWorkTitle'];
$HomeWorkText = $_POST['HomeWorkText'];
$HomeWorkDedline = $_POST['HomeWorkDedline'];
//$HomeWorkDate = $_POST['HomeWorkDate'];
$HomeWorkDegree = $_POST['HomeWorkDegree'];

// استعداد الاستعلام لإضافة المنتج الجديد إلى قاعدة البيانات
$sql = "INSERT INTO homeworks (HomeWorkTitle, HomeWorkText, HomeWorkDedline,  HomeWorkDegree) VALUES ('$HomeWorkTitle', '$HomeWorkText', '$HomeWorkDedline', '$HomeWorkDegree')";
//$sql = "INSERT INTO homeworks (HomeWorkTitle) VALUE ('$HomeWorkTitle')";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    echo "تم إضافة المنتج بنجاح";
} else {
    echo "خطأ في إضافة المنتج: " . $conn->error;
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>
