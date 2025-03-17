abstract class ProductEvent {
  const ProductEvent();
}

class FetchProductsEvent extends ProductEvent {
  final int? categoryId; // Lọc theo danh mục nếu có
  final bool onlyAvailable; // Lọc sản phẩm còn hàng

  const FetchProductsEvent({this.categoryId, this.onlyAvailable = false});
}

class FetchProductDetailsEvent extends ProductEvent {
  final int productId;

  const FetchProductDetailsEvent(this.productId);
}

class AddProductEvent extends ProductEvent {
  final String name;
  final int categoryId;
  final double price;
  final int stock;

  const AddProductEvent(this.name, this.categoryId, this.price, this.stock);
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final String name;
  final int categoryId;
  final double price;
  final int stock;

  const UpdateProductEvent(this.productId, this.name, this.categoryId, this.price, this.stock);
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  const DeleteProductEvent(this.productId);
}