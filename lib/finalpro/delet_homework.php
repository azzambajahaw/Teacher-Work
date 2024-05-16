<?php
include 'db_connect.php';

// استقبال بيانات عنوان الدرس المراد حذفه
$HomeWorkTitle = $_POST['HomeWorkTitle'];

// استعداد الاستعلام لحذف الدرس بناءً على عنوانه
$sql = "DELETE FROM homeworks WHERE HomeWorkTitle = '$HomeWorkTitle'";

// تنفيذ الاستعلام
if ($conn->query($sql) === TRUE) {
    // تم حذف الدرس بنجاح
    http_response_code(200); // إرجاع 200 للنجاح
    echo json_encode(array("message" => "تم حذف الواجب بنجاح"));
} else {
    // فشل حذف الدرس
    http_response_code(400); // إرجاع 400 للخطأ
    echo json_encode(array("message" => "خطأ في حذف السؤال: " . $conn->error));
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();
?>
