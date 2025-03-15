// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            tooltip: 'Giỏ hàng',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            product.imageUrl != null
                ? Image.network(
              product.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
            )
                : Icon(Icons.image, size: 200),
            SizedBox(height: 16),
            // Tên sản phẩm
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Giá
            Text(
              '${product.price} VNĐ',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 8),
            // Mô tả
            Text(
              'Mô tả: ${product.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            // Trạng thái
            Text(
              'Trạng thái: ${product.status}',
              style: TextStyle(fontSize: 16, color: product.status == 'Còn hàng' ? Colors.green : Colors.red),
            ),
            SizedBox(height: 8),
            // Số lượng tồn kho
            Text(
              'Số lượng tồn kho: ${product.quantity}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Nút thêm vào giỏ hàng
            ElevatedButton(
              onPressed: product.status == 'Còn hàng' && product.quantity > 0
                  ? () {
                context.read<CartBloc>().add(AddToCartEvent(product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
                );
              }
                  : null,
              child: Text('Thêm vào giỏ hàng'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            SizedBox(height: 10),
            // Nút xem đánh giá
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reviews', arguments: product.id);
              },
              child: Text('Xem đánh giá'),
              style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}