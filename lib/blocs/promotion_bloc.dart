// lib/blocs/promotion_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/promotion_model.dart';

abstract class PromotionEvent {}
class LoadPromotionsEvent extends PromotionEvent {}
class ApplyPromotionEvent extends PromotionEvent {
  final String code;
  ApplyPromotionEvent(this.code);
}

abstract class PromotionState {}
class PromotionInitial extends PromotionState {}
class PromotionLoading extends PromotionState {}
class PromotionLoaded extends PromotionState {
  final List<PromotionModel> promotions;
  PromotionLoaded(this.promotions);
}
class PromotionApplied extends PromotionState {
  final PromotionModel promotion;
  PromotionApplied(this.promotion);
}
class PromotionError extends PromotionState {
  final String message;
  PromotionError(this.message);
}

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  List<PromotionModel> _promotions = []; // Mock danh sách ưu đãi

  PromotionBloc() : super(PromotionInitial()) {
    on<LoadPromotionsEvent>(_onLoadPromotions);
    on<ApplyPromotionEvent>(_onApplyPromotion);
  }

  Future<void> _onLoadPromotions(LoadPromotionsEvent event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      // Mock: Tạo dữ liệu giả lập
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      if (_promotions.isEmpty) {
        _promotions = [
          PromotionModel(
            id: 1,
            code: 'DISCOUNT10',
            name: 'Giảm 10% cho đơn đầu tiên',
            discount: 10,
            isPercentage: true,
            expiryDate: DateTime(2025, 12, 31),
          ),
          PromotionModel(
            id: 2,
            code: 'FREESHIP',
            name: 'Miễn phí giao hàng',
            discount: 20000,
            isPercentage: false,
          ),
        ];
      }
      emit(PromotionLoaded(_promotions));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/promotions/list.php'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   _promotions = json.map((data) => PromotionModel.fromJson(data)).toList();
      //   emit(PromotionLoaded(_promotions));
      // } else {
      //   throw Exception('Không tải được danh sách ưu đãi');
      // }
    } catch (e) {
      emit(PromotionError(e.toString()));
    }
  }

  Future<void> _onApplyPromotion(ApplyPromotionEvent event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      // Mock: Tìm ưu đãi theo mã
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      final promotion = _promotions.firstWhere(
            (promo) => promo.code == event.code,
        orElse: () => throw Exception('Mã ưu đãi không hợp lệ'),
      );
      if (promotion.expiryDate != null && promotion.expiryDate!.isBefore(DateTime.now())) {
        throw Exception('Mã ưu đãi đã hết hạn');
      }
      emit(PromotionApplied(promotion));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/promotions/apply.php'),
      //   body: jsonEncode({'MaGiamGia': event.code}),
      // );
      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.body);
      //   emit(PromotionApplied(PromotionModel.fromJson(json)));
      // } else {
      //   throw Exception('Không thể áp dụng ưu đãi');
      // }
    } catch (e) {
      emit(PromotionError(e.toString()));
    }
  }
}