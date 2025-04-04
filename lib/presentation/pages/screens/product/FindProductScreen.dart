import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_state.dart';
import '../../../blocs/product/product_state.dart';
import '../../../widgets/CategoryButton.dart';
import '../../../widgets/RecipeCard.dart';
import '../MenuScreen.dart';

class FindProductScreen extends StatelessWidget {
  FindProductScreen({super.key});

  static final String linkImage =
      "gasdandung/Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sửa lại appBar
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
                  String userName = 'Quý khách'; // Mặc định
                  if (state is AccountLoggedIn && state.user != null) {
                    userName = state.user!.hoTen; // Lấy tên từ UserModel
                  }
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
                            MaterialPageRoute(builder: (context) => MenuScreen()),
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
        toolbarHeight: 80, // Tăng chiều cao để chứa nội dung
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


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
                    return const SizedBox
                        .shrink(); // Trạng thái ban đầu hoặc không xác định
                  },
                ),
                const SizedBox(height: 20),

                // Popular Recipes Section
                const Text(
                  'Sản phẩm',
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
                        children: products.take(3).map((product) {
                          // Lấy tối đa 3 sản phẩm
                          return RecipeCard(
                            title: product.name,
                            calories: '${product.price} VNĐ',
                            // Ví dụ: hiển thị giá thay vì calories
                            imageUrl: "assets/images/${(product.imageUrl ?? FindProductScreen.linkImage) == "" ? FindProductScreen.linkImage : (product.imageUrl ?? FindProductScreen.linkImage)}",
                          );
                        }).toList(),
                      );
                    } else if (state is ProductError) {
                      return Text('Lỗi: ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 10),

              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.teal,
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  // context.read<AccountBloc>().add(const LogoutEvent());
                }
                if (index == 1) {
                  MaterialPageRoute(builder: (context) => MenuScreen());
                }
                if (index == 2) {
                  // context.read<AccountBloc>().add(const LogoutEvent());
                }
                if (index == 3) {
                  // context.read<AccountBloc>().add(const LogoutEvent());
                }
                if (index == 4) {
                  // context.read<AccountBloc>().add(const LogoutEvent());
                }
              },
              items: [
                BottomNavigationBarItem(
                  label: 'Trang chủ',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Tìm kiếm',
                  icon: Icon(Icons.search),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10), // Khoảng cách bên trong
                    decoration: BoxDecoration(
                      color: Colors.black, // Màu nền tròn
                      shape: BoxShape.circle, // Hình tròn
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      // Dùng Icons.star để giống vương miện (có thể thay đổi)
                      color: Colors.white, // Màu biểu tượng
                      size: 30, // Kích thước lớn hơn
                    ),
                  ),
                  label: 'Giỏ hàng',
                ),
                BottomNavigationBarItem(
                  label: 'Thông báo',
                  icon: Icon(Icons.notifications_none),
                ),
                BottomNavigationBarItem(
                  label: 'Hóa đơn',
                  icon: Icon(Icons.receipt_long),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
