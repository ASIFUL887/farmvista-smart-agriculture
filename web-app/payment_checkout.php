<?php
session_start();
include("db_connect.php");

// সেশন চেক: ইউজার লগইন না থাকলে লগইন পেজে পাঠাবে
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$role = $_SESSION['role']; // সেশন থেকে রোল নেওয়া হচ্ছে

// রোল অনুযায়ী সঠিক টেবিল (farmer/agronomist) থেকে ডাটা আনা হচ্ছে
$user_query = $conn->query("SELECT * FROM $role WHERE id = $user_id");
$user_data = $user_query->fetch_assoc();

// ইউআরএল থেকে প্রাইস এবং কোয়ান্টিটি ধরা
$unit_price = isset($_GET['price']) ? (float)$_GET['price'] : 0;
$quantity = isset($_GET['qty']) ? (int)$_GET['qty'] : 1;
$item_total = $unit_price * $quantity;
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Checkout | FarmVista</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        :root {
            --primary: #2e7d32;
            --bkash: #d12053;
            --nagad: #f15a22;
            --daraz: #f85606;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            margin: 0;
            transition: 0.3s;
        }

        .checkout-container {
            max-width: 500px;
            margin: 20px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .blur {
            filter: blur(8px);
            pointer-events: none;
        }

        .header {
            background: #fff;
            border-bottom: 1px solid #eee;
            padding: 15px;
            text-align: center;
        }

        .content {
            padding: 20px;
        }

        .step {
            display: none;
        }

        .step.active {
            display: block;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .shipping-box {
            background: #f9f9f9;
            border-left: 4px solid var(--primary);
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
        }

        .btn-pay {
            background: var(--daraz);
            color: white;
            border: none;
            width: 100%;
            padding: 16px;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }

        /* Overlay System */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal {
            background: #fff;
            width: 95%;
            max-width: 380px;
            border-radius: 15px;
            overflow: hidden;
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 15px;
            background: #f8f8f8;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
        }

        .modal-body {
            padding: 20px;
        }

        .pay-card {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
            cursor: pointer;
            text-align: center;
            font-weight: bold;
        }

        .pay-card:hover {
            border-color: var(--daraz);
            background: #fff5f0;
        }

        /* bKash Theme Simulation */
        .bkash-bg {
            background: var(--bkash);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .bkash-input {
            background: white;
            color: black;
            border: none;
            font-size: 18px;
            font-weight: bold;
        }

        .loader {
            border: 4px solid #f3f3f3;
            border-top: 4px solid var(--bkash);
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
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

    <div id="main-content" class="checkout-container">
        <div class="header">
            <h3>Checkout</h3>
        </div>
        <div class="content">
            <form id="orderForm">
                <div id="step1" class="step active">
                    <div class="shipping-box">
                        <strong><?php echo htmlspecialchars($user_data['fullname']); ?></strong>
                        <span style="display:block; font-size:12px; color:#666;"><?php echo htmlspecialchars($user_data['contact']); ?></span>
                    </div>

                    <label style="font-size: 12px; color:#888;">Select Division</label>
                    <select id="division" onchange="updateDistricts()">
                        <option value="Dhaka">Dhaka</option>
                        <option value="Chittagong">Chittagong</option>
                        <option value="Rajshahi">Rajshahi</option>
                        <option value="Sylhet">Sylhet</option>
                        <option value="Khulna">Khulna</option>
                        <option value="Barisal">Barisal</option>
                        <option value="Rangpur">Rangpur</option>
                        <option value="Mymensingh">Mymensingh</option>
                    </select>

                    <label style="font-size: 12px; color:#888;">Select District</label>
                    <select id="district" onchange="calculateShipping()"></select>

                    <textarea id="address_input" placeholder="House No / Road / Area Details" rows="2" required></textarea>

                    <div style="background:#e8f5e9; padding:10px; border-radius:5px; margin:10px 0;">
                        <div style="display:flex; justify-content:space-between;">
                            <span>Item Price:</span>
                            <strong>৳<?php echo $item_total; ?></strong>
                        </div>
                        <div style="display:flex; justify-content:space-between;">
                            <span>Shipping Fee:</span>
                            <strong id="ship_cost">৳60</strong>
                        </div>
                    </div>

                    <h4>Payment Method</h4>
                    <div class="pay-card" onclick="setCOD()" id="cod-btn">📦 Cash on Delivery</div>
                    <div class="pay-card" onclick="openPaymentOverlay()">💳 Digital Payment</div>

                    <input type="hidden" name="method" id="final_method" value="COD">
                    <input type="hidden" name="gateway" id="final_gateway" value="N/A">
                    <input type="hidden" name="trxid" id="final_trxid" value="N/A">
                    <input type="hidden" name="amount" id="final_amount">

                    <button type="button" class="btn-pay" onclick="confirmFinalOrder()">Proceed to Pay: <span id="total-btn-text">৳0</span></button>
                </div>

                <div id="step-invoice" class="step">
                    <div id="invoice-capture" style="padding:20px; border:1px solid #333; background:#fff;">
                        <h3 style="text-align:center; color:var(--primary); margin:0;">FarmVista OFFICIAL INVOICE</h3>
                        <hr>
                        <table style="width:100%; font-size:13px; line-height:2;">
                            <tr>
                                <td><strong>Customer:</strong></td>
                                <td align="right"><?php echo htmlspecialchars($user_data['fullname']); ?></td>
                            </tr>
                            <tr>
                                <td><strong>Address:</strong></td>
                                <td align="right" id="inv-addr"></td>
                            </tr>
                            <tr>
                                <td><strong>Status:</strong></td>
                                <td align="right" id="inv-status"></td>
                            </tr>
                            <tr>
                                <td><strong>Paid Amount:</strong></td>
                                <td align="right" style="color:green;">৳<span id="inv-paid">0</span></td>
                            </tr>
                            <tr>
                                <td><strong>Due Amount:</strong></td>
                                <td align="right" style="color:red; font-weight:bold;">৳<span id="inv-due">0</span></td>
                            </tr>
                            <tr style="border-top:1px solid #eee;">
                                <td><strong>Total Bill:</strong></td>
                                <td align="right"><strong>৳<span id="inv-total"></span></strong></td>
                            </tr>
                            <tr id="inv-trx-row">
                                <td><strong>Transaction ID:</strong></td>
                                <td align="right" id="inv-trx"></td>
                            </tr>
                        </table>
                        <div id="qrcode" style="display:flex; justify-content:center; margin-top:10px;"></div>
                    </div>
                    <button type="button" class="btn-pay" style="background:#333;" onclick="downloadPDF()">Download PDF</button>
                    <button type="button" class="btn-pay" onclick="location.href='dashboard.php'">Confirm & Finish</button>
                </div>
            </form>
        </div>
    </div>

    <div class="overlay" id="paymentOverlay">
        <div class="modal">
            <div class="modal-header">
                <strong>Payment Protection</strong>
                <span style="cursor:pointer; font-size:20px;" onclick="closeOverlay()">&times;</span>
            </div>
            <div class="modal-body" id="modal-content"></div>
        </div>
    </div>

    <script>
        const districtsByDivision = {
            "Dhaka": ["Dhaka City", "Savar", "Gazipur", "Narayanganj", "Keraniganj", "Tongi", "Ashulia", "Manikganj", "Munshiganj", "Narsingdi", "Faridpur", "Gopalganj", "Kishoreganj", "Madaripur", "Rajbari", "Shariatpur", "Tangail"],
            "Chittagong": ["Chittagong City", "Cox's Bazar", "Comilla", "Feni", "Noakhali", "Brahmanbaria", "Chandpur", "Lakshmipur", "Khagrachhari", "Rangamati", "Bandarban"],
            "Rajshahi": ["Rajshahi City", "Bogra", "Pabna", "Natore", "Naogaon", "Chapai Nawabganj", "Joypurhat", "Sirajganj"],
            "Sylhet": ["Sylhet City", "Moulvibazar", "Habiganj", "Sunamganj"],
            "Khulna": ["Khulna City", "Jessore", "Bagerhat", "Chuadanga", "Jhenaidah", "Kushtia", "Magura", "Meherpur", "Narail", "Satkhira"],
            "Barisal": ["Barisal City", "Bhola", "Patuakhali", "Barguna", "Jhalokati", "Pirojpur"],
            "Rangpur": ["Rangpur City", "Dinajpur", "Kurigram", "Gaibandha", "Lalmonirhat", "Nilphamari", "Panchagarh", "Thakurgaon"],
            "Mymensingh": ["Mymensingh City", "Netrokona", "Sherpur", "Jamalpur"]
        };

        let itemPrice = <?php echo $item_total; ?>;
        let shippingFee = 60;
        let methodType = "COD";

        // ডামি পেমেন্ট ডাটা জেনারেট
        let generatedOTP = Math.floor(1000 + Math.random() * 9000);
        let generatedTrx = "8N" + Math.random().toString(36).substr(2, 7).toUpperCase();

        function updateDistricts() {
            const div = document.getElementById('division').value;
            const distSelect = document.getElementById('district');
            distSelect.innerHTML = '';
            districtsByDivision[div].forEach(d => {
                let opt = document.createElement("option");
                opt.value = d;
                opt.text = d;
                distSelect.appendChild(opt);
            });
            calculateShipping();
        }

        function calculateShipping() {
            const div = document.getElementById('division').value;
            const dist = document.getElementById('district').value;
            if (dist === "Dhaka City") shippingFee = 60;
            else if (div === "Dhaka") shippingFee = 80;
            else shippingFee = 120;
            document.getElementById('ship_cost').innerText = "৳" + shippingFee;
            let total = itemPrice + shippingFee;
            document.getElementById('total-btn-text').innerText = "৳" + total;
            document.getElementById('final_amount').value = total;
        }

        function openPaymentOverlay() {
            document.getElementById('main-content').classList.add('blur');
            document.getElementById('paymentOverlay').style.display = 'flex';
            renderGateways();
        }

        function closeOverlay() {
            document.getElementById('main-content').classList.remove('blur');
            document.getElementById('paymentOverlay').style.display = 'none';
        }

        function renderGateways() {
            document.getElementById('modal-content').innerHTML = `
                <div class="pay-card" onclick="renderBkash()">📱 bKash Payment</div>
                <div class="pay-card" onclick="alert('Nagad logic can be added similarly')">📱 Nagad</div>`;
        }

        // bKash Simulation Logic
        function renderBkash() {
            document.getElementById('modal-content').innerHTML = `
                <div class="bkash-bg">
                    <img src="https://www.bkash.com/uploads/images/bkash-logo.png" width="80" style="background:white; padding:5px; border-radius:5px;">
                    <div id="bkash-step1">
                        <p>Enter bKash Account Number</p>
                        <input type="text" id="b_phone" class="bkash-input" placeholder="01XXXXXXXXX" maxlength="11" style="text-align:center;">
                        <div class="loader" id="b_loader"></div>
                        <button class="btn-pay" style="background:white; color:var(--bkash);" onclick="startBkashOTP()">PROCEED</button>
                    </div>
                    <div id="bkash-step2" style="display:none;">
                        <p style="color:#ffeb3b; font-size:12px;">Simulated SMS sent to your browser</p>
                        <p>Enter 4-Digit OTP</p>
                        <input type="text" id="b_otp" class="bkash-input" placeholder="0000" style="text-align:center;">
                        <button class="btn-pay" style="background:white; color:var(--bkash);" onclick="verifyBkashOTP()">VERIFY</button>
                    </div>
                </div>`;
        }

        function startBkashOTP() {
            let ph = document.getElementById('b_phone').value;
            if (ph.length < 11) return alert("Enter valid number");

            document.getElementById('b_loader').style.display = 'block';
            setTimeout(() => {
                document.getElementById('bkash-step1').style.display = 'none';
                document.getElementById('bkash-step2').style.display = 'block';

                // Fake SMS Notification
                Swal.fire({
                    title: 'New Message (bKash)',
                    html: `Verification Code: <b>${generatedOTP}</b>. TrxID: ${generatedTrx}.`,
                    icon: 'info',
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 10000
                });
            }, 1500);
        }

        function verifyBkashOTP() {
            let otp = document.getElementById('b_otp').value;
            if (otp == generatedOTP) {
                document.getElementById('final_method').value = "Digital";
                document.getElementById('final_gateway').value = "bKash";
                document.getElementById('final_trxid').value = generatedTrx;
                methodType = "Digital";
                Swal.fire('Success', 'Payment Verified!', 'success');
                closeOverlay();
            } else {
                alert("Invalid OTP!");
            }
        }

        function setCOD() {
            document.getElementById('final_method').value = "COD";
            methodType = "COD";
            alert("Cash on Delivery Selected");
        }

        function confirmFinalOrder() {
            const addr = document.getElementById('address_input').value;
            if (!addr) return alert("Please enter shipping address");

            document.getElementById('step1').classList.remove('active');
            document.getElementById('step-invoice').classList.add('active');

            let totalBill = itemPrice + shippingFee;
            let paidAmt = (methodType === "Digital") ? itemPrice : 0;
            let dueAmt = (methodType === "Digital") ? shippingFee : totalBill;

            document.getElementById('inv-addr').innerText = document.getElementById('district').value + ", " + document.getElementById('division').value;
            document.getElementById('inv-total').innerText = totalBill;
            document.getElementById('inv-paid').innerText = paidAmt;
            document.getElementById('inv-due').innerText = dueAmt;

            if (methodType === "Digital") {
                document.getElementById('inv-status').innerText = "Partially Paid (bKash)";
                document.getElementById('inv-trx').innerText = generatedTrx;
                document.getElementById('inv-trx-row').style.display = 'table-row';
            } else {
                document.getElementById('inv-status').innerText = "Unpaid (COD)";
                document.getElementById('inv-trx-row').style.display = 'none';
            }

            // AJAX call to save
            fetch('ajax_process_order.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    address: addr,
                    method: methodType,
                    trxid: generatedTrx,
                    total: totalBill
                })
            });

            new QRCode(document.getElementById("qrcode"), {
                text: "ORDER-" + Date.now(),
                width: 80,
                height: 80
            });
        }

        function downloadPDF() {
            html2pdf().from(document.getElementById('invoice-capture')).save('FarmVista_Invoice.pdf');
        }

        updateDistricts();
    </script>
</body>

</html>