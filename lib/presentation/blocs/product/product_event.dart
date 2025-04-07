import 'dart:io';

abstract class ProductEvent {
  const ProductEvent();
}

class FetchProductsEvent extends ProductEvent {
  final int? categoryId; // Chỉ hỗ trợ một category
  final bool onlyAvailable;
  final String? searchQuery;
  final int? page; // Thêm phân trang
  final int? limit;

  const FetchProductsEvent({
    this.categoryId,
    this.onlyAvailable = false,
    this.searchQuery,
    this.page,
    this.limit,
  });
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
  final File? imageFile;
  final String? description;

  const AddProductEvent({
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.imageFile,
    this.description,
  });
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final String name;
  final int categoryId;
  final double price;
  final int stock;
  final File? imageFile; // Thay imageUrl bằng File
  final String? description;

  const UpdateProductEvent({
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.imageFile,
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

class FetchFeaturedProductsEvent extends ProductEvent {
  final int limit;
  const FetchFeaturedProductsEvent({this.limit = 5});
}

class FetchNewProductsEvent extends ProductEvent {
  final int limit;
  const FetchNewProductsEvent({this.limit = 5});
}