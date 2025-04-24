import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/order/create_order_usecase.dart';
import '../../../domain/usecases/order/get_orders_usecase.dart';
import '../../../domain/usecases/order/update_order_status_usecase.dart';
import '../../../domain/usecases/order/get_order_details_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../../domain/entities/order.dart' as entity;

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.createOrderUseCase,
    required this.updateOrderStatusUseCase,
    required this.getOrderDetailsUseCase,
  }) : super(const OrderInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<FetchOrderDetailsEvent>(_onFetchOrderDetails);
    on<CancelOrderEvent>(_onCancelOrder);
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
      emit(OrderCreated(order));
      final orders = await getOrdersUseCase(event.accountId);
      emit(OrderLoaded(orders));
    } catch (e) {
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
      final order = await updateOrderStatusUseCase(event.orderId, event.newStatus);
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