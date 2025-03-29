import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

Widget ProductCard(Product product) {
  return Card(
    elevation: 2,
    child: InkWell(
      onTap: () {
        // Chuyển đến trang chi tiết
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                product.imageUrl != null
                    ? Image.network(product.imageUrl!, width: 80, height: 80)
                    : Icon(Icons.image, size: 80),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "${product.price.toStringAsFixed(0)} VNĐ",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            Text(
              product.status == ProductStatus.inStock ? "Còn hàng" : "Hết hàng",
              style: TextStyle(
                color: product.status == ProductStatus.inStock ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
            if (product.description != null) ...[
              SizedBox(height: 4),
              Text(
                product.description!.length > 30
                    ? "${product.description!.substring(0, 30)}..."
                    : product.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            if (product.status == ProductStatus.inStock && product.stock < 10) ...[
              SizedBox(height: 4),
              Text(
                "Còn ${product.stock} sản phẩm",
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}