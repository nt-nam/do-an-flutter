<?php
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

$email = $data['Email'];
$password = password_hash($data['MatKhau'], PASSWORD_DEFAULT); // Hash mật khẩu
$fullName = $data['HoTen'] ?? null;
$phone = $data['SDT'] ?? null;
$address = $data['DiaChi'] ?? null;

$conn = new mysqli('localhost', 'username', 'password', 'gas_db');
if ($conn->connect_error) die(json_encode(['error' => 'Kết nối thất bại']));

// Thêm vào taikhoan
$stmt = $conn->prepare("INSERT INTO taikhoan (Email, MatKhau, VaiTro, TrangThai) VALUES (?, ?, 1, 1)");
$stmt->bind_param('ss', $email, $password);
$stmt->execute();
$maTK = $conn->insert_id;

// Thêm vào nguoidung nếu có thông tin
if ($fullName || $phone || $address) {
  $stmt = $conn->prepare("INSERT INTO nguoidung (MaTK, HoTen, SDT, DiaChi) VALUES (?, ?, ?, ?)");
  $stmt->bind_param('isss', $maTK, $fullName, $phone, $address);
  $stmt->execute();
}

$response = [
  'MaTK' => $maTK,
  'Email' => $email,
  'VaiTro' => 1,
  'TrangThai' => 1,
  'HoTen' => $fullName,
  'SDT' => $phone,
  'DiaChi' => $address,
];
echo json_encode($response);

$stmt->close();
$conn->close();
?>