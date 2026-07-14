<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'agronomist') {
    header("Location: login.php");
    exit();
}

$my_id = $_SESSION['user_id'];

// যারা মেসেজ দিয়েছে তাদের ইউনিক লিস্ট এবং অপঠিত মেসেজ সংখ্যা আনা
$sql = "SELECT DISTINCT sender_id, 
        (SELECT fullname FROM farmer WHERE id = messages.sender_id) as farmer_name,
        (SELECT COUNT(*) FROM messages WHERE sender_id = m.sender_id AND receiver_id = $my_id AND is_read = 0) as unread_count
        FROM messages m WHERE receiver_id = $my_id ORDER BY created_at DESC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Expert Inbox | FarmVista</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }

        .inbox-list {
            max-width: 600px;
            margin: 0 auto;
        }

        .inbox-card {
            background: white;
            padding: 20px;
            margin-bottom: 12px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: 0.3s;
            border-left: 5px solid transparent;
        }

        .inbox-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .unread {
            border-left-color: #ff5252;
            background: #fff8f8;
        }

        .badge {
            background: #ff5252;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .farmer-name {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <div class="inbox-list">
        <h2 style="color: #2e7d32;">📥 Farmer Messages</h2>
        <?php if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) { ?>
                <div class="inbox-card <?php echo $row['unread_count'] > 0 ? 'unread' : ''; ?>" onclick="location.href='chat.php?receiver_id=<?php echo $row['sender_id']; ?>'">
                    <span class="farmer-name">👨‍🌾 <?php echo htmlspecialchars($row['farmer_name'] ?? "User #" . $row['sender_id']); ?></span>
                    <?php if ($row['unread_count'] > 0) { ?>
                        <span class="badge"><?php echo $row['unread_count']; ?> New</span>
                    <?php } ?>
                </div>
        <?php }
        } else {
            echo "<div class='inbox-card'>আপনার কাছে কোনো মেসেজ নেই।</div>";
        } ?>
    </div>
</body>

</html>