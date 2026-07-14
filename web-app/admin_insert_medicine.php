<?php
session_start();
include("db_connect.php");

if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}

$name = $_POST['name'];
$price = $_POST['price'];
$stock = $_POST['stock'];
$description = $_POST['description'];

/* Image Upload */
$image = $_FILES['image']['name'];
$tmp = $_FILES['image']['tmp_name'];

move_uploaded_file($tmp, "uploads/" . $image);

/* Insert */
$stmt = $conn->prepare("
    INSERT INTO medicines (name, price, image, stock, description)
    VALUES (?, ?, ?, ?, ?)
");

$stmt->bind_param("sdsis", $name, $price, $image, $stock, $description);
$stmt->execute();

header("Location: admin_manage_medicine.php");
?>