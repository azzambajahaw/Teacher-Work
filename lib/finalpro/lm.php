<?php
$db = mysqli_connect('localhost', 'root', '', 'userdata');
if ($db === false) {
    die("ERROR: Could not connect. " . mysqli_connect_error());
}

$name = htmlspecialchars(strip_tags($_POST['name']));
$price = htmlspecialchars(strip_tags($_POST['price']));
$description = htmlspecialchars(strip_tags($_POST['description']));
$userid = htmlspecialchars(strip_tags($_POST['user']));
$image = imageUpload("file");

if ($image != 'fail'){
    $stm = $db->prepare("INSERT INTO `pro`(`name`, `price`, `description`, `image`, `user`)
    VALUES (?, ?, ?, ?, ?)");
    if ($stm === false) {
        die("ERROR: Could not prepare statement.");
    }

    $stm->bind_param("sssss", $name, $price, $description, $image, $userid);
    $stm->execute();
    $count = mysqli_stmt_affected_rows($stm);
    if($count > 0){
        echo json_encode(array("status" => "$image"));
    } else {
        echo json_encode(array("status" => "fail"));
    }
} else {
    echo json_encode(array("status" => "fail"));
}

function imageUpload($imageRequest)
{
    global $msgError;
    $imagename = $_FILES[$imageRequest]['name'];
    $imagetmp = $_FILES[$imageRequest]['tmp_name'];
    $imagesize = $_FILES[$imageRequest]['size'];
    $Extensions = array("jpg", "png", "gif", "jpeg", "php");
    $Image_array = explode(".", $imagename);
    $ext = strtolower(end($Image_array));

    if (!empty($imagename) && !in_array($ext, $Extensions)) {
        $msgError = "fail";
    }

    if (empty($msgError)) {
        if (move_uploaded_file($imagetmp, "C:/xampp/htdocs/abeer/product/images/$imagename")) {
            return $imagename;
        }
    } else {
        echo "<pre>";
        print_r($msgError);
        echo "</pre>";
        return $msgError;
    }
}
?>
