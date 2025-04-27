<?php
require_once 'config.php';

class Security {
    private static $cipher = "AES-256-CBC";
    
    public static function generateSalt($length = 16) {
        return bin2hex(random_bytes($length));
    }
    
    public static function hashPassword($password, $salt) {
        return password_hash($password . $salt, PASSWORD_BCRYPT);
    }
    
    public static function verifyPassword($password, $hash, $salt) {
        return password_verify($password . $salt, $hash);
    }
    
    public static function encrypt($data, $key, $iv = null) {
        if ($iv === null) {
            $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length(self::$cipher));
        }
        $encrypted = openssl_encrypt($data, self::$cipher, $key, 0, $iv);
        return ['data' => $encrypted, 'iv' => bin2hex($iv)];
    }
    
    public static function decrypt($encryptedData, $key, $iv) {
        return openssl_decrypt($encryptedData, self::$cipher, $key, 0, hex2bin($iv));
    }
    
    public static function generateMAC($data, $key) {
        return hash_hmac('sha256', $data, $key);
    }

    public static function verifyMAC($encryptedContent, $key, $mac) {
        // Generate the MAC using the encrypted content and key
        $calculatedMac = self::generateMAC($encryptedContent, $key);
        
        // Compare the calculated MAC with the provided MAC
        return hash_equals($calculatedMac, $mac);
    }
}
