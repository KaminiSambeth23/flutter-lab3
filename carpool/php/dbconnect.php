<?php
$servername ="localhost";
$username   ="theksult_carpooluser";
$password   ="{g}K2&octrK]";
$dbname     ="theksult_carpool";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>