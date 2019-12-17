<?php
//error_reporting(0);
include_once ("dbConnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO job_provider(user_email, user_name, user_password, user_phone, verify) VALUES ('$email','$name','$password','$phone','0')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = 'profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "failed";
}

function sendEmail($email) {
    $to      = $email; 
    $subject = 'Verification for MyPickup'; 
    $message = 'http://pickupandlaundry.com/my_pickup/chan/php/verify.php?email='.$email; 
    $headers = 'From: noreply@pickupandlaundry.com' . "\r\n" . 
    'Reply-To: '.$email . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers);
}
?>