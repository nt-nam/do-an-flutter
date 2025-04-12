import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/cart_detail.dart';
import '../../../../domain/entities/product.dart';
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/cart/cart_event.dart';
import '../../../blocs/cart/cart_state.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_state.dart';
import '../HomeScreen.dart';
import '../PaymentScreen.dart';

class DetailProductScreen extends StatelessWidget {
  const DetailProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Color(0xFF2E7D32);      // Xanh lá đậm
    final Color secondaryColor = Color(0xFF1E88E5);    // Xanh dương
    final Color accentColor = Color(0xFFFFA000);       // Cam vàng
    final Color textDarkColor = Color(0xFF424242);     // Xám đậm
    final Color textLightColor = Color(0xFF757575);    // Xám nhạt
    final Color backgroundColor = Color(0xFFF5F5F5);   // Xám nhạt nhất
    final Color surfaceColor = Colors.white;           // Trắng

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: primaryColor),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: accentColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm vào danh sách yêu thích')),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return _buildLoadingUI(primaryColor);
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            return _buildProductDetails(
                context,
                product,
                primaryColor,
                secondaryColor,
                accentColor,
                textDarkColor,
                textLightColor,
                backgroundColor,
                surfaceColor
            );
          } else if (state is ProductError) {
            return _buildErrorUI(state.message, primaryColor);
          }
          return _buildEmptyUI();
        },
      ),
    );
  }

  Widget _buildLoadingUI(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            'Đang tải thông tin sản phẩm...',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorUI(String message, Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Không có thông tin sản phẩm',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context,
      dynamic product,
      Color primaryColor,
      Color secondaryColor,
      Color accentColor,
      Color textDarkColor,
      Color textLightColor,
      Color backgroundColor,
      Color surfaceColor
      ) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero image section
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // Product image with gradient overlay
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/${(product.imageUrl ?? HomeScreen.linkImage) == "" ? HomeScreen.linkImage : (product.imageUrl ?? HomeScreen.linkImage)}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Product badges
                  Positioned(
                    right: 16,
                    top: MediaQuery.of(context).padding.top + 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: product.status == ProductStatus.inStock
                            ? Color(0xFF43A047).withOpacity(0.9)  // Xanh lá
                            : Color(0xFFE53935).withOpacity(0.9), // Đỏ
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.status == ProductStatus.inStock
                                ? Icons.check_circle
                                : Icons.remove_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.status == ProductStatus.inStock
                                ? 'Còn hàng'
                                : 'Hết hàng',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product information section with curved top edges
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name with primary color
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Price and inventory status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCurrency(product.price),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'VNĐ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.inventory_2,
                                  size: 16,
                                  color: textLightColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Kho: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textLightColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 20,
                                  color: secondaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Mô tả sản phẩm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              product.description ?? 'Không có mô tả cho sản phẩm này.',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: textDarkColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Feature badges
                      _buildFeatureBadges(primaryColor, secondaryColor, accentColor, textDarkColor, surfaceColor),

                      // Add padding at the bottom to ensure content is visible above the action buttons
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Floating action buttons container
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildActionButtons(context, product, primaryColor, secondaryColor, accentColor, surfaceColor),
        ),
      ],
    );
  }

  Widget _buildFeatureBadges(
      Color primaryColor,
      Color secondaryColor,
      Color accentColor,
      Color textDarkColor,
      Color surfaceColor
      ) {
    // Dùng màu khác nhau cho từng badge để tạo điểm nhấn
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildFeatureBadge(Icons.local_shipping_outlined, 'Giao hàng miễn phí', primaryColor, textDarkColor, surfaceColor),
        _buildFeatureBadge(Icons.verified_outlined, 'Bảo hành 12 tháng', secondaryColor, textDarkColor, surfaceColor),
        _buildFeatureBadge(Icons.cached_outlined, 'Đổi trả trong 7 ngày', accentColor, textDarkColor, surfaceColor),
        _buildFeatureBadge(Icons.check_circle_outline, 'Sản phẩm chính hãng', Colors.teal, textDarkColor, surfaceColor),
      ],
    );
  }

  Widget _buildFeatureBadge(
      IconData icon,
      String text,
      Color iconColor,
      Color textColor,
      Color backgroundColor
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      dynamic product,
      Color primaryColor,
      Color secondaryColor,
      Color accentColor,
      Color surfaceColor
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            BlocConsumer<CartBloc, CartState>(
              listener: (context, state) {
                if (state is CartItemAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 10),
                          const Text('Đã thêm vào giỏ hàng!'),
                        ],
                      ),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(10),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is CartError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 10),
                          Text('Lỗi: ${state.message}'),
                        ],
                      ),
                      backgroundColor: Colors.red[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(10),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                    onPressed: product.status == ProductStatus.inStock
                        ? () {
                      final accountState = context.read<AccountBloc>().state;
                      if (accountState is AccountLoggedIn) {
                        final productState = context.read<ProductBloc>().state;
                        if (productState is ProductDetailsLoaded) {
                          final product = productState.product;
                          context.read<CartBloc>().add(
                            AddToCartEvent(
                              accountState.account.id,
                              product.id,
                              1,
                            ),
                          );
                        }
                      } else {
                        _showLoginRequiredDialog(context, primaryColor);
                      }
                    }
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: ${state.message}')),
                    );
                  }
                },
                builder: (context, cartState) {
                  return ElevatedButton(
                    onPressed: product.status == ProductStatus.inStock
                        ? () async {
                      final accountState = context.read<AccountBloc>().state;
                      if (accountState is AccountLoggedIn) {
                        final accountId = accountState.account.id;
                        String deliveryAddress = '123 Main St';
                        if (accountState.user != null) {
                          deliveryAddress = accountState.user!.diaChi ?? '123 Main St';
                        }
                        if (deliveryAddress.isEmpty) {
                          _showAddressRequiredAlert(context, accentColor);
                          return;
                        }

                        if (cartState is! CartLoaded) {
                          context.read<CartBloc>().add(FetchCartEvent(accountId));
                          await Future.delayed(const Duration(milliseconds: 500));
                        }

                        int? cartId;
                        final updatedCartState = context.read<CartBloc>().state;
                        if (updatedCartState is CartLoaded && updatedCartState.cartItems.isNotEmpty) {
                          cartId = updatedCartState.cartItems.first.cartId;
                        }

                        if (cartId == null) {
                          context.read<CartBloc>().add(AddToCartEvent(accountId, product.id, 1));
                          await Future.delayed(const Duration(milliseconds: 500));
                          final newCartState = context.read<CartBloc>().state;
                          if (newCartState is CartLoaded && newCartState.cartItems.isNotEmpty) {
                            cartId = newCartState.cartItems.first.cartId;
                          }
                        }

                        if (cartId == null) {
                          _showCartErrorAlert(context);
                          return;
                        }

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => PaymentScreen(
                              items: [
                                CartDetail(
                                  cartDetailId: 0,
                                  cartId: cartId!,
                                  accountId: accountId,
                                  productId: product.id,
                                  quantity: 1,
                                  createdDate: DateTime.now().toIso8601String(),
                                  productName: product.name ?? '',
                                  productPrice: product.price,
                                  productImage: product.imageUrl ?? '',
                                ),
                              ],
                              accountId: accountId,
                              deliveryAddress: deliveryAddress,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutCubic;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      } else {
                        _showLoginRequiredDialog(context, primaryColor);
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mua ngay',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.account_circle, color: primaryColor),
            const SizedBox(width: 10),
            const Text('Đăng nhập'),
          ],
        ),
        content: const Text('Vui lòng đăng nhập để tiếp tục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Chuyển đến màn hình đăng nhập
              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddressRequiredAlert(BuildContext context, Color accentColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.location_off, color: Colors.white),
            const SizedBox(width: 10),
            const Expanded(child: Text('Vui lòng cập nhật địa chỉ của bạn!')),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Cập nhật',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to profile screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
        ),
      ),
    );
  }

  void _showCartErrorAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            const Text('Không thể lấy thông tin giỏ hàng!'),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }
}

// Extension to add overlay widgets (như floating action buttons)
extension PermittingWidget on Widget {
  Stack permitting(Widget overlay) {
    return Stack(
      children: [
        this,
        overlay,
      ],
    );
  }
}