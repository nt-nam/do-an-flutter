import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String calories;
  final String imageName; // Tên file ảnh (imageUrl từ Product)

  const ProductCard({
    super.key,
    required this.title,
    required this.calories,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    // Tạo imageUrl giống như trong HomeScreen và FindProductScreen
    const String defaultImage = "GDD_Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg";
    final String imageUrl = "assets/images/${(imageName.isEmpty) ? defaultImage : imageName}";

    return Container(
      width: 150, // Fixed width for each card in the horizontal list
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Ảnh không khả dụng')),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  calories,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}