import 'package:do_an_flutter/presentation/widgets/CategoryButton.dart';
import 'package:do_an_flutter/presentation/widgets/FeaturedCard.dart';
import 'package:flutter/material.dart';

import 'domain/entities/product.dart';
import 'presentation/pages/screens/HomeScreen.dart';
import 'presentation/widgets/RecipeCard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      // home: HomeScreen(product: ,),
    );
  }
}

class HomeScreen extends StatelessWidget {
  static const String linkImage = "gasdandung/default_image.jpg"; // Ảnh mặc định

  final Product product;

  const HomeScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String imageUrl = "assets/images/${(product.imageUrl ?? HomeScreen.linkImage) == "" ? HomeScreen.linkImage : (product.imageUrl ?? HomeScreen.linkImage)}";

    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/$linkImage", // Ảnh mặc định nếu lỗi
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          // Các widget khác...
        ],
      ),
    );
  }
}