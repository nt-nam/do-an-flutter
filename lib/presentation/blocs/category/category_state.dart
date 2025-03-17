import '../../../domain/entities/category.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);
}

class CategoryAdded extends CategoryState {
  final Category category;

  const CategoryAdded(this.category);
}

class CategoryUpdated extends CategoryState {
  final Category category;

  const CategoryUpdated(this.category);
}

class CategoryDeleted extends CategoryState {
  final int categoryId;

  const CategoryDeleted(this.categoryId);
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);
}