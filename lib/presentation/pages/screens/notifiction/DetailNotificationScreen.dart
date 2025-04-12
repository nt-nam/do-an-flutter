import 'package:flutter/material.dart';

import '../../../../domain/entities/notification.dart';

class DetailNotificationScreen extends StatelessWidget {
  final NotificationE notification;

  const DetailNotificationScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thông báo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  notification.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(notification.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getTypeName(notification.type),
                    style: TextStyle(
                      color: _getTypeColor(notification.type),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              notification.message,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (notification.displayUntil != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Thông báo có hiệu lực đến ${_formatDate(notification
                            .displayUntil!)}',
                        style: TextStyle(
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute
        .toString().padLeft(2, '0')}';
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.HE_THONG:
        return Colors.blue;
      case NotificationType.UU_DAI:
        return Colors.green;
      case NotificationType.BAO_MAT:
        return Colors.red;
      case NotificationType.SU_KIEN:
        return Colors.purple;
      case NotificationType.CA_NHAN:
        return Colors.orange;
      case NotificationType.THONG_BAO_KHAC:
        return Colors.grey;
    }
  }

  String _getTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.HE_THONG:
        return 'HỆ THỐNG';
      case NotificationType.UU_DAI:
        return 'ƯU ĐÃI';
      case NotificationType.BAO_MAT:
        return 'BẢO MẬT';
      case NotificationType.SU_KIEN:
        return 'SỰ KIỆN';
      case NotificationType.CA_NHAN:
        return 'CÁ NHÂN';
      case NotificationType.THONG_BAO_KHAC:
        return 'THÔNG BÁO';
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (notification.type == NotificationType.UU_DAI)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý tham gia ưu đãi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Tham gia ngay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (notification.type == NotificationType.SU_KIEN) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Xử lý chia sẻ
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.deepPurple),
                ),
                child: const Text(
                  'Chia sẻ',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý đăng ký
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}