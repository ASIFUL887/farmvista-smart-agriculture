<?php
session_start();
include("db_connect.php");

// Set header to JSON because we are sending an AJAX response
header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Please login first"]);
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    // Check if farmer_id exists in session, otherwise use user_id
    $farmer_id = isset($_SESSION['farmer_id']) ? $_SESSION['farmer_id'] : $_SESSION['user_id']; 
    
    $gateway = $_POST['gateway'];
    $phone = $_POST['phone'];
    $amount = $_POST['amount'];
    $trxid = $_POST['trxid'];

    // Basic Validation
    if(empty($phone) || empty($amount) || empty($trxid)){
        echo json_encode(["status" => "error", "message" => "All fields are required!"]);
        exit();
    }

    // Check if TrxID already exists to prevent duplicate payments
    $checkStmt = $conn->prepare("SELECT id FROM payments WHERE trxid = ?");
    $checkStmt->bind_param("s", $trxid);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "This Transaction ID has already been used!"]);
        exit();
    }

    // Insert into 'payments' table (status is 'Pending' by default as per db_create.php)
    $stmt = $conn->prepare("INSERT INTO payments (farmer_id, gateway, phone, trxid, amount) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("isssd", $farmer_id, $gateway, $phone, $trxid, $amount);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Order placed successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid Request"]);
}
?>