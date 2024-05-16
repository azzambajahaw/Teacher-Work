<?php
include 'db_connect.php';

// استعداد الاستعلام لاسترجاع جميع المنتجات
$sql = "SELECT * FROM lessons";
$result = $conn->query($sql);

// التحقق من وجود نتائج
if ($result->num_rows > 0) {
    $products = array();
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
    // إرجاع بيانات المنتجات بتنسيق JSON
    echo json_encode($products);
} else {
    echo "لا يوجد منتجات متاحة";
}

// إغلاق الاتصال بقاعدة البيانات
$conn->close();

?>


