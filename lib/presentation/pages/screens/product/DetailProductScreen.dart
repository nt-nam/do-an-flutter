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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/${(product.imageUrl ?? HomeScreen.linkImage) == "" ? HomeScreen.linkImage : (product.imageUrl ?? HomeScreen.linkImage)}",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Thông tin sản phẩm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(0)} VNĐ',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: product.status == ProductStatus.inStock
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: product.status == ProductStatus.inStock
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              child: Text(
                                product.status == ProductStatus.inStock
                                    ? 'Còn hàng'
                                    : 'Hết hàng',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: product.status == ProductStatus.inStock
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.inventory,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Số lượng tồn: ${product.stock}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Mô tả:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description ?? 'Không có mô tả.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nút hành động
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
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
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Vui lòng cập nhật địa chỉ của bạn!'),
                                        ),
                                      );
                                      return;
                                    }

                                    // Gọi FetchCartEvent nếu giỏ hàng chưa được tải
                                    if (cartState is! CartLoaded) {
                                      context.read<CartBloc>().add(FetchCartEvent(accountId));
                                      await Future.delayed(const Duration(milliseconds: 500)); // Chờ tải giỏ hàng
                                    }

                                    // Lấy cartId từ CartBloc
                                    int? cartId;
                                    final updatedCartState = context.read<CartBloc>().state;
                                    if (updatedCartState is CartLoaded && updatedCartState.cartItems.isNotEmpty) {
                                      cartId = updatedCartState.cartItems.first.cartId;
                                    }

                                    // Nếu giỏ hàng rỗng, thêm sản phẩm vào giỏ hàng trước
                                    if (cartId == null) {
                                      context.read<CartBloc>().add(AddToCartEvent(accountId, product.id, 1));
                                      await Future.delayed(const Duration(milliseconds: 500)); // Chờ thêm sản phẩm
                                      final newCartState = context.read<CartBloc>().state;
                                      if (newCartState is CartLoaded && newCartState.cartItems.isNotEmpty) {
                                        cartId = newCartState.cartItems.first.cartId;
                                      }
                                    }

                                    // Kiểm tra lại cartId
                                    if (cartId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Không thể lấy thông tin giỏ hàng!'),
                                        ),
                                      );
                                      return;
                                    }

                                    // Đảm bảo cartId không null khi truyền vào CartDetail
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                          items: [
                                            CartDetail(
                                              cartDetailId: 0, // Giả định ID tạm thời
                                              cartId: cartId!, // cartId đã được đảm bảo không null
                                              accountId: accountId,
                                              productId: product.id,
                                              quantity: 1,
                                              createdDate: DateTime.now().toIso8601String() ,
                                              productName: product.name ?? '',
                                              productPrice: product.price,
                                              productImage: product.imageUrl ?? '',
                                            ),
                                          ],
                                          accountId: accountId,
                                          deliveryAddress: deliveryAddress,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Vui lòng đăng nhập để đặt hàng!'),
                                      ),
                                    );
                                  }
                                }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  'Đặt hàng ngay',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        BlocConsumer<CartBloc, CartState>(
                          listener: (context, state) {
                            if (state is CartItemAdded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã thêm vào giỏ hàng!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else if (state is CartError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${state.message}')),
                              );
                            }
                          },
                          builder: (context, state) {
                            return IconButton(
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.deepPurple,
                                size: 36,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng!'),
                                    ),
                                  );
                                }
                              }
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const Center(child: Text('Không có dữ liệu sản phẩm.'));
        },
      ),
    );
  }
}