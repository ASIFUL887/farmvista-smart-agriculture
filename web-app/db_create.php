<?php

$servername = "localhost";
$username = "root";
$password = "";

/* Create connection */
$conn = new mysqli($servername, $username, $password);

/* Check connection */
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

/* Create database */
$sql = "CREATE DATABASE IF NOT EXISTS farmvista";

if ($conn->query($sql) === TRUE) {
    echo "Database 'farmvista' created successfully.<br>";
} else {
    die("Error creating database: " . $conn->error);
}

/* Select database */
$conn->select_db("farmvista");


/* ============================
   FARMER TABLE
============================ */
$sql1 = "CREATE TABLE IF NOT EXISTS farmer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    contact VARCHAR(100),
    dob DATE,
    password VARCHAR(255) NOT NULL
)";

if ($conn->query($sql1) === TRUE) {
    echo "Table 'farmer' created successfully.<br>";
} else {
    echo "Error: " . $conn->error . "<br>";
}


/* ============================
   AGRONOMIST TABLE
============================ */
$sql2 = "CREATE TABLE IF NOT EXISTS agronomist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    contact VARCHAR(100),
    specialized VARCHAR(100),
    experienced VARCHAR(100),
    region VARCHAR(100),
    dob DATE,
    password VARCHAR(255) NOT NULL
)";

if ($conn->query($sql2) === TRUE) {
    echo "Table 'agronomist' created successfully.<br>";
} else {
    echo "Error: " . $conn->error . "<br>";
}


/* ============================
   ADMIN TABLE
============================ */
$sql3 = "CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql3) === TRUE) {
    echo "Table 'admin' created successfully.<br>";
} else {
    echo "Error: " . $conn->error . "<br>";
}


/* ============================
   INSERT DEFAULT ADMIN
============================ */
$checkAdmin = "SELECT * FROM admin WHERE email='admin@gmail.com'";
$result = $conn->query($checkAdmin);

if ($result->num_rows == 0) {

    /* 🔥 HASH PASSWORD (VERY IMPORTANT) */
    $adminPass = password_hash('1234', PASSWORD_DEFAULT);

    $insertAdmin = "INSERT INTO admin (email, password) 
                    VALUES ('admin@gmail.com', '$adminPass')";

    if ($conn->query($insertAdmin) === TRUE) {
        echo "Default admin created (admin@gmail.com / 1234)<br>";
    } else {
        echo "Error inserting admin: " . $conn->error;
    }

} else {
    echo "Admin already exists<br>";
}

/* ============================
   PAYMENT TABLE
============================ */
$sql4 = "CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT NULL,
    gateway VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    trxid VARCHAR(50) NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    /* Optional foreign key */
    FOREIGN KEY (farmer_id) REFERENCES farmer(id) ON DELETE SET NULL
)";

if ($conn->query($sql4) === TRUE) {
    echo "Table 'payments' created successfully.<br>";
} else {
    echo "Error: " . $conn->error . "<br>";
}

/* ============================
   FARM / CROP TABLE (NEW)
============================ */
$sql5 = "CREATE TABLE IF NOT EXISTS farms (
    id INT AUTO_INCREMENT PRIMARY KEY,

    farmer_id INT NOT NULL,

    crop_name VARCHAR(100) NOT NULL,
    farm_type VARCHAR(50),
    farm_weight VARCHAR(50),

    description TEXT,

    image VARCHAR(255),

    status ENUM('Active','Pending','Sold') DEFAULT 'Active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (farmer_id) REFERENCES farmer(id) ON DELETE CASCADE
)";

if ($conn->query($sql5) === TRUE) {
    echo "Table 'farms' created successfully.<br>";
} else {
    echo "Error: " . $conn->error . "<br>";
}

$conn->close();
?>