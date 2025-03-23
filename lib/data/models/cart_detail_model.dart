class CartDetailModel {
  final int maGH; // Liên kết với Cart
  final int maSP;
  final int soLuong;

  CartDetailModel({
    required this.maGH,
    required this.maSP,
    required this.soLuong,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return CartDetailModel(
      maGH: json['MaGH'] as int,
      maSP: json['MaSP'] as int,
      soLuong: json['SoLuong'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': maGH,
      'MaSP': maSP,
      'SoLuong': soLuong,
    };
  }
}