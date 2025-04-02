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
  final int? cartId;
  final List<CartDetail> items;
  final String deliveryAddress;
  final int? offerId;

  const CreateOrderEvent(this.accountId, this.items, this.deliveryAddress, {this.offerId, this.cartId});
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