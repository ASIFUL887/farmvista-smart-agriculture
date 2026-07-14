<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_SESSION['user_id'];
    $amount = $_POST['amount'];
    $method = $_POST['method'];
    $phone = $_POST['phone'];
    $trx_id = $_POST['trx_id'];

    $sql = "INSERT INTO payments (user_id, amount, method, phone_number, trx_id) 
            VALUES ('$user_id', '$amount', '$method', '$phone', '$trx_id')";

    if ($conn->query($sql)) {
        $success = "Payment submitted! Wait for admin approval.";
    } else {
        $error = "Error: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Payment | FarmVista</title>
    <style>
        body {
            font-family: sans-serif;
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            padding: 20px;
        }

        .pay-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .method-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .method-box label {
            flex: 1;
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            border-radius: 8px;
            cursor: pointer;
        }

        input[type="radio"]:checked+span {
            color: #d81b60;
            font-weight: bold;
        }

        .inst {
            background: #fff3e0;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 15px;
            border-left: 4px solid #ff9800;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
        }

        .pay-btn {
            width: 100%;
            background: #d81b60;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>

<body>

    <div class="pay-card">
        <h2 style="text-align:center; color: #2e7d32;">FarmVista Payment</h2>

        <?php if (isset($success)) echo "<p style='color:green;'>$success</p>"; ?>
        <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>

        <div class="inst">
            <strong>Instruction:</strong> Send Money to <b>017XXXXXXXX</b> (bKash/Nagad Personal) and enter the Transaction ID below.
        </div>
        a<?php
            session_start();
            include("db_connect.php");
            if (!isset($_SESSION['user_id'])) {
                header("Location: login.php");
                exit();
            }
            ?>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>bKash Payment Simulation</title>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <style>
                body {
                    font-family: 'Segoe UI', sans-serif;
                    background: #e3e6e6;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }

                .bkash-frame {
                    width: 350px;
                    background: #d12053;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                }

                .bkash-header {
                    padding: 20px;
                    text-align: center;
                    background: #fff;
                }

                .bkash-body {
                    padding: 30px 20px;
                    color: white;
                    text-align: center;
                }

                input {
                    width: 100%;
                    padding: 12px;
                    margin: 10px 0;
                    border: none;
                    border-radius: 5px;
                    font-size: 16px;
                    text-align: center;
                }

                .btn-next {
                    width: 100%;
                    background: #b11b46;
                    color: white;
                    border: none;
                    padding: 12px;
                    cursor: pointer;
                    font-weight: bold;
                    border-radius: 5px;
                }

                .btn-next:hover {
                    background: #8e1538;
                }

                #otp-section,
                #trx-section {
                    display: none;
                }

                .loader {
                    border: 4px solid #f3f3f3;
                    border-top: 4px solid #d12053;
                    border-radius: 50%;
                    width: 30px;
                    height: 30px;
                    animation: spin 2s linear infinite;
                    margin: 10px auto;
                    display: none;
                }

                @keyframes spin {
                    0% {
                        transform: rotate(0deg);
                    }

                    100% {
                        transform: rotate(360deg);
                    }
                }
            </style>
        </head>

        <body>

            <div class="bkash-frame">
                <div class="bkash-header">
                    <img src="https://www.logo.wine/a/logo/BKash/BKash-Logo.wine.svg" width="120" alt="bKash">
                </div>

                <div class="bkash-body">
                    <div id="number-section">
                        <p>Enter your bKash Account number</p>
                        <input type="text" id="phone" placeholder="01XXXXXXXXX">
                        <button class="btn-next" onclick="sendOTP()">PROCEED</button>
                    </div>

                    <div class="loader" id="loader"></div>

                    <div id="otp-section">
                        <p>Check your browser notification for OTP</p>
                        <input type="text" id="otp_input" placeholder="Enter 6-digit OTP">
                        <button class="btn-next" onclick="verifyOTP()">VERIFY</button>
                    </div>

                    <div id="trx-section">
                        <p>Verification Success! <br>Enter Transaction ID to confirm</p>
                        <form action="save_payment.php" method="POST">
                            <input type="hidden" name="phone" id="final_phone">
                            <input type="number" name="amount" placeholder="Amount (BDT)" required>
                            <input type="text" name="trx_id" id="fake_trx" readonly>
                            <button type="submit" class="btn-next">CONFIRM PAYMENT</button>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                let generatedOTP = Math.floor(100000 + Math.random() * 900000); // র‍্যান্ডম OTP
                let fakeTrx = "7X" + Math.random().toString(36).substr(2, 8).toUpperCase(); // র‍্যান্ডম TrxID

                function sendOTP() {
                    let phone = document.getElementById('phone').value;
                    if (phone.length < 11) return alert("Enter valid number");

                    document.getElementById('number-section').style.display = 'none';
                    document.getElementById('loader').style.display = 'block';

                    setTimeout(() => {
                        document.getElementById('loader').style.display = 'none';
                        document.getElementById('otp-section').style.display = 'block';

                        // ব্রাউজার নোটিফিকেশন সিমুলেশন (SMS এর মতো)
                        Swal.fire({
                            title: 'New Message (bKash)',
                            text: `bKash Verification Code: ${generatedOTP}. TrxID: ${fakeTrx}. Amount: 500.00 TK.`,
                            icon: 'info',
                            toast: true,
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 10000
                        });
                    }, 2000);
                }

                function verifyOTP() {
                    let input = document.getElementById('otp_input').value;
                    if (input == generatedOTP) {
                        document.getElementById('otp-section').style.display = 'none';
                        document.getElementById('trx-section').style.display = 'block';
                        document.getElementById('fake_trx').value = fakeTrx;
                        document.getElementById('final_phone').value = document.getElementById('phone').value;
                    } else {
                        alert("Invalid OTP! Try again.");
                    }
                }
            </script>

        </body>

        </html>
        <form method="POST">
            <div class="method-box">
                <label><input type="radio" name="method" value="bkash" required> <span>bKash</span></label>
                <label><input type="radio" name="method" value="nagad"> <span>Nagad</span></label>
            </div>

            <input type="number" name="amount" placeholder="Enter Amount (BDT)" required>
            <input type="text" name="phone" placeholder="Your bKash/Nagad Number" required>
            <input type="text" name="trx_id" placeholder="Transaction ID (TrxID)" required>

            <button type="submit" class="pay-btn">Submit Payment</button>
        </form>
    </div>

</body>

</html>