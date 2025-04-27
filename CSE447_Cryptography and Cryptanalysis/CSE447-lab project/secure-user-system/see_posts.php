<?php
require_once 'includes/functions.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}

$db = new Database();
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_post_id'])) {
    $post_id = intval($_POST['delete_post_id']);
    $db->deletePost($post_id, $_SESSION['user_id']); // Pass user_id for ownership validation
    header('Location: ' . $_SERVER['PHP_SELF']); // Refresh page after deletion
    exit;
}

// Fetch user posts
$posts = $db->getUserPosts($_SESSION['user_id']);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Your Posts - Secure User System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <a href="dashboard.php">Back</a>
    <div class="container">
        <h2>Your Posts</h2>

        <?php if (is_array($posts) && !empty($posts)): ?>
            <?php foreach ($posts as $post): ?>
                <div class="post">  
                    <div>
                        
                        
                        <?php if ($post['content'] === 'Tampered content detected!'): ?>
                            <!-- Display tampered message -->
                            <p style="color: red; font-weight: bold;">MAC Not Matched</p>
                        <?php else: ?>
                            <!-- Display MAC matched message -->
                            <p style="color: green; font-weight: bold;">MAC Matched</p>
                        <?php endif; ?>
                        
                        
                        <h3>Content</h3>
                        <p><?php echo htmlspecialchars($post['content']); ?></p>
                    </div>

                </div>
            <?php endforeach; ?>
        <?php else: ?>
            <p>No posts to display.</p>
        <?php endif; ?>


    </div>
</body>
</html>
