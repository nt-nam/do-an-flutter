import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas_store/presentation/pages/screens/product/DetailProductScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/product.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../widgets/ProductCard.dart';
import '../../widgets/ProductCardFeatured.dart';
import 'MenuManagerScreen.dart';
import 'MenuScreen.dart';
import 'auth/LoginScreen.dart';
import 'product/FindProductScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final String linkImage = "placeholder.jpg";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<NotificationE> _specialNotifications = [];
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsEvent());
    _loadSpecialNotifications();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  String _generateHeroTag(Product product) {
    return 'product_${product.id}';
  }

  void _navigateToFindProduct({List<int>? categoryIds}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindProductScreen(
          preselectedCategoryIds: categoryIds,
        ),
      ),
    );
  }

  Future<void> _loadSpecialNotifications() async {
    final notificationBloc = context.read<NotificationBloc>();
    notificationBloc.add(FetchSpecialNotificationsEvent(priority: 4, limit: 3));

    _notificationSubscription = notificationBloc.stream.listen((state) {
      if (state is SpecialNotificationsLoaded && mounted) {
        setState(() {
          _specialNotifications = state.notifications;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.gas_meter, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'GasExpress',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade600,
                      Colors.teal.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
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
                              'Xin chào, $userName',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  final accountBloc = context.read<AccountBloc>();
                  if (accountBloc.state is AccountLoggedIn) {
                    final role = (accountBloc.state as AccountLoggedIn).account.role;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => role == 'Quản trị'
                            ? const MenuManagerScreen()
                            : const MenuScreen(),
                      ),
                    ).then((_) => _loadSpecialNotifications());
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Thông báo đặc biệt - chỉ hiển thị từ state local
                if (_specialNotifications.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông báo đặc biệt',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _specialNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = _specialNotifications[index];
                            return Container(
                              width: 250,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.teal.shade100,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active,
                                        color: Colors.teal.shade700,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      notification.message,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Các phần khác giữ nguyên
                _buildSectionHeader('Món nổi bật', 'Xem tất cả', () {
                  _navigateToFindProduct();
                }),
                const SizedBox(height: 12),
                _buildFeaturedProducts(),

                _buildSectionHeader('Danh mục', ''),
                const SizedBox(height: 12),
                _buildCategories(),

                _buildSectionHeader('Món phổ biến', 'Xem tất cả', () {
                  _navigateToFindProduct();
                }),
                const SizedBox(height: 12),
                _buildPopularProducts(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Các phương thức helper giữ nguyên
  Widget _buildSectionHeader(String title, String actionText, [VoidCallback? onAction]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                color: Colors.teal,
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
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        } else if (state is ProductLoaded) {
          _products = state.products;
        }
        if (_products.isEmpty) {
          return Text(
            'Không có sản phẩm nào.',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          );
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
                  imageUrl: product.imageUrl ?? '',
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
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToFindProduct(categoryIds: [category.id]);
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(category.name),
                              color: Colors.teal.shade700,
                              size: 30,
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
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        } else if (state is ProductLoaded) {
          _products = state.products..shuffle();
        }
        if (_products.isEmpty) {
          return Text(
            'Không có sản phẩm nào.',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          );
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
              price: '${product.price} VNĐ',
              imageUrl: product.imageUrl ?? '',
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
}