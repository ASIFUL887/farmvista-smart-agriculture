<?php
session_start();
include("db_connect.php"); //

/* Fetch medicines */
$sql = "SELECT * FROM medicines ORDER BY id DESC"; //
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Medicine Shop | FarmVista</title>
    <link rel="stylesheet" href="medicine.css">
    <style>
        .qty-input {
            width: 60px;
            padding: 5px;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-right: 10px;
        }

        .order-section {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }
    </style>
</head>

<body>

    <div class="container">
        <h2>Buy Farms & Medicine</h2>

        <div class="tabs">
            <a href="farms.php">All Farms</a>
            <a href="#" class="active">Medicine</a>
        </div>

        <div class="medicine-list">
            <?php while ($row = $result->fetch_assoc()) { ?>
                <div class="card">
                    <div class="image">
                        <img src="uploads/<?php echo $row['image']; ?>" alt="">
                    </div>

                    <div class="details">
                        <h3><?php echo $row['name']; ?></h3>
                        <p class="price">Price: ৳<?php echo $row['price']; ?></p>
                        <p class="stock">Available: <strong><?php echo $row['stock']; ?></strong></p>
                    </div>

                    <div class="actions">
                        <div class="order-section">
                            <label>Qty:</label>
                            <input type="number" id="qty_<?php echo $row['id']; ?>" class="qty-input" value="1" min="1" max="<?php echo $row['stock']; ?>">

                            <button class="order-btn" onclick="orderNow(<?php echo $row['id']; ?>, <?php echo $row['price']; ?>)">Order Now</button>
                        </div>
                    </div>
                </div>
            <?php } ?>
        </div>
    </div>

    <script>
        function orderNow(id, price) {
            let qty = document.getElementById('qty_' + id).value;
            // Redirect with ID, Price, and Quantity
            window.location.href = `payment_checkout.php?medicine_id=${id}&price=${price}&qty=${qty}`;
        }
    </script>

</body>

</html>