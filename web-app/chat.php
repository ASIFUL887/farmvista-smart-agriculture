<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$my_id = $_SESSION['user_id'];
$my_name = $_SESSION['name'];
$my_role = $_SESSION['role'];

$receiver_id = isset($_GET['receiver_id']) ? (int)$_GET['receiver_id'] : 0;

if ($receiver_id == 0) {
    echo "Please select a user to chat.";
    exit();
}

// --- নতুন ডাইনামিক নাম লজিক ---
$target_name = "User"; // ডিফল্ট নাম

// প্রথমে চেক করা হচ্ছে অপরপক্ষ কি কৃষক?
$check_farmer = $conn->query("SELECT fullname FROM farmer WHERE id = $receiver_id");
if ($check_farmer && $check_farmer->num_rows > 0) {
    $target_data = $check_farmer->fetch_assoc();
    $target_name = $target_data['fullname'];
} else {
    // যদি কৃষক না হয়, তবে চেক করা হচ্ছে সে কি কৃষিবিদ?
    $check_agro = $conn->query("SELECT fullname FROM agronomist WHERE id = $receiver_id");
    if ($check_agro && $check_agro->num_rows > 0) {
        $target_data = $check_agro->fetch_assoc();
        $target_name = "Dr. " . $target_data['fullname'];
    }
}
// --- লজিক শেষ ---
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Chat | FarmVista</title>
    <style>
        :root {
            --bg-light: #e8f5e9;
            --primary: #2e7d32;
            --sent: #a5d6a7;
            --received: #ffffff;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg-light);
            margin: 0;
            display: flex;
            justify-content: center;
        }

        .chat-container {
            width: 100%;
            max-width: 450px;
            height: 100vh;
            background: var(--bg-light);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .chat-header {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .header-info strong {
            font-size: 18px;
            color: #333;
        }

        .call-actions button {
            background: none;
            border: none;
            font-size: 22px;
            cursor: pointer;
            margin-left: 15px;
            color: #333;
        }

        .consult-banner {
            background: #c8e6c9;
            margin: 10px 20px;
            padding: 12px;
            text-align: center;
            border-radius: 12px;
            font-size: 13px;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }

        #call-screen {
            display: none;
            width: 100%;
            height: 70%;
            background: #fff;
            position: absolute;
            top: 0;
            z-index: 100;
            border-radius: 0 0 30px 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        #call-frame {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 0 0 30px 30px;
        }

        .end-call-btn {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #ff5252;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
            cursor: pointer;
            font-weight: bold;
        }

        #chat-box {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .message {
            margin-bottom: 15px;
            padding: 12px 16px;
            border-radius: 18px;
            max-width: 75%;
            font-size: 14px;
            line-height: 1.4;
        }

        .sent {
            align-self: flex-end;
            background: var(--sent);
            color: #1b5e20;
            border-bottom-right-radius: 2px;
        }

        .received {
            align-self: flex-start;
            background: var(--received);
            color: #333;
            border-bottom-left-radius: 2px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .input-area {
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .input-wrapper {
            flex: 1;
            background: #fff;
            border-radius: 30px;
            padding: 5px 15px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        input[type="text"] {
            flex: 1;
            border: none;
            padding: 10px;
            outline: none;
            font-size: 14px;
            background: none;
        }

        #upload-options {
            display: none;
            position: absolute;
            bottom: 60px;
            left: 0;
            background: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            padding: 10px;
            z-index: 10;
            width: 150px;
        }

        .opt-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            cursor: pointer;
            border-radius: 8px;
            font-size: 14px;
        }

        .opt-btn:hover {
            background: #f0f2f5;
        }

        .attachment-btn {
            font-size: 20px;
            color: #888;
            cursor: pointer;
            margin-right: 5px;
        }

        .send-btn {
            background: var(--primary);
            color: white;
            border: none;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
    </style>
</head>

<body>

    <div class="chat-container">
        <div class="chat-header">
            <div class="header-info">
                <span style="cursor:pointer;" onclick="history.back()">❮ &nbsp;</span>
                <strong><?php echo htmlspecialchars($target_name); ?></strong>
            </div>
            <div class="call-actions">
                <button onclick="startCall('video')">📹</button>
                <button onclick="startCall('audio')">📞</button>
            </div>
        </div>

        <div class="consult-banner">
            <strong>Consultation Start</strong><br>
            <small>You can chat with <?php echo htmlspecialchars($target_name); ?> now.</small>
        </div>

        <div id="call-screen">
            <iframe id="call-frame" allow="camera; microphone; display-capture; autoplay"></iframe>
            <button class="end-call-btn" onclick="closeCall()">End Call</button>
        </div>

        <div id="chat-box"></div>

        <div class="input-area">
            <div class="input-wrapper">
                <div id="upload-options">
                    <div class="opt-btn" onclick="triggerFileInput('image')">🖼️ Image</div>
                    <div class="opt-btn" onclick="triggerFileInput('video')">📹 Video</div>
                    <div class="opt-btn" onclick="triggerFileInput('file')">📁 File</div>
                </div>

                <input type="file" id="real_file_input" style="display:none;" onchange="uploadFile(this)">
                <span class="attachment-btn" onclick="toggleOptions()">📎</span>

                <input type="text" id="message_text" placeholder="Type message..." onkeypress="if(event.keyCode==13) sendMessage()">
            </div>
            <button class="send-btn" onclick="sendMessage()">➤</button>
        </div>
    </div>

    <script>
        const receiverId = <?php echo $receiver_id; ?>;
        const chatBox = document.getElementById('chat-box');

        function toggleOptions() {
            let opt = document.getElementById('upload-options');
            opt.style.display = (opt.style.display === 'block') ? 'none' : 'block';
        }

        function triggerFileInput(type) {
            let input = document.getElementById('real_file_input');
            if (type === 'image') input.accept = "image/*";
            else if (type === 'video') input.accept = "video/*";
            else input.accept = "*";
            input.click();
            toggleOptions();
        }

        function uploadFile(input) {
            if (input.files.length === 0) return;
            let formData = new FormData();
            formData.append('file_input', input.files[0]);
            formData.append('receiver_id', receiverId);

            fetch('send_message.php', {
                method: 'POST',
                body: formData
            }).then(() => {
                input.value = "";
                loadMessages();
            });
        }

        function sendMessage() {
            let msgInput = document.getElementById('message_text');
            let msg = msgInput.value.trim();
            if (msg == "") return;

            let formData = new FormData();
            formData.append('receiver_id', receiverId);
            formData.append('message', msg);

            fetch('send_message.php', {
                method: 'POST',
                body: formData
            }).then(() => {
                msgInput.value = "";
                loadMessages();
            });
        }

        function startCall(type) {
            let roomName = "FarmVista_" + Math.min(receiverId, <?php echo $my_id; ?>) + "_" + Math.max(receiverId, <?php echo $my_id; ?>);
            let callUrl = `https://meet.jit.si/${roomName}#config.prejoinPageEnabled=false`;
            let msg = `📞 Started a ${type} call. [Join Here](${callUrl})`;

            let formData = new FormData();
            formData.append('receiver_id', receiverId);
            formData.append('message', msg);

            fetch('send_message.php', {
                method: 'POST',
                body: formData
            }).then(() => {
                document.getElementById('call-screen').style.display = 'block';
                document.getElementById('call-frame').src = callUrl;
                loadMessages();
            });
        }

        function closeCall() {
            document.getElementById('call-screen').style.display = 'none';
            document.getElementById('call-frame').src = "";
        }

        function loadMessages() {
            fetch(`fetch_messages.php?receiver_id=${receiverId}`)
                .then(res => res.text())
                .then(data => {
                    const isAtBottom = chatBox.scrollHeight - chatBox.clientHeight <= chatBox.scrollTop + 100;
                    chatBox.innerHTML = data;
                    if (isAtBottom) chatBox.scrollTop = chatBox.scrollHeight;
                });
        }

        setInterval(loadMessages, 2000);
        window.onload = loadMessages;
    </script>
</body>

</html>