<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;


require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';

function sendEmail($receiver, $subject, $content) {
    $mail = new PHPMailer(true);

    try {
        // Server settings
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'dungnguyenhhiii@gmail.com';
        $mail->Password   = 'euwu ibpj veru skom';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = 587;

        // Recipients
        $mail->setFrom('dungnguyenhhiii@gmail.com', 'Trung tâm Tiếng Anh KEC');
        $mail->addAddress($receiver);

        // Content
        $mail->isHTML(true);
        $mail->CharSet = 'UTF-8';
        $mail->Subject = $subject;
        $mail->Body    = nl2br(htmlspecialchars($content, ENT_QUOTES, 'UTF-8'));

        $mail->send();
        return [
            'status' => 'success',
            'message' => 'Email đã được gửi thành công'
        ];

    } catch (Exception $e) {
        error_log("PHPMailer Error: " . $mail->ErrorInfo);
        return [
            'status' => 'fail',
            'message' => 'Không thể gửi email: ' . $mail->ErrorInfo
        ];
    }
}
?>