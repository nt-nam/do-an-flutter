import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is OrderCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order created')));
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  title: Text('Order ID: ${order.id}'),
                  subtitle: Text('Status: ${order.status} - Total: ${order.totalAmount}'),
                  trailing: DropdownButton<String>(
                    // value: order.status,
                    items: ['Chờ xác nhận', 'Đang giao', 'Đã giao', 'Hủy']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        // context.read<OrderBloc>().add(UpdateOrderStatusEvent(order.id, newStatus));
                      }
                    },
                  ),
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<OrderBloc>().add(const FetchOrdersEvent(1)); // Giả định accountId = 1
              },
              child: const Text('Load Orders'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<OrderBloc>().add(
          //   const CreateOrderEvent(
          //     1, // accountId
          //     [(101, 2, 100.0)], // items: (productId, quantity, price)
          //     '123 Main St', // deliveryAddress
          //   ),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}