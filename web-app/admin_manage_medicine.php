<?php
session_start();
include("db_connect.php");

/* Security */
if (!isset($_SESSION['role']) || $_SESSION['role'] != 'admin') {
    die("Access Denied");
}

/* Fetch medicines */
$result = $conn->query("SELECT * FROM medicines ORDER BY id DESC");
?>

<!DOCTYPE html>
<html>

<head>
    <title>Manage Medicine</title>
    <link rel="stylesheet" href="admin.css">
</head>

<body>

<div class="container">

    <!-- HEADER -->
    <div class="header">
        <h2>💊 Manage Medicine</h2>

        <!-- BACK BUTTON -->
        <a href="admin_dashboard.php" class="back-btn">⬅ Back</a>
    </div>

    <!-- MEDICINE LIST -->
    <?php while ($row = $result->fetch_assoc()) { ?>

        <div class="card">

            <div class="info">
                <strong><?php echo $row['name']; ?></strong><br>
                ৳<?php echo $row['price']; ?><br>

                <?php if ($row['stock'] > 0) { ?>
                    <span class="stock">Stock: <?php echo $row['stock']; ?></span>
                <?php } else { ?>
                    <span class="out">Out of Stock</span>
                <?php } ?>
            </div>

            <div class="actions">
                <a href="admin_edit_medicine.php?id=<?php echo $row['id']; ?>" class="edit">✏️ Edit</a>

                <a href="admin_delete_medicine.php?id=<?php echo $row['id']; ?>"
                   class="delete"
                   onclick="return confirm('Delete this medicine?')">
                   ❌ Delete
                </a>
            </div>

        </div>

    <?php } ?>

</div>

</body>

</html>