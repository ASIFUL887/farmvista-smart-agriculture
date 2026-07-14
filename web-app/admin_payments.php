<?php
session_start();
include("db_connect.php");

// এডমিন ভেরিফিকেশন (ঐচ্ছিক: আপনার প্রজেক্টে এডমিন রোল থাকলে সেটি এখানে চেক করবেন)
// if ($_SESSION['role'] != 'admin') { exit('Access Denied'); }

// ১. পেমেন্ট এপ্রুভ বা রিজেক্ট করার লজিক
if (isset($_GET['action']) && isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    $action = $_GET['action'];
    $status = ($action == 'approve') ? 'approved' : 'rejected';

    $sql = "UPDATE payments SET status = '$status' WHERE id = $id";
    if ($conn->query($sql)) {
        header("Location: admin_payments.php?msg=Payment $status successfully");
        exit();
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Payments | FarmVista</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }

        .admin-container {
            max-width: 1000px;
            margin: 0 auto;
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #2e7d32;
            border-bottom: 3px solid #2e7d32;
            padding-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th,
        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #2e7d32;
            color: white;
        }

        .btn {
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            margin-right: 5px;
        }

        .btn-approve {
            background: #4caf50;
            color: white;
        }

        .btn-reject {
            background: #f44336;
            color: white;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: bold;
        }

        .st-pending {
            background: #ffe0b2;
            color: #e65100;
        }

        .st-approved {
            background: #c8e6c9;
            color: #2e7d32;
        }
    </style>
</head>

<body>

    <div class="admin-container">
        <h2>Admin - User Payment Requests</h2>

        <?php if (isset($_GET['msg'])) echo "<p style='color:green; font-weight:bold;'>" . $_GET['msg'] . "</p>"; ?>

        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Method</th>
                    <th>Amount</th>
                    <th>TrxID & Phone</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php
                // সব পেমেন্ট ডাটা আনা হচ্ছে (ইউজারের নাম সহ জয়েন করা যেতে পারে)
                $sql = "SELECT p.*, (SELECT fullname FROM users WHERE id = p.user_id) as user_name FROM payments p ORDER BY p.id DESC";
                $res = $conn->query($sql);

                if ($res->num_rows > 0) {
                    while ($row = $res->fetch_assoc()) {
                ?>
                        <tr>
                            <td><strong><?php echo $row['user_name'] ?? 'User #' . $row['user_id']; ?></strong></td>
                            <td><?php echo strtoupper($row['method']); ?></td>
                            <td><?php echo $row['amount']; ?> BDT</td>
                            <td>
                                <small>TrxID: <?php echo $row['trx_id']; ?></small><br>
                                <small>Phone: <?php echo $row['phone_number']; ?></small>
                            </td>
                            <td>
                                <span class="status-badge st-<?php echo $row['status']; ?>">
                                    <?php echo ucfirst($row['status']); ?>
                                </span>
                            </td>
                            <td>
                                <?php if ($row['status'] == 'pending'): ?>
                                    <a href="admin_payments.php?action=approve&id=<?php echo $row['id']; ?>" class="btn btn-approve">Approve</a>
                                    <a href="admin_payments.php?action=reject&id=<?php echo $row['id']; ?>" class="btn btn-reject">Reject</a>
                                <?php else: ?>
                                    <span style="color:#888;">No Action</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                <?php
                    }
                } else {
                    echo "<tr><td colspan='6' style='text-align:center;'>No payment requests found.</td></tr>";
                }
                ?>
            </tbody>
        </table>
    </div>

</body>

</html>