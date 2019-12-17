<?php
error_reporting(0);
include_once("dbConnect.php");
$email = $_GET['email'];

$sql = "UPDATE job_provider SET verify = '1' WHERE user_email = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
