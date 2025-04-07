import 'package:flutter/material.dart';
import '../../../domain/entities/offer.dart';
import '../pages/screens/offer/OfferDetailScreen.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Điều hướng đến màn hình chi tiết
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfferDetailScreen(offer: offer),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                offer.discountType == DiscountType.amount
                    ? 'Giảm: ${offer.discountAmount.abs()} VND'
                    : 'Giảm: ${offer.discountAmount}%',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Bắt đầu: ${offer.startDate?.toString().substring(0, 10) ?? 'Không xác định'}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Kết thúc: ${offer.endDate?.toString().substring(0, 10) ?? 'Không xác định'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  offer.status.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: offer.status == OfferStatus.active
                    ? Colors.green
                    : offer.status == OfferStatus.inactive
                    ? Colors.grey
                    : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}