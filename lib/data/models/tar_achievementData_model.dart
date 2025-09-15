// To parse this JSON data, do
//
//     final targetAchievement = targetAchievementFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TargetAchievement targetAchievementFromJson(String str) =>
    TargetAchievement.fromJson(json.decode(str));

String targetAchievementToJson(TargetAchievement data) =>
    json.encode(data.toJson());

class TargetAchievement {
  TargetAchievement({
    required this.status,
    required this.userSalesCollAchList,
  });

  final String status;
  final List<UserSalesCollAchList> userSalesCollAchList;

  factory TargetAchievement.fromJson(Map<String, dynamic> json) =>
      TargetAchievement(
        status: json["status"],
        userSalesCollAchList: List<UserSalesCollAchList>.from(
            json["userSalesCollAchList"]
                .map((x) => UserSalesCollAchList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userSalesCollAchList":
            List<dynamic>.from(userSalesCollAchList.map((x) => x.toJson())),
      };
}

class UserSalesCollAchList {
  UserSalesCollAchList({
    required this.repId,
    required this.salesAchv,
    required this.collAchv,
  });

  final String repId;
  final double salesAchv;
  final double collAchv;

  factory UserSalesCollAchList.fromJson(Map<String, dynamic> json) =>
      UserSalesCollAchList(
        repId: json["rep_id"],
        salesAchv: json["sales_achv"].toDouble(),
        collAchv: json["coll_achv"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rep_id": repId,
        "sales_achv": salesAchv,
        "coll_achv": collAchv,
      };
}
