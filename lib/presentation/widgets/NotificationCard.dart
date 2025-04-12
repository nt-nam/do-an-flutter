import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  final NotificationE notification;
  final bool isExpanded;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.isExpanded,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
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

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.HE_THONG:
        return Icons.settings;
      case NotificationType.UU_DAI:
        return Icons.local_offer;
      case NotificationType.BAO_MAT:
        return Icons.security;
      case NotificationType.SU_KIEN:
        return Icons.event;
      case NotificationType.CA_NHAN:
        return Icons.person;
      case NotificationType.THONG_BAO_KHAC:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      size: 20,
                      color: _getTypeColor(notification.type),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (notification.priority >= 4)
                    Icon(
                      Icons.priority_high,
                      color: Colors.red,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
                maxLines: isExpanded ? 10 : 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isExpanded &&
                  (notification.message.length > 100 ||
                      notification.imageUrl != null)) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Xem thêm',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (notification.imageUrl != null && isExpanded) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.imageUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}