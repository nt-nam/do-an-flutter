import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_detail.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  const OrderLoaded(this.orders);
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated(this.order);
}

class OrderStatusUpdated extends OrderState {
  final Order order;

  const OrderStatusUpdated(this.order);
}

class OrderDetailsLoaded extends OrderState {
  final List<OrderDetail> details;

  const OrderDetailsLoaded(this.details);
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);
}

class AllOrdersLoaded extends OrderState {
  final List<Order> orders;
  const AllOrdersLoaded(this.orders);
}