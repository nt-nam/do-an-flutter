import 'package:flutter/material.dart';

import '../../widgets/CategoryButton.dart';
import '../../widgets/FeaturedCard.dart';
import '../../widgets/RecipeCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample data for featured items
  final List<Map<String, String>> featuredItems = const [
    {
      'title': 'Asian white noodle\nwith extra seafood',
      'author': 'James Spader',
      'time': '20 Min',
      'imageUrl': 'https://via.placeholder.com/150', // Replace with actual image URL
    },
    {
      'title': 'Spicy Thai Curry\nwith Shrimp',
      'author': 'Anna Smith',
      'time': '25 Min',
      'imageUrl': 'https://via.placeholder.com/150', // Replace with actual image URL
    },
    {
      'title': 'Grilled Salmon\nwith Lemon',
      'author': 'John Doe',
      'time': '15 Min',
      'imageUrl': 'https://via.placeholder.com/150', // Replace with actual image URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [
          Icon(Icons.shopping_cart, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            const Text(
              'Good Morning',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Text(
              'Alena Sabayan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Featured Section
            const Text(
              'Featured',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredItems.length,
                itemBuilder: (context, index) {
                  final item = featuredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: FeaturedCard(
                      title: item['title']!,
                      author: item['author']!,
                      time: item['time']!,
                      imageUrl: item['imageUrl']!,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Category Section
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryButton(label: 'Breakfast'),
                CategoryButton(label: 'Lunch'),
                CategoryButton(label: 'Dinner'),
                CategoryButton(label: 'All', isSelected: true),
              ],
            ),
            const SizedBox(height: 20),

            // Popular Recipes Section
            const Text(
              'Popular Recipes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                RecipeCard(
                  title: 'Healthy Taco Salad',
                  calories: '120 Kcal',
                  imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URL
                ),
                RecipeCard(
                  title: 'Japanese-style Pancakes',
                  calories: '84 Kcal',
                  imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URL
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}