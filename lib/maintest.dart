import 'package:do_an_flutter/presentation/widgets/CategoryButton.dart';
import 'package:do_an_flutter/presentation/widgets/FeaturedCard.dart';
import 'package:flutter/material.dart';

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
      home: HomeScreen(),
    );
  }
}
