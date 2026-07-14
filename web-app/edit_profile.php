<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$role = $_SESSION['role'];
$table = ($role == "farmer") ? "farmer" : "agronomist";

/* UPDATE PROFILE */
if (isset($_POST['update'])) {

    $fullname = $_POST['fullname'];
    $contact = $_POST['contact'];
    $dob = $_POST['dob'];

    if ($role == "farmer") {
        $stmt = $conn->prepare("UPDATE farmer SET fullname=?, contact=?, dob=? WHERE id=?");
        $stmt->bind_param("sssi", $fullname, $contact, $dob, $user_id);
    } else {
        $specialized = $_POST['specialized'];
        $experienced = $_POST['experienced'];
        $region = $_POST['region'];

        $stmt = $conn->prepare("UPDATE agronomist SET fullname=?, contact=?, dob=?, specialized=?, experienced=?, region=? WHERE id=?");
        $stmt->bind_param("ssssssi", $fullname, $contact, $dob, $specialized, $experienced, $region, $user_id);
    }

    $stmt->execute();
    header("Location: profile.php?updated=1");
    exit();
}

/* IMAGE UPLOAD */
if (isset($_POST['upload'])) {

    $imageName = $_FILES['image']['name'];
    $tmp = $_FILES['image']['tmp_name'];

    $folder = "uploads/" . time() . "_" . $imageName;

    move_uploaded_file($tmp, $folder);

    /* Check if exists */
    $check = $conn->prepare("SELECT * FROM user_profile WHERE user_id=? AND role=?");
    $check->bind_param("is", $user_id, $role);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows > 0) {
        $stmt = $conn->prepare("UPDATE user_profile SET image=? WHERE user_id=? AND role=?");
        $stmt->bind_param("sis", $folder, $user_id, $role);
    } else {
        $stmt = $conn->prepare("INSERT INTO user_profile (user_id, role, image) VALUES (?, ?, ?)");
        $stmt->bind_param("iss", $user_id, $role, $folder);
    }

    $stmt->execute();
}

/* FETCH USER */
$stmt = $conn->prepare("SELECT * FROM $table WHERE id=?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();

/* FETCH IMAGE */
$stmt2 = $conn->prepare("SELECT image FROM user_profile WHERE user_id=? AND role=?");
$stmt2->bind_param("is", $user_id, $role);
$stmt2->execute();
$res2 = $stmt2->get_result();
$img = ($res2->num_rows > 0) ? $res2->fetch_assoc()['image'] : "";
?>

<!DOCTYPE html>
<html>

<head>
    <title>Edit Profile</title>
    <link rel="stylesheet" href="profile.css">
</head>

<body>

    <div class="profile-container">
        <div class="profile-card">

            <h2>Edit Profile</h2>

            <!-- PROFILE IMAGE -->
            <form method="POST" enctype="multipart/form-data">
                <?php if ($img) { ?>
                    <img src="<?php echo $img; ?>" width="100" style="border-radius:50%;">
                <?php } else { ?>
                    <div class="avatar"></div>
                <?php } ?>

                <input type="file" name="image" required>
                <button type="submit" name="upload">Upload Photo</button>
            </form>

            <hr>

            <!-- PROFILE UPDATE -->
            <form method="POST">

                <input type="text" name="fullname" value="<?php echo $user['fullname']; ?>" required><br><br>

                <input type="text" name="contact" value="<?php echo $user['contact']; ?>"><br><br>

                <input type="date" name="dob" value="<?php echo $user['dob']; ?>"><br><br>

                <?php if ($role == "agronomist") { ?>

                    <input type="text" name="specialized" value="<?php echo $user['specialized']; ?>"><br><br>

                    <input type="text" name="experienced" value="<?php echo $user['experienced']; ?>"><br><br>

                    <input type="text" name="region" value="<?php echo $user['region']; ?>"><br><br>

                <?php } ?>

                <button type="submit" name="update">Update Profile</button>
            </form>

        </div>
    </div>

</body>

</html>