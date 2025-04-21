import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import 'PaymentScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Thêm biến để lưu trữ trạng thái "mua vỏ" và số lượng vỏ cho từng sản phẩm
  Map<int, bool> _buyShellMap = {};  // productId -> có mua vỏ hay không
  Map<int, int> _shellQuantityMap = {};  // productId -> số lượng vỏ
  
  // Giả định giá vỏ gas 300,000 VNĐ - trong thực tế có thể lấy từ API hoặc cấu hình
  final double _shellPrice = 300000;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCartData();
    });
  }

  void _loadCartData() {
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountLoggedIn) {
      context.read<CartBloc>().add(
        FetchCartEvent(accountState.account.id),
      );
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
            onPressed: _loadCartData,
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
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
    double totalAmount = 0;
    for (var item in state.cartItems) {
      double itemPrice = item.productPrice ?? 0;
      totalAmount += itemPrice * item.quantity;
    }

    return Column(
      children: [
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
        _buildCheckoutSection(context, state, totalAmount),
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

  Widget _buildCheckoutSection(BuildContext context, CartLoaded state, double totalAmount) {
    // Tính tổng tiền vỏ (nếu có)
    double shellTotalAmount = 0;
    for (var item in state.cartItems) {
      if (_buyShellMap[item.productId] == true) {
        shellTotalAmount += _shellPrice * (_shellQuantityMap[item.productId] ?? 0);
      }
    }
    
    double finalTotalAmount = totalAmount + shellTotalAmount;
    
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
                
                // Truyền thêm thông tin về mua vỏ qua màn hình thanh toán
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
    // Trong dự án thực tế, bạn sẽ gọi API hoặc repository để lấy thông tin sản phẩm
    // Tuy nhiên, để demo, chúng ta giả định rằng:
    // - Nếu productId chia hết cho 2, thì đó là sản phẩm gas (maLoai = 1)
    // - Nếu không, thì đó là sản phẩm khác
    
    // Lưu ý: Đây chỉ là demo, trong thực tế bạn cần truy vấn thông tin chi tiết sản phẩm
    return Future.value(productId == 1 || productId == 2);
  }
}