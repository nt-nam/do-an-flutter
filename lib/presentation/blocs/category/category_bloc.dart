import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/category/add_category_usecase.dart';
import '../../../domain/usecases/category/delete_category_usecase.dart';
import '../../../domain/usecases/category/get_categories_usecase.dart';
import '../../../domain/usecases/category/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc(
      this.getCategoriesUseCase,
      this.addCategoryUseCase,
      this.updateCategoryUseCase,
      this.deleteCategoryUseCase,
      ) : super(const CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onFetchCategories(
      FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      final categories = await getCategoriesUseCase();
      // Debug: In danh sách categories để kiểm tra
      print('Raw Categories: ${categories.map((c) => "ID: ${c.id}, Name: ${c.name}").toList()}');
      // Loại bỏ trùng lặp dựa trên id
      final uniqueCategories = categories.fold<List<Category>>(
        [],
            (list, category) {
          if (!list.any((c) => c.id == category.id)) {
            list.add(category);
          }
          return list;
        },
      );
      print('Unique Categories: ${uniqueCategories.map((c) => "ID: ${c.id}, Name: ${c.name}").toList()}');
      emit(CategoryLoaded(uniqueCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      final category = await addCategoryUseCase(event.name);
      emit(CategoryAdded(category));
      final categories = await getCategoriesUseCase();
      final uniqueCategories = categories.fold<List<Category>>(
        [],
            (list, category) => list.any((c) => c.id == category.id) ? list : list..add(category ),
      );
      emit(CategoryLoaded(uniqueCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      final category = await updateCategoryUseCase(event.categoryId, event.name);
      emit(CategoryUpdated(category));
      final categories = await getCategoriesUseCase();
      final uniqueCategories = categories.fold<List<Category>>(
        [],
            (list, category) => list.any((c) => c.id == category.id) ? list : list..add(category),
      );
      emit(CategoryLoaded(uniqueCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(const CategoryLoading());
    try {
      await deleteCategoryUseCase(event.categoryId);
      emit(CategoryDeleted(event.categoryId));
      final categories = await getCategoriesUseCase();
      final uniqueCategories = categories.fold<List<Category>>(
        [],
            (list, category) => list.any((c) => c.id == category.id) ? list : list..add(category),
      );
      emit(CategoryLoaded(uniqueCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}