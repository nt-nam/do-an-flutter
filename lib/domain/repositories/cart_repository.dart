import '../../data/models/cart_model.dart';
import '../../data/models/cart_detail_model.dart';

abstract class CartRepository {
  Future<CartModel> getCart(int accountId); // Lấy giỏ hàng tổng quát
  Future<List<CartDetailModel>> getCartDetails(int cartId); // Lấy chi tiết giỏ hàng
  Future<CartDetailModel> addToCart(CartDetailModel cartDetail); // Thêm sản phẩm vào giỏ
  Future<CartDetailModel> updateCartDetail(CartDetailModel cartDetail); // Cập nhật số lượng
  Future<void> removeFromCart(int cartDetailId); // Xóa sản phẩm khỏi giỏ
}