<?php
require_once 'includes/functions.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}

$db = new Database();
$posts = $db->allUserPosts($_SESSION['user_id']); // Fetch posts from other users
?>
<!DOCTYPE html>
<html>
<head>
    <title>All Posts - Secure User System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
   
</head>
<body>
    <a href="dashboard.php" class="back">Back</a>
    <div class="container">
        <h2>All Posts</h2>

        <?php if (!empty($posts)): ?>
            <?php foreach ($posts as $post): ?>
                <div class="post">
                    <h3><p class="author">Name: <?php echo htmlspecialchars($post['username'] ?? 'Unknown'); ?></p></h3>
                    <p><?php echo htmlspecialchars($post['content'] ?? 'No content available'); ?></p>
                    
                </div>
            <?php endforeach; ?>
        <?php else: ?>
            <p>No posts to display.</p>
        <?php endif; ?>
    </div>
</body>
</html>
