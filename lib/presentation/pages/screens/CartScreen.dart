import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CartItemAdded) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added to cart')));
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final item = state.cartItems[index];
                return ListTile(
                  title: Text('Product ID: ${item.productId}'),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          // context.read<CartBloc>().add(UpdateCartQuantityEvent(item.id, item.quantity - 1));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CartBloc>().add(const FetchCartEvent(1)); // Giả định accountId = 1
              },
              child: const Text('Load Cart'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CartBloc>().add(const AddToCartEvent(1, 101, 1)); // Thêm sản phẩm giả định
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}