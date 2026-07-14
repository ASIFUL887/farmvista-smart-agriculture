<?php

$host = "localhost";
$user = "root";
$pass = "";
$db   = "farmvista";

/* Create connection */
$conn = new mysqli($host, $user, $pass, $db);

/* Check connection */
if ($conn->connect_error) {
    die("Database Connection Failed: " . $conn->connect_error);
}

/* Set charset (IMPORTANT for proper text handling) */
$conn->set_charset("utf8mb4");

/* Optional: Error reporting (for development only) */
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

?>