import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/add_product_usecase.dart';
import '../../../domain/usecases/update_product_usecase.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final ProductRepository productRepository; // Để xóa sản phẩm

  ProductBloc({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.productRepository,
  }) : super(const ProductInitial()) {
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
      final productModel = await productRepository.getProductById(event.productId);
      final product = Product(
        id: productModel.maSP,
        name: productModel.tenSP,
        description: productModel.moTa,
        price: productModel.gia,
        categoryId: productModel.maLoai,
        imageUrl: productModel.hinhAnh,
        status: productModel.trangThai == 'Còn hàng' ? ProductStatus.inStock : ProductStatus.outOfStock,
        stock: productModel.soLuongTon,
      );
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
      );
      emit(ProductAdded(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
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
      );
      emit(ProductUpdated(product));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      await productRepository.deleteProduct(event.productId);
      emit(ProductDeleted(event.productId));
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}