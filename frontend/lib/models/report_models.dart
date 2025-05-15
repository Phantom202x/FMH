class Report {
  final String author;
  final String phone;
  final String fullName;
  final String nationality;
  const Report({
    required this.author,
    required this.phone,
    required this.fullName,
    required this.nationality,
  });

  Map<String, dynamic> serialize() => {
        "author": author,
        "phone_number": phone,
        "full_name": fullName,
        "nationality": nationality,
        "status": false,
      };
}
