<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$my_id = $_SESSION['user_id'];

if (isset($_POST['follow_id'])) {
    $f_id = $_POST['follow_id'];
    $conn->query("INSERT IGNORE INTO followers (user_id, agronomist_id) VALUES ($my_id, $f_id)");
    echo "success";
    exit;
}
?>
<!DOCTYPE html>
<html>

<head>
    <title>Agronomists | FarmVista</title>
    <style>
        body {
            background: #e8f5e9;
            font-family: sans-serif;
            margin: 0;
        }

        .hero {
            background: #2e7d32;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .container {
            padding: 15px;
        }

        .notif-bar {
            display: none;
            background: #ff5252;
            color: white;
            text-align: center;
            padding: 12px;
            cursor: pointer;
            font-weight: bold;
        }

        .agro-card {
            background: white;
            border-radius: 12px;
            padding: 15px;
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .img-box {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: #ddd;
            margin-right: 15px;
            overflow: hidden;
        }

        .img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .info {
            flex: 1;
        }

        .info h4 {
            margin: 0;
            color: #333;
            cursor: pointer;
        }

        .btn-inbox {
            background: #2e7d32;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin: 10px;
        }
    </style>
</head>

<body>
    <div id="notif-banner" style="display:none; background:#ff5252; color:white; text-align:center; padding:12px; cursor:pointer; font-weight:bold; position: sticky; top: 0; z-index: 9999; box-shadow: 0 4px 6px rgba(0,0,0,0.1);" onclick="handleInboxRedirect()">
        🔔 <span id="notif-msg">আপনার কাছে নতুন মেসেজ এসেছে!</span> (<span id="notif-count">0</span>)
    </div>

    <script>
        function startNotificationSync() {
            fetch('check_notifications.php')
                .then(res => res.json())
                .then(data => {
                    const banner = document.getElementById('notif-banner');
                    const countSpan = document.getElementById('notif-count');
                    const msgSpan = document.getElementById('notif-msg');

                    if (data.unread_count > 0) {
                        banner.style.display = 'block';
                        countSpan.innerText = data.unread_count;

                        // ইউজারের রোল অনুযায়ী মেসেজ কাস্টমাইজ করা
                        const userRole = "<?php echo $_SESSION['role']; ?>";
                        if (userRole === 'agronomist') {
                            msgSpan.innerText = "কৃষক থেকে নতুন মেসেজ এসেছে!";
                        } else {
                            msgSpan.innerText = "বিশেষজ্ঞ থেকে নতুন উত্তর এসেছে!";
                        }
                    } else {
                        banner.style.display = 'none';
                    }
                })
                .catch(err => console.error("Notification Sync Failed:", err));
        }

        function handleInboxRedirect() {
            const role = "<?php echo $_SESSION['role']; ?>";
            if (role === 'agronomist') {
                window.location.href = 'agronomist_inbox.php'; // এগ্রোনোমিস্ট যাবে তার ইনবক্সে
            } else {
                window.location.href = 'agronomist.php'; // কৃষক যাবে বিশেষজ্ঞ লিস্টে
            }
        }

        // প্রতি ৫ সেকেন্ড পর পর অটোমেটিক নতুন মেসেজ চেক করবে
        setInterval(startNotificationSync, 5000);
        startNotificationSync(); // প্রথমবার পেজ লোড হলেই চেক করবে
    </script>
</body>

</html>