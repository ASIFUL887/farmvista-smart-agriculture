<?php
session_start();
include("db_connect.php");

// সেশন চেক: ইউজার লগইন আছে কি না
if (isset($_SESSION['user_id'])) {
    $sender_id = $_SESSION['user_id'];

    // রিসিভার আইডি এবং মেসেজ ডাটা ধরা
    $receiver_id = isset($_POST['receiver_id']) ? (int)$_POST['receiver_id'] : 0;
    $message = isset($_POST['message']) ? mysqli_real_escape_string($conn, $_POST['message']) : "";
    $msg_type = "text"; // ডিফল্ট টাইপ টেক্সট

    // ১. ফাইল আপলোড লজিক (ছবি, ভিডিও বা ডকুমেন্ট)
    if (isset($_FILES['file_input']) && $_FILES['file_input']['error'] == 0) {
        $file = $_FILES['file_input'];
        $file_name = time() . '_' . preg_replace("/[^a-zA-Z0-9.]/", "_", $file['name']);

        if (!is_dir('uploads')) {
            mkdir('uploads', 0777, true);
        }

        $file_path = "uploads/" . $file_name;
        $mime_type = $file['type'];

        if (move_uploaded_file($file['tmp_name'], $file_path)) {
            $message = $file_name;

            if (strpos($mime_type, 'image') !== false) {
                $msg_type = "image";
            } elseif (strpos($mime_type, 'video') !== false) {
                $msg_type = "video";
            } else {
                $msg_type = "file";
            }
        }
    }

    // ২. ডাটাবেসে ইনসার্ট করা
    if ($message != "" && $receiver_id != 0) {
        // এখানে is_read কলামটি ০ হিসেবে ডিফল্ট সেট করা হচ্ছে যাতে প্রাপক নোটিফিকেশন পায়
        $sql = "INSERT INTO messages (sender_id, receiver_id, message, msg_type, is_read) 
                VALUES ('$sender_id', '$receiver_id', '$message', '$msg_type', 0)";

        if (mysqli_query($conn, $sql)) {
            echo json_encode(["status" => "success"]);
        } else {
            // ডাটাবেস এরর দেখালে সেটি এখান থেকে বোঝা যাবে
            echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
        }
    }
} else {
    echo json_encode(["status" => "unauthorized"]);
}
