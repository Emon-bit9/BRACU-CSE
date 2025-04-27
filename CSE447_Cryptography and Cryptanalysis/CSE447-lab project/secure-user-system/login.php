<?php require_once 'includes/config.php'; ?>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Secure User System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div id="login-form">
            <h2>Login</h2>
            <?php if (isset($_GET['error'])): ?>
                <div class="error">Invalid credentials</div>
            <?php endif; ?>
            <form action="process_login.php" method="POST">
                <div class="form-group">
                    <label>Username:</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit">Login</button>
            </form>
            <p>Don't have an account? <a href="register.php">Register</a></p>
        </div>
    </div>
</body>
</html>