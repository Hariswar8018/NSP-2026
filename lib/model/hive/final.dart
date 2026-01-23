import 'package:hive_flutter/adapters.dart';
import '../finalvoterlist.dart';

class FinalVoterListAdapter extends TypeAdapter<FinalVoterList> {
  @override
  final int typeId = 1;

  @override
  FinalVoterList read(BinaryReader reader) {
    return FinalVoterList(
      epicNo: reader.readString(),
      name: reader.readString(),
      nameEn: reader.readString(),
      fatherName: reader.readString(),
      fatherNameEn: reader.readString(),
      houseNo: reader.readString(),
      age: reader.readInt(),
      gender: reader.readString(),
      genderEn: reader.readString(),
      serialNo: reader.readInt(),
      wardsankya: reader.readString(),
      matdansthal: reader.readString(),
      sammilitjaswagram: reader.readString(),

      // 🔹 EXTRA FIELDS
      voterId: reader.readString(),
      consid: reader.readString(),
      jila: reader.readString(),
      vikaskhand: reader.readString(),
      grampanchayat: reader.readString(),
      matdankendra: reader.readString(),
      sambawad: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, FinalVoterList obj) {
    writer.writeString(obj.epicNo);
    writer.writeString(obj.name);
    writer.writeString(obj.nameEn);
    writer.writeString(obj.fatherName);
    writer.writeString(obj.fatherNameEn);
    writer.writeString(obj.houseNo);
    writer.writeInt(obj.age);
    writer.writeString(obj.gender);
    writer.writeString(obj.genderEn);
    writer.writeInt(obj.serialNo);
    writer.writeString(obj.wardsankya);
    writer.writeString(obj.matdansthal);
    writer.writeString(obj.sammilitjaswagram);

    // 🔹 EXTRA FIELDS
    writer.writeString(obj.voterId);
    writer.writeString(obj.consid);
    writer.writeString(obj.jila);
    writer.writeString(obj.vikaskhand);
    writer.writeString(obj.grampanchayat);
    writer.writeString(obj.matdankendra);
    writer.writeString(obj.sambawad);
  }
}
