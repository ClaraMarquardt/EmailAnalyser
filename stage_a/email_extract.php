<?php

/* #-------------------------------------------------------------------------#

# Purpose:     Download Emails
# Author:      CM
# Date:        July 2017
# Language:    PHP (.php)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------# */

/* initialise */
date_default_timezone_set('EST');
error_reporting(0);

/* obtain environment arguments - email related */
$hostname = '{imap.gmail.com:993/imap/ssl}[Gmail]/Sent Mail';
// $hostname = '{imap.gmail.com:993/imap/ssl}[Gmail]/Gesendet';
$username = getenv("email_address");
$password = getenv("email_pwd");

/* obtain environment arguments - misc */
$folder_output_outbox = getenv("data_path_raw_outbox");  // output folder
$log_path = getenv("wd_path_log");  
$execution_id = getenv("execution_id");
$email_date = getenv("email_date");
$date =  getenv("current_date");

/* initialise output buffer */
function ob_file_callback($buffer)
{
  global $ob_file;
  fwrite($ob_file,$buffer);
}

$log_file = $log_path . '/email_extract_php_' . $execution_id . ".txt";
$ob_file = fopen($log_file,'w');
ob_start('ob_file_callback');

/* try to connect to gmail */
$inbox = imap_open($hostname,$username,$password) or die('Cannot connect to Gmail: ' . imap_last_error());

/* extract emails */
echo "\n\nSuccessfully connected to Gmail account\n\n";
$emails = imap_search($inbox,'SINCE "'.$email_date.'"');
echo "\n\n" . "number of emails: " . count($emails) . "\n\n";

/************ HELPER FUNCTIONS

/* Define flatten function */
function flattenParts($messageParts, $flattenedParts = array(), $prefix = '', $index = 1, $fullPrefix = true) {

    foreach($messageParts as $part) {
        $flattenedParts[$prefix.$index] = $part;
        if(isset($part->parts)) {
            if($part->type == 2) {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix.$index.'.', 0, false);
            }
            elseif($fullPrefix) {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix.$index.'.');
            }
            else {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix);
            }
            unset($flattenedParts[$prefix.$index]->parts);
        }
        $index++;
    }

    return $flattenedParts;
            
}

/* Define getPart function */
function getPart($connection, $messageNumber, $partNumber, $encoding) {
    
    $data = imap_fetchbody($connection, $messageNumber, $partNumber);
    switch($encoding) {
        case 0: return $data; // 7BIT
        case 1: return $data; // 8BIT
        case 2: return $data; // BINARY
        case 3: return base64_decode($data); // BASE64
        case 4: return quoted_printable_decode($data); // QUOTED_PRINTABLE
        case 5: return $data; // OTHER
    }
    
    
}

/************ END HELPER FUNCTIONS

/* if emails are returned, cycle through each email */
if($emails) {
	
	/* begin output var */
	$output = '';
	
	/* put the newest emails on top */
	rsort($emails);
	
	/* for every email... */
	foreach($emails as $email_number) {

        echo "\n\n" . "email #: " . $email_number . "\n\n";

        /* mark as read */
        $status = imap_setflag_full($inbox, $email_number, "\\Seen \\Flagged"); 
        $header = imap_header($inbox, $email_number);

        $email_date_actual = date_create($header->date);
        $email_date_actual = date_format($email_date_actual,"d_m_Y");
        $recipient = $header->toaddress;
        $recipient = str_replace(' ', '_', $recipient);
        
        /* get mail structure */
        $structure_raw = imap_fetchstructure($inbox, $email_number);
        $structure_flat = flattenParts($structure_raw->parts);

        /* get email type */
        $type = $structure_raw->type;

        /* loop over parts */
        $i = 0;

        if ($type==1) {
            
            echo "\nmulti part\n"; 

            foreach($structure_flat as $partNumber => $part) {

                switch($part->type) {
        
                    case 0:
            
                    $message = getPart($inbox, $email_number, $partNumber, $part->encoding);
                    print_r($message);
                    $filepath = $folder_output_outbox ."/email_" . "$email_number" . "_" . "$i" . "__" . "$email_date_actual" . "__" . $recipient . ".txt";

                    $fp = fopen($filepath,"w+");
                    fwrite($fp, $message);
                    fclose($fp);
            
                    break;


                }

                $i++;
            }
        } elseif ($type==0) {

          echo "\nsingle part\n"; 

          $message = imap_fetchbody($inbox, $email_number, 1);
          print_r($message);

          $filepath = $folder_output_outbox ."/email_" . "$email_number" . "_" . "$i" . "__" . "$email_date_actual" . "__" . $recipient . ".txt";
          $fp = fopen($filepath,"w+");

          switch ($structure_raw->encoding) {
                
                case 3: 

                $message = imap_base64($message);
                fwrite($fp, $message);

                break;

                case 4: 

                $message = imap_qprint($message);
                fwrite($fp, $message);

                break;

                default: 

                fwrite($fp, $message);

                break;
           }

            
            fclose($fp);

            $i++;

        }

    }


/* close the connection */
imap_close($inbox);


}

ob_end_flush();

/* #-------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------# */

?>


