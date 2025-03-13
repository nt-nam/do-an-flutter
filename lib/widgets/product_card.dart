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
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm (nếu có)
            product.imageUrl != null
                ? Image.network(
              product.imageUrl!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80),
            )
                : Icon(Icons.image, size: 80), // Placeholder nếu không có hình ảnh
            SizedBox(width: 16),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Giá: ${product.price.toStringAsFixed(0)} VNĐ',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Số lượng: ${product.quantity}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Trạng thái: ${product.status}',
                    style: TextStyle(fontSize: 14, color: product.status == 'Còn hàng' ? Colors.blue : Colors.red),
                  ),
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