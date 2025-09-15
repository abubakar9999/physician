// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddItemModelAdapter extends TypeAdapter<AddItemModel> {
  @override
  final int typeId = 0;

  @override
  AddItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddItemModel(
      uiqueKey1: fields[0] as int?,
      quantity: fields[1] as int,
      item_name: fields[2] as String,
      tp: fields[3] as double,
      item_id: fields[4] as String,
      category_id: fields[5] as String,
      vat: fields[6] as double,
      manufacturer: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uiqueKey1)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.item_name)
      ..writeByte(3)
      ..write(obj.tp)
      ..writeByte(4)
      ..write(obj.item_id)
      ..writeByte(5)
      ..write(obj.category_id)
      ..writeByte(6)
      ..write(obj.vat)
      ..writeByte(7)
      ..write(obj.manufacturer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomerDataModelAdapter extends TypeAdapter<CustomerDataModel> {
  @override
  final int typeId = 1;

  @override
  CustomerDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDataModel(
      uiqueKey: fields[0] as int,
      clientName: fields[1] as String,
      marketName: fields[2] as String,
      areaId: fields[3] as String,
      clientId: fields[4] as String,
      outstanding: fields[5] as String,
      thana: fields[6] as String,
      address: fields[7] as String,
      deliveryDate: fields[8] as String,
      collectionDate: fields[15] as String,
      deliveryTime: fields[9] as String,
      paymentMethod: fields[10] as String,
      offer: fields[11] as String?,
      note: fields[12] as String?,
      shift: fields[13] as String?,
      areaName: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDataModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.marketName)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.clientId)
      ..writeByte(5)
      ..write(obj.outstanding)
      ..writeByte(6)
      ..write(obj.thana)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.deliveryDate)
      ..writeByte(9)
      ..write(obj.deliveryTime)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.offer)
      ..writeByte(12)
      ..write(obj.note)
      ..writeByte(13)
      ..write(obj.shift)
      ..writeByte(14)
      ..write(obj.areaName)
      ..writeByte(15)
      ..write(obj.collectionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DcrDataModelAdapter extends TypeAdapter<DcrDataModel> {
  @override
  final int typeId = 2;

  @override
  DcrDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DcrDataModel(
      uiqueKey: fields[0] as int,
      docName: fields[1] as String,
      docId: fields[2] as String,
      areaId: fields[3] as String,
      areaName: fields[4] as String,
      address: fields[5] as String,
      visitedWith: fields[6] as String?,
      note: fields[7] as String?,
      non_Excution: fields[8] as String?,
      shift: fields[9] as String?,
      image: fields[10] as String?,
      visitedPerson: fields[11] as String?,
      organizationName: fields[12] as String?,
      phoneNum: fields[13] as int?,
      category: fields[14] as String?,
      brandId: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DcrDataModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.docName)
      ..writeByte(2)
      ..write(obj.docId)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.areaName)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.visitedWith)
      ..writeByte(7)
      ..write(obj.note)
      ..writeByte(8)
      ..write(obj.non_Excution)
      ..writeByte(9)
      ..write(obj.shift)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.visitedPerson)
      ..writeByte(12)
      ..write(obj.organizationName)
      ..writeByte(13)
      ..write(obj.phoneNum)
      ..writeByte(14)
      ..write(obj.category)
      ..writeByte(15)
      ..write(obj.brandId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DcrDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RxDcrDataModelAdapter extends TypeAdapter<RxDcrDataModel> {
  @override
  final int typeId = 3;

  @override
  RxDcrDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RxDcrDataModel(
      uiqueKey: fields[0] as int,
      docName: fields[1] as String,
      docId: fields[2] as String,
      areaId: fields[3] as String,
      areaName: fields[4] as String,
      address: fields[5] as String,
      presImage: fields[6] as String,
      dcrGrad: fields[7] as String,
      phnNum: fields[8] as String?,
      patientName: fields[9] as String?,
      gender: fields[10] as String?,
      dob: fields[11] as String?,
      stripWastage: fields[12] as String?,
      systemName: fields[13] as String?,
      disease: fields[14] as String?,
      patientTemperament: fields[15] as String?,
      diabetesBefore: fields[16] as String?,
      diabetesAfter: fields[17] as String?,
      bloodSystolic: fields[18] as String?,
      bloodDiastolic: fields[19] as String?,
      oxygenLevel: fields[20] as String?,
      bodyTemperature: fields[21] as String?,
      weight: fields[22] as String?,
      heightFeet: fields[23] as String?,
      heightInch: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RxDcrDataModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.docName)
      ..writeByte(2)
      ..write(obj.docId)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.areaName)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.presImage)
      ..writeByte(7)
      ..write(obj.dcrGrad)
      ..writeByte(8)
      ..write(obj.phnNum)
      ..writeByte(9)
      ..write(obj.patientName)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.dob)
      ..writeByte(12)
      ..write(obj.stripWastage)
      ..writeByte(13)
      ..write(obj.systemName)
      ..writeByte(14)
      ..write(obj.disease)
      ..writeByte(15)
      ..write(obj.patientTemperament)
      ..writeByte(16)
      ..write(obj.diabetesBefore)
      ..writeByte(17)
      ..write(obj.diabetesAfter)
      ..writeByte(18)
      ..write(obj.bloodSystolic)
      ..writeByte(19)
      ..write(obj.bloodDiastolic)
      ..writeByte(20)
      ..write(obj.oxygenLevel)
      ..writeByte(21)
      ..write(obj.bodyTemperature)
      ..writeByte(22)
      ..write(obj.weight)
      ..writeByte(23)
      ..write(obj.heightFeet)
      ..writeByte(24)
      ..write(obj.heightInch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RxDcrDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DcrGSPDataModelAdapter extends TypeAdapter<DcrGSPDataModel> {
  @override
  final int typeId = 4;

  @override
  DcrGSPDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DcrGSPDataModel(
      uiqueKey: fields[0] as int,
      quantity: fields[1] as int,
      giftName: fields[2] as String,
      giftId: fields[3] as String,
      giftType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DcrGSPDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.giftName)
      ..writeByte(3)
      ..write(obj.giftId)
      ..writeByte(4)
      ..write(obj.giftType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DcrGSPDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineListModelAdapter extends TypeAdapter<MedicineListModel> {
  @override
  final int typeId = 5;

  @override
  MedicineListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineListModel(
      uiqueKey: fields[0] as int,
      strength: fields[1] as String,
      brand: fields[3] as String,
      company: fields[4] as String,
      formation: fields[5] as String,
      name: fields[2] as String,
      generic: fields[6] as String,
      itemId: fields[7] as String,
      quantity: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineListModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.strength)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.formation)
      ..writeByte(6)
      ..write(obj.generic)
      ..writeByte(7)
      ..write(obj.itemId)
      ..writeByte(8)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoticeListModelAdapter extends TypeAdapter<NoticeListModel> {
  @override
  final int typeId = 6;

  @override
  NoticeListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoticeListModel(
      uiqueKey: fields[0] as int,
      notice_date: fields[2] as String?,
      notice_title: fields[3] as String,
      notice_details: fields[4] as String?,
      notice_id: fields[1] as String,
      status: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NoticeListModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.notice_id)
      ..writeByte(2)
      ..write(obj.notice_date)
      ..writeByte(3)
      ..write(obj.notice_title)
      ..writeByte(4)
      ..write(obj.notice_details)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
