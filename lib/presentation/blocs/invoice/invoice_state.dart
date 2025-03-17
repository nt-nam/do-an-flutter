

import '../../../domain/entities/order.dart';

abstract class InvoiceState {
  const InvoiceState();
}

class InvoiceInitial extends InvoiceState {
  const InvoiceInitial();
}

class InvoiceLoading extends InvoiceState {
  const InvoiceLoading();
}

class InvoiceLoaded extends InvoiceState {
  final List<Order> invoices;

  const InvoiceLoaded(this.invoices);
}

class InvoiceCreated extends InvoiceState {
  final Order invoice;

  const InvoiceCreated(this.invoice);
}

class InvoiceStatusUpdated extends InvoiceState {
  final Order invoice;

  const InvoiceStatusUpdated(this.invoice);
}

class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError(this.message);
}