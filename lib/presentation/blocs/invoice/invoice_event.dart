abstract class InvoiceEvent {
  const InvoiceEvent();
}

class FetchInvoicesEvent extends InvoiceEvent {
  final int accountId;

  const FetchInvoicesEvent(this.accountId);
}

class CreateInvoiceEvent extends InvoiceEvent {
  final int accountId;
  final List<(int productId, int quantity, double price)> items;
  final String deliveryAddress;
  final int? offerId;

  const CreateInvoiceEvent(this.accountId, this.items, this.deliveryAddress, {this.offerId});
}

class UpdateInvoiceStatusEvent extends InvoiceEvent {
  final int invoiceId;
  final String newStatus;

  const UpdateInvoiceStatusEvent(this.invoiceId, this.newStatus);
}