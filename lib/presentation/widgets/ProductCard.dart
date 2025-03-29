import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../pages/screens/HomeScreen.dart';

Widget ProductCard(Product product) {
  return Container(
    width: 180,
    height: 220,
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade300, // Nền xám
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Thẻ màu (nền xanh cho text + nút)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.brown, // Thẻ màu
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        // Ảnh sản phẩm
        Positioned(
          top: -10,
          left: 25,
          right: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
            // product.imageUrl != null ?
            Image.network(
              "assets/images/${(product.imageUrl ?? HomeScreen.linkImage) == "" ? HomeScreen.linkImage : (product.imageUrl ?? HomeScreen.linkImage)}",
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 120, color: Colors.grey),
                  )
                // : const Icon(Icons.image, size: 80, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}
