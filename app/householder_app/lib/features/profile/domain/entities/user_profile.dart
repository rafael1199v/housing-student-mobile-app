class UserProfile {
  final String email;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? nationality;
  final String? gender;
  final String? imageUrl;
  final String? birthDate;

  const UserProfile({
    required this.email,
    required this.firstName,
    this.lastName,
    this.phoneNumber,
    this.nationality,
    this.gender,
    this.imageUrl,
    this.birthDate,
  });

  String get fullName {
    final last = lastName?.trim() ?? '';
    return last.isEmpty ? firstName.trim() : '${firstName.trim()} $last';
  }
}
