<?php
session_start();
include("db_connect.php");

// JSON ইনপুট ডাটা ধরা
$data = json_decode(file_get_contents("php://input"), true);

// সেশনে user_id এবং ডাটা আছে কি না চেক করা
if (isset($_SESSION['user_id']) && !empty($data)) {

    $user_id = (int)$_SESSION['user_id'];

    // ডাটা ক্লিন করা (SQL Injection থেকে বাঁচতে)
    $address    = mysqli_real_escape_string($conn, $data['address']);
    $district   = mysqli_real_escape_string($conn, $data['district']);
    $method     = mysqli_real_escape_string($conn, $data['method']);
    $gateway    = mysqli_real_escape_string($conn, $data['gateway']);
    $trxid      = mysqli_real_escape_string($conn, $data['trxid']);

    // সংখ্যা জাতীয় ডাটাগুলো ধরা
    $item_total = (float)$data['item_total'];
    $shipping   = (float)$data['shipping'];
    $paid       = (float)$data['paid'];
    $due        = (float)$data['due'];

    // ডাটাবেসে ইনসার্ট কোয়েরি
    // নিশ্চিত করুন আপনার 'orders' টেবিলের কলামের নামগুলো নিচের সাথে মিলেছে
    $sql = "INSERT INTO orders (user_id, address, district, payment_method, gateway, transaction_id, item_total, shipping_fee, paid_amount, due_amount, order_status) 
            VALUES ($user_id, '$address', '$district', '$method', '$gateway', '$trxid', $item_total, $shipping, $paid, $due, 'Pending')";

    if (mysqli_query($conn, $sql)) {
        echo json_encode(["status" => "success"]);
    } else {
        // যদি এরর হয় তবে সেটি জানাবে
        echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Authentication failed or empty data"]);
}
