import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../domain/entities/cart_detail.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartDetail> items;
  final int accountId;
  final String deliveryAddress;
  final Map<int, bool>? buyShellMap;
  final Map<int, int>? shellQuantityMap;
  final double? shellPrice;

  const PaymentScreen({
    super.key,
    required this.items,
    required this.accountId,
    required this.deliveryAddress,
    this.buyShellMap,
    this.shellQuantityMap,
    this.shellPrice,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<CartDetail> _items;
  late Map<int, bool> _buyShellMap;
  late Map<int, int> _shellQuantityMap;
  late double _shellPrice;

  // Định nghĩa bảng màu mới
  final Color primaryColor = Colors.teal;
  final Color secondaryColor = Colors.teal.shade700;
  final Color accentColor = Colors.teal.shade300;
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = Colors.black87;
  final Color textSecondaryColor = Colors.black54;

  @override
  void initState() {
    super.initState();
    _items = widget.items.map((item) => CartDetail(
      cartDetailId: item.cartDetailId,
      cartId: item.cartId,
      accountId: widget.accountId,
      productId: item.productId,
      quantity: item.quantity,
      createdDate: item.createdDate.toString(),
      productName: item.productName,
      productPrice: item.productPrice,
      productImage: item.productImage,
    )).toList();
    
    // Khởi tạo các map
    _buyShellMap = widget.buyShellMap ?? {};
    _shellQuantityMap = widget.shellQuantityMap ?? {};
    _shellPrice = widget.shellPrice ?? 300000; // Giá mặc định nếu không được truyền vào
  }

  void _incrementQuantity(int index) {
    setState(() {
      _items[index] = CartDetail(
        cartDetailId: _items[index].cartDetailId,
        cartId: _items[index].cartId,
        accountId: widget.accountId,
        productId: _items[index].productId,
        quantity: _items[index].quantity + 1,
        createdDate: _items[index].createdDate,
        productName: _items[index].productName,
        productPrice: _items[index].productPrice,
        productImage: _items[index].productImage,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index] = CartDetail(
          cartDetailId: _items[index].cartDetailId,
          cartId: _items[index].cartId,
          accountId: widget.accountId,
          productId: _items[index].productId,
          quantity: _items[index].quantity - 1,
          createdDate: _items[index].createdDate,
          productName: _items[index].productName,
          productPrice: _items[index].productPrice,
          productImage: _items[index].productImage,
        );
      }
    });
  }

  double _calculateTotalAmount() {
    return _items.fold(0.0, (sum, item) => sum + (item.productPrice ?? 0) * item.quantity);
  }

  double _calculateShellAmount() {
    double total = 0;
    for (var item in _items) {
      if (_buyShellMap[item.productId] == true) {
        total += _shellPrice * (_shellQuantityMap[item.productId] ?? 0);
      }
    }
    return total;
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deliveryFee = 15000; // Phí giao hàng cố định
    final double productAmount = _calculateTotalAmount();
    final double shellAmount = _calculateShellAmount();
    final double totalWithDelivery = productAmount + shellAmount + deliveryFee;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thanh toán',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            context.read<CartBloc>().add(const ClearCartEvent());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 30),
                      const SizedBox(width: 10),
                      const Text('Thành công'),
                    ],
                  ),
                  content: const Text('Đơn hàng đã được tạo thành công!'),
                  actions: [
                    TextButton(
                      child: Text(
                        'Đóng',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Đóng dialog
                        Navigator.pop(context); // Quay lại trang trước
                        context.read<CartBloc>().add(FetchCartEvent(widget.accountId));
                      },
                    ),
                  ],
                );
              },
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần địa chỉ giao hàng
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Địa chỉ giao hàng',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.deliveryAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: textSecondaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Chức năng thay đổi địa chỉ thêm vào sau
                            },
                            child: Text(
                              'Thay đổi',
                              style: TextStyle(color: textPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Phần đơn hàng
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_bag, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Đơn hàng của bạn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: item.productImage != null && item.productImage!.isNotEmpty
                                    ? Image.asset(
                                  'assets/images/${item.productImage}',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName ?? 'Sản phẩm không tên',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: textPrimaryColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_formatCurrency(item.productPrice ?? 0)} VNĐ',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: accentColor.withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => _decrementQuantity(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.remove,
                                          size: 16,
                                          color: textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _incrementQuantity(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.add,
                                          size: 16,
                                          color: textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      // Hiển thị thông tin vỏ cho các sản phẩm
                      ..._items.asMap().entries.where((entry) => 
                        _buyShellMap[entry.value.productId] == true
                      ).map((entry) {
                        final item = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8, left: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline, color: Colors.teal, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Vỏ gas (${_shellQuantityMap[item.productId]} cái)',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '${_formatCurrency(_shellPrice * (_shellQuantityMap[item.productId] ?? 0))} VNĐ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Phần phương thức thanh toán
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Phương thức thanh toán',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor),
                          color: primaryColor.withOpacity(0.05),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.money, color: textPrimaryColor),
                            const SizedBox(width: 12),
                            const Text(
                              'Thanh toán khi nhận hàng',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Icon(Icons.check_circle, color: primaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Phần chi tiết thanh toán
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Chi tiết thanh toán',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tạm tính', style: TextStyle(color: textSecondaryColor)),
                          Text(
                            '${_formatCurrency(productAmount)} VNĐ',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      
                      // Hiển thị tiền vỏ nếu có
                      if (shellAmount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tiền vỏ gas', style: TextStyle(color: textSecondaryColor)),
                            Text(
                              '${_formatCurrency(shellAmount)} VNĐ',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phí vận chuyển', style: TextStyle(color: textSecondaryColor)),
                          Text(
                            '${_formatCurrency(deliveryFee)} VNĐ',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.grey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng cộng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            '${_formatCurrency(totalWithDelivery)} VNĐ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Nút đặt hàng
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Tạo đối tượng chứa thông tin vỏ
                      final shellData = {
                        'buyShell': _buyShellMap,
                        'shellQuantity': _shellQuantityMap,
                        'shellPrice': _shellPrice,
                        'totalShellAmount': shellAmount
                      };
                      
                      context.read<OrderBloc>().add(
                        CreateOrderEvent(
                          widget.accountId,
                          _items,
                          widget.deliveryAddress,
                          cartId: _items.isNotEmpty ? _items.first.cartId : null,
                          deliveryFee: deliveryFee,
                          additionalData: shellData, // Thêm thông tin vỏ gas
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đặt hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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