
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Secure User System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, rgb(117, 125, 233), rgb(62, 128, 241));
            color: #333;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }


        .container {
            width: 600px;
            padding: 20px;
            background-color: rgb(255, 255, 255); 
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logout {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        .logout:hover {
            background-color: #c0392b;
            transform: scale(1.1);
        }

        h2 {
            color:rgb(33, 104, 176);
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 500;
            color: #2c3e50;
            display: block;
            margin-bottom: 8px;
        }

        textarea {
            width: calc(100% - 30px);
            padding: 15px;
            margin: 15px 0;
            border: 1px solid #dcdde1;
            border-radius: 10px;
            font-size: 16px;
            resize: none;
            min-height: 150px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: border 0.3s;
        }

        textarea:focus {
            border-color: #3498db;
            outline: none;
        }

        button {
            background-color:rgb(5, 62, 100);
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        button:hover {
            background-color:rgb(19, 148, 234);
            transform: scale(1.05);
        }

        .see-posts {
            display: inline-block;
            margin-top: 20px;
            background-color: #2ecc71;
            color: white;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 25px;
            text-decoration: none;
            transition: background-color 0.3s, transform 0.2s;
        }

        .see-posts:hover {
            background-color: #27ae60;
            transform: scale(1.05);
        }

        a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        a:hover {
            color: #2980b9;
        }

        .buttons {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>
            Welcome
        </h2>

        <form action="" method="POST">
            <div class="form-group">
                <label for="content">Create New Post:</label>
                <textarea id="content" name="content" required></textarea>
            </div>
            <button type="submit">Post</button>
        </form>

        <div class="buttons">
            <a href="see_posts.php" class="see-posts">My Posts</a>
            <a href="allpost.php" class="see-posts">Other Posts</a>
        </div>
    </div>
</body>
</html>
