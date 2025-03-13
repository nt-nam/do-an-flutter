
Chức năng chính của ứng dụng

Quản lý đơn hàng:
Khách hàng đặt hàng gas thông qua ứng dụng.
Nhân viên tiếp nhận và cập nhật trạng thái đơn hàng.

Kiểm soát kho hàng:
Quản lý số lượng gas trong kho.
Cảnh báo khi hàng sắp hết.
Cập nhật số lượng sau mỗi giao dịch.

Quản lý khách hàng:
Lưu trữ thông tin khách hàng.
Hỗ trợ truy xuất đơn hàng đã đặt.
Cho phép khách hàng đánh giá sản phẩm và dịch vụ.

Quản lý giao hàng:
Theo dõi tiến trình giao hàng theo thời gian thực.
Liên hệ với nhân viên giao hàng khi cần.

Thanh toán và ưu đãi:
Hỗ trợ nhiều phương thức thanh toán (tiền mặt, chuyển khoản, ví điện tử).
Áp dụng các mã giảm giá cho khách hàng.

Dữ liệu và API kết nối MySQL
Hệ thống sử dụng cơ sở dữ liệu MySQL, bao gồm các bảng dữ liệu chính:
1. Bảng sanpham (Quản lý sản phẩm)
Mã sản phẩm, Tên sản phẩm, Mô tả, Giá, Số lượng tồn kho, Trạng thái, Hình ảnh.
2. Bảng donhang (Quản lý đơn hàng)
Mã đơn hàng, Mã khách hàng, Ngày đặt hàng, Tổng tiền, Trạng thái, Địa chỉ giao hàng, Mã ưu đãi (nếu có).
3. Bảng giohang (Quản lý giỏ hàng của khách hàng)
Mã giỏ hàng, Mã tài khoản, Mã sản phẩm, Số lượng, Ngày thêm vào giỏ.
4. Bảng nguoidung (Thông tin người dùng)
Mã người dùng, Họ tên, Số điện thoại, Địa chỉ.
5. Bảng taikhoan (Xác thực người dùng)
Mã tài khoản, Email, Mật khẩu, Vai trò (admin/khách hàng/nhân viên giao hàng), Trạng thái tài khoản.
6. Bảng danhgia (Đánh giá sản phẩm)
Mã đánh giá, Mã tài khoản, Mã sản phẩm, Điểm đánh giá, Nhận xét, Ngày đánh giá.
7. Bảng uudai (Ưu đãi & khuyến mãi)
Mã ưu đãi, Tên ưu đãi, Mức giảm giá, Ngày bắt đầu, Ngày kết thúc, Trạng thái.

API kết nối với MySQL
Ứng dụng Flutter sẽ sử dụng API backend (Node.js + Express) để giao tiếp với MySQL, cung cấp các chức năng:
Đăng ký / Đăng nhập
Xem danh sách sản phẩm
Thêm sản phẩm vào giỏ hàng
Đặt hàng
Theo dõi trạng thái đơn hàng
Đánh giá sản phẩm
Quản lý kho hàng


