class FinalVoterList {
  final int serialNo;
  final String voterId;
  final String houseNo;
  final String name;
  final String fatherName;
  final String gender;
  final String nameEn;
  final String fatherNameEn;
  final String genderEn;
  final String epicNo;
  final int age;
  final String consid;
  final String jila;
  final String vikaskhand;
  final String grampanchayat;
  final String matdankendra;
  final String sambawad;
  final String matdansthal;
  final String wardsankya;
  final String sammilitjaswagram;

  FinalVoterList({
    required this.serialNo,
    required this.voterId,
    required this.houseNo,
    required this.name,
    required this.fatherName,
    required this.gender,
    required this.nameEn,
    required this.fatherNameEn,
    required this.genderEn,
    required this.epicNo,
    required this.age,
    required this.consid,
    required this.jila,
    required this.vikaskhand,
    required this.grampanchayat,
    required this.matdankendra,
    required this.sambawad,
    required this.matdansthal,
    required this.wardsankya,
    required this.sammilitjaswagram,
  });

  Map<String, dynamic> toMap() {
    return {
      'serialNo': serialNo,
      'voterId': voterId,
      'houseNo': houseNo,
      'name': name,
      'fatherName': fatherName,
      'gender': gender,
      'nameEn': nameEn,
      'fatherNameEn': fatherNameEn,
      'genderEn': genderEn,
      'epicNo': epicNo,
      'age': age,
      'consid': consid,
      'jila': jila,
      'vikaskhand': vikaskhand,
      'grampanchayat': grampanchayat,
      'matdankendra': matdankendra,
      'sambawad': sambawad,
      'matdansthal': matdansthal,
      'wardsankya': wardsankya,
      'sammilitjaswagram': sammilitjaswagram,
    };
  }

  factory FinalVoterList.fromMap(Map<String, dynamic> map) {
    return FinalVoterList(
      serialNo: map['serialNo'] ?? 0,
      voterId: map['voterId'] ?? '',
      houseNo: map['houseNo'] ?? '',
      name: map['name'] ?? '',
      fatherName: map['fatherName'] ?? '',
      gender: map['gender'] ?? '',
      nameEn: map['nameEn'] ?? '',
      fatherNameEn: map['fatherNameEn'] ?? '',
      genderEn: map['genderEn'] ?? '',
      epicNo: map['epicNo'] ?? '',
      age: int.tryParse(map['age'].toString()) ?? 0,
      consid: map['consid'] ?? '',
      jila: map['jila'] ?? '',
      vikaskhand: map['vikaskhand'] ?? '',
      grampanchayat: map['grampanchayat'] ?? '',
      matdankendra: map['matdankendra'] ?? '',
      sambawad: map['sambawad'] ?? '',
      matdansthal: map['matdansthal'] ?? '',
      wardsankya: map['wardsankya'] ?? '',
      sammilitjaswagram: map['sammilitjaswagram'] ?? '',
    );
  }

  @override
  String toString() {
    return '$serialNo $name → $nameEn ($epicNo)';
  }
}
