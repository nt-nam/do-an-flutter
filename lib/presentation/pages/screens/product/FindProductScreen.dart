import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_state.dart';
import '../../../blocs/product/product_state.dart';
import '../../../widgets/CategoryButton.dart';
import '../../../widgets/CustomBottomNavigation.dart';
import '../../../widgets/RecipeCard.dart';
import '../MenuScreen.dart';
import '../OrderScreen.dart';

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
        title: Text(
          'Tìm kiếm',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
              color: Colors.grey[600],
          ),
        ),
        toolbarHeight: 40, // Tăng chiều cao để chứa nội dung
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
    );
  }
}
