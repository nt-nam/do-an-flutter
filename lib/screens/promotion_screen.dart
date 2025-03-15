// lib/screens/promotion_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/promotion_bloc.dart';

class PromotionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<PromotionBloc>().add(LoadPromotionsEvent());

    return Scaffold(
      appBar: AppBar(title: Text('Ưu đãi')),
      body: BlocBuilder<PromotionBloc, PromotionState>(
        builder: (context, state) {
          if (state is PromotionLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PromotionLoaded) {
            if (state.promotions.isEmpty) {
              return Center(child: Text('Chưa có ưu đãi nào'));
            }
            return ListView.builder(
              itemCount: state.promotions.length,
              itemBuilder: (context, index) {
                final promo = state.promotions[index];
                return ListTile(
                  title: Text(promo.name),
                  subtitle: Text(
                    'Mã: ${promo.code} - Giảm: ${promo.isPercentage ? '${promo.discount}%' : '${promo.discount} VNĐ'}'
                        '${promo.expiryDate != null ? ' - Hết hạn: ${promo.expiryDate!.toString().substring(0, 10)}' : ''}',
                  ),
                  onTap: () {
                    // Có thể thêm logic để áp dụng ngay từ đây
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã chọn mã: ${promo.code}')),
                    );
                  },
                );
              },
            );
          }
          if (state is PromotionError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Chưa có dữ liệu ưu đãi'));
        },
      ),
    );
  }
}