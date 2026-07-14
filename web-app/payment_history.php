<?php
session_start();
include("db_connect.php");

// ইউজার লগইন না থাকলে লগইন পেজে পাঠিয়ে দিবে
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$my_id = $_SESSION['user_id'];
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Payment History | FarmVista</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f7f6;
            padding: 20px;
        }

        .history-container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #2e7d32;
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th,
        td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            color: #333;
        }

        .status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .pending {
            background: #fff3e0;
            color: #ef6c00;
        }

        .approved {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .rejected {
            background: #ffebee;
            color: #c62828;
        }

        .no-data {
            text-align: center;
            padding: 20px;
            color: #888;
        }
    </style>
</head>

<body>

    <div class="history-container">
        <h2>My Payment History</h2>

        <table>
            <thead>
                <tr>
                    <th>Method</th>
                    <th>Amount</th>
                    <th>Transaction ID</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php
                // ডাটাবেস থেকে পেমেন্ট লিস্ট আনা হচ্ছে
                $res = $conn->query("SELECT * FROM payments WHERE user_id = '$my_id' ORDER BY id DESC");

                if ($res->num_rows > 0) {
                    while ($row = $res->fetch_assoc()) {
                        $statusClass = strtolower($row['status']); // pending, approved, or rejected
                ?>
                        <tr>
                            <td><strong><?php echo ucfirst($row['method']); ?></strong></td>
                            <td><?php echo number_format($row['amount'], 2); ?> BDT</td>
                            <td><code><?php echo htmlspecialchars($row['trx_id']); ?></code></td>
                            <td><?php echo date('d M, Y', strtotime($row['created_at'])); ?></td>
                            <td>
                                <span class="status <?php echo $statusClass; ?>">
                                    <?php echo ucfirst($row['status']); ?>
                                </span>
                            </td>
                        </tr>
                <?php
                    }
                } else {
                    echo "<tr><td colspan='5' class='no-data'>No payments found.</td></tr>";
                }
                ?>
            </tbody>
        </table>

        <div style="margin-top: 20px; text-align: center;">
            <a href="payment.php" style="color: #2e7d32; text-decoration: none; font-weight: bold;">+ Make New Payment</a>
        </div>
    </div>

</body>

</html>