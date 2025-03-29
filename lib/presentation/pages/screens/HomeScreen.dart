import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_event.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/product/product_state.dart';
import '../../widgets/CategoryButton.dart';
import '../../widgets/CustomShapeWidget.dart';
import '../../widgets/FeaturedCard.dart';
import '../../widgets/RecipeCard.dart';
import 'auth/LoginScreen.dart';
import 'category/CategoryScreen.dart'; // Import CategoryScreen với đường dẫn chính xác

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  static final String linkImage = "https://images.pexels.com/photos/31042266/pexels-photo-31042266/free-photo-of-canh-d-ng-vang-r-ng-l-n-d-i-b-u-tr-i-em-d-u.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: Colors.black),
            onPressed: () {
              // TODO: Điều hướng đến màn hình đơn hàng
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _showLogoutConfirmationDialog(context); // Hiển thị hộp thoại xác nhận
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          String userName = 'Quý khách'; // Mặc định là "Quý khách"
          if (state is AccountLoggedIn && state.user != null) {
            userName = state.user!.hoTen; // Lấy tên từ UserModel nếu có
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section với CustomShapeWidget làm nền
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kính chào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      final products = state.products;
                      if (products.isEmpty) {
                        return const Text('Không có Sản phẩm nào.');
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CategoryButton(label: product.name),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is ProductError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink(); // Trạng thái ban đầu hoặc không xác định
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
                              child: CategoryButton(label: category.name),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is CategoryError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink(); // Trạng thái ban đầu hoặc không xác định
                  },
                ),
                const SizedBox(height: 20),

                // Popular Recipes Section
                const Text(
                  'Công thức nấu ăn',
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
                      final products = state.products;
                      if (products.isEmpty) {
                        return const Text('Không có sản phẩm nào.');
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: products.take(3).map((product) { // Lấy tối đa 3 sản phẩm
                          return RecipeCard(
                            title: product.name,
                            calories: '${product.price} VNĐ', // Ví dụ: hiển thị giá thay vì calories
                            imageUrl: linkImage,
                          );
                        }).toList(),
                      );
                    } else if (state is ProductError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     RecipeCard(
                //       title: 'Healthy Taco Salad',
                //       calories: '120 Kcal',
                //       imageUrl: linkImage,
                //     ),
                //     RecipeCard(
                //       title: 'Japanese-style Pancakes',
                //       calories: '84 Kcal',
                //       imageUrl: linkImage,
                //     ),
                //     RecipeCard(
                //       title: 'Japanese-style Pancakes',
                //       calories: '84 Kcal',
                //       imageUrl: linkImage,
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),

                const Text(
                  'Những gì bạn có thể cần',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      final products = state.products;
                      if (products.isEmpty) {
                        return const Text('Không có sản phẩm nào.');
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: products.skip(3).take(3).map((product) { // Lấy 3 sản phẩm tiếp theo
                          return RecipeCard(
                            title: product.name,
                            calories: '${product.price} VNĐ',
                            imageUrl: product.imageUrl ?? linkImage,
                          );
                        }).toList(),
                      );
                    } else if (state is ProductError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<AccountBloc>().add(const LogoutEvent());
      //   },
      //   backgroundColor: Colors.teal,
      //   child: const Icon(Icons.logout),
      // ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          children: [
            // CustomShapeWidget(
            //   width: MediaQuery.of(context).size.width,
            //   height: 100,
            //   backgroundColor: Colors.teal.withOpacity(0.3),
            // ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // Đảm bảo các mục cố định
              backgroundColor: Colors.transparent, // Để trong suốt để thấy CustomShapeWidget
              elevation: 0,                        // Bỏ bóng để hòa hợp với CustomShapeWidget
              selectedItemColor: Colors.teal,      // Màu khi được chọn
              unselectedItemColor: Colors.teal,    // Màu khi không được chọn
              currentIndex: 0,                     // Mặc định chọn mục đầu tiên (có thể thay đổi)
              onTap: (index) {
                if (index == 4) {
                  // Xử lý đăng xuất khi nhấn vào biểu tượng người dùng
                  // context.read<AccountBloc>().add(const LogoutEvent());
                }
              },
              items: [
                BottomNavigationBarItem(
                  label: '__',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Sreach',
                  icon: Icon(Icons.search),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10), // Khoảng cách bên trong
                    decoration: BoxDecoration(
                      color: Colors.black,    // Màu nền tròn
                      shape: BoxShape.circle, // Hình tròn
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,          // Dùng Icons.star để giống vương miện (có thể thay đổi)
                      color: Colors.white, // Màu biểu tượng
                      size: 30,            // Kích thước lớn hơn
                    ),
                  ),
                  label: 'Star',
                ),
                BottomNavigationBarItem(
                  label: 'Notification',
                  icon: Icon(Icons.notifications_none),
                ),
                BottomNavigationBarItem(
                  label: 'Person',
                  icon: Icon(Icons.person_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<AccountBloc>().add(const LogoutEvent());
                //TODO setScreen LoginScreen
                Navigator.of(context).pop();
                MaterialPageRoute(builder: (context) => LoginScreen());
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}
