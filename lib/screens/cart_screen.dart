// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giỏ hàng')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            if (state.items.isEmpty) {
              return Center(child: Text('Giỏ hàng trống'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) => CartItem(cartItem: state.items[index]),
            );
          }
          return Center(child: Text('Giỏ hàng trống'));
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/checkout'),
          child: Text('Thanh toán'),
        ),
      ),
    );
  }
}