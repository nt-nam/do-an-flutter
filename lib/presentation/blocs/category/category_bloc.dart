import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_category_usecase.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;

  CategoryBloc(this.getCategoriesUseCase, this.addCategoryUseCase) : super(const CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onFetchCategories(FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      final category = await addCategoryUseCase(event.name); // Sử dụng AddCategoryUseCase
      emit(CategoryAdded(category));
      // Tải lại danh sách sau khi thêm
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      // Chưa triển khai use case
      emit(const CategoryError('Update category not implemented yet'));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      // Chưa triển khai use case
      emit(const CategoryError('Delete category not implemented yet'));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}