import '../../../domain/entities/cart_detail.dart';
import '../../../domain/entities/order.dart' as entity;

abstract class OrderEvent {
  const OrderEvent();
}

class FetchOrdersEvent extends OrderEvent {
  final int accountId;
  final int page;
  final int limit;

  const FetchOrdersEvent(this.accountId, {this.page = 1, this.limit = 10});
}

class CreateOrderEvent extends OrderEvent {
  final int accountId;
  final List<CartDetail> items;
  final String deliveryAddress;
  final int? cartId;
  final double deliveryFee;
  final String? offerId;
  final Map<String, dynamic>? additionalData;

  const CreateOrderEvent(
    this.accountId, 
    this.items, 
    this.deliveryAddress, 
    {this.cartId, 
    this.deliveryFee = 0,
    this.offerId,
    this.additionalData}
  );
}

class UpdateOrderStatusEvent extends OrderEvent {
  final int orderId;
  final entity.OrderStatus newStatus;

  const UpdateOrderStatusEvent(this.orderId, this.newStatus);
}

class FetchOrderDetailsEvent extends OrderEvent {
  final int orderId;

  const FetchOrderDetailsEvent(this.orderId);
}

class CancelOrderEvent extends OrderEvent {
  final int orderId;

  const CancelOrderEvent(this.orderId);
}

class FetchAllOrdersEvent extends OrderEvent {}
class ConfirmOrderEvent extends OrderEvent {
  final int orderId;
  const ConfirmOrderEvent(this.orderId);
}
class CompleteOrderEvent extends OrderEvent {
  final int orderId;
  const CompleteOrderEvent(this.orderId);
}