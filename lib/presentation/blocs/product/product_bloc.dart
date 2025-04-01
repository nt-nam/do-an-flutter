import 'package:do_an_flutter/domain/usecases/product/get_product_by_id_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final GetProductByIdUsecase getProductByIdUsecase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.getProductByIdUsecase,
  }) : super(const ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(
        categoryId: event.categoryId,
        onlyAvailable: event.onlyAvailable,
        searchQuery: event.searchQuery,
      );
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProductDetails(
      FetchProductDetailsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await getProductByIdUsecase(event.productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await addProductUseCase(
        name: event.name,
        categoryId: event.categoryId,
        price: event.price,
        stock: event.stock,
        imageUrl: event.imageUrl, // Truyền imageUrl
        description: event.description, // Truyền description
      );
      emit(ProductAdded(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await updateProductUseCase(
        productId: event.productId,
        name: event.name,
        categoryId: event.categoryId,
        price: event.price,
        stock: event.stock,
        imageUrl: event.imageUrl, // Truyền imageUrl
        description: event.description, // Truyền description
      );
      emit(ProductUpdated(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      deleteProductUseCase(event.productId);
      emit(ProductDeleted(event.productId));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
