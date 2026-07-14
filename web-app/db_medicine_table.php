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



/* Select Database */
$conn->select_db("farmvista");

/* Create Medicines Table */
$table = "CREATE TABLE IF NOT EXISTS medicines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(255) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($table) === TRUE) {
    echo "Table 'medicines' created successfully<br>";
} else {
    die("Error creating table: " . $conn->error);
}


$conn->close();

?>