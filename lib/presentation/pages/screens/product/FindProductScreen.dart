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
  const FindProductScreen({super.key});

  static final String linkImage = "gasdandung/placeholder.jpg";

  @override
  State<FindProductScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsEvent());
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
      // Debug log để kiểm tra
      print('Selected Category IDs: $_selectedCategoryIds');
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          'Tìm kiếm',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 50,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
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
                      prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Loại',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                    } else if (state is CategoryLoaded) {
                      final categories = state.categories;
                      if (categories.isEmpty) {
                        return Text(
                          'Không có danh mục nào.',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        );
                      }
                      // Debug log để kiểm tra danh mục
                      print('Categories: ${categories.map((c) => c.id).toList()}');
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: categories.map((category) {
                            final isSelected = _selectedCategoryIds.contains(category.id);
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CategoryCheckbox(
                                key: ValueKey(category.id),
                                label: category.name,
                                isSelected: isSelected,
                                onTap: () => _onCategorySelected(category.id),
                              ),
                            );
                          }).toList(),
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
                ),
                const SizedBox(height: 24),
                Text(
                  'Sản phẩm',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                      } else if (state is ProductLoaded) {
                        final products = state.products;
                        if (products.isEmpty) {
                          return Center(
                            child: Text(
                              'Không tìm thấy sản phẩm nào.',
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                            ),
                          );
                        }
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return AnimatedSlide(
                              offset: Offset(0, index * 0.1),
                              duration: Duration(milliseconds: 300 + index * 100),
                              child: ProductCard(
                                title: product.name,
                                calories: '${product.price} VNĐ',
                                imageName: product.imageUrl ?? '',
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
                              ),
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