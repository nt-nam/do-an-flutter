import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/account/account_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import 'PaymentScreen.dart';
import '../../blocs/product/product_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Thêm biến để lưu trữ trạng thái "mua vỏ" và số lượng vỏ cho từng sản phẩm
  Map<int, bool> _buyShellMap = {};  // productId -> có mua vỏ hay không
  Map<int, int> _shellQuantityMap = {};  // productId -> số lượng vỏ
  int _currentUserLevel = 1; // Theo dõi cấp độ người dùng hiện tại

  // Giả định giá vỏ gas 300,000 VNĐ - trong thực tế có thể lấy từ API hoặc cấu hình
  final double _shellPrice = 300000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCartData();
      _refreshUserData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kiểm tra cấp độ người dùng hiện tại
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn && accountState.user != null) {
      final userLevel = accountState.user!.capDo ?? 1;
      if (_currentUserLevel != userLevel) {
        _currentUserLevel = userLevel;
        // Nếu cấp độ đã thay đổi, làm mới giỏ hàng
        _loadCartData();
      }
    }

    // Lắng nghe sự thay đổi từ UserBloc
    final userState = context.watch<UserBloc>().state;
    if (userState is UserLoaded) {
      final userLevel = userState.user.level ?? 1;
      if (_currentUserLevel != userLevel) {
        _currentUserLevel = userLevel;
        // Nếu cấp độ đã thay đổi, làm mới giỏ hàng
        _loadCartData();
      }
    }
  }

  void _loadCartData() {
    developer.log('🛒 Đang làm mới dữ liệu giỏ hàng');
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn) {
      context.read<CartBloc>().add(
        FetchCartEvent(accountState.account.id),
      );
    }
  }

  // Làm mới thông tin người dùng
  void _refreshUserData() {
    developer.log('🛒 Đang làm mới thông tin người dùng');
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn) {
      // Tải lại thông tin người dùng
      context.read<UserBloc>().add(LoadUserByAccountId(accountState.account.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        elevation: 0,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _refreshUserData(); // Làm mới thông tin người dùng
              _loadCartData(); // Làm mới giỏ hàng
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartError) {
                _showSnackBar(context, state.message, isError: true);
              } else if (state is CartItemRemoved) {
                _showSnackBar(context, 'Đã xóa sản phẩm khỏi giỏ hàng');
                _loadCartData(); // Chỉ reload khi xóa sản phẩm
              } else if (state is CartItemUpdated) {
                // _showSnackBar(context, 'Đã cập nhật số lượng');
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                final userLevel = state.user.level ?? 1;
                if (_currentUserLevel != userLevel) {
                  _currentUserLevel = userLevel;
                  setState(() {}); // Cập nhật UI
                  developer.log('🛒 Cấp độ người dùng đã thay đổi: $_currentUserLevel');
                }
              }
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              );
            } else if (state is CartLoaded) {
              if (state.cartItems.isEmpty) {
                return _buildEmptyCart();
              }
              return _buildLoadedCart(context, state);
            }
            return _buildLoginPrompt();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedCart(BuildContext context, CartLoaded state) {
    // Lấy thông tin cấp độ khách hàng từ AccountBloc và UserBloc
    int userLevel = _currentUserLevel; // Sử dụng cấp độ đã được theo dõi
    
    // Double check với dữ liệu mới nhất
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn && accountState.user != null) {
      final newLevel = accountState.user!.capDo ?? 1;
      if (userLevel != newLevel) {
        userLevel = newLevel;
        _currentUserLevel = newLevel;
        developer.log('🛒 Cập nhật cấp độ từ AccountBloc: $userLevel');
      }
    }
    
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final newLevel = userState.user.level ?? 1;
      if (userLevel != newLevel) {
        userLevel = newLevel;
        _currentUserLevel = newLevel;
        developer.log('🛒 Cập nhật cấp độ từ UserBloc: $userLevel');
      }
    }

    double totalAmount = 0;
    int totalItems = 0;

    for (var item in state.cartItems) {
      double itemPrice = item.productPrice ?? 0;
      totalAmount += itemPrice * item.quantity;
      totalItems += item.quantity;
    }

    // Tính toán chiết khấu dựa trên cấp độ khách hàng
    double discountAmount = 0;
    String discountDescription = '';

    if (userLevel == 1 && totalItems >= 10) {
      discountAmount = totalAmount * 0.1;
      discountDescription = 'Khách hàng cấp 1: Mua 10 tính tiền 9 (Giảm 10%)';
    } else if (userLevel == 2) {
      if (totalItems >= 10) {
        discountAmount = totalAmount * 0.2;
        discountDescription = 'Khách hàng cấp 2: Mua 10 tính tiền 8';
      } else if (totalItems >= 7) {
        discountAmount = totalAmount * 0.143;
        discountDescription = 'Khách hàng cấp 2: Mua 7 tính tiền 6';
      }
    } else if (userLevel == 3) {
      discountAmount = totalAmount * 0.3;
      discountDescription = 'Khách hàng cấp 3: Giảm 30% tổng đơn hàng';
    }
    
    developer.log('🛒 Hiển thị giỏ hàng với cấp độ: $userLevel, chiết khấu: $discountAmount');

    return Column(
      children: [
        // Thêm thông báo về cấp độ người dùng
        if (accountState is AccountLoggedIn)
          _buildUserLevelInfo(context, userLevel),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final item = state.cartItems[index];
              return _buildCartItem(context, item);
            },
          ),
        ),
        _buildCheckoutSection(context, state, totalAmount, discountAmount, discountDescription),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item) {
    // Kiểm tra nếu sản phẩm chưa có trong map thì khởi tạo giá trị mặc định
    if (!_buyShellMap.containsKey(item.productId)) {
      _buyShellMap[item.productId] = false;
    }
    if (!_shellQuantityMap.containsKey(item.productId)) {
      _shellQuantityMap[item.productId] = 1;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.productImage != null && item.productImage!.isNotEmpty
                  ? Image.asset(
                'assets/images/${item.productImage}',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? 'Sản phẩm không tên',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatCurrency(item.productPrice ?? 0)} VNĐ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityControl(
                        context: context,
                        icon: Icons.remove,
                        onPressed: () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                              UpdateCartQuantityEvent(
                                item.cartId!,
                                item.productId,
                                item.quantity - 1,
                              ),
                            );

                            // Cập nhật số lượng vỏ tối đa nếu mua vỏ
                            if (_buyShellMap[item.productId] == true) {
                              setState(() {
                                if (_shellQuantityMap[item.productId]! > item.quantity - 1) {
                                  _shellQuantityMap[item.productId] = item.quantity - 1;
                                }
                              });
                            }
                          } else {
                            _showDeleteConfirmation(context, item);
                          }
                        },
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQuantityControl(
                        context: context,
                        icon: Icons.add,
                        onPressed: () {
                          context.read<CartBloc>().add(
                            UpdateCartQuantityEvent(
                              item.cartId!,
                              item.productId,
                              item.quantity + 1,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(context, item),
                      ),
                    ],
                  ),

                  // Thêm phần tùy chọn mua vỏ cho sản phẩm loại gas (maLoai = 1)
                  FutureBuilder<bool>(
                    future: _isGasProduct(item.productId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _buyShellMap[item.productId] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _buyShellMap[item.productId] = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'Mua vỏ (${_formatCurrency(_shellPrice)} VNĐ/vỏ)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            // Hiển thị dropdown chọn số lượng vỏ nếu checkbox được chọn
                            if (_buyShellMap[item.productId] == true)
                              Padding(
                                padding: const EdgeInsets.only(left: 32, bottom: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Số lượng vỏ: ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: DropdownButton<int>(
                                        value: _shellQuantityMap[item.productId],
                                        underline: const SizedBox(),
                                        items: List.generate(
                                          item.quantity,
                                              (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text('${index + 1}'),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _shellQuantityMap[item.productId] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }
                      return const SizedBox.shrink(); // Không hiển thị gì nếu không phải sản phẩm gas
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        constraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 30,
        ),
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCheckoutSection(
      BuildContext context,
      CartLoaded state,
      double totalAmount,
      double discountAmount,
      String discountDescription
      ) {
    // Tính tổng tiền vỏ (nếu có)
    double shellTotalAmount = 0;
    for (var item in state.cartItems) {
      if (_buyShellMap[item.productId] == true) {
        shellTotalAmount += _shellPrice * (_shellQuantityMap[item.productId] ?? 0);
      }
    }

    double subtotalAmount = totalAmount - discountAmount;
    double finalTotalAmount = subtotalAmount + shellTotalAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tạm tính:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_formatCurrency(totalAmount)} VNĐ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Hiển thị phần giảm giá nếu có
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Giảm giá ($discountDescription):',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '-${_formatCurrency(discountAmount)} VNĐ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sau giảm giá:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${_formatCurrency(subtotalAmount)} VNĐ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          // Hiển thị phần tiền vỏ nếu có chọn mua vỏ
          if (shellTotalAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiền vỏ:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${_formatCurrency(shellTotalAmount)} VNĐ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng thanh toán:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_formatCurrency(finalTotalAmount)} VNĐ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final accountState = context.read<AccountBloc>().state;
              if (accountState is AccountLoggedIn) {
                final accountId = accountState.account.id;
                final userLevel = accountState.user?.capDo ?? 1;
                String deliveryAddress = '123 Main St';
                if (accountState.user != null) {
                  deliveryAddress = accountState.user!.diaChi ?? '123 Main St';
                }
                if (deliveryAddress.isEmpty) {
                  _showSnackBar(
                    context,
                    'Vui lòng cập nhật địa chỉ của bạn!',
                    isError: true,
                  );
                  return;
                }

                // Truyền thêm thông tin về mua vỏ và giảm giá qua màn hình thanh toán
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      items: state.cartItems,
                      accountId: accountId,
                      deliveryAddress: deliveryAddress,
                      buyShellMap: _buyShellMap,
                      shellQuantityMap: _shellQuantityMap,
                      shellPrice: _shellPrice,
                      discountAmount: discountAmount,
                      userLevel: userLevel,
                    ),
                  ),
                );
              } else {
                _showSnackBar(
                  context,
                  'Vui lòng đăng nhập để thanh toán!',
                  isError: true,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Thanh toán ngay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 70,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Vui lòng đăng nhập để xem giỏ hàng',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadCartData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CartBloc>().add(
                RemoveFromCartEvent(
                  item.cartDetailId,
                ),
              );
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  // Phương thức kiểm tra sản phẩm có thuộc loại gas (maLoai = 1) hay không
  Future<bool> _isGasProduct(int productId) async {
    try {
      // Sử dụng GetProductByIdUsecase để lấy thông tin sản phẩm (bao gồm categoryId)
      final productRepository = context.read<ProductBloc>().getProductByIdUsecase.repository;
      final productModel = await productRepository.getProductById(productId);

      // Kiểm tra nếu sản phẩm thuộc loại gas (maLoai = 1)
      return productModel.maLoai == 1 || productModel.maLoai == 2;
    } catch (e) {
      // Nếu có lỗi, ghi log và trả về false
      print('Lỗi khi kiểm tra loại sản phẩm: $e');
      return false;
    }
  }

  // Thêm widget hiển thị thông tin cấp độ người dùng
  Widget _buildUserLevelInfo(BuildContext context, int userLevel) {
    String levelText = '';
    String nextLevelText = '';
    Color levelColor = Colors.teal;
    
    switch (userLevel) {
      case 1:
        levelText = 'Khách hàng cấp 1';
        nextLevelText = 'Hoàn thành đơn hàng để lên cấp 2 và nhận ưu đãi lớn hơn';
        levelColor = Colors.teal;
        break;
      case 2:
        levelText = 'Khách hàng cấp 2';
        nextLevelText = 'Hoàn thành đơn hàng để lên cấp 3 và nhận ưu đãi lớn hơn';
        levelColor = Colors.deepPurple;
        break;
      case 3:
        levelText = 'Khách hàng cấp 3 - Cao cấp';
        nextLevelText = 'Bạn đã đạt cấp độ cao nhất và được hưởng ưu đãi tối đa';
        levelColor = Colors.deepOrange;
        break;
      default:
        levelText = 'Khách hàng cấp 1';
        nextLevelText = 'Hoàn thành đơn hàng để lên cấp và nhận ưu đãi lớn hơn';
        levelColor = Colors.teal;
    }
    
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: levelColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: levelColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: levelColor),
              const SizedBox(width: 8),
              Text(
                levelText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            nextLevelText,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cấp 1: Giảm 10% cho đơn từ 10 sản phẩm\nCấp 2: Giảm 14.3% cho đơn từ 7 sản phẩm, 20% cho đơn từ 10 sản phẩm\nCấp 3: Giảm 30% cho tất cả đơn hàng',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}