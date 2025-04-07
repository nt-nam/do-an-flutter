import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/get_product_by_id_usecase.dart';
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
    on<ResetProductsEvent>(_onResetProducts);
    on<FetchFeaturedProductsEvent>(_onFetchFeaturedProducts);
    on<FetchNewProductsEvent>(_onFetchNewProducts);
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(
        categoryId: event.categoryId,
        searchQuery: event.searchQuery,
        page: event.page,
        limit: event.limit,
      );
      // Lọc chỉ sản phẩm còn hàng nếu cần
      final filteredProducts = event.onlyAvailable
          ? products.where((p) => p.trangThai == 'Còn hàng').toList()
          : products;
      emit(ProductLoaded(filteredProducts, meta: {'page': event.page, 'limit': event.limit}));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProductDetails(FetchProductDetailsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await getProductByIdUsecase(event.productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await addProductUseCase(
        name: event.name,
        categoryId: event.categoryId,
        price: event.price,
        stock: event.stock,
        imageFile: event.imageFile, // Truyền File thay vì URL
        description: event.description,
      );
      emit(ProductAdded(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      if (e.toString().contains('Forbidden')) {
        emit(const ProductError('Bạn không có quyền thêm sản phẩm'));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await updateProductUseCase(
        productId: event.productId,
        name: event.name,
        categoryId: event.categoryId,
        price: event.price,
        stock: event.stock,
        imageFile: event.imageFile, // Truyền File thay vì URL
        description: event.description,
      );
      emit(ProductUpdated(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      if (e.toString().contains('Forbidden')) {
        emit(const ProductError('Bạn không có quyền cập nhật sản phẩm'));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      await deleteProductUseCase(event.productId);
      emit(ProductDeleted(event.productId));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      if (e.toString().contains('Forbidden')) {
        emit(const ProductError('Bạn không có quyền xóa sản phẩm'));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onResetProducts(ResetProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchFeaturedProducts(FetchFeaturedProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(featured: true, limit: event.limit);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchNewProducts(FetchNewProductsEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(newProducts: true, limit: event.limit);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}