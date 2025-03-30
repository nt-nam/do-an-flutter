import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_state.dart';
import '../../../blocs/product/product_event.dart';
import '../../../blocs/product/product_state.dart';
import '../../../widgets/CategoryButton.dart';
import '../../../widgets/RecipeCard.dart';

class FindProductScreen extends StatefulWidget {
  const FindProductScreen({super.key});

  static final String linkImage =
      "gasdandung/Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg";

  @override
  State<FindProductScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách tất cả sản phẩm khi vào màn hình
    context.read<ProductBloc>().add(const FetchProductsEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<ProductBloc>().add(FetchProductsEvent(
      searchQuery: query.isNotEmpty ? query : null,
      categoryId: _selectedCategoryId,
    ));
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    context.read<ProductBloc>().add(FetchProductsEvent(
      categoryId: categoryId,
      searchQuery: _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tìm kiếm',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        toolbarHeight: 40,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh tìm kiếm
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên sản phẩm...',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Danh mục
                const Text(
                  'Loại',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoryLoaded) {
                      final categories = state.categories;
                      if (categories.isEmpty) {
                        return const Text('Không có danh mục nào.');
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: categories.map((category) {
                            final isSelected = _selectedCategoryId == category.id;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CategoryButton(
                                label: category.name,
                                isSelected: isSelected,
                                onTap: () => _onCategorySelected(category.id),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is CategoryError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                // Danh sách sản phẩm
                const Text(
                  'Sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductLoaded) {
                        final products = state.products;
                        if (products.isEmpty) {
                          return const Center(
                            child: Text('Không tìm thấy sản phẩm nào.'),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 cột
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75, // Tỷ lệ chiều cao/chiều rộng
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return RecipeCard(
                              title: product.name,
                              calories: '${product.price} VNĐ',
                              imageUrl:
                              "assets/images/${(product.imageUrl ?? FindProductScreen.linkImage) == "" ? FindProductScreen.linkImage : (product.imageUrl ?? FindProductScreen.linkImage)}",
                            );
                          },
                        );
                      } else if (state is ProductError) {
                        return Center(child: Text('Lỗi: ${state.message}'));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Cập nhật CategoryButton để hỗ trợ trạng thái được chọn
class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}