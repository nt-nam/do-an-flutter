import 'package:flutter/material.dart';
import '../../../../domain/entities/offer.dart';

class OfferDetailScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          offer.name,
          style: const TextStyle(
            fontSize: 22, // Tăng kích thước chữ cho tiêu đề
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
        // Đảm bảo Container bao phủ toàn bộ màn hình
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent], // Thay đổi gradient để trẻ trung hơn
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin cơ bản
              Card(
                elevation: 6, // Tăng elevation cho hiệu ứng bóng nổi bật
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Bo góc mềm mại hơn
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Tăng padding cho thoáng
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin ưu đãi',
                        style: TextStyle(
                          fontSize: 20, // Tăng kích thước tiêu đề
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16), // Tăng khoảng cách
                      _buildInfoRow(
                        icon: Icons.local_offer,
                        label: 'Tên ưu đãi',
                        value: offer.name,
                      ),
                      _buildInfoRow(
                        icon: Icons.discount,
                        label: 'Giá trị',
                        value: offer.discountType == DiscountType.amount
                            ? 'Giảm ${offer.discountAmount.abs()} VND'
                            : 'Giảm ${offer.discountAmount}%',
                      ),
                      _buildInfoRow(
                        icon: Icons.info,
                        label: 'Trạng thái',
                        value: offer.status.name.toUpperCase(),
                        valueStyle: TextStyle(
                          fontSize: 16,
                          color: offer.status == OfferStatus.active
                              ? Colors.green
                              : offer.status == OfferStatus.inactive
                              ? Colors.grey
                              : Colors.red,
                        ),
                      ),
                      if (offer.startDate != null)
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Ngày bắt đầu',
                          value: offer.startDate!.toString().substring(0, 10),
                        ),
                      if (offer.endDate != null)
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Ngày kết thúc',
                          value: offer.endDate!.toString().substring(0, 10),
                        ),
                      if (offer.note != null && offer.note!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.note,
                          label: 'Ghi chú',
                          value: offer.note!,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Điều kiện áp dụng
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Điều kiện áp dụng',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (offer.minBill != null && offer.minBill! > 0)
                        _buildInfoRow(
                          icon: Icons.attach_money,
                          label: 'Hóa đơn tối thiểu',
                          value: '${offer.minBill} VND',
                        ),
                      if (offer.productCode != null && offer.productCode!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.qr_code,
                          label: 'Áp dụng cho sản phẩm',
                          value: offer.productCode!,
                        ),
                      if (offer.productType != null && offer.productType!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.category,
                          label: 'Loại sản phẩm',
                          value: offer.productType!,
                        ),
                      if (offer.maxDiscount != null && offer.maxDiscount! > 0)
                        _buildInfoRow(
                          icon: Icons.money_off,
                          label: 'Giảm tối đa',
                          value: '${offer.maxDiscount} VND',
                        ),
                      if (offer.maxUses != null && offer.maxUses! > 0)
                        _buildInfoRow(
                          icon: Icons.repeat,
                          label: 'Số lần sử dụng tối đa',
                          value: offer.maxUses.toString(),
                        ),
                      if (offer.customerLimit != null && offer.customerLimit! > 0)
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Giới hạn mỗi khách',
                          value: '${offer.customerLimit} lần',
                        ),
                      if (offer.minBill == null &&
                          offer.productCode == null &&
                          offer.productType == null &&
                          offer.maxDiscount == null &&
                          offer.maxUses == null &&
                          offer.customerLimit == null)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Không có điều kiện áp dụng cụ thể',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper để hiển thị thông tin với icon
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ??
                      const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}