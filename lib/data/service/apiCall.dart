// ignore_for_file: avoid_print, non_constant_identifier_names, file_names, unused_local_variable, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../core/constant.dart';
import '../../main.dart';
import '../../features/pages/DCR_section/dcr_list_page.dart';
import '../../features/pages/attendance_page.dart';
import '../../features/pages/homePage.dart';
import '../../features/pages/loginPage.dart';
import '../../features/pages/order_sections/customerListPage.dart';
import '../../features/pages/target_achievemet.dart';
import '../datasources/local_storage/boxes.dart';
import '../datasources/local_storage/hive_data_model.dart';
import '../models/late_attendance_report_model.dart';
import '../models/order_approval_model.dart';
import 'all_service.dart';
import 'auth_services.dart';


String timer_track_url = "";
String sync_notice_url = "";
String expenseSubmit = "";
String expenseType = "";
String sync_url = "";
String reportAttMtr = "";
String report_exp_log = "";
String cid = "";
String user_id = "";
String user_pass = "";
String device_id = "";
// String att_apprroval_url = "";
String late_attendance_url = "";
// String late_attendance_report_url = "";
final databox = Boxes.allData();

getboxData() {
  timer_track_url = databox.get("timer_track_url");
  expenseSubmit = databox.get("exp_submit_url");
  expenseType = databox.get("exp_type_url");
  sync_url = databox.get("sync_url");
  reportAttMtr = databox.get("report_atten_url");
  sync_notice_url = databox.get("sync_notice_url");
  report_exp_log = databox.get("report_exp_log");
  // att_apprroval_url = databox.get("att_approval_url");
  late_attendance_url = databox.get('late_attendance_url');
  // late_attendance_report_url = databox.get(' late_attendance_report_url');
  cid = databox.get("CID");
  user_id = databox.get("USER_ID");
  user_pass = databox.get("PASSWORD");
  device_id = databox.get("deviceId");
}

///*************************************************** *************************************///
///******************************** Reset Password **********************************************///
///******************************** ********************************************************///

Future ResetPass(sync_url, oldPass, newPass, conPass, context) async {
  getboxData();
  debugPrint(device_id);
  debugPrint('$sync_url' "api_utility/change_password");
  final response = await http.post(
    Uri.parse('$sync_url' "api_utility/change_password"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "cid": cid,
      "user_id": user_id,
      "user_pass": user_pass,
      "device_id": device_id,
      "old_pass": oldPass,
      "new_pass": newPass,
      "con_pass": conPass,
    }),
  );

  var statusCode = response.statusCode;
  if (statusCode == 200) {
    var data = json.decode(response.body);
    print("======================== $data");

    if (data['status'] == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['ret_str'].toString()}')));
      // Navigator.push(
      //     cont, MaterialPageRoute(builder: (_) => const LoginScreen()));
      // debugPrint('reset');

      // change password successful then all pevius route close and push login page
      await AuthServices.logOut(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['ret_str'].toString()}')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('InCompleted Reset Password')));
  }
  return "Null";
}

///*************************************************** *************************************///
///******************************** Area page **********************************************///
///******************************** ********************************************************///

Future<List> getAreaPage(
    areaPageUrl, String cid, String userId, String userPassword) async {
  print(
       'Area data $areaPageUrl?cid=$cid&user_id=$userId&user_pass=$userPassword');
      //'Area data http://192.168.0.153:8000/hamdard_api/api_area/area_list?cid=$cid&user_id=$userId&user_pass=$userPassword');
  List arePageList = [];

  try {
    final http.Response res = await http.get(
        Uri.parse(
             '$areaPageUrl?cid=$cid&user_id=$userId&user_pass=$userPassword'),
            //'http://192.168.0.153:8000/hamdard_api/api_area/area_list?cid=$cid&user_id=$userId&user_pass=$userPassword'),
        headers: <String, String>{
          'Content-Type': 'appliscation/json; charset=UTF-8'
        });

    var areaPageInfo = json.decode(res.body);
    String status = areaPageInfo['status'];
    if (status == 'Success') {
      // arePageList = areaPageDataModelFromJson(res.body);
      arePageList = areaPageInfo['area_list'];
      return arePageList;
    }
    else {
      return arePageList;
    }
  } catch (e) {
    debugPrint('Error message: $e');
  }
  return arePageList;
}

