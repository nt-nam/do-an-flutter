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
  final List<(int productId, int quantity, double price)> items;
  final String deliveryAddress;
  final int? offerId;

  const CreateOrderEvent(this.accountId, this.items, this.deliveryAddress, {this.offerId});
}

class UpdateOrderStatusEvent extends OrderEvent {
  final int orderId;
  final String newStatus;

  const UpdateOrderStatusEvent(this.orderId, this.newStatus);
}