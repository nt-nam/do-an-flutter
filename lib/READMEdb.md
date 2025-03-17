-- =====================================
-- 1. Bảng tài khoản (taikhoan)
-- =====================================
CREATE TABLE taikhoan (
MaTK INT PRIMARY KEY AUTO_INCREMENT,
Email VARCHAR(255) UNIQUE NOT NULL,
MatKhau VARCHAR(255) NOT NULL,
VaiTro ENUM('Khách hàng', 'Nhân viên', 'Quản trị') NOT NULL DEFAULT 'Khách hàng',
TrangThai BOOLEAN NOT NULL DEFAULT 1
);

-- =====================================
-- 2. Bảng người dùng (nguoidung)
-- =====================================
CREATE TABLE nguoidung (
MaND INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT UNIQUE,
HoTen VARCHAR(100) NOT NULL,
SDT VARCHAR(15) NOT NULL,
DiaChi TEXT NOT NULL,
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE CASCADE
);

-- =====================================
-- 3. Bảng loại sản phẩm (loaisanpham)
-- =====================================
CREATE TABLE loaisanpham (
MaLoai INT PRIMARY KEY AUTO_INCREMENT,
TenLoai VARCHAR(100) NOT NULL
);

-- =====================================
-- 4. Bảng sản phẩm (sanpham)
-- =====================================
CREATE TABLE sanpham (
MaSP INT PRIMARY KEY AUTO_INCREMENT,
TenSP VARCHAR(255) NOT NULL,
MoTa TEXT,
Gia DECIMAL(10,2) NOT NULL,
MaLoai INT,
HinhAnh VARCHAR(255),
TrangThai ENUM('Còn hàng', 'Hết hàng') NOT NULL DEFAULT 'Còn hàng',
FOREIGN KEY (MaLoai) REFERENCES loaisanpham(MaLoai) ON DELETE SET NULL
);

-- =====================================
-- 5. Bảng kho hàng (khohang)
-- =====================================
CREATE TABLE khohang (
MaKho INT PRIMARY KEY AUTO_INCREMENT,
TenKho VARCHAR(100) NOT NULL,
DiaChi TEXT NOT NULL
);

-- =====================================
-- 6. Bảng nhập hàng (nhaphang)
-- =====================================
CREATE TABLE nhaphang (
MaNhap INT PRIMARY KEY AUTO_INCREMENT,
MaSP INT,
MaKho INT,
SoLuong INT NOT NULL,
NgayNhap DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (MaSP) REFERENCES sanpham(MaSP) ON DELETE CASCADE,
FOREIGN KEY (MaKho) REFERENCES khohang(MaKho) ON DELETE CASCADE
);

-- =====================================
-- 7. Bảng đơn hàng (donhang)
-- =====================================
CREATE TABLE donhang (
MaDH INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT,
NgayDat DATETIME DEFAULT CURRENT_TIMESTAMP,
TongTien DECIMAL(10,2) NOT NULL,
TrangThai ENUM('Chờ xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy') NOT NULL DEFAULT 'Chờ xác nhận',
DiaChiGiao TEXT NOT NULL,
MaUD INT NULL,
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE CASCADE
);

-- =====================================
-- 8. Bảng chi tiết đơn hàng (chitietdonhang)
-- =====================================
CREATE TABLE chitietdonhang (
MaDH INT,
MaSP INT,
SoLuong INT NOT NULL,
GiaLucMua DECIMAL(10,2) NOT NULL,
PRIMARY KEY (MaDH, MaSP),
FOREIGN KEY (MaDH) REFERENCES donhang(MaDH) ON DELETE CASCADE,
FOREIGN KEY (MaSP) REFERENCES sanpham(MaSP) ON DELETE CASCADE
);

-- =====================================
-- 9. Bảng vận chuyển (vanchuyen)
-- =====================================
CREATE TABLE vanchuyen (
MaVC INT PRIMARY KEY AUTO_INCREMENT,
MaDH INT UNIQUE,
MaNVG INT,  -- Mã nhân viên giao hàng
NgayGiao DATETIME,
TrangThai ENUM('Chưa giao', 'Đang giao', 'Đã giao') NOT NULL DEFAULT 'Chưa giao',
FOREIGN KEY (MaDH) REFERENCES donhang(MaDH) ON DELETE CASCADE
);

-- =====================================
-- 10. Bảng nhân viên giao hàng (nhanviengiaohang)
-- =====================================
CREATE TABLE nhanviengiaohang (
MaNVG INT PRIMARY KEY AUTO_INCREMENT,
HoTen VARCHAR(100) NOT NULL,
SDT VARCHAR(15) NOT NULL,
DiaChi TEXT NOT NULL
);

