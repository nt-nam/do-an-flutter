// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadProductsEvent());
    return Scaffold(
      appBar: AppBar(title: Text('Trang chủ')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) return Center(child: CircularProgressIndicator());
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) => ProductCard(product: state.products[index]),
            );
          }
          if (state is ProductError) return Center(child: Text(state.message));
          return Center(child: Text('Chưa có dữ liệu'));
        },
      ),
    );
  }
}