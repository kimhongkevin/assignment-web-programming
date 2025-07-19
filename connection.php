<?php
// Database configuration
$host = 'localhost';
$username = 'root';      // Default XAMPP username
$password = '';          // Default XAMPP password (empty)
$database = 'audio_store_db';

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set charset
$conn->set_charset("utf8mb4");
?>