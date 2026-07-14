<?php
session_start();
include("db_connect.php");

/* Fetch active farms */
$sql = "SELECT * FROM farms WHERE status='Active' ORDER BY id DESC";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Buy Farms & Medicine</title>
    <link rel="stylesheet" href="farms.css">
</head>

<body>

<div class="container">

    <h2>Buy Farms & Medicine</h2>

    <!-- Tabs -->
    <div class="tabs">
        <button class="tab active">All Farms</button>
        <button class="tab">Medicine</button>
    </div>

    <!-- Farm List -->
    <?php while($row = $result->fetch_assoc()): ?>

    <div class="farm-card">

        <!-- LEFT IMAGE -->
        <div class="farm-img-box">
            <img src="uploads/<?php echo $row['image'] ?: 'default.png'; ?>">
        </div>

        <!-- DETAILS -->
        <div class="farm-info">
            <h3><?php echo htmlspecialchars($row['crop_name']); ?></h3>

            <p>Type: <?php echo $row['farm_type']; ?></p>

            <p>Available: <?php echo $row['farm_weight']; ?></p>
        </div>

        <!-- ORDER BUTTON -->
        <div class="farm-action">
            <a href="book_farm.php?id=<?php echo $row['id']; ?>">
                <button>Order</button>
            </a>
        </div>

    </div>

    <?php endwhile; ?>

</div>

</body>
</html>