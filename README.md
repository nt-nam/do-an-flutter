# do_an_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



danh sach viec can làm

ưu tiên:
1. Xây dựng hệ thống xác thực người dùng
     Mô tả: Đăng ký, đăng nhập, phân quyền (admin, khách hàng, nhân viên giao hàng).
     Lý do: Đây là bước nền tảng để phân quyền truy cập và cá nhân hóa dữ liệu.
     Liên quan đến:
     Bảng và .taikhoannguoidung
     API xác thực (, ).authservice.dartauthbloc.dart
2. Quản lý sản phẩm
     Mô tả: Hiển thị danh sách sản phẩm, chi tiết sản phẩm.
     Lý do: Đây là chức năng cốt lõi để khách hàng xem và lựa chọn sản phẩm.
     Liên quan đến:
     Bảng .sanpham
     API hiển thị danh sách sản phẩm (, ).productrepository.dartproductbloc.dar
3. Giỏ hàng
     Mô tả: Thêm sản phẩm vào giỏ hàng, xem giỏ hàng.
     Lý do: Đây là bước trung gian quan trọng trước khi đặt hàng.
     Liên quan đến:
     Bảng .giohang
     API xử lý giỏ hàng (, ).cartrepository.dartcartbloc.dart
4. Đặt hàng
     Mô tả: Tạo đơn hàng mới, cập nhật trạng thái đơn hàng.
     Lý do: Đây là chức năng chính để khách hàng thực hiện giao dịch.
     Liên quan đến:
     Bảng .donhang
     API đặt hàng (, ).orderrepository.dartorderbloc.dart
5. Quản lý kho
     Mô tả: Theo dõi số lượng sản phẩm trong kho, cảnh báo khi sắp hết hàng.
     Lý do: Hỗ trợ nhân viên quản lý nguồn cung ứng hiệu quả.
     Liên quan đến:
     Bảng .sanpham
6. Quản lý giao hàng
     Mô tả: Theo dõi trạng thái giao hàng theo thời gian thực, liên hệ với nhân viên giao hàng.
     Lý do: Tăng trải nghiệm khách hàng và đảm bảo quy trình giao nhận.
     Liên quan đến:
     API xử lý trạng thái đơn hàng ().orderstate.dart
     Dịch vụ định vị ().locationservice.dart
7. Thanh toán và ưu đãi
     Mô tả: Hỗ trợ thanh toán qua nhiều phương thức (VNPay, Momo), áp dụng mã giảm giá.
     Lý do: Hoàn thiện quy trình mua sắm và tăng doanh thu qua ưu đãi.
     Liên quan đến:
     Bảng .uudai
     API thanh toán ().paymentrepository.dart
8. Đánh giá sản phẩm
     Mô tả: Khách hàng đánh giá chất lượng sản phẩm sau khi mua.
     Lý do: Nâng cao uy tín sản phẩm và cải thiện dịch vụ dựa trên phản hồi.
     Liên quan đến:
     Bảng .danhgia
     API đánh giá (, ).reviewrepository.dartreviewbloc.dart