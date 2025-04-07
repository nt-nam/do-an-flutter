class Cart {
  final int cartId;
  final int accountId;
  final DateTime addedDate;
  final String status;

  Cart({
    required this.cartId,
    required this.accountId,
    required this.addedDate,
    required this.status,
  });
}