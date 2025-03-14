// lib/screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(LoadOrdersEvent());
    return BlocProvider(
      create: (_) => OrderBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Đơn hàng')),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderInitial) {
              context.read<OrderBloc>().add(LoadOrdersEvent());
            }
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is OrderLoaded) {
              if (state.orders.isEmpty) {
                return Center(child: Text('Chưa có đơn hàng nào'));
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    title: Text('Đơn hàng #${order.id}'),
                    subtitle: Text('Tổng: ${order.total} VNĐ - Trạng thái: ${order.status}'),
                    trailing: Text(order.createdAt.toString().substring(0, 10)),
                    onTap: () {
                      // Có thể thêm chi tiết đơn hàng sau
                      Navigator.pushNamed(context, '/delivery', arguments: order.id);
                    },
                  );
                },
              );
            }
            if (state is OrderError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('Chưa có đơn hàng nào'));
          },
        ),
      ),
    );



      Scaffold(
      appBar: AppBar(title: Text('Đơn hàng')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return Center(child: Text('Chưa có đơn hàng nào'));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  title: Text('Đơn hàng #${order.id}'),
                  subtitle: Text('Tổng: ${order.total} VNĐ - Trạng thái: ${order.status}'),
                  trailing: Text(order.createdAt.toString().substring(0, 10)),
                  onTap: () {
                    // Có thể thêm chi tiết đơn hàng sau
                  },
                );
              },
            );
          }
          if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Chưa có đơn hàng nào'));
        },
      ),
    );
  }
}