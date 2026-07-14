<?php
session_start();
include("db_connect.php");

/* Security check */
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$role = $_SESSION['role'];

/* Select table */
$table = ($role == "farmer") ? "farmer" : "agronomist";

/* Fetch user data */
$stmt = $conn->prepare("SELECT * FROM $table WHERE id=?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows != 1) {
    die("User not found");
}

$user = $result->fetch_assoc();

/* Fetch profile image */
$stmt2 = $conn->prepare("SELECT image FROM user_profile WHERE user_id=? AND role=?");
$stmt2->bind_param("is", $user_id, $role);
$stmt2->execute();
$res2 = $stmt2->get_result();

$profileImage = "";
if ($res2->num_rows > 0) {
    $profileImage = $res2->fetch_assoc()['image'];
}
?>

<!DOCTYPE html>
<html>

<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="dashboard.css">
    <link rel="stylesheet" href="profile.css">
</head>

<body>

<div class="profile-container">
    <div class="profile-card">

        <!-- ✅ SUCCESS MESSAGE INSIDE CARD -->
        <?php if (isset($_GET['updated'])) { ?>
            <div class="success-msg" id="successMsg">
                ✅ Profile updated successfully!
            </div>
        <?php } ?>

        <!-- PROFILE IMAGE -->
        <?php if ($profileImage) { ?>
            <img src="<?php echo htmlspecialchars($profileImage); ?>" class="profile-img">
        <?php } else { ?>
            <div class="avatar"></div>
        <?php } ?>

        <h2><?php echo htmlspecialchars($user['fullname']); ?></h2>

        <div class="profile-info">
            <span class="label">Role:</span>
            <?php echo ucfirst(htmlspecialchars($role)); ?>
        </div>

        <div class="profile-info">
            <span class="label">Contact:</span>
            <?php echo htmlspecialchars($user['contact']); ?>
        </div>

        <div class="profile-info">
            <span class="label">Date of Birth:</span>
            <?php echo htmlspecialchars($user['dob']); ?>
        </div>

        <!-- AGRONOMIST ONLY -->
        <?php if ($role == "agronomist") { ?>

            <div class="profile-info">
                <span class="label">Specialized:</span>
                <?php echo htmlspecialchars($user['specialized']); ?>
            </div>

            <div class="profile-info">
                <span class="label">Experience:</span>
                <?php echo htmlspecialchars($user['experienced']); ?>
            </div>

            <div class="profile-info">
                <span class="label">Region:</span>
                <?php echo htmlspecialchars($user['region']); ?>
            </div>

        <?php } ?>

        <!-- BUTTONS -->
        <a href="edit_profile.php" class="edit-btn">✏️ Edit Profile</a>
        <a href="dashboard.php" class="back-btn">⬅ Back to Dashboard</a>

    </div>
</div>

<!-- ✅ AUTO HIDE MESSAGE + CLEAN URL -->
<script>
    const msg = document.getElementById("successMsg");

    if (msg) {
        setTimeout(() => {
            msg.style.display = "none";

            // remove ?updated=1 from URL (clean)
            window.history.replaceState({}, document.title, "profile.php");
        }, 2500);
    }
</script>

</body>
</html>