<?php
$name=$_POST['name'];
$to = "varunraj@zathrac.com";
$subject = "Hello, Varun. I'm ".$name;

$message = $_POST['message'];

$from = $_POST['email'];
$headers = "From:" . $from;
mail($to,$subject,$message,$headers);
echo "Thank You ".$name." For your message !";
?>
