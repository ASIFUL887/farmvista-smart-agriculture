<?php
session_start();
include("db_connect.php");

/* =========================
   GET FORM DATA SAFELY
========================= */
$contact  = trim($_POST['contact'] ?? '');
$password = $_POST['password'] ?? '';
$role     = strtolower(trim($_POST['role'] ?? ''));

/* =========================
   🔴 1. ADMIN LOGIN
========================= */
$adminStmt = $conn->prepare("SELECT id, email, password FROM admin WHERE email=?");
$adminStmt->bind_param("s", $contact);
$adminStmt->execute();
$adminStmt->bind_result($adminId, $adminEmail, $adminHash);
$adminStmt->fetch();
$adminStmt->close();

if ($adminId && !empty($adminHash)) {
    if (password_verify($password, $adminHash)) {
        $_SESSION['user_id'] = (int)$adminId;
        $_SESSION['role']    = 'admin';
        $_SESSION['name']    = 'Admin';

        session_regenerate_id(true);
        header("Location: admin_dashboard.php");
        exit();
    } else {
        header("Location: login.php?error=Wrong admin password");
        exit();
    }
}

/* =========================
   🟢 2. FARMER / AGRONOMIST LOGIN
========================= */

if ($role === "farmer") {
    $table = "farmer";
} elseif ($role === "agronomist") {
    $table = "agronomist";
} else {
    header("Location: login.php?error=Invalid role");
    exit();
}

// ইউজার কুয়েরি
$stmt = $conn->prepare("SELECT id, fullname, contact, password FROM $table WHERE contact=?");
$stmt->bind_param("s", $contact);
$stmt->execute();
$stmt->store_result(); // এটি যোগ করুন যাতে row count চেক করা যায়

// যদি ইউজার পাওয়া যায়
if ($stmt->num_rows > 0) {
    $stmt->bind_result($uid, $fullname, $ucontact, $hashed_password);
    $stmt->fetch();
    $stmt->close();

    // পাসওয়ার্ড ভেরিফিকেশন এবং সেশন সেট
    if (!empty($hashed_password) && password_verify($password, $hashed_password)) {
        $_SESSION['user_id'] = (int)$uid; // সবার জন্য কমন আইডি
        $_SESSION['role']    = $role;
        $_SESSION['name']    = $fullname;
        $_SESSION['contact'] = $ucontact;

        if ($role === "farmer") {
            $_SESSION['farmer_id'] = (int)$uid;
        } elseif ($role === "agronomist") {
            $_SESSION['agronomist_id'] = (int)$uid;
        }

        session_regenerate_id(true);
        header("Location: dashboard.php");
        exit();
    } else {
        header("Location: login.php?error=Wrong password");
        exit();
    }
} else {
    $stmt->close();
    header("Location: login.php?error=User not found");
    exit();
}

$conn->close();
