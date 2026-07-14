<?php
session_start();
include("db_connect.php");

if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}

$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];
$stock = $_POST['stock'];
$description = $_POST['description'];

/* Check if new image uploaded */
if (!empty($_FILES['image']['name'])) {

    $image = time() . "_" . $_FILES['image']['name'];
    $tmp = $_FILES['image']['tmp_name'];

    move_uploaded_file($tmp, "../uploads/" . $image);

    $sql = "UPDATE medicines 
            SET name=?, price=?, stock=?, description=?, image=? 
            WHERE id=?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sdis si", $name, $price, $stock, $description, $image, $id);

} else {

    $sql = "UPDATE medicines 
            SET name=?, price=?, stock=?, description=? 
            WHERE id=?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sdisi", $name, $price, $stock, $description, $id);
}

$stmt->execute();

header("Location: admin_manage_medicine.php");
?>