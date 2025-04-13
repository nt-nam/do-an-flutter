import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/order.dart';
import '../../../blocs/order/order_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/order/order_event.dart';
import '../../../blocs/order/order_state.dart';

class OrderManagerScreen extends StatefulWidget {
  const OrderManagerScreen({super.key});

  @override
  State<OrderManagerScreen> createState() => _OrderManagerScreenState();
}

class _OrderManagerScreenState extends State<OrderManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'Tất cả',
    'Chờ xác nhận',
    'Đang giao',
    'Đã giao',
    'Đã hủy'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    context.read<OrderBloc>().add(FetchAllOrdersEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Các hàm hỗ trợ hiển thị (giữ nguyên từ OrderScreen)
  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered: return 'Đã giao';
      case OrderStatus.delivering: return 'Đang giao';
      case OrderStatus.pending: return 'Chờ xác nhận';
      case OrderStatus.cancelled: return 'Đã hủy';
    }
    return 'Không xác định';
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.delivering: return Colors.orange;
      case OrderStatus.pending: return Colors.blue;
      case OrderStatus.cancelled: return Colors.red;
    }
    return Colors.grey;
  }

  IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered: return Icons.check_circle;
      case OrderStatus.delivering: return Icons.local_shipping;
      case OrderStatus.pending: return Icons.pending;
      case OrderStatus.cancelled: return Icons.cancel;
    }
    return Icons.help_outline;
  }

  List<Order> filterOrdersByStatus(List<Order> orders, int tabIndex) {
    if (tabIndex == 0) return orders;

    final status = {
      1: OrderStatus.pending,
      2: OrderStatus.delivering,
      3: OrderStatus.delivered,
      4: OrderStatus.cancelled,
    }[tabIndex]!;

    return orders.where((order) => order.status == status).toList();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // String _formatCurrency(double amount) {
  //   return amount.toStringAsFixed(0).replaceAllMapped(
  //     RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d)'),
  //         (Match m) => '${m[1]}.',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          isScrollable: true,
          labelColor: Colors.white,
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          // else if (state is OrderCancelled) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Đã hủy đơn hàng thành công')),
          //   );
          //   context.read<OrderBloc>().add(FetchAllOrdersEvent());
          // }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllOrdersLoaded) {
            return TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (tabIndex) {
                final filteredOrders = filterOrdersByStatus(state.orders, tabIndex);
                return _buildOrderManagerList(filteredOrders);
              }),
            );
          }
          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
    );
  }

  Widget _buildOrderManagerList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: getStatusColor(order.status).withOpacity(0.1),
                  child: Icon(
                    getStatusIcon(order.status),
                    color: getStatusColor(order.status),
                  ),
                ),
                // title: Text('Đơn #${order.id} - ${order.customerName ?? "Khách hàng"}'),
                subtitle: Text(formatDate(order.orderDate)),
                trailing: Chip(
                  label: Text(getStatusText(order.status)),
                  backgroundColor: getStatusColor(order.status).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: getStatusColor(order.status),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Sản phẩm: ${order.items.length}'),
                    // Text('Tổng tiền: ${_formatCurrency(order.totalAmount)} VNĐ'),
                    Text('Tổng tiền: '+order.totalAmount.toString()+' VNĐ'),
                    const SizedBox(height: 8),
                    Text(
                      'Địa chỉ: ${order.deliveryAddress ?? "Không có"}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ButtonBar(
                children: [
                  if (order.status == OrderStatus.pending)
                    TextButton(
                      onPressed: () => _confirmOrder(order.id??0),
                      child: const Text('Xác nhận'),
                    ),
                  if (order.status == OrderStatus.pending)
                    TextButton(
                      onPressed: () => _cancelOrder(order.id??0),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Hủy đơn'),
                    ),
                  if (order.status == OrderStatus.delivering)
                    TextButton(
                      onPressed: () => _completeOrder(order.id??0),
                      child: const Text('Hoàn thành'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmOrder(int orderId) {
    context.read<OrderBloc>().add(ConfirmOrderEvent(orderId));
  }

  void _cancelOrder(int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn chắc chắn muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderBloc>().add(CancelOrderEvent(orderId));
              Navigator.pop(context);
            },
            child: const Text('Có', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _completeOrder(int orderId) {
    context.read<OrderBloc>().add(CompleteOrderEvent(orderId));
  }
}