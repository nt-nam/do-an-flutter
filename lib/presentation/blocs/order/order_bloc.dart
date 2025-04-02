import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/order/create_order_usecase.dart';
import '../../../domain/usecases/order/get_orders_usecase.dart';
import '../../../domain/usecases/order/update_order_status_usecase.dart';
import '../../../domain/usecases/order/get_order_details_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

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
  }

  Future<void> _onFetchOrders(FetchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await getOrdersUseCase(event.accountId, page: event.page, limit: event.limit);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final order = await createOrderUseCase(
        event.accountId,
        event.items,
        event.deliveryAddress,
        offerId: event.offerId,
        cartId: event.cartId,
      );
      emit(OrderCreated(order));
      final orders = await getOrdersUseCase(event.accountId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final order = await updateOrderStatusUseCase(event.orderId, event.newStatus);
      emit(OrderStatusUpdated(order));
      if (order.accountId != null) {
        final orders = await getOrdersUseCase(order.accountId!);
        emit(OrdersLoaded(orders));
      } else {
        emit(const OrderError('Cannot reload orders: accountId is null'));
      }
    } catch (e) {
      emit(OrderError(e.toString())); // Sửa từ CartError thành OrderError
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
}