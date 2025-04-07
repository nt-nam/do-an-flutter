import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/offer.dart';
import '../../../blocs/offer/offer_bloc.dart';
import '../../../blocs/offer/offer_event.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _discountController = TextEditingController();
  final _minBillController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _noteController = TextEditingController();
  final _maxUsesController = TextEditingController();
  final _customerLimitController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  DiscountType _discountType = DiscountType.amount; // Mặc định là giảm tiền
  String? _productType; // Loại sản phẩm

  @override
  void dispose() {
    _nameController.dispose();
    _discountController.dispose();
    _minBillController.dispose();
    _productCodeController.dispose();
    _noteController.dispose();
    _maxUsesController.dispose();
    _customerLimitController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double discountValue = double.parse(_discountController.text);
      if (_discountType == DiscountType.percentage && discountValue > 0) {
        discountValue = discountValue.clamp(1, 100); // Giới hạn 1-100 cho %
      } else if (_discountType == DiscountType.amount && discountValue > 0) {
        discountValue = -discountValue; // Chuyển thành âm cho giảm tiền
      }

      context.read<OfferBloc>().add(
        AddOfferEvent(
          _nameController.text,
          discountValue,
          _startDate,
          _endDate,
          minBill: _minBillController.text.isNotEmpty
              ? double.parse(_minBillController.text)
              : null,
          productCode: _productCodeController.text.isNotEmpty
              ? _productCodeController.text
              : null,
          productType: _productType,
          note: _noteController.text.isNotEmpty ? _noteController.text : null,
          maxUses: _maxUsesController.text.isNotEmpty
              ? int.parse(_maxUsesController.text)
              : null,
          customerLimit: _customerLimitController.text.isNotEmpty
              ? int.parse(_customerLimitController.text)
              : null,
          maxDiscount: _maxDiscountController.text.isNotEmpty
              ? double.parse(_maxDiscountController.text)
              : null,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm ưu đãi mới',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin cơ bản
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin cơ bản',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Tên ưu đãi',
                            prefixIcon: const Icon(Icons.local_offer, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập tên ưu đãi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: _discountType == DiscountType.amount
                                ? 'Số tiền giảm (VND)'
                                : 'Phần trăm giảm (%)',
                            prefixIcon: const Icon(Icons.discount, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return 'Vui lòng nhập giá trị';
                            final num = double.tryParse(value);
                            if (num == null || num <= 0) {
                              return 'Giá trị phải là số dương';
                            }
                            if (_discountType == DiscountType.percentage &&
                                (num < 1 || num > 100)) {
                              return 'Phần trăm phải từ 1-100';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<DiscountType>(
                              value: DiscountType.amount,
                              groupValue: _discountType,
                              onChanged: (value) => setState(() => _discountType = value!),
                              activeColor: Colors.teal,
                            ),
                            const Text('Giảm tiền', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 20),
                            Radio<DiscountType>(
                              value: DiscountType.percentage,
                              groupValue: _discountType,
                              onChanged: (value) => setState(() => _discountType = value!),
                              activeColor: Colors.teal,
                            ),
                            const Text('Giảm %', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          tileColor: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            'Ngày bắt đầu: ${_startDate?.toString().substring(0, 10) ?? 'Chưa chọn'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.calendar_today, color: Colors.teal),
                          onTap: () => _selectDate(context, true),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          tileColor: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            'Ngày kết thúc: ${_endDate?.toString().substring(0, 10) ?? 'Chưa chọn'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.calendar_today, color: Colors.teal),
                          onTap: () => _selectDate(context, false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Điều kiện áp dụng
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điều kiện áp dụng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _minBillController,
                          decoration: InputDecoration(
                            labelText: 'Hóa đơn tối thiểu (VND)',
                            prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              final num = double.tryParse(value);
                              if (num == null || num < 0) {
                                return 'Hóa đơn tối thiểu phải là số không âm';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _productCodeController,
                          decoration: InputDecoration(
                            labelText: 'Mã sản phẩm (nếu có)',
                            prefixIcon: const Icon(Icons.qr_code, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _productType,
                          decoration: InputDecoration(
                            labelText: 'Loại sản phẩm (nếu có)',
                            prefixIcon: const Icon(Icons.category, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Gas', child: Text('Gas')),
                            DropdownMenuItem(value: 'Bếp', child: Text('Bếp')),
                            DropdownMenuItem(value: 'Phụ kiện', child: Text('Phụ kiện')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _productType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _maxUsesController,
                          decoration: InputDecoration(
                            labelText: 'Số lần sử dụng tối đa (nếu có)',
                            prefixIcon: const Icon(Icons.repeat, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              final num = int.tryParse(value);
                              if (num == null || num <= 0) {
                                return 'Số lần sử dụng phải là số dương';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _customerLimitController,
                          decoration: InputDecoration(
                            labelText: 'Giới hạn mỗi khách (nếu có)',
                            prefixIcon: const Icon(Icons.person, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              final num = int.tryParse(value);
                              if (num == null || num <= 0) {
                                return 'Giới hạn phải là số dương';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _maxDiscountController,
                          decoration: InputDecoration(
                            labelText: 'Giá trị giảm tối đa (VND, nếu có)',
                            prefixIcon: const Icon(Icons.money_off, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              final num = double.tryParse(value);
                              if (num == null || num <= 0) {
                                return 'Giá trị giảm tối đa phải là số dương';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Ghi chú
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ghi chú',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            labelText: 'Ghi chú (nếu có)',
                            prefixIcon: const Icon(Icons.note, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nút submit
                Center(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Thêm ưu đãi',
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
          ),
        ),
      ),
    );
  }
}