// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/order_bloc.dart';
import '../blocs/promotion_bloc.dart';
import '../models/cart_model.dart';

class CheckoutScreen extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is CartUpdated && cartState.items.isNotEmpty) {
            final cartItems = cartState.items;
            double total = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('Số lượng: ${item.quantity} - ${item.totalPrice} VNĐ'),
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Địa chỉ giao hàng'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoCodeController,
                          decoration: InputDecoration(labelText: 'Mã ưu đãi'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PromotionBloc>().add(ApplyPromotionEvent(_promoCodeController.text));
                        },
                        child: Text('Áp dụng'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<PromotionBloc, PromotionState>(
                    builder: (context, promoState) {
                      double discount = 0;
                      if (promoState is PromotionApplied) {
                        discount = promoState.promotion.applyDiscount(total);
                        total -= discount;
                      }
                      if (promoState is PromotionError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(promoState.message)));
                        });
                      }
                      return Column(
                        children: [
                          if (discount > 0)
                            Text('Giảm: $discount VNĐ', style: TextStyle(color: Colors.green)),
                          Text('Tổng tiền: $total VNĐ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(CreateOrderEvent(cartItems, address: _addressController.text));
                      context.read<CartBloc>().add(RemoveFromCartEvent(cartItems.first.id)); // Xóa giỏ
                      Navigator.pushNamed(context, '/orders');
                    },
                    child: Text('Xác nhận đơn hàng'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('Giỏ hàng trống'));
        },
      ),
    );
  }
}