import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/offer/offer_bloc.dart';
import '../../blocs/offer/offer_event.dart';
import '../../blocs/offer/offer_state.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: BlocConsumer<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state is OfferError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            return ListView.builder(
              itemCount: state.offers.length,
              itemBuilder: (context, index) {
                final offer = state.offers[index];
                return ListTile(
                  title: Text(offer.name),
                  subtitle: Text(
                      'Discount: ${offer.discountAmount} - ${offer.startDate} to ${offer.endDate} - Status: ${offer.status}'),
                );
              },
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<OfferBloc>().add(const FetchOffersEvent());
                  },
                  child: const Text('Load All Offers'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<OfferBloc>().add(const FetchOffersEvent(onlyActive: true));
                  },
                  child: const Text('Load Active Offers'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
