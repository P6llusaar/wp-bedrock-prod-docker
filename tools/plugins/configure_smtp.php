<?php

add_action('phpmailer_init', function($phpmailer) {

    $SMTP_HOST = getenv('SMTP_HOST');
    $SMTP_PORT = getenv('SMTP_PORT');
    $SMTP_USER = getenv('SMTP_USER');
    $SMTP_PASSWD = getenv('SMTP_PASSWD');
    $SMTP_ENCRYPTION = getenv('SMTP_ENCRYPTION');

    if(empty($SMTP_HOST))
        return;

    if (empty($SMTP_PORT) || empty($SMTP_USER) || empty($SMTP_PASSWD) || empty($SMTP_ENCRYPTION)) {
        error_log('SMTP configuration is incomplete. Please ensure all settings are configured.');
        return;
    }

    $phpmailer->isSMTP();

    // SMTP host (e.g., smtp.example.com)
    $phpmailer->Host =  $SMTP_HOST;

    // SMTP port (e.g., 587 for TLS, 465 for SSL)
    $phpmailer->Port = $SMTP_PORT;

    // Whether to use SMTP authentication
    $phpmailer->SMTPAuth = true;

    // SMTP username and password
    $phpmailer->Username = $SMTP_USER;
    $phpmailer->Password = $SMTP_PASSWD;

    // Encryption (tls or ssl)
    $phpmailer->SMTPSecure = $SMTP_ENCRYPTION;
});
