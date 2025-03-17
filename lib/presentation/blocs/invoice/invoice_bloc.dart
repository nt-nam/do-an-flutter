import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_order_usecase.dart';
import '../../../domain/usecases/get_orders_usecase.dart';
import '../../../domain/usecases/update_order_status_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  InvoiceBloc(
      this.getOrdersUseCase,
      this.createOrderUseCase,
      this.updateOrderStatusUseCase,
      ) : super(const InvoiceInitial()) {
    on<FetchInvoicesEvent>(_onFetchInvoices);
    on<CreateInvoiceEvent>(_onCreateInvoice);
    on<UpdateInvoiceStatusEvent>(_onUpdateInvoiceStatus);
  }

  Future<void> _onFetchInvoices(FetchInvoicesEvent event, Emitter<InvoiceState> emit) async {
    emit(const InvoiceLoading());
    try {
      final invoices = await getOrdersUseCase(event.accountId);
      emit(InvoiceLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onCreateInvoice(CreateInvoiceEvent event, Emitter<InvoiceState> emit) async {
    emit(const InvoiceLoading());
    try {
      final invoice = await createOrderUseCase(
        event.accountId,
        event.items,
        event.deliveryAddress,
        offerId: event.offerId,
      );
      emit(InvoiceCreated(invoice));
      // Tải lại danh sách đơn hàng
      final invoices = await getOrdersUseCase(event.accountId);
      emit(InvoiceLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onUpdateInvoiceStatus(UpdateInvoiceStatusEvent event, Emitter<InvoiceState> emit) async {
    emit(const InvoiceLoading());
    try {
      final invoice = await updateOrderStatusUseCase(event.invoiceId, event.newStatus);
      emit(InvoiceStatusUpdated(invoice));
      // Kiểm tra nullable
      if (invoice.accountId != null) {
        final invoices = await getOrdersUseCase(invoice.accountId!); // Dùng ! vì đã kiểm tra null
        emit(InvoiceLoaded(invoices));
      } else {
        // Nếu accountId là null, không tải lại danh sách
        emit(const InvoiceError('Cannot reload invoices: accountId is null'));
      }
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}