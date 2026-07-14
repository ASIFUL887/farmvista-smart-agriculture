<?php 
session_start();
include("db_connect.php");

/* যদি already login থাকে → dashboard এ পাঠাও */
if (isset($_SESSION['farmer_id']) || isset($_SESSION['agronomist_id'])) {
    header("Location: dashboard.php");
    exit();
}

/* Error message from login_process */
$error = $_GET['error'] ?? "";
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Login - FarmVista</title>
    <link rel="stylesheet" href="login.css">
</head>

<body>

    <div class="container">
        <form action="login_process.php" method="POST" class="card">

            <h2>Welcome Back</h2>
            <p class="subtitle">Glad to see you, <span>FarmVista</span></p>

            <!-- ✅ ERROR MESSAGE -->
            <?php if (!empty($error)) { ?>
                <p style="color:red; text-align:center;">
                    <?php echo htmlspecialchars($error); ?>
                </p>
            <?php } ?>

            <!-- ROLE -->
            <div class="role-toggle">
                <input type="radio" id="farmer" name="role" value="farmer" checked>
                <label for="farmer">Farmer</label>

                <input type="radio" id="agronomist" name="role" value="agronomist">
                <label for="agronomist">Agronomist</label>
            </div>

            <!-- CONTACT -->
            <input type="text" name="contact" placeholder="Email or Phone" required>

            <!-- PASSWORD -->
            <div class="password-group">
                <input type="password" name="password" id="password" placeholder="Password" required>
                <span onclick="togglePassword()">👁</span>
            </div>

            <p class="forgot">Forgot your password?</p>

            <button type="submit" class="btn">Login</button>

            <p style="font-size:12px; color:#888; margin-top:10px;">
                Admin? Use your admin email & password
            </p>

            <p class="signup-link">
                Don't have an account? <a href="signup.php">Sign Up</a>
            </p>

        </form>
    </div>

    <script>
        function togglePassword() {
            let field = document.getElementById("password");
            field.type = field.type === "password" ? "text" : "password";
        }
    </script>

</body>
</html>