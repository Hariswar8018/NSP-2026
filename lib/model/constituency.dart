class Constituency {
  final String id;

  final String state;
  final String district;
  final String assemblyConstituency;
  final String boothNo;

  final String jila;
  final String vikaskhand;
  final String grampanchayat;
  final String matdankendra;
  final String sambawad;
  final String matdansthal;
  final String wardsankya;
  final String sammilitjaswagram;

  Constituency({
    required this.id,
    required this.state,
    required this.district,
    required this.assemblyConstituency,
    required this.boothNo,
    required this.jila,
    required this.vikaskhand,
    required this.grampanchayat,
    required this.matdankendra,
    required this.sambawad,
    required this.matdansthal,
    required this.wardsankya,
    required this.sammilitjaswagram,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
      'district': district,
      'assemblyConstituency': assemblyConstituency,
      'boothNo': boothNo,
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

  factory Constituency.fromJson(Map<String, dynamic> map) {
    return Constituency(
      id: map['id'] ?? '',
      state: map['state'] ?? '',
      district: map['district'] ?? '',
      assemblyConstituency: map['assemblyConstituency'] ?? '',
      boothNo: map['boothNo'] ?? '',
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
}
