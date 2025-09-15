class LateAttendanceReportModel {
  String? status;
  List<DataList>? dataList;

  LateAttendanceReportModel({this.status, this.dataList});

  LateAttendanceReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data_list'] != null) {
      dataList = <DataList>[];
      json['data_list'].forEach((v) {
        dataList!.add(new DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataList != null) {
      data['data_list'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  String? submittedDatetime;
  String? status;
  String? note;

  DataList({this.submittedDatetime, this.status, this.note});

  DataList.fromJson(Map<String, dynamic> json) {
    submittedDatetime = json['submitted_datetime'];
    status = json['status'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submitted_datetime'] = this.submittedDatetime;
    data['status'] = this.status;
    data['note'] = this.note;
    return data;
  }
}
