<?php

$conn = new mysqli("localhost", "root", "", "farmvista");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

/* Get form data */
$fullname = trim($_POST['fullname']);
$contact = trim($_POST['contact']);
$dob = $_POST['dob'];
$password = $_POST['password'];
$repassword = $_POST['repassword'];
$role = $_POST['role'];

$specialized = $_POST['specialized'] ?? '';
$experienced = $_POST['experienced'] ?? '';
$region = $_POST['region'] ?? '';


/* Validation */
if (empty($fullname) || empty($contact) || empty($dob) || empty($password)) {
    die("All fields are required!");
}

if ($password !== $repassword) {
    die("Passwords do not match!");
}

/* Hash password */
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

/* ---------- CHECK DUPLICATE ---------- */
$stmt = $conn->prepare("SELECT id FROM " . ($role == "farmer" ? "farmer" : "agronomist") . " WHERE contact=?");
$stmt->bind_param("s", $contact);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    die("User already exists!");
}

/* ---------- INSERT BASED ON ROLE ---------- */
if ($role == "farmer") {

    $stmt = $conn->prepare("INSERT INTO farmer (fullname, contact, dob, password)
                            VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $fullname, $contact, $dob, $hashedPassword);

} else {

    $stmt = $conn->prepare("INSERT INTO agronomist (fullname, contact, specialized, experienced, region, dob, password)
                            VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssss", $fullname, $contact, $specialized, $experienced,$region, $dob, $hashedPassword);
}

/* Execute */
if ($stmt->execute()) {
    echo "<h3>Signup Successful!</h3>";
    echo "<a href='login.php'>Go to Login</a>";
} else {
    echo "Error: " . $stmt->error;
}

$conn->close();
?>