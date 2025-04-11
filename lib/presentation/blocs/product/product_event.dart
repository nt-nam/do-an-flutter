abstract class ProductEvent {
  const ProductEvent();
}

class FetchProductsEvent extends ProductEvent {
  final List<int>? categoryIds;
  final bool onlyAvailable;
  final String? searchQuery;

  const FetchProductsEvent({this.categoryIds, this.onlyAvailable = false,this.searchQuery,});
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
  final String? imageUrl;
  final String? description;

  const AddProductEvent({
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.description,
  });
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final String name;
  final int categoryId;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? description;

  const UpdateProductEvent({
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.description,
  });
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  const DeleteProductEvent(this.productId);
}
class ResetProductsEvent extends ProductEvent {
  const ResetProductsEvent();
}