-- =====================================
-- 11. Bảng giỏ hàng (giohang)
-- =====================================
CREATE TABLE giohang (
MaGH INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT,
MaSP INT,
SoLuong INT NOT NULL,
NgayThem DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE CASCADE,
FOREIGN KEY (MaSP) REFERENCES sanpham(MaSP) ON DELETE CASCADE
);

-- =====================================
-- 12. Bảng ưu đãi (uudai)
-- =====================================
CREATE TABLE uudai (
MaUD INT PRIMARY KEY AUTO_INCREMENT,
TenUD VARCHAR(255) NOT NULL,
MucGiam DECIMAL(10,2) NOT NULL,  -- % hoặc số tiền giảm
NgayBatDau DATE NOT NULL,
NgayKetThuc DATE NOT NULL,
TrangThai ENUM('Hoạt động', 'Hết hạn') NOT NULL DEFAULT 'Hoạt động'
);

-- =====================================
-- 13. Bảng đánh giá sản phẩm (danhgia)
-- =====================================
CREATE TABLE danhgia (
MaDG INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT,
MaSP INT,
Diem DECIMAL(2,1) CHECK (Diem BETWEEN 1 AND 5),
NhanXet TEXT,
NgayDanhGia DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE CASCADE,
FOREIGN KEY (MaSP) REFERENCES sanpham(MaSP) ON DELETE CASCADE
);

-- =====================================
-- 14. Bảng thông báo (thongbao)
-- =====================================
CREATE TABLE thongbao (
MaTB INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT,
NoiDung TEXT NOT NULL,
NgayGui DATETIME DEFAULT CURRENT_TIMESTAMP,
TrangThai ENUM('Chưa đọc', 'Đã đọc') NOT NULL DEFAULT 'Chưa đọc',
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE CASCADE
);

-- =====================================
-- 15. Bảng nhật ký hệ thống (nhatky)
-- =====================================
CREATE TABLE nhatky (
MaNK INT PRIMARY KEY AUTO_INCREMENT,
MaTK INT,
MoTa TEXT NOT NULL,
ThoiGian DATETIME DEFAULT CURRENT_TIMESTAMP,
Loai ENUM('Đăng nhập', 'Thay đổi đơn hàng', 'Lỗi hệ thống') NOT NULL,
FOREIGN KEY (MaTK) REFERENCES taikhoan(MaTK) ON DELETE SET NULL
);

-- ==============================
-- 1. Bảng tài khoản (taikhoan)
-- ==============================
INSERT INTO taikhoan (Email, MatKhau, VaiTro, TrangThai) VALUES
('user1@example.com', 'password1', 'Khách hàng', 1),
('user2@example.com', 'password2', 'Khách hàng', 1),
('staff1@example.com', 'password3', 'Nhân viên', 1),
('admin@example.com', 'password4', 'Quản trị', 1),
('user3@example.com', 'password5', 'Khách hàng', 1);

-- ==============================
-- 2. Bảng người dùng (nguoidung)
-- ==============================
INSERT INTO nguoidung (MaTK, HoTen, SDT, DiaChi) VALUES
(1, 'Nguyễn Văn A', '0123456789', 'Hà Nội'),
(2, 'Trần Thị B', '0987654321', 'TP.HCM'),
(3, 'Lê Văn C', '0345678912', 'Đà Nẵng'),
(4, 'Hoàng Văn D', '0367891234', 'Cần Thơ'),
(5, 'Phạm Thị E', '0390123456', 'Hải Phòng');

-- ==============================
-- 3. Bảng loại sản phẩm (loaisanpham)
-- ==============================
INSERT INTO loaisanpham (TenLoai) VALUES
('Bình gas'),
('Phụ kiện gas'),
('Bếp gas'),
('Dịch vụ sửa chữa'),
('Van điều áp');

-- ==============================
-- 4. Bảng sản phẩm (sanpham)
-- ==============================
INSERT INTO sanpham (TenSP, MoTa, Gia, MaLoai, HinhAnh, TrangThai) VALUES
('Gas 12kg', 'Bình gas dân dụng 12kg', 350000, 1, 'gas_12kg.jpg', 'Còn hàng'),
('Gas 45kg', 'Bình gas công nghiệp 45kg', 1200000, 1, 'gas_45kg.jpg', 'Còn hàng'),
('Van điều áp', 'Van điều áp dùng cho bình gas', 150000, 5, 'van_dieu_ap.jpg', 'Còn hàng'),
('Dây gas', 'Dây dẫn gas an toàn', 50000, 2, 'day_gas.jpg', 'Còn hàng'),
('Bếp gas đôi', 'Bếp gas đôi tiết kiệm nhiên liệu', 800000, 3, 'bep_gas_doi.jpg', 'Còn hàng');