lib/
│── main.dart                # Điểm khởi chạy ứng dụng
│── app.dart                 # Cấu hình chính của ứng dụng
│── dependencies.dart        # Cấu hình các dependency (BLoC, Repositories, Services)
│
├── core/                    # Chứa cấu hình chung & tiện ích hệ thống
│   ├── config/              
│   │   ├── api_config.dart  # URL API & các endpoint quan trọng
│   │   ├── app_theme.dart   # Cấu hình giao diện (theme)
│   │   ├── app_constants.dart # Các hằng số dùng chung
│   │
│   ├── services/            # Dịch vụ hỗ trợ API, Database, Local Storage
│   │   ├── api_service.dart  # Kết nối với API backend
│   │   ├── local_storage.dart # Lưu trữ dữ liệu cục bộ (SharedPreferences, Hive)
│   │   ├── auth_service.dart  # Xác thực đăng nhập, đăng ký
│   │   ├── notification_service.dart # Xử lý thông báo đẩy (Firebase)
│   │   ├── location_service.dart # Lấy vị trí giao hàng
│   │
│   ├── utils/               # Các hàm tiện ích chung
│   │   ├── validators.dart  # Kiểm tra tính hợp lệ của dữ liệu đầu vào
│   │   ├── formatters.dart  # Định dạng số, tiền tệ, thời gian
│   │   ├── logger.dart      # Ghi log lỗi
│   │   ├── network_checker.dart # Kiểm tra kết nối mạng
│
├── data/                    # Xử lý dữ liệu (Models, Repositories)
│   ├── models/              
│   │   ├── user_model.dart  
│   │   ├── product_model.dart
│   │   ├── order_model.dart   
│   │   ├── cart_model.dart    
│   │   ├── review_model.dart  
│   │
│   ├── repositories/        # Xử lý logic dữ liệu giữa API & BLoC
│   │   ├── product_repository.dart
│   │   ├── order_repository.dart
│   │   ├── cart_repository.dart
│   │   ├── user_repository.dart
│   │   ├── review_repository.dart
│   │   ├── auth_repository.dart
│   │   ├── payment_repository.dart  # Xử lý thanh toán (VNPay, Momo, PayPal)
│
├── logic/                   # BLoC quản lý trạng thái
│   ├── authentication/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   ├── auth_state.dart
│   │
│   ├── products/
│   │   ├── product_bloc.dart
│   │   ├── product_event.dart
│   │   ├── product_state.dart
│   │
│   ├── cart/
│   │   ├── cart_bloc.dart
│   │   ├── cart_event.dart
│   │   ├── cart_state.dart
│   │
│   ├── orders/
│   │   ├── order_bloc.dart
│   │   ├── order_event.dart
│   │   ├── order_state.dart
│   │
│   ├── reviews/
│   │   ├── review_bloc.dart
│   │   ├── review_event.dart
│   │   ├── review_state.dart
│   │
│   ├── notifications/
│   │   ├── notification_bloc.dart
│   │   ├── notification_event.dart
│   │   ├── notification_state.dart
│
├── presentation/            # Giao diện (UI)
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── order_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── review_screen.dart
│   │   ├── notification_screen.dart
│   │
│   ├── widgets/             # Các widget tái sử dụng
│   │   ├── product_card.dart
│   │   ├── cart_item.dart
│   │   ├── order_item.dart
│   │   ├── rating_stars.dart
│   │   ├── custom_button.dart
│   │   ├── input_field.dart
│   │   ├── empty_state.dart  # Widget hiển thị khi không có dữ liệu
│
├── routes/                  
│   ├── app_routes.dart       # Điều hướng giữa các màn hình
│
├── localization/            # Đa ngôn ngữ
│   ├── app_localization.dart
│   ├── en.json               # Ngôn ngữ tiếng Anh
│   ├── vi.json               # Ngôn ngữ tiếng Việt
│
├── assets/                  # Tài nguyên (hình ảnh, icon, fonts)
│   ├── images/
│   │   ├── logo.png
│   │   ├── banner.jpg
│   │
│   ├── fonts/
│   │   ├── Roboto-Regular.ttf
│   │   ├── Roboto-Bold.ttf

--table có trong project
DROP TABLE IF EXISTS `danhgia`;
CREATE TABLE IF NOT EXISTS `danhgia` (
`MaDG` int NOT NULL AUTO_INCREMENT,
`MaTK` int NOT NULL,
`MaSP` int NOT NULL,
`Diem` float NOT NULL,
`NhanXet` text,
`NgayDanhGia` date NOT NULL,
PRIMARY KEY (`MaDG`),
KEY `MaTK` (`MaTK`),
KEY `MaSP` (`MaSP`)
) ;

CREATE TABLE IF NOT EXISTS `donhang` (
`MaDH` int NOT NULL AUTO_INCREMENT,
`MaTK` int NOT NULL,
`NgayDat` date NOT NULL,
`TongTien` float NOT NULL,
`TrangThai` varchar(50) NOT NULL,
`DiaChiGiao` varchar(255) NOT NULL,
`MaUD` int DEFAULT NULL,
PRIMARY KEY (`MaDH`),
KEY `MaTK` (`MaTK`),
KEY `MaUD` (`MaUD`)
)

