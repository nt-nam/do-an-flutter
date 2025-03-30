abstract class ProductEvent {
  const ProductEvent();
}

class FetchProductsEvent extends ProductEvent {
  final int? categoryId;
  final bool onlyAvailable;
  final String? searchQuery;

  const FetchProductsEvent({this.categoryId, this.onlyAvailable = false,this.searchQuery,});
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