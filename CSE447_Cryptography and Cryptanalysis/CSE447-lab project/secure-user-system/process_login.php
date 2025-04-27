<?php
require_once 'includes/functions.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    
    $db = new Database();
    $userId = $db->loginUser($username, $password);
    
    if ($userId) {
        $_SESSION['user_id'] = $userId;
        $_SESSION['username'] = $username;
        header('Location: dashboard.php');
        exit;
    } else {
        header('Location: login.php?error=1');
        exit;
    }
}