abstract class CartEvent {
  const CartEvent();
}

class FetchCartEvent extends CartEvent {
  final int accountId;

  const FetchCartEvent(this.accountId);
}

class AddToCartEvent extends CartEvent {
  final int accountId;
  final int productId;
  final int quantity;

  const AddToCartEvent(this.accountId, this.productId, this.quantity);
}

class RemoveFromCartEvent extends CartEvent {
  final int cartId;
  final int productId;

  const RemoveFromCartEvent(this.cartId, this.productId);
}

class UpdateCartQuantityEvent extends CartEvent {
  final int cartId;
  final int productId;
  final int newQuantity;

  const UpdateCartQuantityEvent(this.cartId, this.productId, this.newQuantity);
}