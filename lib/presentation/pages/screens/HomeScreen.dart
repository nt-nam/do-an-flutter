import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/pages/screens/product/DetailProductScreen.dart';
import '../../../domain/entities/product.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../widgets/ProductCardFeatured.dart';
import '../../widgets/ProductCard.dart';
import 'MenuScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final String linkImage = "placeholder.jpg";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    // Gửi FetchProductsEvent khi khởi tạo màn hình
    context.read<ProductBloc>().add(const FetchProductsEvent());
  }

  String _generateHeroTag(Product product) {
    return 'product_${product.id}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  print('AppBar state: $state');
                  String userName = 'Quý khách';
                  if (state is AccountLoggedIn && state.user != null) {
                    userName = state.user!.hoTen;
                    print('User name: $userName');
                  }
                  print('AppBar state: $userName');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Kính chào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.teal.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: Colors.teal,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          String userName = 'Quý khách';
          if (state is AccountLoggedIn && state.user != null) {
            userName = state.user!.hoTen;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Featured Section
                const Text(
                  'Yêu thích',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      _products = state.products;
                    }
                    if (_products.isEmpty) {
                      return const Text('Không có sản phẩm nào.');
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _products.take(5).map((product) {
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
                                          DetailProductScreen(heroTag: '',)),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Category Section
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
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              // child: CategoryButton(
                              //   label: category.name,
                              //   onTap: () {},
                              // ),
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
                // Popular Recipes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sản phẩm phổ biến',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<ProductBloc, ProductState>(
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
                ),
                const SizedBox(height: 10),
                const Text(
                  'Những gì bạn có thể cần',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
