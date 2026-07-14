<?php
session_start();
include("db_connect.php");

if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}

$id = $_GET['id'];

$conn->query("DELETE FROM medicines WHERE id=$id");

header("Location: admin_manage_medicine.php");
?>