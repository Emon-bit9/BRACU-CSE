<?php
require_once 'Security.php'; // Make sure to include the Security class

class Database {
    private $conn;
    
    public function __construct() {
        $this->conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        if ($this->conn->connect_error) {
            die("Connection failed: " . $this->conn->connect_error);
        }
    }

    
    public function registerUser($username, $password, $email) {
        $salt = Security::generateSalt();
        $passwordHash = Security::hashPassword($password, $salt);
        $userKey = bin2hex(random_bytes(32));
        $encryptedEmail = Security::encrypt($email, ENCRYPTION_KEY);
        
        $stmt = $this->conn->prepare("INSERT INTO users (username, password_hash, salt, encryption_key, iv, email) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssss", $username, $passwordHash, $salt, $userKey, $encryptedEmail['iv'], $encryptedEmail['data']);
        return $stmt->execute();
    }
    
    public function loginUser($username, $password) {
        $stmt = $this->conn->prepare("SELECT id, password_hash, salt FROM users WHERE username = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($row = $result->fetch_assoc()) {
            if (Security::verifyPassword($password, $row['password_hash'], $row['salt'])) {
                return $row['id'];
            }
        }
        return false;
    }
    
    public function createPost($userId, $content) {
        $stmt = $this->conn->prepare("SELECT encryption_key FROM users WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $userKey = $result->fetch_assoc()['encryption_key'];
        
        $encrypted = Security::encrypt($content, $userKey);
        $mac = Security::generateMAC($encrypted['data'], $userKey);
        
        $stmt = $this->conn->prepare("INSERT INTO posts (user_id, encrypted_content, iv, mac) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("isss", $userId, $encrypted['data'], $encrypted['iv'], $mac);
        return $stmt->execute();
    }
    
    public function getUserPosts($userId) {
        // Fetch the encryption key for the user
        $stmt = $this->conn->prepare("SELECT encryption_key FROM users WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $userKey = $result->fetch_assoc()['encryption_key'];
    
        // Fetch the encrypted posts for the user
        $stmt = $this->conn->prepare("SELECT encrypted_content, iv, mac FROM posts WHERE user_id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
    
        $posts = [];
        while ($row = $result->fetch_assoc()) {
            $encryptedContent = $row['encrypted_content'];
            $iv = $row['iv'];
            $mac = $row['mac'];
    
            // Verify the MAC to ensure integrity
            if (Security::verifyMAC($encryptedContent, $userKey, $mac)) {
                // Decrypt the content
                $decryptedContent = Security::decrypt($encryptedContent, $userKey, $iv);
                $posts[] = ['content' => $decryptedContent];
            } else {
                // Handle the case where MAC verification fails
                $posts[] = ['content' => 'Tampered content detected!'];
            }
        }
    
        return $posts;
    }
    public function allUserPosts($userId) {
        // Fetch the encryption keys and usernames for all other users
        $stmt = $this->conn->prepare("SELECT id, encryption_key, username FROM users WHERE id != ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $userKeys = [];
        while ($row = $result->fetch_assoc()) {
            $userKeys[$row['id']] = [
                'key' => $row['encryption_key'],
                'username' => $row['username']
            ];
        }
    
        // Fetch the encrypted posts for all other users
        $stmt = $this->conn->prepare("SELECT user_id, encrypted_content, iv, mac FROM posts WHERE user_id != ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
    
        $posts = [];
        while ($row = $result->fetch_assoc()) {
            $userIdFromPost = $row['user_id'];
            $encryptedContent = $row['encrypted_content'];
            $iv = $row['iv'];
            $mac = $row['mac'];
    
            // Retrieve the corresponding encryption key and username for the user
            $userData = $userKeys[$userIdFromPost] ?? null;
    
            if ($userData) {
                $userKey = $userData['key'];
                $username = $userData['username'];
    
                // Verify the MAC to ensure integrity
                if (Security::verifyMAC($encryptedContent, $userKey, $mac)) {
                    // Decrypt the content
                    $decryptedContent = Security::decrypt($encryptedContent, $userKey, $iv);
                    $posts[] = [
                        'user_id' => $userIdFromPost,
                        'username' => $username,
                        'content' => $decryptedContent
                    ];
                } else {
                    // Handle the case where MAC verification fails
                    $posts[] = [
                        'user_id' => $userIdFromPost,
                        'username' => $username,
                        'content' => 'Tampered content detected!'
                    ];
                }
            } else {
                $posts[] = [
                    'user_id' => $userIdFromPost,
                    'username' => 'Unknown',
                    'content' => 'Encryption key not found!'
                ];
            }
        }
    
        return $posts;
    }
    
    
}
