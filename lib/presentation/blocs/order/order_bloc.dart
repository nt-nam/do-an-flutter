import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../domain/usecases/order/create_order_usecase.dart';
import '../../../domain/usecases/order/get_orders_usecase.dart';
import '../../../domain/usecases/order/update_order_status_usecase.dart';
import '../../../domain/usecases/order/get_order_details_usecase.dart';
import '../../../domain/usecases/user/update_user_level_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../../domain/entities/order.dart' as entity;

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final UpdateUserLevelUseCase? updateUserLevelUseCase;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.createOrderUseCase,
    required this.updateOrderStatusUseCase,
    required this.getOrderDetailsUseCase,
    this.updateUserLevelUseCase,
  }) : super(const OrderInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<FetchOrderDetailsEvent>(_onFetchOrderDetails);
    on<CancelOrderEvent>(_onCancelOrder);
    on<CompleteOrderEvent>(_onCompleteOrder);
    // on<FetchAllOrdersEvent>(_onFetchAllOrders);
  }

  Future<void> _onFetchOrders(FetchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await getOrdersUseCase(event.accountId, page: event.page, limit: event.limit);
      if (orders.isEmpty) {
        emit(const OrderLoaded([])); // Trạng thái danh sách rỗng
      } else {
        emit(OrderLoaded(orders));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      developer.log('🛒 Đang tạo đơn hàng mới cho tài khoản ${event.accountId}');
      
      // Tính tổng tiền sản phẩm
      final double itemsTotal = event.items.fold(
        0.0,
            (sum, item) => sum + (item.productPrice ?? 0) * item.quantity,
      );
      
      // Lấy thông tin giảm giá từ additionalData nếu có
      double discountAmount = 0.0;
      if (event.additionalData != null && event.additionalData!.containsKey('discountAmount')) {
        discountAmount = event.additionalData!['discountAmount'] as double;
      }
      
      // Lấy thông tin tiền vỏ gas từ additionalData nếu có
      double shellAmount = 0.0;
      if (event.additionalData != null && event.additionalData!.containsKey('totalShellAmount')) {
        shellAmount = event.additionalData!['totalShellAmount'] as double;
      }
      
      // Tổng tiền sau khi giảm giá
      final double subtotalAmount = itemsTotal - discountAmount;
      
      // Tổng tiền bao gồm phí vận chuyển và tiền vỏ gas (nếu có)
      final double totalAmount = subtotalAmount + shellAmount + event.deliveryFee;

      final order = await createOrderUseCase(
        event.accountId,
        event.items,
        event.deliveryAddress,
        offerId: event.offerId,
        cartId: event.cartId,
        totalAmount: totalAmount, // Truyền tổng tiền đã tính giảm giá
      );
      developer.log('🛒 Tạo đơn hàng thành công, mã đơn: ${order.id}');
      
      // Cập nhật cấp độ người dùng sau khi tạo đơn hàng mới
      if (event.accountId > 0 && updateUserLevelUseCase != null) {
        try {
          developer.log('🛒 Bắt đầu cập nhật cấp độ người dùng sau khi tạo đơn hàng');
          await updateUserLevelUseCase!(event.accountId);
          developer.log('🛒 Đã cập nhật cấp độ người dùng cho tài khoản ${event.accountId}');
        } catch (e) {
          developer.log('🛒 Lỗi khi cập nhật cấp độ người dùng: $e', error: e);
        }
      }
      
      emit(OrderCreated(order));
      final orders = await getOrdersUseCase(event.accountId);
      emit(OrderLoaded(orders));
    } catch (e) {
      developer.log('🛒 Lỗi khi tạo đơn hàng: $e', error: e);
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: Failed to create order: Exception: Bad request:')) {
        errorMessage = errorMessage.split('Exception: Bad request: ')[1];
      } else if (errorMessage.contains('Exception: Failed to create order: Exception: Failed to create order:')) {
        errorMessage = errorMessage.split('Exception: Failed to create order: Exception: Failed to create order: ')[1];
      } else if (errorMessage.contains('Exception: Failed to create order:')) {
        errorMessage = errorMessage.split('Exception: Failed to create order: ')[1];
      }
      emit(OrderError(errorMessage));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      developer.log('📝 Đang cập nhật trạng thái đơn hàng ${event.orderId} -> ${event.newStatus}');
      final order = await updateOrderStatusUseCase(event.orderId, event.newStatus);
      emit(OrderStatusUpdated(order));
      
      // Cập nhật cấp độ người dùng sau khi đơn hàng hoàn thành
      if (event.newStatus == entity.OrderStatus.delivered && 
          order.accountId != null && 
          updateUserLevelUseCase != null) {
        try {
          developer.log('📝 Bắt đầu cập nhật cấp độ người dùng sau khi hoàn thành đơn hàng');
          await updateUserLevelUseCase!(order.accountId!);
          developer.log('📝 Đã cập nhật cấp độ người dùng cho tài khoản ${order.accountId}');
        } catch (e) {
          developer.log('📝 Lỗi khi cập nhật cấp độ người dùng: $e', error: e);
        }
      }
      
      if (order.accountId != null) {
        final orders = await getOrdersUseCase(order.accountId!);
        emit(OrderLoaded(orders));
      } else {
        emit(const OrderError('Cannot reload orders: accountId is null'));
      }
    } catch (e) {
      developer.log('📝 Lỗi khi cập nhật trạng thái đơn hàng: $e', error: e);
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onFetchOrderDetails(FetchOrderDetailsEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final details = await getOrderDetailsUseCase(event.orderId);
      emit(OrderDetailsLoaded(details));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final int orderId = int.parse(event.orderId.toString());
      final order = await updateOrderStatusUseCase(orderId, entity.OrderStatus.cancelled);
      emit(OrderStatusUpdated(order));
      if (order.accountId != null) {
        final orders = await getOrdersUseCase(order.accountId!);
        emit(OrderLoaded(orders));
      } else {
        emit(const OrderError('Cannot reload orders: accountId is null'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCompleteOrder(CompleteOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      developer.log('✅ Đang hoàn thành đơn hàng ${event.orderId}');
      final order = await updateOrderStatusUseCase(event.orderId, entity.OrderStatus.delivered);
      emit(OrderStatusUpdated(order));
      
      // Cập nhật cấp độ người dùng sau khi đơn hàng hoàn thành
      if (order.accountId != null && updateUserLevelUseCase != null) {
        try {
          developer.log('✅ Bắt đầu cập nhật cấp độ người dùng sau khi hoàn thành đơn hàng');
          await updateUserLevelUseCase!(order.accountId!);
          developer.log('✅ Đã cập nhật cấp độ người dùng cho tài khoản ${order.accountId}');
        } catch (e) {
          developer.log('✅ Lỗi khi cập nhật cấp độ người dùng: $e', error: e);
        }
      } else {
        developer.log('✅ Không thể cập nhật cấp độ: accountId=${order.accountId}, updateUserLevelUseCase=${updateUserLevelUseCase != null}');
      }
      
      if (order.accountId != null) {
        final orders = await getOrdersUseCase(order.accountId!);
        emit(OrderLoaded(orders));
      } else {
        emit(const OrderError('Cannot reload orders: accountId is null'));
      }
    } catch (e) {
      developer.log('✅ Lỗi khi hoàn thành đơn hàng: $e', error: e);
      emit(OrderError(e.toString()));
    }
  }
  
  // Future<void> _onFetchAllOrders(FetchAllOrdersEvent event, Emitter<OrderState> emit) async {
  //   emit(const OrderLoading());
  //   try {
  //     final orders = await getOrdersUseCase(event.accountId, page: event.page, limit: event.limit);
  //     emit(AllOrdersLoaded(orders));
  //   } catch (e) {
  //     emit(OrderError(e.toString()));
  //   }
  // }
}