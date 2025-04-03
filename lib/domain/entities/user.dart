class User {
  final int id;
  final int accountId;
  final String fullName;
  final String? phoneNumber;
  final String? address;
  final String email;

  User({
    required this.id,
    required this.accountId,
    required this.fullName,
    this.phoneNumber,
    this.address,
    required this.email,
  });
}