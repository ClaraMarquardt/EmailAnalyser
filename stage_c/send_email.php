<?php

/* #-------------------------------------------------------------------------#

# Purpose:     Send Emails
# Author:      CM
# Date:        July 2017
# Language:    PHP (.php)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------# */

/* initialise */
require 'PHPMailerAutoload.php';
date_default_timezone_set('EST');
error_reporting(0);


/* obtain environment arguments - email related */
$hostname = '{imap.gmail.com:993/imap/ssl}[Gmail]/Sent Mail';
$username = getenv("email_address");
$password = getenv("email_pwd");

/* obtain environment arguments - misc */
$log_path = getenv("wd_path_log");  
$execution_id = getenv("execution_id");
$date =  getenv("current_date");
$email_text = getenv("email_report");
$email_plot = getenv("email_plot");

/* initialise output buffer */
function ob_file_callback($buffer)
{
  global $ob_file;
  fwrite($ob_file,$buffer);
}

$log_file = $log_path . '/email_send_php_' . $execution_id . ".txt";
$ob_file = fopen($log_file,'w');
ob_start('ob_file_callback');

/* Create email */
$email = new PHPMailer();

$email->IsSMTP();                           
$email->Host       = "smtp.gmail.com"; 
$email->SMTPDebug  = 0;                     
$email->SMTPAuth   = true;                  
$email->SMTPSecure = "tls";                       
$email->Port       = 587;                       
$email->Username   = $username;  
$email->Password   = $password;           

$email->SetFrom($username, $username);

/* body */ 
$msg = $email_text;
$msg = wordwrap($msg,80);

/* create email */ 
$email->Subject   = "How Am I Doing?";
$email->Body      = $msg;
$email->AddAddress($username);

$email->AddAttachment($email_plot , "HowAmIDoing.pdf");

/* Send email */
if(!$email->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $email->ErrorInfo;
} else {
    echo 'Message has been sent';
}

ob_end_flush();

/* #-------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------# */

?>

