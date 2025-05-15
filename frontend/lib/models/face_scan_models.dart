class FaceMatch {
  //final String id;
  final int id;
  final String fullName;
  final String nationality;
  final String age;
  final String bloodType;
  final String gender;
  final String contact;
  final String? illness;

  const FaceMatch({
    required this.id,
    required this.fullName,
    required this.nationality,
    required this.age,
    required this.bloodType,
    required this.gender,
    required this.contact,
    this.illness, // nullable illness
  });

  Map<String, dynamic> serialize() => {
        "id": id,
        "full_name": fullName,
        "nationality": nationality,
        "age": age,
        "blood_type": bloodType,
        "gender": gender,
        "contact": contact,
        "illness": illness ?? "-", // Ensure `null` gets replaced with "-"
      };
}
