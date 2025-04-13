import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_state.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_event.dart';
import '../../../blocs/product/product_state.dart';
import '../../../widgets/CategoryCheckbox.dart';
import '../../../widgets/ProductCard.dart';
import 'DetailProductScreen.dart';

class FindProductScreen extends StatefulWidget {
  final List<int>? preselectedCategoryIds;

  const FindProductScreen({
    super.key,
    this.preselectedCategoryIds,
  });

  @override
  State<FindProductScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedCategoryIds != null) {
      _selectedCategoryIds = widget.preselectedCategoryIds!;
    }
    context.read<ProductBloc>().add(FetchProductsEvent(
      categoryIds: _selectedCategoryIds.isNotEmpty ? _selectedCategoryIds : null,
    ));
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<ProductBloc>().add(FetchProductsEvent(
      searchQuery: query.isNotEmpty ? query : null,
      categoryIds: _selectedCategoryIds.isNotEmpty ? _selectedCategoryIds : null,
    ));
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
      }
    });
    context.read<ProductBloc>().add(FetchProductsEvent(
      categoryIds: _selectedCategoryIds.isNotEmpty ? _selectedCategoryIds : null,
      searchQuery: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 180;
    final crossAxisCount = (screenWidth / itemWidth).floor().clamp(2, 4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tìm kiếm sản phẩm',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên sản phẩm...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.search, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 16),

                // Categories
                Text(
                  'Danh mục',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCategories(),
                const SizedBox(height: 16),

                // Products
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kết quả tìm kiếm',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoaded) {
                          return Text(
                            '${state.products.length} sản phẩm',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildProducts(crossAxisCount),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        } else if (state is CategoryLoaded) {
          final categories = state.categories;
          if (categories.isEmpty) {
            return Text(
              'Không có danh mục nào.',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            );
          }
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategoryIds.contains(category.id);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CategoryCheckbox(
                    key: ValueKey(category.id),
                    label: category.name,
                    isSelected: isSelected,
                    onTap: () => _onCategorySelected(category.id),
                  ),
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          return Text(
            'Lỗi: ${state.message}',
            style: GoogleFonts.poppins(color: Colors.red[700]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProducts(int crossAxisCount) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        } else if (state is ProductLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy sản phẩm nào',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                title: product.name,
                price: '${product.price} VNĐ',
                imageUrl: product.imageUrl ?? '',
                heroTag: 'product-${product.id}',
                onTap: () {
                  context.read<ProductBloc>().add(FetchProductDetailsEvent(product.id));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProductScreen(heroTag: 'product-${product.id}'),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is ProductError) {
          return Center(
            child: Text(
              'Lỗi: ${state.message}',
              style: GoogleFonts.poppins(color: Colors.red[700]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}