// Featured Card Widget
import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String title;
  final String author;
  final String time;
  final String imageUrl;
  final VoidCallback? onTap;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.author,
    required this.time,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width for each card in the horizontal list
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.teal[50],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/50', // Replace with actual author image URL
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        author,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              width: 150,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}