class User {
  final int id;
  final int? accountId; // Có thể null nếu không liên kết tài khoản
  final String fullName;
  final String phoneNumber;
  final String address;

  User({
    required this.id,
    this.accountId,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
  });
}