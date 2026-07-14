<?php
session_start();
include("db_connect.php");

/* সুরক্ষা: user login check */
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$user_name = $_SESSION['name'];
?>

<!DOCTYPE html>
<html>

<head>
    <title>Farmer Dashboard | FarmVista</title>
    <link rel="stylesheet" href="dashboard.css">
    <style>
        /* চ্যাট বাটনের জন্য ছোট সিএসএস */
        .chat-btn {
            display: inline-block;
            margin-top: 5px;
            padding: 5px 10px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 11px;
        }

        .chat-btn:hover {
            background: #1b5e20;
        }
    </style>
</head>

<body>

    <div id="overlay" class="overlay" onclick="toggleSidebar()"></div>

    <div class="sidebar" id="sidebar">
        <h2>🌱 FarmVista</h2>
        <a class="active">🏠 Home</a>
        <a>🌿 Farms</a>
        <a href="agronomist.php">👨‍🌾 Agronomists</a>
        <a href="medicine.php">💊 Medicine</a>
        <a href="chat_list.php">💬 Messages</a> <a href="add_farm.php">🌾 Add Farm</a>
        <a href="profile.php">👤 Profile</a>
        <a href="logout.php" class="logout">🚪 Logout</a>
    </div>

    <div class="content" id="content">

        <div class="navbar">
            <span class="menu-btn" onclick="toggleSidebar()">☰</span>
            <div class="weather-card" id="weather">Loading weather...</div>
            <div style="margin-left: auto; display: flex; align-items: center; gap: 15px;">
                <span>Welcome, <strong><?php echo $user_name; ?></strong></span>
                <span class="icon">🔔</span>
            </div>
        </div>

        <div class="header">
            <img src="assets/dashboard.png" alt="Dashboard">
        </div>

        <div class="stats">
            <?php
            $farmCount = $conn->query("SELECT COUNT(*) AS total FROM farms WHERE status='Active'")->fetch_assoc();
            ?>
            <div class="card">
                🌾<br>
                <a href="farms.php"><?php echo $farmCount['total']; ?> Crops</a>
            </div>

            <?php
            $agroCount = $conn->query("SELECT COUNT(*) AS total FROM agronomist")->fetch_assoc();
            ?>
            <div class="card">
                👨‍🌾<br>
                <a href="agronomist.php"><?php echo $agroCount['total']; ?> Agronomists</a>
            </div>

            <?php
            $farmerCount = $conn->query("SELECT COUNT(*) AS total FROM farmer")->fetch_assoc();
            ?>
            <div class="card">
                👨‍🌾<br>
                <?php echo $farmerCount['total']; ?> Farmers
            </div>

            <?php
            $medCount = $conn->query("SELECT COUNT(*) AS total FROM medicines")->fetch_assoc();
            ?>
            <div class="card">
                💊<br>
                <a href="medicine.php"><?php echo $medCount['total']; ?> Medicines</a>
            </div>
        </div>

        <div class="section">
            <div class="section-header">
                <h3>Agronomists</h3>
                <span><a href="agronomist.php" class="view-btn">View all...</a></span>
            </div>

            <div class="scroll">
                <?php
                $agroList = $conn->query("SELECT a.id, a.fullname, u.image FROM agronomist a LEFT JOIN user_profile u ON a.id = u.user_id AND u.role = 'agronomist' LIMIT 10");
                if ($agroList->num_rows > 0) {
                    while ($row = $agroList->fetch_assoc()) {
                ?>
                        <div class="avatar-card" style="text-align: center;">
                            <a href="view_agronomist.php?id=<?php echo $row['id']; ?>">
                                <?php if (!empty($row['image'])) { ?>
                                    <img src="<?php echo htmlspecialchars($row['image']); ?>" class="avatar-img">
                                <?php } else { ?>
                                    <div class="avatar"></div>
                                <?php } ?>
                                <p><?php echo htmlspecialchars($row['fullname']); ?></p>
                            </a>
                            <a href="chat.php?receiver_id=<?php echo $row['id']; ?>" class="chat-btn">💬 Chat Now</a>
                        </div>
                <?php
                    }
                } else {
                    echo "<p>No agronomists found</p>";
                }
                ?>
            </div>
        </div>

        <div class="section">
            <div class="section-header">
                <h3>Medicines</h3>
                <span><a href="medicine.php" class="view-btn">View all...</a></span>
            </div>
            <div class="scroll">
                <?php
                $medicines = $conn->query("SELECT * FROM medicines ORDER BY created_at DESC LIMIT 10");
                while ($row = $medicines->fetch_assoc()):
                ?>
                    <a href="medicine_details.php?id=<?php echo $row['id']; ?>" class="pill-link">
                        <div class="pill">
                            <img src="uploads/<?php echo $row['image']; ?>">
                            <p><?php echo $row['name']; ?></p>
                            <small>৳<?php echo $row['price']; ?></small>
                        </div>
                    </a>
                <?php endwhile; ?>
            </div>
        </div>

        <div class="section">
            <div class="section-header">
                <h3>Farms</h3>
                <span><a href="farms.php" class="view-btn">View all...</a></span>
            </div>
            <?php
            function getFarmBadge($type)
            {
                switch (strtolower($type)) {
                    case 'vegetables':
                        return ['emoji' => '🥦', 'class' => 'veg'];
                    case 'fruits':
                        return ['emoji' => '🍎', 'class' => 'fruit'];
                    case 'grains':
                        return ['emoji' => '🌾', 'class' => 'grain'];
                    default:
                        return ['emoji' => '🌱', 'class' => 'default'];
                }
            }
            ?>
            <div class="farm-scroll">
                <?php
                $farms = $conn->query("SELECT * FROM farms WHERE status='Active' ORDER BY created_at DESC LIMIT 10");
                while ($row = $farms->fetch_assoc()):
                    $badge = getFarmBadge($row['farm_type']);
                ?>
                    <a href="farm_details.php?id=<?php echo $row['id']; ?>" class="farm-link">
                        <div class="farm-card">
                            <span class="farm-badge <?php echo $badge['class']; ?>"><?php echo $badge['emoji']; ?></span>
                            <img src="uploads/<?php echo $row['image'] ?: 'default.png'; ?>">
                            <h4><?php echo htmlspecialchars($row['crop_name']); ?></h4>
                            <p><?php echo htmlspecialchars($row['farm_type']); ?></p>
                        </div>
                    </a>
                <?php endwhile; ?>
            </div>
        </div>
    </div>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("overlay").classList.toggle("active");
        }
    </script>
    <script src="script.js"></script>
</body>

</html>