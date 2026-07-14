<?php
session_start();
include("db_connect.php");

header('Content-Type: application/json');

if (isset($_SESSION['user_id'])) {
    $my_id = $_SESSION['user_id'];

    // ডাটাবেস থেকে শুধুমাত্র লগইন করা ইউজারের অপঠিত মেসেজ সংখ্যা বের করা
    $sql = "SELECT COUNT(*) as unread FROM messages WHERE receiver_id = '$my_id' AND is_read = 0";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();

    echo json_encode(["unread_count" => (int)$row['unread']]);
} else {
    echo json_encode(["unread_count" => 0]);
}
