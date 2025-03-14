// lib/widgets/cart_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/cart_model.dart';

class CartItem extends StatelessWidget {
  final CartModel cartItem;

  const CartItem({required this.cartItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
            cartItem.product.imageUrl != null
                ? Image.network(cartItem.product.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                : Icon(Icons.image, size: 60),
            SizedBox(width: 16),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Giá: ${cartItem.product.price} VNĐ'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            context.read<CartBloc>().add(UpdateQuantityEvent(cartItem.id, cartItem.quantity - 1));
                          }
                        },
                      ),
                      Text('${cartItem.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          context.read<CartBloc>().add(UpdateQuantityEvent(cartItem.id, cartItem.quantity + 1));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Nút xóa
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<CartBloc>().add(RemoveFromCartEvent(cartItem.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}