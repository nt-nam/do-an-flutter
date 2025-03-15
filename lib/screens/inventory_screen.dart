// lib/screens/inventory_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/inventory_bloc.dart';
import '../models/inventory_model.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<InventoryBloc>().add(LoadInventoryEvent());

    return Scaffold(
      appBar: AppBar(title: Text('Quản lý kho')),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is InventoryLoaded) {
            if (state.inventory.isEmpty) {
              return Center(child: Text('Kho trống'));
            }
            return ListView.builder(
              itemCount: state.inventory.length,
              itemBuilder: (context, index) {
                final item = state.inventory[index];
                final TextEditingController _quantityController =
                TextEditingController(text: item.quantity.toString());

                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          final newQuantity = int.tryParse(_quantityController.text) ?? item.quantity;
                          context.read<InventoryBloc>().add(UpdateInventoryEvent(item.productId, newQuantity));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is InventoryError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Chưa có dữ liệu kho'));
        },
      ),
    );
  }
}