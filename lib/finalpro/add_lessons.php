<?php
include 'db_connect.php';

// استقبال بيانات المنتج الجديد
$LessonTitle = $_POST['LessonTitle'];
$LessonFile = $_POST['LessonFile'];
$Lessonlink = $_POST['Lessonlink'];
//$LessonDate = $_POST['LessonDate'];


// استعداد الاستعلام لإضافة المنتج الجديد إلى قاعدة البيانات
$sql = "INSERT INTO lessons (LessonTitle, LessonFile, Lessonlink ) VALUES ('$LessonTitle', '$LessonFile', '$Lessonlink')";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    echo "تم إضافة المنتج بنجاح";
} else {
    echo "خطأ في إضافة المنتج: " . $conn->error;
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>
