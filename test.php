<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<?php


$pass = password_hash('123', PASSWORD_DEFAULT);
// echo ($pass);

// echo '<i class="fa-light fa-snowflake fa-bounce"></i>';
?>

<i class="fa-solid fa-group-arrows-rotate fa-spin"></i>
<i class="fa-solid fa-circle-notch fa-spin fa-spin-reverse"></i>
<div class="loading-screen">
    <div class="loading-content">
        <div class="loading-spinner"></div>
        <div class="loading-text">
            Đang tải<span>.</span><span>.</span><span>.</span>
        </div>
    </div>
</div>

<style>
    .loading-dots::after {
    content: '';
    animation: dots 1.4s infinite;
}

@keyframes dots {
    0% {
        content: '.';
    }
    33% {
        content: '..';
    }
    66% {
        content: '...';
    }
}

.loading-text span {
    display: inline-block;
    animation: dot-jump 1.4s ease-in-out infinite;
}

.loading-text span:nth-child(2) {
    animation-delay: 0.2s;
}

.loading-text span:nth-child(3) {
    animation-delay: 0.4s;
}

@keyframes dot-jump {
    0%, 80%, 100% {
        transform: translateY(0);
    }
    40% {
        transform: translateY(-4px);
    }
}
</style> -->

<?php
date_default_timezone_set('Asia/Ho_Chi_Minh');
    echo date_default_timezone_get() . "<br>";
echo date('Y-m-d H:i:s');
?>