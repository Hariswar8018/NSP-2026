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

  final bool transliteradone;
  final bool bool1;
  final bool bool2;
  final bool bool3;
  final bool bool4;
  final bool bool5;
  final bool bool6;
  final bool bool7;
  final bool bool8;
  final bool bool9;


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

    this.transliteradone = false,
    this.bool1 = false,
    this.bool2 = false,
    this.bool3 = false,
    this.bool4 = false,
    this.bool5 = false,
    this.bool6 = false,
    this.bool7 = false,
    this.bool8 = false,
    this.bool9 = false,

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
      'transliteradone': transliteradone,
      'bool1': bool1,
      'bool2': bool2,
      'bool3': bool3,
      'bool4': bool4,
      'bool5': bool5,
      'bool6': bool6,
      'bool7': bool7,
      'bool8': bool8,
      'bool9': bool9,
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
      transliteradone: map['transliteradone'] ?? false,
      bool1: map['bool1'] ?? false,
      bool2: map['bool2'] ?? false,
      bool3: map['bool3'] ?? false,
      bool4: map['bool4'] ?? false,
      bool5: map['bool5'] ?? false,
      bool6: map['bool6'] ?? false,
      bool7: map['bool7'] ?? false,
      bool8: map['bool8'] ?? false,
      bool9: map['bool9'] ?? false,
    );
  }
}
