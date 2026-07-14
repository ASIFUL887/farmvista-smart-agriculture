<?php
session_start();
include("db_connect.php");

if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}

$id = $_GET['id'];

$result = $conn->query("SELECT * FROM medicines WHERE id=$id");
$row = $result->fetch_assoc();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Medicine</title>
    <link rel="stylesheet" href="admin.css">
</head>
<body>

<div class="container">

<h2>Edit Medicine</h2>

<form action="admin_update_medicine.php" method="POST" enctype="multipart/form-data">

    <input type="hidden" name="id" value="<?php echo $row['id']; ?>">

    <input type="text" name="name" value="<?php echo $row['name']; ?>" required><br><br>

    <input type="number" name="price" value="<?php echo $row['price']; ?>" required><br><br>

    <input type="number" name="stock" value="<?php echo $row['stock']; ?>" required><br><br>

    <p>Current Image:</p>
    <img src="uploads/<?php echo $row['image']; ?>" width="80"><br><br>

    <input type="file" name="image"><br><br>

    <textarea name="description"><?php echo $row['description']; ?></textarea><br><br>

    <button type="submit">Update Medicine</button>

</form>

</div>

</body>
</html>