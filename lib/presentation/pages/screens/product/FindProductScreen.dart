import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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

  static const String linkImage = "gasdandung/placeholder.jpg";

  @override
  State<FindProductScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedCategoryIds = [];
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsEvent());
    _searchController.addListener(_onSearchChanged);

    // Animation for search bar
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _searchAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _searchAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 180;
    final crossAxisCount = (screenWidth / itemWidth).floor().clamp(2, 4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          return CustomScrollView(
            slivers: [
              // Search app bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purpleAccent.shade200,
                          Colors.deepPurple.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  title: AnimatedBuilder(
                    animation: _searchAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _searchAnimation.value,
                        child: Hero(
                          tag: 'search-bar',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm món ăn...',
                                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                                  border: InputBorder.none,
                                ),
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                ),
              ),

              // Main content
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Categories section
                    Text(
                      'Danh mục',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategories(),

                    // Products section
                    const SizedBox(height: 24),
                    _buildProductsSection(crossAxisCount),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<CategoryBloc, CategoryState>(
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
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategoryIds.contains(category.id);
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
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

  Widget _buildProductsSection(int crossAxisCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kết quả tìm kiếm',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded) {
                  return Text(
                    '${state.products.length} kết quả',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
            } else if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/empty.json',
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      'Không tìm thấy sản phẩm nào',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ProductCard(
                      key: ValueKey(product.id),
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
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/error.json',
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Lỗi: ${state.message}',
                      style: GoogleFonts.poppins(color: Colors.red[700]),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}