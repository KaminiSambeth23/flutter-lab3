<?php
//error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename =$mydate.'-'.$email;

$sqlinsert = "INSERT INTO users(EMAIL, USERNAME, PASSWORD, PHONE, VERIFY,IMAGE) VALUES ('$email','$name','$password','$phone','0','$imagename')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for carpool'; 
    $message = 'http://.com/purchase_it/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@carpool.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}


?>