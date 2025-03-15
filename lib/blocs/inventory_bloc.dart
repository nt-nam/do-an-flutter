// lib/blocs/inventory_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/inventory_model.dart';
import '../models/product_model.dart';

abstract class InventoryEvent {}
class LoadInventoryEvent extends InventoryEvent {}
class UpdateInventoryEvent extends InventoryEvent {
  final int productId;
  final int newQuantity;
  UpdateInventoryEvent(this.productId, this.newQuantity);
}

abstract class InventoryState {}
class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventoryLoaded extends InventoryState {
  final List<InventoryModel> inventory;
  InventoryLoaded(this.inventory);
}
class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  List<InventoryModel> _inventory = []; // Mock danh sách tồn kho

  InventoryBloc() : super(InventoryInitial()) {
    on<LoadInventoryEvent>(_onLoadInventory);
    on<UpdateInventoryEvent>(_onUpdateInventory);
  }

  Future<void> _onLoadInventory(LoadInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      // Mock: Tạo dữ liệu giả lập
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      if (_inventory.isEmpty) {
        _inventory = [
          InventoryModel(
            productId: 1,
            product: ProductModel(id: 1, name: 'Bình gas 12kg', description: 'Bình gas an toàn', price: 350000, quantity: 100, status: 'Còn hàng'),
            quantity: 50,
          ),
          InventoryModel(
            productId: 2,
            product: ProductModel(id: 2, name: 'Van gas', description: 'Van tự ngắt', price: 150000, quantity: 50, status: 'Còn hàng'),
            quantity: 20,
          ),
        ];
      }
      emit(InventoryLoaded(_inventory));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/inventory/list.php'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   _inventory = json.map((data) => InventoryModel.fromJson(data)).toList();
      //   emit(InventoryLoaded(_inventory));
      // } else {
      //   throw Exception('Không tải được danh sách kho');
      // }
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateInventory(UpdateInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      // Mock: Cập nhật số lượng
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      _inventory = _inventory.map((item) {
        if (item.productId == event.productId) {
          return InventoryModel(
            productId: item.productId,
            product: item.product,
            quantity: event.newQuantity,
          );
        }
        return item;
      }).toList();
      emit(InventoryLoaded(_inventory));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/inventory/update.php'),
      //   body: jsonEncode({'MaSP': event.productId, 'SoLuong': event.newQuantity}),
      // );
      // if (response.statusCode == 200) {
      //   emit(InventoryLoaded(_inventory));
      // } else {
      //   throw Exception('Không thể cập nhật kho');
      // }
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}