DROP TABLE IF EXISTS `giohang`;
CREATE TABLE IF NOT EXISTS `giohang` (
`MaGH` int NOT NULL AUTO_INCREMENT,
`MaTK` int NOT NULL,
`MaSP` int NOT NULL,
`SoLuong` int NOT NULL DEFAULT '1',
`NgayThem` date NOT NULL,
PRIMARY KEY (`MaGH`),
UNIQUE KEY `UC_GioHang` (`MaTK`,`MaSP`),
KEY `MaSP` (`MaSP`)
)

DROP TABLE IF EXISTS `nguoidung`;
CREATE TABLE IF NOT EXISTS `nguoidung` (
`MaND` int NOT NULL AUTO_INCREMENT,
`MaTK` int NOT NULL,
`HoTen` varchar(100) NOT NULL,
`SDT` varchar(15) DEFAULT NULL,
`DiaChi` varchar(255) DEFAULT NULL,
PRIMARY KEY (`MaND`),
KEY `MaTK` (`MaTK`)
)

DROP TABLE IF EXISTS `sanpham`;
CREATE TABLE IF NOT EXISTS `sanpham` (
`MaSP` int NOT NULL AUTO_INCREMENT,
`TenSP` varchar(255) NOT NULL,
`MoTa` text,
`Gia` float NOT NULL,
`SoLuong` int NOT NULL DEFAULT '0',
`TrangThai` varchar(50) NOT NULL,
`HinhAnh` varchar(255) DEFAULT NULL,
PRIMARY KEY (`MaSP`)
)

CREATE TABLE IF NOT EXISTS `taikhoan` (
`MaTK` int NOT NULL AUTO_INCREMENT,
`Email` varchar(100) NOT NULL,
`MatKhau` varchar(255) NOT NULL,
`VaiTro` int NOT NULL DEFAULT '1',
`TrangThai` int NOT NULL DEFAULT '1',
PRIMARY KEY (`MaTK`),
UNIQUE KEY `Email` (`Email`)
)

DROP TABLE IF EXISTS `uudai`;
CREATE TABLE IF NOT EXISTS `uudai` (
`MaUD` int NOT NULL AUTO_INCREMENT,
`TenUD` varchar(255) NOT NULL,
`MucGiam` float NOT NULL,
`NgayBatDau` date NOT NULL,
`NgayKetThuc` date NOT NULL,
`TrangThai` varchar(50) NOT NULL,
PRIMARY KEY (`MaUD`)
)

      { method: 'POST', path: '/gas/auth/register', description: 'Đăng ký tài khoản mới' },
      { method: 'POST', path: '/gas/auth/login', description: 'Đăng nhập và nhận token JWT' },
      { method: 'GET', path: '/gas/users', description: 'Lấy danh sách người dùng (chỉ quản lý)' },
      { method: 'GET', path: '/gas/users/:id', description: 'Lấy thông tin người dùng theo ID' },
      { method: 'PUT', path: '/gas/users/:id', description: 'Cập nhật thông tin người dùng' },
      { method: 'DELETE', path: '/gas/users/:id', description: 'Xóa người dùng (chỉ quản lý)' },
      { method: 'GET', path: '/gas/products', description: 'Lấy danh sách sản phẩm' },
      { method: 'GET', path: '/gas/products/:id', description: 'Lấy thông tin sản phẩm theo ID' },
      { method: 'POST', path: '/gas/products', description: 'Thêm sản phẩm mới (chỉ quản lý)' },
      { method: 'PUT', path: '/gas/products/:id', description: 'Cập nhật thông tin sản phẩm (chỉ quản lý)' },
      { method: 'DELETE', path: '/gas/products/:id', description: 'Xóa sản phẩm (chỉ quản lý)' },
      { method: 'GET', path: '/gas/cart', description: 'Lấy thông tin giỏ hàng của người dùng' },
      { method: 'POST', path: '/gas/cart', description: 'Thêm sản phẩm vào giỏ hàng' },
      { method: 'DELETE', path: '/gas/cart/:id', description: 'Xóa sản phẩm khỏi giỏ hàng' },
      { method: 'GET', path: '/gas/orders', description: 'Lấy danh sách đơn hàng của người dùng' },
      { method: 'POST', path: '/gas/orders', description: 'Tạo đơn hàng mới' },
      { method: 'GET', path: '/gas/orders/:id', description: 'Lấy thông tin chi tiết đơn hàng' }



