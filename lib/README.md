
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






