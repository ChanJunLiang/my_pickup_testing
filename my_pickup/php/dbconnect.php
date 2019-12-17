<?php
$servername = "localhost";
$username 	= "pickupan_mypickupchan";
$password 	= "cjunliang123";
$dbname 	= "pickupan_mypickup2";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>