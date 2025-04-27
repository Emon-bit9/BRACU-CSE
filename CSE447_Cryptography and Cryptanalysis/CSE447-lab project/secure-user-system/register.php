<?php require_once 'includes/config.php'; ?>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Secure User System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div id="register-form">
            <h2>Register</h2>
            <?php if (isset($_GET['error'])): ?>
                <div class="error">Registration failed. Username might be taken.</div>
            <?php endif; ?>
            <form action="process_register.php" method="POST">
                <div class="form-group">
                    <label>Username:</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit">Register</button>
            </form>
            <p>Already have an account? <a href="login.php">Login</a></p>
        </div>
    </div>
</body>
</html>