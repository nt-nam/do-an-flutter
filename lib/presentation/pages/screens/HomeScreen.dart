import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_event.dart';
import '../../blocs/account/account_state.dart';
import '../../widgets/CategoryButton.dart';
import '../../widgets/CustomShapeWidget.dart';
import '../../widgets/FeaturedCard.dart';
import '../../widgets/RecipeCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample data for featured items
  final List<Map<String, String>> featuredItems = const [
    {
      'title': 'Asian white noodle\nwith extra seafood',
      'author': 'James Spader',
      'time': '20 Min',
      'imageUrl':
          'https://images.pexels.com/photos/31042266/pexels-photo-31042266/free-photo-of-canh-d-ng-vang-r-ng-l-n-d-i-b-u-tr-i-em-d-u.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      // Replace with actual image URL
    },
    {
      'title': 'Spicy Thai Curry\nwith Shrimp',
      'author': 'Anna Smith',
      'time': '25 Min',
      'imageUrl':
          'https://images.pexels.com/photos/31042266/pexels-photo-31042266/free-photo-of-canh-d-ng-vang-r-ng-l-n-d-i-b-u-tr-i-em-d-u.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      // Replace with actual image URL
    },
    {
      'title': 'Grilled Salmon\nwith Lemon',
      'author': 'John Doe',
      'time': '15 Min',
      'imageUrl':
          'https://images.pexels.com/photos/31042266/pexels-photo-31042266/free-photo-of-canh-d-ng-vang-r-ng-l-n-d-i-b-u-tr-i-em-d-u.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      // Replace with actual image URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [
          Icon(Icons.shopping_cart, color: Colors.black),
          SizedBox(width: 16),
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
                            'Good Morning',
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
                  'Featured',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredItems.length,
                    itemBuilder: (context, index) {
                      final item = featuredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: FeaturedCard(
                          title: item['title']!,
                          author: item['author']!,
                          time: item['time']!,
                          imageUrl: item['imageUrl']!,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Category Section
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CategoryButton(label: 'Bình'),
                    CategoryButton(label: 'Bếp'),
                    CategoryButton(label: 'Phụ kiện'),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    RecipeCard(
                      title: 'Healthy Taco Salad',
                      calories: '120 Kcal',
                      imageUrl: 'https://via.placeholder.com/150',
                    ),
                    RecipeCard(
                      title: 'Japanese-style Pancakes',
                      calories: '84 Kcal',
                      imageUrl: 'https://via.placeholder.com/150',
                    ),
                    RecipeCard(
                      title: 'Japanese-style Pancakes',
                      calories: '84 Kcal',
                      imageUrl: 'https://via.placeholder.com/150',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AccountBloc>().add(const LogoutEvent());
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.logout),
      ),
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
                  context.read<AccountBloc>().add(const LogoutEvent());
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home', // Ẩn nhãn
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Sreach',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(10), // Khoảng cách bên trong
                    decoration: BoxDecoration(
                      color: Colors.black,    // Màu nền tròn
                      shape: BoxShape.circle, // Hình tròn
                    ),
                    child: Icon(
                      Icons.star,          // Dùng Icons.star để giống vương miện (có thể thay đổi)
                      color: Colors.white, // Màu biểu tượng
                      size: 30,            // Kích thước lớn hơn
                    ),
                  ),
                  label: 'Star',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Person',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
