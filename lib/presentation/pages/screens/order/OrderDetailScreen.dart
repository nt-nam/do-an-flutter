import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_flutter/domain/entities/order.dart';
import 'package:do_an_flutter/domain/entities/order_detail.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_event.dart';
import 'package:do_an_flutter/presentation/blocs/order/order_state.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra order.id trước khi gọi sự kiện
    if (order.id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
        body: const Center(child: Text('Lỗi: Mã đơn hàng không hợp lệ')),
      );
    }

    // Gọi sự kiện với order.id (đã đảm bảo không null)
    context.read<OrderBloc>().add(FetchOrderDetailsEvent(order.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng #${order.id}'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailsLoaded) {
            return _buildOrderDetails(context, state.details);
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, List<OrderDetail> orderDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin đơn hàng
          Text(
            'Mã đơn hàng: ${order.id}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Ngày đặt: ${order.orderDate.toString()}'),
          Text('Tổng tiền: ${order.totalAmount} VNĐ'),
          Text('Trạng thái: ${order.status.toString().split('.').last}'),
          Text('Địa chỉ giao hàng: ${order.deliveryAddress ?? 'Không có'}'),
          const SizedBox(height: 16),

          // Danh sách sản phẩm
          const Text(
            'Sản phẩm:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: orderDetails.length,
              itemBuilder: (context, index) {
                final detail = orderDetails[index];
                return ListTile(
                  title: Text('Sản phẩm ID: ${detail.productId ?? 'Không xác định'}'),
                  subtitle: Text(
                      'Số lượng: ${detail.quantity ?? 0} - Giá: ${detail.priceAtPurchase ?? 0} VNĐ'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}