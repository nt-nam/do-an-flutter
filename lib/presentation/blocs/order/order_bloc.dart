import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_order_usecase.dart';
import '../../../domain/usecases/get_orders_usecase.dart';
import '../../../domain/usecases/update_order_status_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderBloc(
      this.getOrdersUseCase,
      this.createOrderUseCase,
      this.updateOrderStatusUseCase,
      ) : super(const OrderInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(FetchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await getOrdersUseCase(event.accountId, page: event.page, limit: event.limit);
      emit(OrderLoaded(orders));
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
      );
      emit(OrderCreated(order));
      // Tải lại danh sách đơn hàng
      final orders = await getOrdersUseCase(event.accountId);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final order = await updateOrderStatusUseCase(event.orderId, event.newStatus);
      emit(OrderStatusUpdated(order));
      // Tải lại danh sách đơn hàng
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
}