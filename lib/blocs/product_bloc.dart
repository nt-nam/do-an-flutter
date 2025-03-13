// lib/blocs/product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';

abstract class ProductEvent {}
class LoadProductsEvent extends ProductEvent {}

abstract class ProductState {}
class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      // Mock data thay vì gọi API
      await Future.delayed(Duration(seconds: 1));
      final products = [
        ProductModel(id: 1, name: 'Bình gas 12kg', description: 'Bình gas an toàn', price: 350000, quantity: 100, status: 'Còn hàng'),
        ProductModel(id: 2, name: 'Van gas', description: 'Van tự ngắt', price: 150000, quantity: 50, status: 'Còn hàng'),
      ];
      emit(ProductLoaded(products));

      // Khi dùng API thật (PHP/phpMyAdmin):
      // final response = await http.get(Uri.parse('http://your-php-server/products.php'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   final products = json.map((data) => ProductModel.fromJson(data)).toList();
      //   emit(ProductLoaded(products));
      // } else {
      //   throw Exception('Không tải được sản phẩm');
      // }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}