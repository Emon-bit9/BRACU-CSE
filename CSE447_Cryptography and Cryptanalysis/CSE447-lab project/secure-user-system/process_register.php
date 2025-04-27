<?php
require_once 'includes/functions.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    $email = $_POST['email'] ?? '';
    
    $db = new Database();
    if ($db->registerUser($username, $password, $email)) {
        header('Location: login.php?registered=1');
        exit;
    } else {
        header('Location: register.php?error=1');
        exit;
    }
}