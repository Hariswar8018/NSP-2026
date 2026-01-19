class VoterModel {
  final int serialNo;        // 1 → 50 (row index)
  final String voterId;      // 0 → 50 (ID column)
  final String houseNo;      // 68अँ / 1 / 2 / etc
  final String name;         // first name
  final String fatherName;   // father / husband name
  final String epicNo;       // 9-digit unique code
  final String gender;       // पु / म
  final int age;             // age

  VoterModel({
    required this.serialNo,
    required this.voterId,
    required this.houseNo,
    required this.name,
    required this.fatherName,
    required this.epicNo,
    required this.gender,
    required this.age,
  });

  @override
  String toString() {
    return '$serialNo $name ($epicNo)';
  }
  VoterModel copyWith({
    String? houseNo,
    String? name,
    String? fatherName,
    String? epicNo,
    String? gender,
    int? age,
  }) {
    return VoterModel(
      serialNo: serialNo,
      voterId: voterId,
      houseNo: houseNo ?? this.houseNo,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      epicNo: epicNo ?? this.epicNo,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

}
