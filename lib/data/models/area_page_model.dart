// To parse this JSON data, do
//
//     final areaPageDataModel = areaPageDataModelFromJson(jsonString);

import 'dart:convert';

AreaPageDataModel areaPageDataModelFromJson(String str) =>
    AreaPageDataModel.fromJson(json.decode(str));

String areaPageDataModelToJson(AreaPageDataModel data) =>
    json.encode(data.toJson());

class AreaPageDataModel {
  AreaPageDataModel({
    required this.status,
    required this.areaList,
  });

  final String status;
  final List<AreaList> areaList;

  factory AreaPageDataModel.fromJson(Map<String, dynamic> json) =>
      AreaPageDataModel(
        status: json["status"],
        areaList: List<AreaList>.from(
            json["area_list"].map((x) => AreaList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "area_list": List<dynamic>.from(areaList.map((x) => x.toJson())),
      };
}

class AreaList {
  AreaList({
    required this.areaId,
    required this.areaName,
  });

  final String areaId;
  final String areaName;

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
        areaId: json["area_id"],
        areaName: json["area_name"],
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
      };
}
