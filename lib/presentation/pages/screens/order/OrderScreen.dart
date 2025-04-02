import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_flutter/domain/entities/cart_detail.dart';
import 'package:do_an_flutter/domain/entities/order.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_event.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_state.dart';
import 'OrderDetailScreen.dart';
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn) {
      final accountId = accountState.account.id;
      if (accountId != null) {
        context.read<OrderBloc>().add(FetchOrdersEvent(accountId));
      }
    }
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.delivering:
        return 'Đang giao';
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
    return 'Không xác định';
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.delivering:
        return Colors.orange;
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.cancelled:
        return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Không có đơn hàng nào',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      // Chuyển hướng đến OrderDetailScreen và tải lại dữ liệu khi quay lại
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      ).then((_) {
                        // Tải lại danh sách đơn hàng khi quay lại từ OrderDetailScreen
                        _loadOrders();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mã đơn hàng: ${order.id ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(order.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: getStatusColor(order.status),
                                  ),
                                ),
                                child: Text(
                                  getStatusText(order.status),
                                  style: TextStyle(
                                    color: getStatusColor(order.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tổng tiền: ${order.totalAmount.toStringAsFixed(0)} VNĐ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ngày đặt: ${order.orderDate.toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Địa chỉ giao: ${order.deliveryAddress ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                if (accountState is AccountLoggedIn) {
                  return const Text(
                    'Đang tải đơn hàng...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  );
                }
                return const Text(
                  'Vui lòng đăng nhập để xem đơn hàng',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}