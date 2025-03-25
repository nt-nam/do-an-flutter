import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_event.dart';
import '../../../blocs/category/category_state.dart';
import '../../../../domain/entities/category.dart';

class CategoryFormScreen extends StatelessWidget {
  final Category? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: category?.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Thêm loại sản phẩm' : 'Sửa loại sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên loại sản phẩm'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên loại sản phẩm')),
                  );
                  return;
                }

                if (category == null) {
                  context.read<CategoryBloc>().add(AddCategoryEvent(name));
                } else {
                  context.read<CategoryBloc>().add(UpdateCategoryEvent(category!.id, name));
                }

                Navigator.pop(context);
              },
              child: Text(category == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}