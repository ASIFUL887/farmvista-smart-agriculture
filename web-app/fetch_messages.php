<?php
session_start();
include("db_connect.php");

if (isset($_SESSION['user_id']) && isset($_GET['receiver_id'])) {
    $my_id = $_SESSION['user_id'];
    $receiver_id = (int)$_GET['receiver_id'];

    // আপনার ডাটাবেসে কলামের নাম 'is_read'
    // মেসেজ পড়া হয়েছে বলে আপডেট করা
    mysqli_query($conn, "UPDATE messages SET is_read = 1 WHERE sender_id = '$receiver_id' AND receiver_id = '$my_id'");

    // আপনার ডাটাবেসে সময়ের কলামের নাম 'created_at'
    $sql = "SELECT * FROM messages 
            WHERE (sender_id = '$my_id' AND receiver_id = '$receiver_id') 
            OR (sender_id = '$receiver_id' AND receiver_id = '$my_id') 
            ORDER BY created_at ASC";

    $result = mysqli_query($conn, $sql);

    if (!$result) {
        die("Query Failed: " . mysqli_error($conn));
    }

    while ($row = mysqli_fetch_assoc($result)) {
        $class = ($row['sender_id'] == $my_id) ? 'sent' : 'received';
        $type = $row['msg_type']; // আপনার ডাটাবেসে কলামের নাম 'msg_type'
        $msg_content = $row['message'];

        if ($type == 'image') {
            echo '<div class="message ' . $class . '"><img src="uploads/' . htmlspecialchars($msg_content) . '" style="max-width:200px; border-radius:10px;" onclick="window.open(this.src)"></div>';
        } elseif ($type == 'video') {
            echo '<div class="message ' . $class . '"><video src="uploads/' . htmlspecialchars($msg_content) . '" style="max-width:200px;" controls></video></div>';
        } elseif ($type == 'file') {
            echo '<div class="message ' . $class . '">📁 <a href="uploads/' . htmlspecialchars($msg_content) . '" download style="color:inherit;">' . htmlspecialchars($msg_content) . '</a></div>';
        } else {
            // সাধারণ টেক্সট মেসেজ
            echo '<div class="message ' . $class . '">' . nl2br(htmlspecialchars($msg_content)) . '</div>';
        }
    }
}
