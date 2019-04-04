<?php

$name = "Prom Week Beta";
$s_mail = "promweekbugs@gmail.com";
$subject = stripslashes($_POST['sender_subject']);
$to = stripslashes("promweekbugs@gmail.com");
$body = stripslashes($_POST['sender_message']);
$body .= "\n\n---------------------------\n";
$body .= "Mail sent by: $s_name <$s_mail>\n";
$header = "From: $s_name <$s_mail>\n";
$header .= "Reply-To: $s_name <$s_mail>\n";
$header .= "X-Mailer: PHP/" . phpversion() . "\n";
$header .= "X-Priority: 1";

if(@mail($to, $subject, $body, $header)) {
    echo "output=sent";
} else {
    echo "output=error";
}

?>

