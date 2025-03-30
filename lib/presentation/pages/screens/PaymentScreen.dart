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

  const PaymentScreen({
    super.key,
    required this.items,
    required this.accountId,
    required this.deliveryAddress,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<CartDetail> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items.map((item) => CartDetail(
      productId: item.productId,
      quantity: item.quantity,
      price: item.price,
      productName: item.productName,
      image: item.image,
      cartId: item.cartId,
    )).toList();
  }

  void _incrementQuantity(int index) {
    setState(() {
      _items[index] = CartDetail(
        productId: _items[index].productId,
        quantity: _items[index].quantity + 1,
        price: _items[index].price,
        productName: _items[index].productName,
        image: _items[index].image,
        cartId: _items[index].cartId,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index] = CartDetail(
          productId: _items[index].productId,
          quantity: _items[index].quantity - 1,
          price: _items[index].price,
          productName: _items[index].productName,
          image: _items[index].image,
          cartId: _items[index].cartId,
        );
      }
    });
  }

  double _calculateTotalAmount() {
    return _items.fold(0.0, (sum, item) => sum + (item.price ?? 0) * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            // Xóa giỏ hàng sau khi thanh toán
            context.read<CartBloc>().add(const ClearCartEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đơn hàng đã được tạo thành công!'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context); // Quay lại trang trước
            Navigator.pop(context); // Quay lại trang trước nữa (DetailProductScreen)
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin thanh toán',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sản phẩm:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        leading: item.image != null && item.image!.isNotEmpty
                            ? Image.asset(
                          'assets/images/${item.image}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image, size: 50),
                        title: Text(item.productName ?? 'Sản phẩm không tên'),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Text('Số lượng: ${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${((item.price ?? 0) * item.quantity).toStringAsFixed(0)} VNĐ',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng tiền:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_calculateTotalAmount().toStringAsFixed(0)} VNĐ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Địa chỉ giao hàng: ${widget.deliveryAddress}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(
                      CreateOrderEvent(
                        widget.accountId,
                        _items,
                        widget.deliveryAddress,
                        cartId: _items.isNotEmpty ? _items.first.cartId : null,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Center(
                    child: Text(
                      'Thanh toán',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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