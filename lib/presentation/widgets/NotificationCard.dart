import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return Colors.teal;
      case NotificationType.UU_DAI:
        return Colors.tealAccent.shade700;
      case NotificationType.BAO_MAT:
        return Colors.redAccent;
      case NotificationType.SU_KIEN:
        return Colors.purpleAccent;
      case NotificationType.CA_NHAN:
        return Colors.orangeAccent;
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
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
                    padding: const EdgeInsets.all(8),
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
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.date),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (notification.priority >= 4)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.priority_high,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                style: GoogleFonts.poppins(
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Xem thêm',
                      style: GoogleFonts.poppins(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
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
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[500],
                        ),
                      ),
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