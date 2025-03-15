// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Tự động tải danh sách sản phẩm khi vào màn hình
    context.read<ProductBloc>().add(LoadProductsEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            tooltip: 'Giỏ hàng',
          ),
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
            tooltip: 'Đơn hàng',
          ),
          IconButton(
            icon: Icon(Icons.local_shipping),
            onPressed: () => Navigator.pushNamed(context, '/delivery', arguments: 1), // Mock orderId
          ),
          IconButton(
            icon: Icon(Icons.store),
            onPressed: () => Navigator.pushNamed(context, '/inventory'),
            tooltip: 'Quản lý kho',
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return Center(child: Text('Chưa có sản phẩm nào'));
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: state.products[index]);
              },
            );
          }
          if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Chưa có dữ liệu sản phẩm'));
        },
      ),
    );
  }
}