// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../blocs/cart_bloc.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            product.imageUrl != null
                ? Image.network(product.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                : Icon(Icons.image, size: 60),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Giá: ${product.price} VNĐ'),
                  Text('Trạng thái: ${product.status}'),
                ],
              ),
            ),
            // Nút thêm vào giỏ hàng
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                context.read<CartBloc>().add(AddToCartEvent(product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}