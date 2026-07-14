<?php
session_start();
include("db_connect.php");

if ($_SESSION['role'] != 'admin') {
    die("Access Denied");
}
?>

<!DOCTYPE html>
<html>

<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="admin.css">
</head>

<body>

    <div class="container">

        <h2>⚙️ Admin Dashboard</h2>

        <div class="cards">

            <a href="admin_add_medicine.php" class="card">
                ➕ Add Medicine
            </a>

            <a href="admin_manage_medicine.php" class="card">
                📋 Manage Medicine
            </a>

            <!-- 🔥 NEW: Payment Approval -->
            <a href="admin_payments.php" class="card highlight">
                💳 Payment Approval
            </a>

        </div>


        <a href="dashboard.php" class="back">⬅ Back to User Panel</a>

    </div>

</body>

</html>