///*************************************************** *************************************///
///******************************** Area Base Client ***************************************///
///******************************** ********************************************************///

Future<bool> getAreaBaseClient(BuildContext context, String syncUrl, cid,
    userId, userPassword, areaId, areaName) async {
  print(
      'client List : $syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword&area_id=$areaId');
  List clientList = [];
  try {
    final http.Response res = await http.get(
        Uri.parse(
            '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword&area_id=$areaId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var clientJsonData = json.decode(res.body);
    String clientStatus = clientJsonData['status'];

    if (clientStatus == 'Success') {
      clientList = clientJsonData['clientList'];

      print("AAAAAAAAAAAAAA8******$areaId");
      print("AAAAAAAAAAAAAA8******$areaName");
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CustomerListScreen(
                    terrorId: areaId,
                    data: clientList,
                    terrorName: areaName,
                  )));
      return false;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('Error message: $e');
  }
  return false;
}


///*************************************************** *************************************///
///******************************** Area Base Order for Approval ***************************///
///******************************** ********************************************************///

Future<List<AreaList>> getOrderApprovalData(orderListUrl, String cid, String userId, String userPassword) async {
  // print('client List : $areaPageUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword');
  print('aaaaaaaaaaaaaaaaaaa');
  List<AreaList> arePageList = [];

  try {
    final http.Response res = await http.get(Uri.parse('$orderListUrl?cid=$cid&user_id=$userId&user_pass=$userPassword'),headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'});
    // final http.Response res = await http.get(Uri.parse('http://192.168.100.235:8000/apex_pharma_api/api_order_list/order_list?cid=apex&user_id=8778&user_pass=1234'));

    // OrderApprovalModel areaPageInfo = json.decode(res.body);
    // var response = body;
    OrderApprovalModel areaPageInfo = OrderApprovalModel.fromJson(json.decode(res.body));
    // OrderApprovalModel areaPageInfo = OrderApprovalModel.fromJson(response);
    String status = areaPageInfo.status!;
    if (status == 'Success') {
      // arePageList = areaPageDataModelFromJson(res.body);
      arePageList = areaPageInfo.areaList ?? [];
      return arePageList;
    } else {
      return arePageList;
    }
  } catch (e) {
    debugPrint('Error message: $e');
  }
  return arePageList;
}


///*************************************************** *************************************///
///******************************** Target Achievement *************************************///
///******************************** ********************************************************///

Future getTarAch(BuildContext context, String userSalesCollAchUrl, cid, userId,
    userPassword, deviceId) async {
  debugPrint(
      '$userSalesCollAchUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId');
  try {
    final http.Response response = await http.get(
        Uri.parse(
            '$userSalesCollAchUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var userInfo = json.decode(response.body);
    var status = userInfo['status'];
    debugPrint(status);
    if (status == 'Success') {
      List tarAchievementList = userInfo['userSalesCollAchList'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TargetAchievement(
                    tarAchievementList: tarAchievementList,
                  )));
    } else {
      // _submitToastforOrder2();
    }
  } on Exception catch (_) {
    // throw Exception("Error on server");
    Fluttertoast.showToast(msg: "No Target Achievement ");
  }
}

///*************************************************** *************************************///
///******************************** Order History ******************************************///
///******************************** ********************************************************///

Future getOrderHistory() async {
  try {
    final http.Response response = await http.get(
        Uri.parse(
            'http://w305.yeapps.com/acme_api/api_ord_history/ord_history'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var orderHistoryInfo = json.decode(response.body);
    String status = orderHistoryInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    debugPrint('Order History error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** Invoice History ******************************************///
///******************************** ********************************************************///

Future getInvoiceHistory() async {
  try {
    final http.Response response = await http.get(
        Uri.parse(
            'http://w305.yeapps.com/acme_api/api_inv_history/inv_history'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var invoiceHistoryInfo = json.decode(response.body);
    String status = invoiceHistoryInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    debugPrint('Invoice history error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** OutStanding Details ***********************************///
///******************************** ********************************************************///

Future getOutStandingDetails() async {
  try {
    final http.Response response = await http.get(
        Uri.parse('http://w305.yeapps.com/acme_api/api_os_details/os_details'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var outDetailsInfo = json.decode(response.body);
    String status = outDetailsInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    debugPrint('OutStanding Details error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** Edit URL *************************************///
///******************************** ********************************************************///
///
///
///

Future timeTracker(
    String location, cid, userid, userpass, deviceid, timer_track_url) async {
  try {
    var _url =
        "$timer_track_url?cid=$cid&user_id=$userid&user_pass=$userpass&device_id=$deviceid&locations=$location";

    final response = await http.post(Uri.parse(_url));
    print(_url);
    var body = jsonDecode(response.body);

    return body;
  } catch (e) {
    print(e);
  }
}

///*************************************************** *************************************///
///******************************** Attendance  ******************************************///
///******************************** ********************************************************///
Future attendanceAPI(BuildContext context, String submitType, reportAttendance,
    userName, mtrReading, double? lat, double? long, String address) async {
  print(1);
  DateTime now = DateTime.now();
  String todaydate = DateFormat('yyyy-MM-dd').format(now);

  print("------------------------$todaydate");
  bool isclick = true;
  String finalExpenseStr = '';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  getboxData();
  if (submitType == "END") {
    finalExpenseStr = await draftExpenseListAutoSubmit();
  }

  String latitude =
      (minLatitude <= lat! && lat <= maxLatitude) ? lat.toString() : '';
  String longitude =
      (minLongitude <= long! && long <= maxLongitude) ? long.toString() : '';
  String attendanceAddress = ((minLatitude <= lat && lat <= maxLatitude) &&
          (minLongitude <= long && long <= maxLongitude))
      ? address
      : '';
  String url =
      "${sync_url}api_attendance_submit_meter/submit_data?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&submit_type=$submitType&meter_reading=$mtrReading&exp_data=$finalExpenseStr&app_version=$appVersion&latitude=$latitude&longitude=$longitude&address=$attendanceAddress"; ///main url
       //"http://192.168.100.219:8000/physician_api/api_attendance_submit_meter/submit_data?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&submit_type=$submitType&meter_reading=$mtrReading&exp_data=$finalExpenseStr&app_version=$appVersion&latitude=$latitude&longitude=$longitude&address=$attendanceAddress";
  debugPrint(
      "attendance api:::${sync_url}api_attendance_submit_meter/submit_data?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&submit_type=$submitType&meter_reading=$mtrReading&exp_data=$finalExpenseStr&app_version=$appVersion&latitude=$latitude&longitude=$longitude&address=$attendanceAddress");
      //"attendance api::: http://192.168.100.219:8000/physician_api/api_attendance_submit_meter/submit_data?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&submit_type=$submitType&meter_reading=$mtrReading&exp_data=$finalExpenseStr&app_version=$appVersion&latitude=$latitude&longitude=$longitude&address=$attendanceAddress",);

      debugPrint(url);
  print(url);
  if (reportAttendance == true && isclick) {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = json.decode(response.body);
    debugPrint(response.toString());
    debugPrint("data:  ${data["status"]}");
    if (data["status"] == "Success") {
      print("*******************API Hided**************");
      // bool need_approval = data["need_approval"] ?? null;
      // bool need_approval = true;
      var returnString = data["ret_str"];
      var startTime = data["start_time"];
      // var startTime = "";
      var endTime = data["end_time"];
      bool background_service = data["background_service"] ?? false;
      String meter_reading_last = data["meter_reading_last"];
      reportAttendance = false;


      if (submitType.toString() == 'START') {
        databox.put('attendance', todaydate);
        databox.put('attendanceUserId', user_id.toString());
        await _secureStorage.write(
            key: 'background_service',
            value: "${background_service.toString()}");
        await _secureStorage.write(key: 'notice_api_hit' , value: 'true');
        //await restartBackgroundService();
      } else if (submitType.toString() == 'Approval') {
        databox.put('need_approval', false);
      } else {
        databox.put('attendance', '');
        await Hive.box<dynamic>("draftForExpense").clear();
        await _secureStorage.write(key: 'notice_api_hit' , value: 'false');
        await _secureStorage.write(key: 'background_service', value: "false");
        await mydatabox.put('first_notice_api_hit', false);
        //await stopBackgroundService();
      }
      // await databox.put('need_approval', need_approval);
      await databox.put('startTime', startTime);
      await databox.put('endTime', endTime);
      await databox.put('meter_reading_last',
          meter_reading_last.isNotEmpty ? meter_reading_last : '0');
      await databox.put('present', todaydate);
      databox.put('submitType', submitType);
      // need_approval == true ?
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AttendanceScreen()))
      //     :
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            userName: userName,
            user_id: user_id,
            userPassword: user_pass,
          ),
        ),
      );
    }
    else if (data['ret_str'].toString().toLowerCase().contains('http') && data['status'] == 'Failed' )
    {
      String update_app_url = '';
      String update_app_notification = '';
      if(data['ret_str'].toString().contains('http')){
        int index = data['ret_str'].toString().indexOf("http");
        //
        update_app_notification = data['ret_str'].toString().substring(0, index).trim() ?? '';
        // debugPrint(update_app_notification);

        update_app_url =
            data['ret_str'].toString().substring(index).trim() ?? '';
      }
      await databox.put('update_new_app',update_app_notification);
      await databox.put('update_new_app_url',update_app_url);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('${orderInfo['ret_str']}'),
      //     backgroundColor: Colors.red));
      AllServices().messageForUser(data['ret_str']);
      // setState(() {
      //   _isLoading = true;
      // });
      // debugPrint(update_app_url);

      if(update_app_url != null || update_app_url != '') {
        AllServices().showMap(update_app_url);
      }


    }
    else {
      AllServices().messageForUser(
        data["ret_str"],
      );
      // Fluttertoast.showToast(
      //   msg: data["ret_str"],
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.SNACKBAR,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
    }
  } else {
    Fluttertoast.showToast(
        msg: 'End Time has been Submitted for Today',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

///*************************************************** *************************************///
///******************************** Expense Entry ******************************************///
///******************************** ********************************************************///

expenseEntry() async {
  getboxData();
  debugPrint("$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            '$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var orderHistoryInfo = json.decode(response.body);

    String status = orderHistoryInfo['status'];
    List<dynamic> expTypeList = orderHistoryInfo['expTypeList'];

    if (status == 'Success') {
      return expTypeList;
    }
  } catch (e) {
    debugPrint('Order History error message: $e');
  }
  return "error";
}

Future<String> draftExpenseListAutoSubmit() async {
  Box<dynamic> expenseBox = await Hive.box<dynamic>("draftForExpense");
  String expenseListString = '';

  for (int i = 0; i < expenseBox.length; i++) {
    var boxKey = expenseBox.keyAt(i);
    var date = boxKey.toString().split(' ')[0];
    DateTime parsedDate = DateFormat('M/d/yyyy').parse(date);
    String expenseDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    var expenseCategory = boxKey.toString().split(' ')[1];
    dynamic data = expenseBox.get(boxKey);

    if (data is Map<String, dynamic>) {
      String itemString = '';
      itemString = '$expenseDate||$expenseCategory|1';
      data.forEach((key, value) {
        if (double.parse(value['amount'].toString()) > 0) {
          itemString += '||$key|${value['amount']}';
        }
      });

      if (itemString.isNotEmpty) {
        if (expenseListString.isEmpty) {
          expenseListString = itemString;
        } else {
          expenseListString += "|||$itemString";
        }
      }
    } else {
      String itemString = '';
      itemString = '$expenseDate||$expenseCategory|1';
      data.forEach((key, value) {
        if (double.parse(value['amount'].toString()) > 0) {
          itemString += '||$key|${value['amount']}';
        }
      });

      if (itemString.isNotEmpty) {
        if (expenseListString.isEmpty) {
          expenseListString = itemString;
        } else {
          expenseListString += "|||$itemString";
        }
      }
    }
  }

  var expense = expenseListString.split('|||');
  Map<String, List<String>> groupedEntries = {};

  for (String entry in expense) {
    if (entry.isNotEmpty) {
      String date = entry.substring(0, entry.indexOf("||"));
      String value = entry.substring(entry.indexOf("||") + 2);
      String exType = value.split("||")[0].toString().split("|")[0];
      var str = '';
      for (int i = 1; i < value.split("||").length; i++) {
        if (str.isEmpty) {
          str = value.split("||")[i];
        } else {
          str += "||${value.split("||")[i]}";
        }
      }
      String eValue = "";
      if (str.isEmpty) {
        eValue = "($exType)|1";
      } else {
        eValue = "($exType)|1||$str";
      }
      groupedEntries.putIfAbsent(date, () => []).add(eValue);
    }
  }
  String finalExpenseString = '';
  groupedEntries.forEach((key, value) {
    var expenseStr = '';
    for (int i = 0; i < value.length; i++) {
      if (expenseStr.isEmpty) {
        expenseStr = "<day_start>$key|||${value[i]}";
      } else {
        expenseStr += "|||${value[i]}";
      }
    }
    expenseStr += '<day_end>';
    finalExpenseString += "$expenseStr";
  });
  return finalExpenseString;
}

///*************************************************** *************************************///
///******************************** Expense Submit ******************************************///
///******************************** ********************************************************///

SubmitToExpense(expDAteforSubmit, itemString) async {
  try {
    // await getboxData();
    debugPrint(
        "$expenseSubmit?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date=$expDAteforSubmit&exp_data=$itemString");

    final http.Response response = await http.get(
        Uri.parse(
            "$expenseSubmit?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date=$expDAteforSubmit&exp_data=$itemString"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var ExpenseSubmitInfo = jsonDecode(response.body);
    // debugPrint(ExpenseSubmitInfo);
    // String status = orderHistoryInfo['status'];
    // List expTypeList = orderHistoryInfo['expTypeList'];
    return ExpenseSubmitInfo;

    // if (status == 'Success') {
    //   return "200";
    //   // return expTypeList;

    // }
  } catch (e) {
    debugPrint('Expense Submit error message: $e');
  }
  return "error";
}

///*************************************************** *************************************///
///******************************** Expense LOG/EXPENSE REPORT ******************************************///
///******************************** ********************************************************///

ExpenseReport() async {
  getboxData();
  debugPrint(
      "${report_exp_log}expense_history_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id");

  try {
    final http.Response response = await http.get(
      Uri.parse(
          "${report_exp_log}expense_history_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id"),
      // headers: <String, String>{
      //   'Content-Type': 'Application/json; charset=UTF-8'
      // }
    );

    var ExpenseHistoryInfo = json.decode(response.body);

    // debugPrint(ExpenseHistoryInfo);

    return ExpenseHistoryInfo;
  } catch (e) {
    debugPrint('Expense History error message: $e');
  }
  return "error";
}

///*************************************************** *************************************///
///******************************** Notice [[Homepage]] *******************************///
///******************************** ********************************************************///

Future<List<NoticeListModel>> noticeEvent() async {
  log('api hitted');
  final noticeBox = Hive.box<NoticeListModel>('noticeList');

  // Clear the existing data in the Hive box
  getboxData();
  debugPrint(
      "notice api: $sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass"
          // "http://192.168.100.244:8000/hamdard_api/api_notice/notice_list?cid=HAMDARD&user_id=9001&user_pass=1234"
  );
  try {
    print(sync_notice_url);
    final http.Response response = await http.get(
      // Uri.parse(
      // "http://192.168.100.244:8000/hamdard_api/api_notice/notice_list?cid=HAMDARD&user_id=9001&user_pass=1234"),
      Uri.parse(
          "$sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    var noticeDetails = json.decode(response.body);
    String status = noticeDetails['status'];
    debugPrint('noticeList');
    List<NoticeListModel> noticeList = (noticeDetails['noticeList'] as List)
        .map((item) => NoticeListModel.fromJson(item))
        .toList();
        // List<NoticeListModel>.from(noticeDetails['noticeList']);
    // List<Map<String, dynamic>> noticeList = [];
    // String target_amount = noticeDetails['target_amount'];

    if (status == "Success") {
      log('notice api hitted and success');
      print(noticeDetails);
      databox.put('target_amount', noticeDetails['target_amount'] == null || noticeDetails['target_amount'] == "" ? '0' : AllServices().formatAndRoundNumber(noticeDetails['target_amount']));
      databox.put('sales_amount', noticeDetails['sales_amount'] == null || noticeDetails['sales_amount'] == "" ? '0' : AllServices().formatAndRoundNumber(noticeDetails['sales_amount']));
      databox.put('achievement_amount', noticeDetails['achievement_amount'] == null || noticeDetails['achievement_amount'] == "" ? '0' : noticeDetails['achievement_amount']);
      // databox.put('sales_amount', noticeDetails?['sales_amount']  ?? '0');
      // databox.put('achievement_amount', noticeDetails?['achievement_amount']  ?? '0');
      // databox.put('target_amount', '120');
      // databox.put('sales_amount', '18800.12132');
      // databox.put('achievement_amount', '55.658dfg36545f%');
      await noticeBox.clear();
      print(noticeList);
      return noticeList;
    } else {
      return [];
    }
  } catch (e) {
    debugPrint('notice error message: $e');
    return [];
  }
}

///*************************************************** *************************************///
///******************************** ExpApprovarl Lists [[expense]] ******************************************///
///******************************** ********************************************************///

expensapprovel(
    {String? cid,
    ff_type,
    user_id,
    user_pass,
    device_id,
    exp_date_from,
    exp_date_to,
    exp_url}) async {
  debugPrint(
      "${exp_url}expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type");
      // "http://192.168.0.102:8000/ipi_combined_api/api_expense_approval/expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type");

  try {
    final response = await http.get(
      Uri.parse(
          "${exp_url}expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type"),
          // "http://192.168.0.102:8000/ipi_combined_api/api_expense_approval/expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List approvalDatalist = data['expList'];

      // debugPrint(approvalDatalist);

      return approvalDatalist;
    } else {
      return 'error';
    }
  } catch (e) {
    print(e);
  }

  return "error";
}

///*************************************************** *************************************///
///******************************** ExpApprovarl 0f Reject [[expense]] ******************************************///
///******************************** ********************************************************///

expenseApproveAndReject(
    {String? cid,
    ff_type,
    user_id,
    user_pass,
    device_id,
    exp_date_from,
    exp_date_to,
    exp_url,
    status,
    exp_string,
    reasonController}) async {
  debugPrint(
      "${exp_url}update_status_emp_exp_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type&emp_id_list=$exp_string&status=$status&reject_reason=$reasonController");
  Response? data;
  var dat;
  try {
    final Response data = await http.get(
      Uri.parse(
          "${exp_url}update_status_emp_exp_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type&emp_id_list=$exp_string&status=$status&reject_reason=$reasonController"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (data.statusCode == 200) {
      var dat = jsonDecode(data.body);
      return dat;
    } else {
      return 'error';
    }
  } catch (e) {
    print(e);
  }

  return dat;
}

///*************************************************** *************************************///
///******************************** Exp Emp Details List[[expense]] ******************************************///
///******************************** ********************************************************///

ExpEmpDetailsList(
    {String? cid,
    ff_type,
    user_id,
    user_pass,
    device_id,
    exp_date_from,
    exp_date_to,
    exp_url,
    emp_id}) async {
  debugPrint(
      "${exp_url}emp_expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&emp_id=$emp_id");

  try {
    final response = await http.get(
      Uri.parse(
          "${exp_url}emp_expense_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type&emp_id=$emp_id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // debugPrint('api data $data');

      List approvalDatalistData = data['expList'];

      // debugPrint('in list api $approvalDatalistData');

      return approvalDatalistData;
    } else {
      return 'error';
    }
  } catch (e) {
    print(e);
  }

  return "error";
}

///*************************************************** *************************************///
///********************************Emp ExpApprovarl 0f Reject Details [[expense]] ******************************************///
///******************************** ********************************************************///

Future expenseEmpApproveAndRejectDetels(
    {String? cid,
    ff_type,
    user_id,
    user_pass,
    device_id,
    exp_date_from,
    exp_date_to,
    exp_url,
    emp_id,
    emp_id_exp_sl_list,
    status,
    reasonController}) async {
  debugPrint(
      "${exp_url}update_status_emp_exp_sl_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type&emp_id=$emp_id&emp_id_exp_sl_list=$emp_id_exp_sl_list&status=$status&reject_reason=$reasonController");
  Response? data;
  var dat;
  try {
    final Response data = await http.get(
      Uri.parse(
          "${exp_url}update_status_emp_exp_sl_list?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date_from=$exp_date_from&exp_date_to=$exp_date_to&ff_type=$ff_type&emp_id=$emp_id&emp_id_exp_sl_list=$emp_id_exp_sl_list&status=$status&reject_reason=$reasonController"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (data.statusCode == 200) {
      var dat = jsonDecode(data.body);

      // debugPrint('In Api ...........$dat');

      return dat;
    } else {
      return 'error';
    }
  } catch (e) {
    print(e);
  }

  return dat;
}

///*************************************************** *********************************************************///
///********************************Expense Summary *******************************///
///******************************** ***************************************************************************///
ExpenseSummary(
    {String? initialDate,
    String? lastDate,
    String? ffType,
    String? ffuserId}) async {
  getboxData();

  try {
    var _url =
        "${report_exp_log}expense_summary_by_exp_head?cid=$cid&user_id=$user_id&user_pass=$user_pass&date_from=$initialDate&date_to=$lastDate&ff_type=$ffType&ff_user_id=$ffuserId";
    print(_url);
    final http.Response response = await http.get(Uri.parse(_url),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var expenseSummary = json.decode(response.body);
    // debugPrint(expenseSummary);
    String status = expenseSummary['status'];
    List expSumList = expenseSummary['expSumList'];
    if (status == "Success") {
      return expSumList;
    } else {
      return "error";
    }
  } catch (e) {
    debugPrint('notice error message: $e');
  }
  return "error";
}

///*************************************************** *********************************************************///
///********************************Attendance & Meter Reading History *****************************************///
///******************************** ***************************************************************************///
AttendanceMtrHistory() async {
  getboxData();
  debugPrint("$reportAttMtr?cid=$cid&user_id=$user_id&user_pass=$user_pass");
  try {
    final http.Response response = await http.get(
        Uri.parse(
            "$reportAttMtr?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var attenMtr = json.decode(response.body);
    // debugPrint(attenMtr);
    String status = attenMtr['status'];
    List attenMtrList = attenMtr['meterReadingList'];
    //  debugPrint(attenMtrList);
    if (status == "Success") {
      return attenMtrList;
    } else {
      return "error";
    }
  } catch (e) {
    debugPrint('notice error message: $e');
  }
  return "error";
}

/*************************************************** *********************************************************/ //
/********************************Attendance Approval Request*****************************************/ //
/******************************** ***************************************************************************/ //

attendanceApprovalAPI(BuildContext context, String late_reason) async {
  getboxData();
  debugPrint(
      // "$att_apprroval_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&$late_reason");
      "${late_attendance_url}late_atte_request");

  var body = jsonEncode(<String, String>{
    'cid': cid,
    'user_id': user_id,
    'user_pass': user_pass,
    'note': late_reason
  });

  try {
    Response response = await http.post(
        //   Uri.parse("http://192.168.0.102:8000/gulf_api/api_customer/customer_list?cid=gulf&UserId=test420"), body: body, headers: <String, String>{
        // 'Content-Type': 'Application/json; charset=UTF-8'
        Uri.parse("${late_attendance_url}late_atte_request"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var bodyData = jsonDecode(response.body);
    String status = bodyData['status'];
    // String status = 'success';
    print(status.toString());
    // String message = bodyData['message'];
    if (status == "Success") {
      Fluttertoast.showToast(
          msg: 'Request submitted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: const Color.fromARGB(255, 121, 192, 153),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
          context, MaterialPageRoute(builder: (_) => AttendanceScreen()));
      return "Success";
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong. \n Please try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "error";
    }
  } catch (e) {
    debugPrint("Failed!");
  }
  return "error";
}

/*************************************************** *********************************************************/ //
/********************************Late Attendance Report*****************************************/ //
/******************************** ***************************************************************************/ //

lateAttendanceReportApi() async {
  getboxData();
  debugPrint(
      // "$att_apprroval_url?cid=$cid&user_id=$user_id&user_pass=$user_pass&");
      "${late_attendance_url}late_atte_req_report?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  var body = {
    'cid': cid,
    'user_id': user_id,
    'user_pass': user_pass,
  };

  try {
    Response response = await http.get(
        Uri.parse("${late_attendance_url}late_atte_req_report?cid=$cid&user_id=$user_id&user_pass=$user_pass"));
    var bodyData = jsonDecode(response.body);
    // var bodyData1 = json.decode(jsonBody);
    String status = bodyData['status'];
    // String status = 'success';
    print(status.toString());
    // String message = bodyData['message'];
    if (status == "Success") {
      print("entered to success");
      LateAttendanceReportModel dataList =
          LateAttendanceReportModel.fromJson(bodyData);
      print(dataList.dataList);
      return dataList.dataList;
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "error";
    }
  } catch (e) {
    debugPrint("Failed!");
  }
  return "error";
}

///*************************************************** *********************************************************///
///********************************Low Users get claint & doc *****************************************///
///******************************** ***************************************************************************///

getClaintandDoctot() async {
  getboxData();
  debugPrint(
       //"doctor:${sync_url}api_rep_client_dcr/rep_client_dcr?cid=$cid&user_id=$user_id&user_pass=$user_pass");
       "visit branch office list:${sync_url}api_branch_office_list/get_branch_office_list?cid=$cid&user_id=$user_id&user_pass=$user_pass");


  try {
    final http.Response response = await http.get(
      Uri.parse(
           //"${sync_url}api_rep_client_dcr/rep_client_dcr?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
           "${sync_url}api_branch_office_list/get_branch_office_list?cid=$cid&user_id=$user_id&user_pass=$user_pass"),

    );

    Map bodyData = json.decode(response.body);

    // debugPrint(ExpenseHistoryInfo);

    return bodyData;
  } catch (e) {
    debugPrint('Expense History error message: $e');
  }
  return {};
}

///*************************************************** *************************************///
///******************************** Area Base DocTor ***************************************///
///******************************** ********************************************************///

Future<bool> getAreaBaseDoctor(BuildContext context, String syncUrl, cid,
    userId, userPassword, areaId, areaName) async {
  print(
       'client List : ${syncUrl}api_sup_dcr/sup_dcr?cid=$cid&user_id=$userId&user_pass=$userPassword&territory=$areaId');
      //'client List : http://192.168.0.153:8000/hamdard_api/api_sup_dcr/sup_dcr?cid=HAMDARD&user_id=946&user_pass=3695&territory=M0631d');
  //'client List : http://192.168.100.239:8000/hamdard_api/api_sup_dcr/sup_dcr?cid=$cid&user_id=$userId&user_pass=$userPassword&territory=$areaId');
  List doctorList = [];
  try {
    final http.Response res = await http.get(
        Uri.parse(
             '${syncUrl}api_sup_dcr/sup_dcr?cid=$cid&user_id=$userId&user_pass=$userPassword&territory=$areaId'),
            //'http://192.168.0.153:8000/hamdard_api/api_sup_dcr/sup_dcr?cid=HAMDARD&user_id=946&user_pass=3695&territory=M0631'),
        //'http://192.168.100.239:8000/hamdard_api/api_sup_dcr/sup_dcr?cid=$cid&user_id=$userId&user_pass=$userPassword&territory=$areaId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var clientJsonData = json.decode(res.body);
    String clientStatus = clientJsonData['status'];

    if (clientStatus == 'Success') {
      doctorList = clientJsonData['doctor'][0]["doctorlist"];
      print("-----------------------------------------------------");
      print(doctorList);
      print("************************************");

      print("AAAAAAAAAAAAAA8******$areaId");
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DcrListPage(
                    visitOfficeDataList: doctorList,
                    branchId: areaId,
                    branchName: areaName,
                  )));
      return false;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('Error message: $e');
  }
  return false;
}

Future<List<String>> getFFList(
    {String? cid, String? userId, String? userPass, String? ffType}) async {
  var _url =
      "http://ww11.yeapps.com/ipi_api/api_expense_summary/expense_summary_ff?cid=$cid&user_id=$userId&user_pass=$userPass&ff_type=$ffType";
  print(_url);
  http.Response response = await http.get(Uri.parse(_url));
  List<String> ffList = [];
  if (response.statusCode == 200) {
    ffList.clear();
    var data = jsonDecode(response.body);
    if (data['status'] == "Success") {
      List replist = data['replist'];
      for (var i in replist.toList()) {
        ffList.add(i);
      }
    } else {
      AllServices().messageForUser("${data['ret_str'] ?? ''}");
    }
  } else {
    AllServices().messageForUser("Connection Erro");
  }
  return ffList;
}

Future expenseReSubmit(
    {required String expenseData,
    required String date,
    required String refSL}) async {
  await getboxData();
  String _url =
      "${sync_url}api_expense_edit_submit/submit_data_edit_exp?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date=$date&ref_sl=$refSL&exp_data=$expenseData";
  print(_url);
  http.Response response = await http.post(Uri.parse(_url));
  return response;
}
