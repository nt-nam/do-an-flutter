import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc(this.getProductsUseCase) : super(const ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(
        categoryId: event.categoryId,
        onlyAvailable: event.onlyAvailable,
      );
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProductDetails(FetchProductDetailsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const ProductError('Fetch product details not implemented yet'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const ProductError('Add product not implemented yet'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const ProductError('Update product not implemented yet'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const ProductError('Delete product not implemented yet'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}