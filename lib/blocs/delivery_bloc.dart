// lib/blocs/delivery_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/delivery_model.dart';

abstract class DeliveryEvent {}
class TrackDeliveryEvent extends DeliveryEvent {
  final int orderId;
  TrackDeliveryEvent(this.orderId);
}
class UpdateDeliveryStatusEvent extends DeliveryEvent {
  final int orderId;
  final String newStatus;
  UpdateDeliveryStatusEvent(this.orderId, this.newStatus);
}

abstract class DeliveryState {}
class DeliveryInitial extends DeliveryState {}
class DeliveryLoading extends DeliveryState {}
class DeliveryLoaded extends DeliveryState {
  final DeliveryModel delivery;
  DeliveryLoaded(this.delivery);
}
class DeliveryError extends DeliveryState {
  final String message;
  DeliveryError(this.message);
}

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc() : super(DeliveryInitial()) {
    on<TrackDeliveryEvent>(_onTrackDelivery);
    on<UpdateDeliveryStatusEvent>(_onUpdateDeliveryStatus);
  }

  Future<void> _onTrackDelivery(TrackDeliveryEvent event, Emitter<DeliveryState> emit) async {
    emit(DeliveryLoading());
    try {
      // Mock: Tạo dữ liệu giả lập
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      final delivery = DeliveryModel(
        orderId: event.orderId,
        status: 'preparing', // Trạng thái ban đầu
        updatedAt: DateTime.now(),
        location: 'Kho Hà Nội',
      );
      emit(DeliveryLoaded(delivery));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/delivery/track.php?MaDH=${event.orderId}'));
      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.body);
      //   emit(DeliveryLoaded(DeliveryModel.fromJson(json)));
      // } else {
      //   throw Exception('Không thể theo dõi giao hàng');
      // }
    } catch (e) {
      emit(DeliveryError(e.toString()));
    }
  }

  Future<void> _onUpdateDeliveryStatus(UpdateDeliveryStatusEvent event, Emitter<DeliveryState> emit) async {
    emit(DeliveryLoading());
    try {
      // Mock: Cập nhật trạng thái
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      final delivery = DeliveryModel(
        orderId: event.orderId,
        status: event.newStatus,
        updatedAt: DateTime.now(),
        location: event.newStatus == 'shipping' ? 'Đường Láng' : 'Đã đến nơi',
      );
      emit(DeliveryLoaded(delivery));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/delivery/update.php'),
      //   body: jsonEncode({'MaDH': event.orderId, 'TrangThai': event.newStatus}),
      // );
      // if (response.statusCode == 200) {
      //   emit(DeliveryLoaded(DeliveryModel.fromJson(jsonDecode(response.body))));
      // } else {
      //   throw Exception('Không thể cập nhật trạng thái');
      // }
    } catch (e) {
      emit(DeliveryError(e.toString()));
    }
  }
}