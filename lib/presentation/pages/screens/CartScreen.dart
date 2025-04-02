import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import 'PaymentScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CartItemAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
            );
          } else if (state is CartItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã xóa sản phẩm khỏi giỏ hàng')),
            );
          } else if (state is CartItemUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật số lượng')),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Giỏ hàng trống'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return ListTile(
                        leading: item.productImage != null && item.productImage!.isNotEmpty
                            ? Image.asset(
                          'assets/images/${item.productImage}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image, size: 50),
                        title: Text(item.productName ?? 'Sản phẩm không tên'),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartBloc>().add(
                                    UpdateCartQuantityEvent(
                                      item.cartId!,
                                      item.productId,
                                      item.quantity - 1,
                                    ),
                                  );
                                } else {
                                  context.read<CartBloc>().add(
                                    RemoveFromCartEvent(
                                      item.cartId!,
                                      item.productId,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text('Số lượng: ${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                    item.cartId!,
                                    item.productId,
                                    item.quantity + 1,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CartBloc>().add(
                              RemoveFromCartEvent(
                                item.cartId!,
                                item.productId,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              items: state.cartItems,
                              accountId: accountId,
                              deliveryAddress: deliveryAddress,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng đăng nhập để thanh toán!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Center(
                      child: Text(
                        'Thanh toán',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                final accountState = context.read<AccountBloc>().state;
                if (accountState is AccountLoggedIn) {
                  context.read<CartBloc>().add(
                    FetchCartEvent(accountState.account.id),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng đăng nhập để xem giỏ hàng!'),
                    ),
                  );
                }
              },
              child: const Text('Tải giỏ hàng'),
            ),
          );
        },
      ),
    );
  }
}