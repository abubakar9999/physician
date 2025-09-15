// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';

part 'hive_data_model.g.dart';

@HiveType(typeId: 0)
class AddItemModel extends HiveObject {
  @HiveField(0)
  int? uiqueKey1;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String item_name;
  @HiveField(3)
  double tp;
  @HiveField(4)
  String item_id;
  @HiveField(5)
  String category_id;
  @HiveField(6)
  double vat;
  @HiveField(7)
  String manufacturer;
  @HiveField(8)
  AddItemModel({
    this.uiqueKey1,
    required this.quantity,
    required this.item_name,
    required this.tp,
    required this.item_id,
    required this.category_id,
    required this.vat,
    required this.manufacturer,
  });
}

@HiveType(typeId: 1)
class CustomerDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String clientName;
  @HiveField(2)
  String marketName;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String clientId;
  @HiveField(5)
  String outstanding;
  @HiveField(6)
  String thana;
  @HiveField(7)
  String address;
  @HiveField(8)
  String deliveryDate;
  @HiveField(9)
  String deliveryTime;
  @HiveField(10)
  String paymentMethod;
  @HiveField(11)
  String? offer;
  @HiveField(12)
  String? note;
  @HiveField(13)
  String? shift;
  @HiveField(14)
  String? areaName;
  @HiveField(15)
  String collectionDate;

  CustomerDataModel({
    required this.uiqueKey,
    required this.clientName,
    required this.marketName,
    required this.areaId,
    required this.clientId,
    required this.outstanding,
    required this.thana,
    required this.address,
    required this.deliveryDate,
    required this.collectionDate,
    required this.deliveryTime,
    required this.paymentMethod,
    this.offer,
    this.note,
    this.shift,
    required this.areaName,
  });
}

@HiveType(typeId: 2)
class DcrDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String docName;
  @HiveField(2)
  String docId;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String areaName;
  @HiveField(5)
  String address;
  @HiveField(6)
  String? visitedWith;
  @HiveField(7)
  String? note;
  @HiveField(8)
  String? non_Excution;
  @HiveField(9)
  String? shift;
  @HiveField(10)
  String? image;
  @HiveField(11)
  String? visitedPerson;
  @HiveField(12)
  String? organizationName;
  @HiveField(13)
  int? phoneNum;
  @HiveField(14)
  String? category;
  @HiveField(15)
  String? brandId;

  DcrDataModel(
      {required this.uiqueKey,
      required this.docName,
      required this.docId,
      required this.areaId,
      required this.areaName,
      required this.address,
      this.visitedWith,
      this.note,
      this.non_Excution,
      this.shift,
      required this.image,
      required this.visitedPerson,
      required this.organizationName,
      required this.phoneNum,
      required this.category,
        required this.brandId
      });
}

@HiveType(typeId: 3)
class RxDcrDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String docName;
  @HiveField(2)
  String docId;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String areaName;
  @HiveField(5)
  String address;
  @HiveField(6)
  String presImage;
  @HiveField(7)
  String dcrGrad;
  @HiveField(8)
  String? phnNum;
  @HiveField(9)
  String? patientName;
  @HiveField(10)
  String? gender;
  @HiveField(11)
  String? dob;
  @HiveField(12)
  String? stripWastage;
  @HiveField(13)
  String? systemName;
  @HiveField(14)
  String? disease;
  @HiveField(15)
  String? patientTemperament;
  @HiveField(16)
  String? diabetesBefore;
  @HiveField(17)
  String? diabetesAfter;
  @HiveField(18)
  String? bloodSystolic;
  @HiveField(19)
  String? bloodDiastolic;
  @HiveField(20)
  String? oxygenLevel;
  @HiveField(21)
  String? bodyTemperature;
  @HiveField(22)
  String? weight;
  @HiveField(23)
  String? heightFeet;
  @HiveField(24)
  String? heightInch;


  RxDcrDataModel({
    required this.uiqueKey,
    required this.docName,
    required this.docId,
    required this.areaId,
    required this.areaName,
    required this.address,
    required this.presImage,
    required this.dcrGrad,

    required this.phnNum,
    required this.patientName,
    required this.gender,
    required this.dob,
    required this.stripWastage,
    required this.systemName,
    required this.disease,
    required this.patientTemperament,
    required this.diabetesBefore,
    required this.diabetesAfter,
    required this.bloodSystolic,
    required this.bloodDiastolic,
    required this.oxygenLevel,
    required this.bodyTemperature,
    required this.weight,
    required this.heightFeet,
    required this.heightInch,
  });
}

