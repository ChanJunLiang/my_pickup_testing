<?php
error_reporting(0);
include_once("dbConnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM job_provider WHERE USER_EMAIL = '$email' AND USER_PASSWORD = '$passwordsha' AND VERIFY ='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    echo "success";
}else{
    echo "failed";
}