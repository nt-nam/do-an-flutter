import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/product.dart';
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_state.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_event.dart';
import '../../../blocs/product/product_state.dart';
import '../../../widgets/CategoryButton.dart';
import '../../../widgets/ProductCard.dart';
import 'DetailProductScreen.dart';

class FindProductScreen extends StatefulWidget {
  const FindProductScreen({super.key});

  static final String linkImage = "gasdandung/placeholder.jpg";

  @override
  State<FindProductScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedCategoryIds = []; // Thay đổi thành danh sách

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsEvent());
    _searchController.addListener(_onSearchChanged);
  }
  String _generateHeroTag(Product product) {
    return 'product_${product.id}';
  }
  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<ProductBloc>().add(FetchProductsEvent(
          searchQuery: query.isNotEmpty ? query : null,
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds
              : null, // Truyền danh sách
        ));
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId); // Bỏ chọn nếu đã chọn
      } else {
        _selectedCategoryIds.add(categoryId); // Thêm vào nếu chưa chọn
      }
    });
    context.read<ProductBloc>().add(FetchProductsEvent(
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds
              : null, // Truyền danh sách
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
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                            final isSelected =
                                _selectedCategoryIds.contains(category.id);
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
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              title: product.name,
                              calories: '${product.price} VNĐ',
                              imageName: product.imageUrl ?? '',
                              heroTag: _generateHeroTag(product),
                              onTap: () {
                                context.read<ProductBloc>().add(FetchProductDetailsEvent(product.id));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProductScreen(heroTag: _generateHeroTag(product)),
                                  ),
                                );
                              },
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