@HiveType(typeId: 4)
class DcrGSPDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String giftName;
  @HiveField(3)
  String giftId;
  @HiveField(4)
  String giftType;

  DcrGSPDataModel({
    required this.uiqueKey,
    required this.quantity,
    required this.giftName,
    required this.giftId,
    required this.giftType,
  });
}

@HiveType(typeId: 5)
class MedicineListModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String strength;
  @HiveField(2)
  String name;
  @HiveField(3)
  String brand;
  @HiveField(4)
  String company;
  @HiveField(5)
  String formation;
  @HiveField(6)
  String generic;
  @HiveField(7)
  String itemId;
  @HiveField(8)
  int quantity;

  MedicineListModel({
    required this.uiqueKey,
    required this.strength,
    required this.brand,
    required this.company,
    required this.formation,
    required this.name,
    required this.generic,
    required this.itemId,
    required this.quantity,
  });
}

@HiveType(typeId: 6)
class NoticeListModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String notice_id;
  @HiveField(2)
  String? notice_date;
  @HiveField(3)
  String notice_title;
  @HiveField(4)
  String? notice_details;
  @HiveField(5)
  String? status;


  NoticeListModel({
    required this.uiqueKey,
    required this.notice_date,
    required this.notice_title,
    required this.notice_details,
    required this.notice_id,
    this.status
  });
  // From JSON
  factory NoticeListModel.fromJson(Map<String, dynamic> json) {
    return NoticeListModel(
      uiqueKey: int.parse(json['notice_id']), // Assuming 'notice_id' is unique
      notice_date: json['notice_date'],
      notice_title: json['notice_title'],
      notice_details: json['notice_details'],
      notice_id: json['notice_id'],
      status: json['status'] ?? "",
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'notice_id': notice_id,
      'notice_date': notice_date,
      'notice_title': notice_title,
      'notice_details': notice_details,
      'status': status
    };
  }

}

// @HiveType(typeId: 7)
// class ButtonNameModel extends HiveObject {
//   @HiveField(0)
//   String new_order;
//
//   @HiveField(1)
//   String draft_order;
//
//   @HiveField(2)
//   String order_report;
//
//   @HiveField(3)
//   String new_dcr;
//
//   @HiveField(4)
//   String draft_dcr;
//
//   @HiveField(5)
//   String dcr_report;
//
//   @HiveField(6)
//   String seen_rx_capture;
//
//   @HiveField(7)
//   String draft_seen_rx;
//
//   @HiveField(8)
//   String seen_rx_report;
//
//   @HiveField(9)
//   String attendance;
//
//   @HiveField(10)
//   String expense;
//
//   @HiveField(11)
//   String tour_plan;
//
//   @HiveField(12)
//   String approval;
//
//   @HiveField(13)
//   String plug_in_reports;
//
//   @HiveField(14)
//   String activity_log;
//
//   @HiveField(15)
//   String notice;
//
//   @HiveField(16)
//   String sync_data;
//
//   ButtonNameModel({
//     required this.new_order,
//     required this.draft_order,
//     required this.order_report,
//     required this.new_dcr,
//     required this.draft_dcr,
//     required this.dcr_report,
//     required this.seen_rx_capture,
//     required this.draft_seen_rx,
//     required this.seen_rx_report,
//     required this.attendance,
//     required this.expense,
//     required this.tour_plan,
//     required this.approval,
//     required this.plug_in_reports,
//     required this.activity_log,
//     required this.notice,
//     required this.sync_data,
//   });
// }
