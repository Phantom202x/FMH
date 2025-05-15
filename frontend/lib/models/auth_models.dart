class AdminUser {
  final String email;
  final String password;
  const AdminUser({required this.email, required this.password});

  Map<String, dynamic> serialize() {
    return {
      "email": email,
      "password": password,
    };
  }
}

class GuestUser {
  final String fullName;
  final String nationality;
  final String email;
  final String phone;

  const GuestUser({
    required this.fullName,
    required this.nationality,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> serialize() {
    return {
      "full_name": fullName,
      "nationality": nationality,
      "email": email,
      "phone": phone,
    };
  }
}
