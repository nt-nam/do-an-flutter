import '../../domain/entities/cart_detail.dart';

class CartDetailModel {
  final int? maCTGH;
  final int? maGH;
  final int? maTK; // Thêm trường maTK
  final int? maSP;
  final int? soLuong;
  final String? ngayThem;
  final String? tenSP;
  final double? gia;
  final String? hinhAnh;

  CartDetailModel({
    this.maCTGH,
    this.maGH,
    this.maTK,
    this.maSP,
    this.soLuong,
    this.ngayThem,
    this.tenSP,
    this.gia,
    this.hinhAnh,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    print('Parsing CartDetailModel from JSON: $json');
    return CartDetailModel(
      maCTGH: json['MaCTGH'] as int?,
      maGH: json['MaGH'] as int?,
      maTK: json['MaTK'] as int?, // Ánh xạ MaTK
      maSP: json['MaSP'] as int?,
      soLuong: json['SoLuong'] as int?,
      ngayThem: json['NgayThem'] as String?,
      tenSP: json['TenSP'] as String?,
      gia: (json['Gia'] as num?)?.toDouble(),
      hinhAnh: json['HinhAnh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaCTGH': maCTGH,
      'MaGH': maGH,
      'MaTK': maTK,
      'MaSP': maSP,
      'SoLuong': soLuong,
      'NgayThem': ngayThem,
      'TenSP': tenSP,
      'Gia': gia,
      'HinhAnh': hinhAnh,
    };
  }

  CartDetail toEntity() {
    return CartDetail(
      cartDetailId: maCTGH ?? 0,
      cartId: maGH ?? 0,
      accountId: maTK ?? 0,
      productId: maSP ?? 0,
      quantity: soLuong ?? 0,
      createdDate: ngayThem ?? '',
      productName: tenSP,
      productPrice: gia ?? 0.0,
      productImage: hinhAnh,
    );
  }

  factory CartDetailModel.fromEntity(CartDetail cartDetail) {
    return CartDetailModel(
      maCTGH: cartDetail.cartDetailId,
      maGH: cartDetail.cartId,
      maTK: cartDetail.accountId,
      maSP: cartDetail.productId,
      soLuong: cartDetail.quantity,
      ngayThem: cartDetail.createdDate,
      tenSP: cartDetail.productName,
      gia: cartDetail.productPrice,
      hinhAnh: cartDetail.productImage,
    );
  }
}
