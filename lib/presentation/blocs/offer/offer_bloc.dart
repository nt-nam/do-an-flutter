import 'package:do_an_flutter/domain/usecases/add_offer_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_offers_usecase.dart';
import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetOffersUseCase getOffersUseCase;
  final AddOfferUseCase addOfferUseCase;

  OfferBloc(this.getOffersUseCase, this.addOfferUseCase) : super(const OfferInitial()) {
    on<FetchOffersEvent>(_onFetchOffers);
    on<AddOfferEvent>(_onAddOffer);
    on<UpdateOfferEvent>(_onUpdateOffer);
    on<DeleteOfferEvent>(_onDeleteOffer);
  }

  Future<void> _onFetchOffers(FetchOffersEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      final offers = await getOffersUseCase(onlyActive: event.onlyActive);
      emit(OfferLoaded(offers));
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }

  Future<void> _onAddOffer(AddOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      final offer = await addOfferUseCase(event.name, event.discountAmount, event.startDate, event.endDate);
      emit(OfferAdded(offer));
      final offers = await getOffersUseCase();
      emit(OfferLoaded(offers));
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }

  Future<void> _onUpdateOffer(UpdateOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const OfferError('Update offer not implemented yet'));
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }

  Future<void> _onDeleteOffer(DeleteOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      // Chưa triển khai use case, để trống hoặc thêm sau
      emit(const OfferError('Delete offer not implemented yet'));
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }
}