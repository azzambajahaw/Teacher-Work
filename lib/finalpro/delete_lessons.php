<?php
include 'db_connect.php';

// استقبال بيانات عنوان الدرس المراد حذفه
$lessonTitle = $_POST['LessonTitle'];

// استعداد الاستعلام لحذف الدرس بناءً على عنوانه
$sql = "DELETE FROM lessons WHERE LessonTitle = '$lessonTitle'";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    // تم حذف الدرس بنجاح
    http_response_code(200); // إرجاع 200 للنجاح
    echo json_encode(array("message" => "تم حذف الدرس بنجاح"));
} else {
    // فشل حذف الدرس
    http_response_code(400); // إرجاع 400 للخطأ
    echo json_encode(array("message" => "خطأ في حذف الدرس: " . $conn->error));
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();
?>
