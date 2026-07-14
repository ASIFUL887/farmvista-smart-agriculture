<!DOCTYPE html>
<html>
<head>
    <title>FarmVista Sign Up</title>
    <link rel="stylesheet" href="signup.css">
</head>
<body>

<div class="container">
    <h1>Sign Up</h1>

<div class="role-toggle">
    <button type="button" class="active" onclick="setRole('farmer', this)">Farmer</button>
    <button type="button" onclick="setRole('agronomist', this)">Agronomist</button>
</div>

<form action="signup_process.php" method="POST" onsubmit="return validateForm()">

    <input type="hidden" name="role" id="role" value="farmer">

    <input type="text" name="fullname" placeholder="Full Name" required>
    <input type="text" name="contact" placeholder="Email / Phone" required>
    <input type="date" name="dob" required>

    <!-- Agronomist Fields -->
    <div id="agronomistFields" style="display:none;">
        <input type="text" name="specialized" placeholder="Specialization">
        <input type="text" name="experienced" placeholder="Experience (years)">
        <input type="text" name="region" placeholder="region">
    </div>

 <div class="password-group">
    <input type="password" name="password" id="password" placeholder="Password" required>
    <span onclick="togglePassword('password')">👁</span>
</div>

<div class="password-group">
    <input type="password" name="repassword" id="repassword" placeholder="Re-type Password" required>
    <span onclick="togglePassword('repassword')">👁</span>
</div>


    <button type="submit">Sign Up</button>
</form>


    <p>Already have an account? <a href="login.php">Login</a></p>
</div>

<script src="script.js"></script>
</body>
</html>