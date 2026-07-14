<?php
session_start();
if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Add Medicine</title>
    <link rel="stylesheet" href="admin.css">
</head>
<body>

<div class="container">

<h2>Add Medicine</h2>

<form action="admin_insert_medicine.php" method="POST" enctype="multipart/form-data">

    <input type="text" name="name" placeholder="Medicine Name" required><br><br>
    <input type="number" name="price" placeholder="Price" required><br><br>
    <input type="number" name="stock" placeholder="Stock" required><br><br>

    <input type="file" name="image" required><br><br>

    <textarea name="description" placeholder="Description"></textarea><br><br>

    <button type="submit">Add Medicine</button>

</form>

</div>

</body>
</html>