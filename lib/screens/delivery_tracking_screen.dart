// lib/screens/delivery_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/delivery_bloc.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  final int? orderId;

  const DeliveryTrackingScreen({this.orderId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orderId != null) {
      context.read<DeliveryBloc>().add(TrackDeliveryEvent(orderId!));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Theo dõi giao hàng')),
      body: BlocBuilder<DeliveryBloc, DeliveryState>(
        builder: (context, state) {
          if (state is DeliveryLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is DeliveryLoaded) {
            final delivery = state.delivery;
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đơn hàng #${delivery.orderId}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Trạng thái: ${delivery.status}', style: TextStyle(fontSize: 18)),
                  Text('Cập nhật lúc: ${delivery.updatedAt?.toString().substring(0, 16) ?? 'Chưa cập nhật'}'),
                  Text('Vị trí: ${delivery.location ?? 'Không xác định'}'),
                  SizedBox(height: 20),
                  if (delivery.status != 'delivered')
                    ElevatedButton(
                      onPressed: () {
                        final newStatus = delivery.status == 'preparing' ? 'shipping' : 'delivered';
                        context.read<DeliveryBloc>().add(UpdateDeliveryStatusEvent(delivery.orderId, newStatus));
                      },
                      child: Text(delivery.status == 'preparing' ? 'Bắt đầu giao' : 'Hoàn tất giao hàng'),
                    ),
                ],
              ),
            );
          }
          if (state is DeliveryError) {
            return Center(child: Text(state.message));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nhập mã đơn hàng để theo dõi'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<DeliveryBloc>().add(TrackDeliveryEvent(1));
                  },
                  child: Text('Theo dõi đơn hàng mẫu'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}