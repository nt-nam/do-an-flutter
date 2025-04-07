import '../../../domain/entities/product.dart';

abstract class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final Map<String, dynamic>? meta; // Thêm meta cho phân trang
  const ProductLoaded(this.products, {this.meta});
}

class ProductDetailsLoaded extends ProductState {
  final Product product;
  const ProductDetailsLoaded(this.product);
}

class ProductAdded extends ProductState {
  final Product product;
  const ProductAdded(this.product);
}

class ProductUpdated extends ProductState {
  final Product product;
  const ProductUpdated(this.product);
}

class ProductDeleted extends ProductState {
  final int productId;
  const ProductDeleted(this.productId);
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}