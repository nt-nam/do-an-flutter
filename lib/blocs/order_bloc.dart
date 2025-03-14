// lib/blocs/order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

abstract class OrderEvent {}
class CreateOrderEvent extends OrderEvent {
  final List<CartModel> cartItems;
  final String? address;
  CreateOrderEvent(this.cartItems, {this.address});
}
class LoadOrdersEvent extends OrderEvent {}

abstract class OrderState {}
class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  OrderLoaded(this.orders);
}
class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  List<OrderModel> _orders = []; // Mock danh sách đơn hàng

  OrderBloc() : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<LoadOrdersEvent>(_onLoadOrders);
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      // Mock: Tạo đơn hàng từ giỏ hàng
      final order = OrderModel.fromCart(event.cartItems, address: event.address);
      _orders.add(order);
      emit(OrderLoaded(_orders));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/orders/create.php'),
      //   body: jsonEncode(order.toJson()),
      // );
      // if (response.statusCode == 201) {
      //   _orders.add(order);
      //   emit(OrderLoaded(_orders));
      // } else {
      //   throw Exception('Không thể tạo đơn hàng');
      // }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadOrders(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      // Mock: Trả về danh sách đơn hàng đã lưu
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      emit(OrderLoaded(_orders));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/orders/list.php'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   _orders = json.map((data) => OrderModel.fromJson(data)).toList();
      //   emit(OrderLoaded(_orders));
      // } else {
      //   throw Exception('Không tải được đơn hàng');
      // }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}