<?php
session_start();
include("db_connect.php");
$id = $_GET['id'];
$agro = $conn->query("SELECT * FROM agronomist WHERE id=$id")->fetch_assoc();
?>
<!DOCTYPE html>
<html>

<head>
    <style>
        body {
            background: #e8f5e9;
            font-family: sans-serif;
            padding: 0;
            margin: 0;
        }

        .top-bar {
            padding: 20px;
            display: flex;
            align-items: center;
        }

        .back-btn {
            font-size: 24px;
            cursor: pointer;
            margin-right: 20px;
        }

        .profile-header {
            text-align: center;
            padding: 20px;
        }

        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 12px;
            background: #ddd;
            margin: 0 auto 15px;
            border: 4px solid white;
        }

        .stats-row {
            display: flex;
            justify-content: center;
            gap: 10px;
            font-size: 12px;
            color: #666;
        }

        .content-body {
            background: white;
            border-radius: 30px 30px 0 0;
            padding: 30px;
            min-height: 50vh;
        }

        .about h3 {
            margin-bottom: 10px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            color: #444;
        }

        .chat-float {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #2e7d32;
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>

<body>
    <div class="top-bar"><span class="back-btn" onclick="history.back()">❮</span>
        <h2>Doctor Detail</h2>
    </div>
    <div class="profile-header">
        <div class="profile-img"></div>
        <h3>Dr. <?php echo $agro['fullname']; ?></h3>
        <p style="color: #666;">Fish Doctor | Online</p>
        <div class="stats-row"><span>⭐ 4.7</span> <span>📍 Dhaka</span></div>
    </div>
    <div class="content-body">
        <div class="about">
            <h3>About</h3>
            <p color="#888">Experienced specialist in fish diseases and pond management. Available for online consultation.</p>
        </div>
        <div class="info-item">📧 <?php echo $agro['contact']; ?></div>
        <div class="info-item">📞 +8801XXXXXXXXX</div>
        <div class="chat-float" onclick="location.href='chat.php?receiver_id=<?php echo $id; ?>'">💬</div>
    </div>
</body>

</html>