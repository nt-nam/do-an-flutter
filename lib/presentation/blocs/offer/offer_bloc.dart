import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/offer_model.dart';
import '../../../domain/entities/offer.dart';
import '../../../domain/usecases/offer/add_offer_usecase.dart';
import '../../../domain/usecases/offer/get_offers_usecase.dart';
import 'offer_event.dart';
import 'offer_state.dart';
import '../../../domain/repositories/offer_repository.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetOffersUseCase getOffersUseCase;
  final AddOfferUseCase addOfferUseCase;
  final OfferRepository repository;

  OfferBloc(this.getOffersUseCase, this.addOfferUseCase, this.repository)
      : super(const OfferInitial()) {
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
      emit(OfferError('Failed to fetch offers: $e'));
    }
  }

  Future<void> _onAddOffer(AddOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      final offer = await addOfferUseCase(
        event.name,
        event.discountAmount,
        event.startDate,
        event.endDate,
        minBill: event.minBill,
        productCode: event.productCode,
        productType: event.productType,
        note: event.note,
        maxUses: event.maxUses,
        customerLimit: event.customerLimit,
        maxDiscount: event.maxDiscount,
      );
      emit(OfferAdded(Offer(
        id: offer.id,
        name: offer.name,
        discountAmount: offer.discountAmount,
        discountType: offer.discountType,
        startDate: offer.startDate,
        endDate: offer.endDate,
        status: offer.status,
        minBill: offer.minBill,
        productCode: offer.productCode,
        productType: offer.productType,
        note: offer.note,
        maxUses: offer.maxUses,
        customerLimit: offer.customerLimit,
        maxDiscount: offer.maxDiscount,
      )));
      final offers = await getOffersUseCase();
      emit(OfferLoaded(offers));
    } catch (e) {
      emit(OfferError('Failed to add offer: $e'));
    }
  }

  Future<void> _onUpdateOffer(UpdateOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      final offerModel = OfferModel(
        maUD: event.offerId,
        tenUD: event.name,
        mucGiam: event.discountAmount,
        discountType: event.discountAmount < 0 ? DiscountType.amount : DiscountType.percentage,
        ngayBatDau: event.startDate,
        ngayKetThuc: event.endDate,
        trangThai: event.status == 'ACTIVE' ? OfferStatus.active : OfferStatus.inactive,
      );
      final updatedOffer = await repository.updateOffer(offerModel);
      emit(OfferUpdated(Offer(
        id: updatedOffer.maUD,
        name: updatedOffer.tenUD,
        discountAmount: updatedOffer.mucGiam,
        discountType: updatedOffer.discountType,
        startDate: updatedOffer.ngayBatDau,
        endDate: updatedOffer.ngayKetThuc,
        status: updatedOffer.trangThai,
        minBill: updatedOffer.hoadonMin,
        productCode: updatedOffer.masp,
        productType: updatedOffer.loaisp,
        note: updatedOffer.ghiChu,
        maxUses: updatedOffer.soLanMax,
        customerLimit: updatedOffer.gioiHanKhach,
        maxDiscount: updatedOffer.giaTriMax,
      )));
      final offers = await getOffersUseCase();
      emit(OfferLoaded(offers));
    } catch (e) {
      emit(OfferError('Failed to update offer: $e'));
    }
  }

  Future<void> _onDeleteOffer(DeleteOfferEvent event, Emitter<OfferState> emit) async {
    emit(const OfferLoading());
    try {
      emit(const OfferError('Delete offer not implemented yet'));
    } catch (e) {
      emit(OfferError('Failed to delete offer: $e'));
    }
  }
}