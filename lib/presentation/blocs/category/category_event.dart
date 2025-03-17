abstract class CategoryEvent {
  const CategoryEvent();
}

class FetchCategoriesEvent extends CategoryEvent {
  const FetchCategoriesEvent();
}

class AddCategoryEvent extends CategoryEvent {
  final String name;

  const AddCategoryEvent(this.name);
}

class UpdateCategoryEvent extends CategoryEvent {
  final int categoryId;
  final String name;

  const UpdateCategoryEvent(this.categoryId, this.name);
}

class DeleteCategoryEvent extends CategoryEvent {
  final int categoryId;

  const DeleteCategoryEvent(this.categoryId);
}