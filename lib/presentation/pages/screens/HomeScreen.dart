import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../presentation/pages/screens/product/DetailProductScreen.dart';
import '../../../domain/entities/product.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../widgets/ProductCardFeatured.dart';
import '../../widgets/ProductCard.dart';
import 'MenuScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final String linkImage = "placeholder.jpg";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Product> _products = [];
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsEvent());

    // Animation for wave effect
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _waveAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  String _generateHeroTag(Product product) {
    return 'product_${product.id}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar với hiệu ứng gradient và animation
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _waveAnimation.value),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purpleAccent.shade200,
                            Colors.deepPurple.shade400,
                            Colors.indigo.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Xin chào 👋',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      BlocBuilder<UserBloc, UserState>(
                                        builder: (context, userState) {
                                          String userName = 'Khách hàng';
                                          if (userState is UserLoaded && userState.user != null) {
                                            userName = userState.user.fullName ?? 'Khách hàng';
                                          } else {
                                            final accountState = context.watch<AccountBloc>().state;
                                            if (accountState is AccountLoggedIn && accountState.user != null) {
                                              userName = accountState.user!.hoTen ?? 'Khách hàng';
                                            }
                                          }
                                          return Text(
                                            userName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MenuScreen()),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white.withOpacity(0.2),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Search bar with animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Hero(
                                  tag: 'search-bar',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        // Navigate to search screen
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.search, color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Tìm kiếm món ngon...',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Nội dung chính
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section 1: Featured products with animation
                _buildSectionHeader('Món nổi bật', 'Xem tất cả'),
                const SizedBox(height: 12),
                _buildFeaturedProducts(),

                // Section 2: Categories with animation
                _buildSectionHeader('Danh mục', ''),
                const SizedBox(height: 12),
                _buildCategories(),

                // Section 3: Popular products
                _buildSectionHeader('Món phổ biến', 'Xem tất cả'),
                const SizedBox(height: 12),
                _buildPopularProducts(),

                // Section 4: Special offers
                _buildSpecialOffers(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedProducts() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          _products = state.products;
        }
        if (_products.isEmpty) {
          return const Text('Không có sản phẩm nào.');
        }
        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _products.take(5).length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FeaturedCard(
                  title: product.name,
                  price: '${product.price.toStringAsFixed(0)} VNĐ',
                  time: product.status == ProductStatus.inStock
                      ? 'Còn hàng'
                      : 'Hết hàng',
                  imageUrl: "assets/images/${product.imageUrl ?? HomeScreen.linkImage}",
                  onTap: () {
                    context.read<ProductBloc>().add(
                        FetchProductDetailsEvent(product.id)
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailProductScreen(heroTag: _generateHeroTag(product))),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          final categories = state.categories;
          if (categories.isEmpty) {
            return const Text('Không có danh mục nào.');
          }
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle category tap
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purpleAccent.shade100,
                                Colors.deepPurple.shade300,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(category.name),
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          return Text('Lỗi: ${state.message}');
        }
        return const SizedBox.shrink();
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'đồ uống':
        return Icons.local_drink;
      case 'món chính':
        return Icons.set_meal;
      case 'tráng miệng':
        return Icons.icecream;
      case 'đồ nhanh':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildPopularProducts() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          _products = state.products..shuffle();
        }
        if (_products.isEmpty) {
          return const Text('Không có sản phẩm nào.');
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _products.take(4).length,
          itemBuilder: (context, index) {
            final product = _products[index];
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
      },
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Ưu đãi đặc biệt', ''),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade300,
                Colors.deepOrange.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Lottie.asset(
                  'assets/animations/fire.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giảm giá 30%',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Cho tất cả các món vào thứ 3 hàng tuần',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Đặt ngay',
                        style: GoogleFonts.poppins(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}