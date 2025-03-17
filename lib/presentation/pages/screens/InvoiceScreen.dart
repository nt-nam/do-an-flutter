import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/invoice/invoice_bloc.dart';
import '../../blocs/invoice/invoice_event.dart';
import '../../blocs/invoice/invoice_state.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is InvoiceCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice created')));
          }
        },
        builder: (context, state) {
          if (state is InvoiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InvoiceLoaded) {
            return ListView.builder(
              itemCount: state.invoices.length,
              itemBuilder: (context, index) {
                final invoice = state.invoices[index];
                return ListTile(
                  title: Text('Invoice ID: ${invoice.id}'),
                  subtitle: Text('Status: ${invoice.status} - Total: ${invoice.totalAmount}'),
                  trailing: DropdownButton<String>(
                    value: invoice.status,
                    items: ['Chờ xác nhận', 'Đang giao', 'Đã giao', 'Hủy']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        context.read<InvoiceBloc>().add(UpdateInvoiceStatusEvent(invoice.id, newStatus));
                      }
                    },
                  ),
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<InvoiceBloc>().add(const FetchInvoicesEvent(1)); // Giả định accountId = 1
              },
              child: const Text('Load Invoices'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<InvoiceBloc>().add(
            const CreateInvoiceEvent(
              1, // accountId
              [(101, 2, 100.0)], // items: (productId, quantity, price)
              '123 Main St', // deliveryAddress
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}