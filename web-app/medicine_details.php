<?php
session_start();
include("db_connect.php"); //

// ইউআরএল থেকে মেডিসিন আইডি নেওয়া
if (isset($_GET['id'])) {
    $id = $_GET['id'];
    $result = $conn->query("SELECT * FROM medicines WHERE id = $id"); //
    $row = $result->fetch_assoc();
} else {
    header("Location: medicine.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Medicine Details | FarmVista</title>
    <link rel="stylesheet" href="medicine.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 20px;
        }

        .details-container {
            max-width: 450px;
            margin: auto;
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .header {
            background: #2e7d32;
            color: white;
            padding: 15px;
            text-align: center;
        }

        .image-box {
            background: #eee;
            padding: 20px;
            text-align: center;
        }

        .image-box img {
            max-width: 150px;
            border-radius: 10px;
        }

        .info {
            padding: 20px;
        }

        .price-tag {
            color: #2e7d32;
            font-weight: bold;
            font-size: 18px;
        }

        /* Quantity Selector Design (Figma Style) */
        .qty-control {
            display: flex;
            align-items: center;
            justify-content: space-around;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
        }

        .qty-btn {
            background: #e8f5e9;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-size: 24px;
            color: #2e7d32;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
        }

        .qty-btn:hover {
            background: #2e7d32;
            color: white;
        }

        #qty-val {
            font-size: 28px;
            font-weight: bold;
        }

        .total-info {
            text-align: center;
            font-size: 14px;
            color: #666;
        }

        .next-btn {
            display: block;
            width: 90%;
            margin: 20px auto;
            padding: 15px;
            background: #2e7d32;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 12px;
            font-weight: bold;
            font-size: 18px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>

<body>

    <div class="details-container">
        <div class="header">
            <h2 style="margin:0;">Medicine Details</h2>
        </div>

        <div class="image-box">
            <img src="uploads/<?php echo $row['image']; ?>" alt="">
        </div>

        <div class="info">
            <p style="color: grey; margin: 0; font-size: 12px;">Hemayetpur, Savar, Dhaka</p>
            <h2 style="margin: 5px 0;"><?php echo $row['name']; ?></h2>
            <p class="price-tag">৳<?php echo $row['price']; ?> <span style="font-size: 12px; color: grey;">/pics</span></p>

            <p style="text-align:center; font-size: 12px; color: #2e7d32;">
                Maximum: <?php echo $row['stock']; ?> pics<br>
                Remaining: <?php echo $row['stock']; ?>
            </p>

            <div class="qty-control">
                <button class="qty-btn" onclick="updateQty(-1)">−</button>
                <div id="qty-val">1</div>
                <button class="qty-btn" onclick="updateQty(1)">+</button>
            </div>

            <div class="total-info">
                <strong id="display-total"><?php echo $row['price']; ?></strong> BDT<br>
                <span style="font-size: 10px;">Total payable amount</span>
            </div>

            <button class="next-btn" onclick="goToPayment()">Next</button>
        </div>
    </div>

    <script>
        let unitPrice = <?php echo $row['price']; ?>;
        let maxStock = <?php echo $row['stock']; ?>;
        let currentQty = 1;

        function updateQty(val) {
            currentQty += val;

            // স্টক লিমিট এবং মিনিমাম লিমিট চেক
            if (currentQty < 1) currentQty = 1;
            if (currentQty > maxStock) currentQty = maxStock;

            // ভ্যালু আপডেট
            document.getElementById('qty-val').innerText = currentQty;

            // রিয়েল-টাইম টোটাল প্রাইস ক্যালকুলেশন
            let total = (unitPrice * currentQty).toFixed(2);
            document.getElementById('display-total').innerText = total;
        }

        function goToPayment() {
            // ID, Price এবং Quantity নিয়ে পেমেন্ট পেজে রিডাইরেক্ট
            window.location.href = `payment_checkout.php?medicine_id=<?php echo $row['id']; ?>&price=${unitPrice}&qty=${currentQty}`;
        }
    </script>

</body>

</html>