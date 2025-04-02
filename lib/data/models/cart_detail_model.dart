import 'package:do_an_flutter/domain/entities/cart_detail.dart';

class CartDetailModel {
  final int? maCTGH;
  final int? maGH;
  final int? maSP;
  final int? soLuong;
  final double? donGia;
  final String? tenSP;
  final double? gia;
  final String? hinhAnh;

  CartDetailModel({
    this.maCTGH,
    this.maGH,
    this.maSP,
    this.soLuong,
    this.donGia,
    this.tenSP,
    this.gia,
    this.hinhAnh,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return CartDetailModel(
      maCTGH: json['MaCTGH'] as int?,
      maGH: json['MaGH'] as int?,
      maSP: json['MaSP'] as int?,
      soLuong: json['SoLuong'] as int?,
      donGia: (json['DonGia'] as num?)?.toDouble(),
      tenSP: json['TenSP'] as String?,
      gia: (json['Gia'] as num?)?.toDouble(),
      hinhAnh: json['HinhAnh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaCTGH': maCTGH,
      'MaGH': maGH,
      'MaSP': maSP,
      'SoLuong': soLuong,
      'DonGia': donGia,
      'TenSP': tenSP,
      'Gia': gia,
      'HinhAnh': hinhAnh,
    };
  }

  CartDetail toEntity() {
    return CartDetail(
      cartDetailId: maCTGH ?? 0, // Sử dụng giá trị mặc định nếu null
      cartId: maGH ?? 0,
      productId: maSP ?? 0,
      quantity: soLuong ?? 0,
      price: donGia ?? 0.0,
      productName: tenSP,
      productPrice: gia ?? 0.0,
      productImage: hinhAnh,
    );
  }

  factory CartDetailModel.fromEntity(CartDetail cartDetail) {
    return CartDetailModel(
      maCTGH: cartDetail.cartDetailId,
      maGH: cartDetail.cartId,
      maSP: cartDetail.productId,
      soLuong: cartDetail.quantity,
      donGia: cartDetail.price,
      tenSP: cartDetail.productName,
      gia: cartDetail.productPrice,
      hinhAnh: cartDetail.productImage,
    );
  }
}