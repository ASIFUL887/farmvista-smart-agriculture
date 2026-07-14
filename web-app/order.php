<?php
include 'db_connect.php';

$medicine_id = intval($_POST['medicine_id']);
$quantity = intval($_POST['quantity']);

// Get current stock
$result = $conn->query("SELECT stock FROM medicines WHERE id = $medicine_id");
$row = $result->fetch_assoc();

if ($row['stock'] < $quantity) {
    die("Not enough stock available");
}

// Update stock
$conn->query("UPDATE medicines SET stock = stock - $quantity WHERE id = $medicine_id");

echo "Order placed successfully!";
?>