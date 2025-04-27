<?php
// Check if the session is not already started
if (session_status() == PHP_SESSION_NONE) {
    // Set session configuration before starting session
    ini_set('session.cookie_httponly', 1);
    ini_set('session.use_only_cookies', 1);
    ini_set('session.cookie_secure', 1);

    // Start the session
    session_start();
} else {
    // Session is already active, no need to call session_start() again
    // You can log this or handle as per your needs
}

// Database constants
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'secure_user_system');

// Generate secure random key
$encKey = base64_encode(random_bytes(32));
define('ENCRYPTION_KEY', $encKey);

// Set secure headers
header("X-Frame-Options: DENY");
header("X-XSS-Protection: 1; mode=block");
header("X-Content-Type-Options: nosniff");
header("Referrer-Policy: strict-origin-origin-when-cross-origin");
header("Content-Security-Policy: default-src 'self'");

// Error reporting (disable in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);
