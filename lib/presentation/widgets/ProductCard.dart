import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String calories;
  final String imageName;
  final VoidCallback? onTap; // Đảm bảo onTap được sử dụng

  const ProductCard({
    super.key,
    required this.title,
    required this.calories,
    required this.imageName,
    this.onTap, // Không cần required vì có thể null
  });

  @override
  Widget build(BuildContext context) {
    const String defaultImage = "GDD_Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg";
    final String imageUrl = "assets/images/${imageName.isEmpty ? defaultImage : imageName}";

    return GestureDetector(
      onTap: onTap, // Thêm GestureDetector để xử lý sự kiện nhấn
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                        child: Text('Ảnh không khả dụng', style: TextStyle(fontSize: 12))),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    calories,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}