-- ==============================
-- 5. Bảng kho hàng (khohang)
-- ==============================
INSERT INTO khohang (TenKho, DiaChi) VALUES
('Kho Hà Nội', 'Số 123, Hà Nội'),
('Kho TP.HCM', 'Số 456, TP.HCM'),
('Kho Đà Nẵng', 'Số 789, Đà Nẵng'),
('Kho Cần Thơ', 'Số 101, Cần Thơ'),
('Kho Hải Phòng', 'Số 202, Hải Phòng');

-- ==============================
-- 6. Bảng nhập hàng (nhaphang)
-- ==============================
INSERT INTO nhaphang (MaSP, MaKho, SoLuong, NgayNhap) VALUES
(1, 1, 50, '2025-03-01'),
(2, 2, 20, '2025-03-02'),
(3, 3, 100, '2025-03-03'),
(4, 4, 150, '2025-03-04'),
(5, 5, 30, '2025-03-05');

-- ==============================
-- 7. Bảng đơn hàng (donhang)
-- ==============================
INSERT INTO donhang (MaTK, NgayDat, TongTien, TrangThai, DiaChiGiao, MaUD) VALUES
(1, '2025-03-10', 350000, 'Chờ xác nhận', 'Hà Nội', NULL),
(2, '2025-03-12', 1250000, 'Đã giao', 'TP.HCM', 1),
(3, '2025-03-14', 200000, 'Đang giao', 'Đà Nẵng', NULL),
(4, '2025-03-15', 850000, 'Chờ xác nhận', 'Cần Thơ', 3),
(5, '2025-03-16', 400000, 'Đã hủy', 'Hải Phòng', NULL);

-- ==============================
-- 8. Bảng chi tiết đơn hàng (chitietdonhang)
-- ==============================
INSERT INTO chitietdonhang (MaDH, MaSP, SoLuong, GiaLucMua) VALUES
(1, 1, 1, 350000),
(2, 2, 1, 1200000),
(2, 3, 1, 150000),
(3, 4, 2, 50000),
(4, 5, 1, 800000);

-- ==============================
-- 9. Bảng giỏ hàng (giohang)
-- ==============================
INSERT INTO giohang (MaTK, MaSP, SoLuong, NgayThem) VALUES
(1, 1, 1, '2025-03-10'),
(2, 2, 1, '2025-03-12'),
(3, 3, 2, '2025-03-14'),
(4, 4, 3, '2025-03-15'),
(5, 5, 1, '2025-03-16');

-- ==============================
-- 10. Bảng ưu đãi (uudai)
-- ==============================
INSERT INTO uudai (TenUD, MucGiam, NgayBatDau, NgayKetThuc, TrangThai) VALUES
('Giảm 10% cho đơn trên 500k', 10, '2025-03-01', '2025-03-31', 'Hoạt động'),
('Giảm 50k khi mua gas 12kg', 50000, '2025-03-05', '2025-03-20', 'Hoạt động'),
('Mua bếp gas giảm 5%', 5, '2025-02-01', '2025-03-15', 'Hết hạn'),
('Giảm 15% cho đơn trên 1 triệu', 15, '2025-03-10', '2025-04-01', 'Hoạt động'),
('Tặng dây gas miễn phí', 100, '2025-03-01', '2025-03-31', 'Hoạt động');

-- ==============================
-- 11. Bảng đánh giá sản phẩm (danhgia)
-- ==============================
INSERT INTO danhgia (MaTK, MaSP, Diem, NhanXet, NgayDanhGia) VALUES
(1, 1, 5, 'Gas chất lượng, giao nhanh.', '2025-03-11'),
(2, 2, 4, 'Bình gas lớn, dùng tốt.', '2025-03-13'),
(3, 3, 3.5, 'Van điều áp bình thường.', '2025-03-14'),
(4, 5, 5, 'Bếp gas xài tốt, nấu nhanh.', '2025-03-15'),
(5, 4, 4, 'Dây gas dẻo, an toàn.', '2025-03-16');

-- ==============================
-- 12. Bảng thông báo (thongbao)
-- ==============================
INSERT INTO thongbao (MaTK, NoiDung, NgayGui, TrangThai) VALUES
(1, 'Đơn hàng của bạn đang chờ xác nhận.', '2025-03-10', 'Chưa đọc'),
(2, 'Đơn hàng của bạn đã được giao.', '2025-03-12', 'Đã đọc'),
(3, 'Có ưu đãi mới dành cho bạn!', '2025-03-14', 'Chưa đọc'),
(4, 'Bạn đã nhận xét về sản phẩm.', '2025-03-15', 'Đã đọc'),
(5, 'Hệ thống bảo trì vào 16/03.', '2025-03-16', 'Chưa đọc');
