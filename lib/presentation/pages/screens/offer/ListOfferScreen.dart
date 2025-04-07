import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/offer/offer_bloc.dart';
import '../../../blocs/offer/offer_event.dart';
import '../../../blocs/offer/offer_state.dart';
import '../../../widgets/OfferCard.dart';
import 'AddOfferScreen.dart';

class ListOfferScreen extends StatelessWidget {
  const ListOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OfferBloc>().add(const FetchOffersEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách ưu đãi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state is OfferError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is OfferAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm ưu đãi thành công')),
            );
          }
        },
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            return state.offers.isEmpty
                ? const Center(child: Text('Chưa có ưu đãi nào'))
                : ListView.builder(
              itemCount: state.offers.length,
              itemBuilder: (context, index) {
                return OfferCard(offer: state.offers[index]);
              },
            );
          }
          return const Center(child: Text('Nhấn nút để tải danh sách ưu đãi'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOfferScreen()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}