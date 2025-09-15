// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'dart:ui';
import 'package:android_id/android_id.dart';
//import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:path_provider/path_provider.dart';
import 'package:physician_latest/features/pages/splash_screen.dart';
import 'package:physician_latest/features/pages/syncDataTabPaga.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';
import '../../data/service/all_service.dart';
import '../../data/service/apiCall.dart';
import '../../data/service/auth_services.dart';
import '../../data/service/network_connectivity.dart';
import '../../main.dart';
import 'homePage.dart';
//export 'package:flutter_background_service/flutter_background_service.dart';
//export 'package:flutter_background_service_android/flutter_background_service_android.dart';

List<String> dcr_visitedWithList = [];
List<String> rxTypeList = [];
List<String> salesTypeList=[];
List<String> patientTypeList=[];
List<String> systemNameList=[];
List<String> patientTemperamentList=[];

List<String> exp_reject_reasonList = [];
List<String> user_basis_level_list = [];
List<String> causeForNonExecution = [];
//List<String> branchList = [];
//List<dynamic> branchList = [];

bool offer_flag = false;
bool? note_flag;
bool? client_edit_flag;
bool? os_show_flag;
bool? os_details_flag;
bool? ord_history_flag;
bool? inv_histroy_flag;
// bool? timer_flag;
bool? rx_doc_must;
bool? rx_type_must;
bool? rx_gallery_allow;
int? notice_reload_duration;

final mydatabox = Boxes.allData();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _companyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  double screenHeight = 0;
  double screenWidth = 0;
  Color initialColor = Colors.white;
  bool _obscureText = true;
  List<String> visitedWith = [];
  List<String> rxType = [];
  String deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? savedUserId = '';
  bool isLoading = false;
  bool timer_flag = false;
  bool background_service = false;
  final box = Boxes.allData();
  String update_app_notification = '';
  String update_app_url = '';

  String address = "";

  String version = "test";
  String DeviceId='';

  bool? serviceEnabled;
  // PermissionStatus? permissionGranted;

  // Location location = Location();

  @override
  initState() {
    super.initState();
    if (mounted) {
      AllServices().getPermission();

      getLatLong();
      _getDeviceInfo();
      getDeviceAndroidInfo();

      if (box.get("CID") != null) {
        var a = box.get("CID");
        savedUserId = box.get('user_id');
        setState(() {
          _companyIdController.text = a.toString();
        });
      }
      update_app_notification = box.get('update_new_app') ?? '';
      update_app_url = box.get('update_new_app_url') ?? '';


      debugPrint("offer flag result $offer_flag");
    }
  }

  Future _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    DeviceId = await getDeviceAndroidInfo();


    var androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = DeviceId;
    print('xxxxxxx ${deviceId.toString()}');
    //deviceId = androidDeviceInfo.id!;
    deviceBrand = androidDeviceInfo.brand!;
    deviceModel = androidDeviceInfo.model!;

    // try {
    //   deviceId = (await PlatformDeviceId.getDeviceId)!;
    //   // debugPrint(deviceId);
    // } on PlatformException {
    //   deviceId = 'Failed to get deviceId.';
    // }
    // All_SharePreference().setDeviceInfo(deviceId, deviceBrand, deviceModel);
    //!Share preference
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('deviceId', deviceId);
    // await prefs.setString('deviceBrand', deviceBrand!);
    // await prefs.setString('deviceModel', deviceModel!);

    //todo!   add Hive
    box.put('deviceId', deviceId);
    box.put('deviceBrand', deviceBrand!);
    box.put('deviceModel', deviceModel!);

    print("Device ID: $deviceId");
    print("Brand: $deviceBrand");
    print("Model: $deviceModel");
  }


  Future<String> getDeviceAndroidInfo() async {
    const androidIdPlugin = AndroidId();
    String androidId;
    try {
      androidId = await androidIdPlugin.getId() ?? 'Unknown ID';

    } on PlatformException {
      androidId = 'Failed to get Android ID';
    }
    print('maruf $androidId ');
    return androidId.toString();
  }




  getLatLong() {
    Future<Position> data = AllServices().determinePosition();
    data.then((value) {
      debugPrint("value $value");
      setState(() {
        double latitude = value.latitude;
        double longitude = value.longitude;

        debugPrint("Splass Screen Lat Long :::::::::::::  $latitude : $longitude");

        box.put("latitude", latitude);
        box.put("longitude", longitude);
      });
    }).catchError((error) {
      // debugPrint("Error $error");
    });
  }

  ///******************************************************Function to Store button Names**********************************************************///

  Future<void> putButtonNames(Map<String, dynamic> buttonNames) async {
    Box box = Hive.box('buttonNames');

    try {
      await box.clear(); // Clear the box before adding new data

      buttonNames.forEach((key, value) {
        box.put(key, value); // Store each key-value pair in Hive
      });

      debugPrint("Successfully stored buttonNames in Hive: ${box.toMap()}");
    } catch (e) {
      debugPrint("Error storing buttonNames in Hive: $e");
    }
  }

  ///******************************************************Function to Store button Names**********************************************************///

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    final double safeAreaBotttom = MediaQuery.of(context).padding.bottom;

    return isLoading
        ? Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFE2EFDA),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenHeight - 30,
                    width: screenWidth,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 240,
                                height: 120,
                                child: Image.asset(
                                  'assets/images/mRep7_wLogo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    // Company ID Field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _companyIdController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'Company Id',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.domain_outlined,
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your valid CompanyId';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    // User Id field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _userIdController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'User Id',
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your User Id';
                                        }
                                        if (value.contains("@")) {
                                          return 'Please Provide Your Valid User Id';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    // Password Field
                                    TextFormField(
                                      obscureText: _obscureText,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.vpn_key,
                                          color: Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        suffixIcon: _obscureText == true
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      _obscureText = false;
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_off,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        // RegExp regexp = RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return 'Please enter your password.';
                                        }
                                        // if (value.length >= 6) {
                                        //   return 'Password is too short ,please expand';
                                        // }
                                        return null;
                                      },
                                    ),
                                    // SizedBox(height: screenHeight / 60),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool result = await NetworkConnecticity.checkConnectivity();

                                    if (result == true) {
                                      final userid = box.get("USER_ID");
                                      // debugPrint(
                                      //     "User Iddddddddddadssdfs:$userid");

                                      dmPath(deviceId, deviceBrand, deviceModel, _companyIdController.text.trim().toUpperCase(), _userIdController.text.trim(), _passwordController.text.trim(), context);
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      AllServices().messageForUser('No Internet Connection\nPlease check your internet connection.');

                                      // debugPrint(InternetConnectionChecker()
                                      //     .lastTryResults);
                                    }
                                  } else {}
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    child: Column
                      (
                      children: [
                        update_app_notification == '' ? SizedBox.shrink() : Center(child: GestureDetector(onTap : (){
                          AllServices().showMap(update_app_url);
                        }, child: Container(color: Colors.red, height: 20, width: double.infinity, child: Text(textAlign: TextAlign.center,"Please click here to download new version", style: TextStyle(color: Colors.white),)))),
                        Container(
                          height: 30,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(color: Colors.green.shade300),
                          child: Text(
                            "$appVersion",
                            style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // buildShowDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             CircularProgressIndicator(
  //               color: Colors.white,
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //           ],
  //         );
  //       });
  // }

  ///********************************** Dm Path and Login function***********************************************************

  Future dmPath(String? deviceId, String? deviceBrand, String? deviceModel, String cid, String userId, String password, BuildContext context) async {
    // debugPrint("DM::patht **************: $userId");

    try {
      debugPrint(

      //"dmpath::http://192.168.100.219:8000/physician_api/dmpath_test/get_dmpath?cid=$cid"
      "dmpath::https://w05.yeapps.com/dmpath/dmpath_phy/get_dmpath?cid=$cid"
      );
      final http.Response response = await http.get(
        Uri.parse(
             //'http://192.168.100.219:8000/physician_api/dmpath_test/get_dmpath?cid=$cid'),
            "https://w05.yeapps.com/dmpath/dmpath_phy/get_dmpath?cid=$cid"),
      );
      log(json.decode(response.body).toString(),name: 'bodyyyy');
      var userInfo = json.decode(response.body);
      print('userinfo::$userInfo');

      var status = userInfo['res_data'];
      print('status::$status');
      if (status['ret_res'] == 'Welcome to mReporting.') {
        AllServices().messageForUser("Wrong CID");

        setState(() {
          isLoading = false;
        });
      } else {
        print(status);
        var login_url = status['login_url'];
        String sync_url = status['sync_url']?? '';
        String submit_url = status['submit_url']??'';
        String report_sales_url = status['report_sales_url']??'';
        String report_dcr_url = status['report_dcr_url']??'';
        String report_rx_url = status['report_rx_url']??'';
        String photo_submit_url = status['photo_submit_url']??'';
        String photo_url = status['photo_url']??'';
        String leave_request_url = status['leave_request_url']??'';
        String leave_report_url = status['leave_report_url']??'';
        String plugin_url = status['plugin_url']??'';
        String board_meeting_submit_url = status['board_meeting_submit_url']??'';
        String visit_office_add_url = status['visit_office_add_url']??'';
        String visit_office_edit_url = status['visit_office_edit_url']??'';
        String tour_plan_url = status['tour_plan_url']??'';
        String tour_compliance_url = status['tour_compliance_url']??'';
        String client_url = status['client_url']??'';
        String doctor_url = status['doctor_url']??'';
        String doctor_edit_url = status['doctor_edit_url']??'';
        String microunion_url = status['microunion_url']??'';
        String activity_log_url = status['activity_log_url']??'';
        String user_sales_coll_ach_url = status['user_sales_coll_ach_url']??'';
        String client_outst_url = status['client_outst_url']??'';
        String user_area_url = status['user_area_url']??'';
        String os_details_url = status['os_details_url']??'';
        String ord_history_url = status['ord_history_url']??'';
        String inv_history_url = status['inv_history_url']??'';
        String client_edit_url = status['client_edit_url']??'';
        String timer_track_url = status['timer_track_url']??'';
        String exp_type_url = status['exp_type_url']??'';
        String exp_submit_url = status['exp_submit_url']??'';
        String report_exp_url = status['report_exp_url']??'';
        String report_exp_log = status['report_exp_log']??'';
        String report_outst_url = status['report_outst_url']??'';
        String report_last_ord_url = status['report_last_ord_url']??'';
        String report_last_doc_visit_url = status['report_last_doc_visit_url']??'';
        String report_last_inv_url = status['report_last_inv_url']??'';
        String exp_approval_url = status['exp_approval_url']??'';
        String sync_notice_url = status['sync_notice_url']??'';
        String report_atten_url = status['report_atten_url']??'';
        String approval_url = status['approval_url']??'';
        String late_attendance_url = status['late_attendance_url'] ?? "";
        String order_approval_url = status['order_approval_url'] ?? "";
        String order_list_url = status['order_list_url'] ?? "";
        String check_in_url = status['check_in_url'] ?? "";
        print('check in url::$check_in_url');

        String gift_url = status['gift_url'] ?? "";
        String sample_url = status['sample_url'] ?? "";
        String ppm_url = status['ppm_url'] ?? "";
        String activity_log_areawise_url = status['activity_log_areawise_url'] ?? "";

        String prescriptionReportUrl=status['prescription_report_url'] ?? '';
        print('prescription report url: $prescriptionReportUrl');
        String visiReportUrl=status['visit_report_url'] ?? '';
        print('visit report url: $visiReportUrl');
        String patientCallBoardMeetingReportUrl=status['board_meeting_report_url'] ?? '';
        print('board meeting report url: $patientCallBoardMeetingReportUrl');
        String examUrl=status['exam_url'] ?? '';
        print('exam url: $examUrl');
        String examResultUrl=status['exam_result_url'] ?? '';
        print('exam result url: $examResultUrl');



        // //todo Add HIVe,

        //todo! Start Hive

        await box.put('sync_url', sync_url);
        await box.put('report_sales_url', report_sales_url);
        await box.put('report_dcr_url', report_dcr_url);
        await box.put('report_rx_url', report_rx_url);
        await box.put('submit_url', submit_url);
        await box.put('photo_submit_url', photo_submit_url);
        await box.put('activity_log_url', activity_log_url);
        await box.put('client_outst_url', client_outst_url);
        await box.put('user_area_url', user_area_url);
        await box.put('photo_url', photo_url);
        await box.put('leave_request_url', leave_request_url);
        await box.put('leave_report_url', leave_report_url);
        await box.put('plugin_url', plugin_url);
        await box.put('board_meeting_submit_url', board_meeting_submit_url);
        await box.put('visit_office_add_url', visit_office_add_url);
        await box.put('visit_office_edit_url', visit_office_edit_url);
        await box.put('tour_plan_url', tour_plan_url);
        await box.put('tour_compliance_url', tour_compliance_url);
        await box.put('client_url', client_url);
        await box.put('doctor_url', doctor_url);
        await box.put('doctor_edit_url', doctor_edit_url);
        await box.put('microunion_url', microunion_url);
        await box.put('user_sales_coll_ach_url', user_sales_coll_ach_url);
        await box.put('os_details_url', os_details_url);
        await box.put('ord_history_url', ord_history_url);
        await box.put('inv_history_url', inv_history_url);
        await box.put('client_edit_url', client_edit_url);
        await box.put('timer_track_url', timer_track_url);
        await box.put('exp_type_url', exp_type_url);
        await box.put('exp_submit_url', exp_submit_url);
        await box.put('report_exp_url', report_exp_url);
        await box.put('report_exp_log', report_exp_log);
        await box.put('report_outst_url', report_outst_url);
        await box.put('report_last_ord_url', report_last_ord_url);
        await box.put('report_last_doc_visit_url', report_last_doc_visit_url);
        await box.put('report_last_inv_url', report_last_inv_url);
        await box.put('exp_approval_url', exp_approval_url);
        await box.put('sync_notice_url', sync_notice_url);
        await box.put('report_atten_url', report_atten_url);
        await box.put('approval_url', approval_url);
        await box.put('late_attendance_url', late_attendance_url);
        await box.put('order_approval_url', order_approval_url);
        await box.put('order_list_url', order_list_url);
        await box.put('check_in_url', check_in_url);

        await box.put('gift_url', gift_url);
        await box.put('sample_url', sample_url);
        await box.put('ppm_url', ppm_url);
        await box.put('activity_log_areawise_url', activity_log_areawise_url);

        await box.put('prescription_report_url', prescriptionReportUrl);
        await box.put('visit_report_url', visiReportUrl);
        await box.put('board_meeting_report_url', patientCallBoardMeetingReportUrl);
        await box.put('exam_url', examUrl);
        await box.put('exam_result_url', examResultUrl);



        // await box.put('late_attendance_report_url',late_attendance_report_url);
        await secureStorage.write(key: 'timer_track_url', value: timer_track_url.toString());

        await login(deviceId, deviceBrand, deviceModel, cid, userId, password, login_url, context);
      }

      // return isLoading;
    } on Exception catch (e) {
      // throw Exception(e);
      debugPrint("$e");
    }
  }

  Future login(String? deviceId, String? deviceBrand, String? deviceModel, String cid, String userId, String password, String loginUrl, BuildContext context) async {
    version = 'v03';
    String _url =
        '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=${deviceModel}_${version}&app_version=${appVersion}'; /// main url
         //'http://192.168.100.219:8000/physician_api/api_login/check_user?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=${deviceModel}_${version}&app_version=${appVersion}'; //check local url
    print('login url:::$_url');
    debugPrint(_url);
    try {
      final http.Response response = await http.get(
        Uri.parse(_url),
      );

      // final Map<String, dynamic> jsonresponse = json.decode(response.body);

      var userInfo = json.decode(response.body);
      var status = userInfo['status'];

      if (status == 'Success') {
        setState(() {
          isLoading = true;
        });
        print(userInfo);

        print('user id:${userInfo['user_id']}');
        print('user id1:${userInfo['USER_ID']}');

        String userName = userInfo['user_name'];
        String user_id = userInfo['user_id'];
        String mobile_no = userInfo['mobile_no'];
        String? logo_url_1 = userInfo['logo_url_1'] ?? null;
        String? logo_url_2 = userInfo['logo_url_2'] ?? null;
        List market_name= userInfo['market_list'] ?? [];
        String marketList = market_name
            .map((market) => market.values.first) // Extract the first value from each map
            .join(',');

        List branch= userInfo['branch_list'] ?? [];
        print('branch list: $branch');



        List area_name = userInfo['area_name'] ?? [];
        String user_level = userInfo['user_level'] ?? "";


        String areaName = area_name.map((area) => area.values.first).join(',');
        ///example market name with id DOHAR 1  NARISA BAZAR(D1NGA04M01) commented///
        // String marketList = market_name
        //     .map((market) => "${market.values.first}(${market.keys.first})") // Combine value and key
        //     .join(', ');
        ///****************************************************************************
        // Map<String, dynamic> buttonNames = {
        //   "new_order": "",
        //   "draft_order": "Draft Order",
        //   "order_report": "Report",
        //   // "new_dcr": "New DCR Button",
        //   // "draft_dcr": "Draft DCR Button",
        //   "dcr_report": "DCR Report",
        //   "seen_rx_capture": "RX Sent",
        //   "draft_seen_rx": "Draft Seen Rx",
        //   "seen_rx_report": "Seen RX Report",
        //   "attendance": "Attendance",
        //   "expense": "Expense",
        //   "tour_plan": "Tour Plan",
        //   "approval": "Approval",
        //   "plug_in_reports": "Plug-in & Reports",
        //   "activity_log": "Activity Log",
        //   "notice": "Notice",
        //   "sync_data": "Sync Data",
        //   "leave_request": "Leave Request",
        //   "leave_report":	"Leave Report"
        // };
        Map<String, dynamic>? buttonNames = userInfo['button_names'] ?? {};
        offer_flag = userInfo['offer_flag'];
        note_flag = userInfo['note_flag'];
        client_edit_flag = userInfo['client_edit_flag'];
        os_show_flag = userInfo['os_show_flag'];
        os_details_flag = userInfo['os_details_flag'];
        ord_history_flag = userInfo['ord_history_flag'];
        inv_histroy_flag = userInfo['inv_histroy_flag'];
        background_service = userInfo['background_service'];
        // background_service = true;

        notice_reload_duration = userInfo['notice_reload_duration'] ?? 30;
        // notice_reload_duration = 1;
        timer_flag = userInfo['timer_flag'];
        rx_doc_must = userInfo['rx_doc_must'];
        rx_type_must = userInfo['rx_type_must'];
        rx_gallery_allow = userInfo['rx_gallery_allow'];

        List dcr_visit_with_list = userInfo['dcr_visit_with_list'];

        List rx_type_list = userInfo['rx_type_list'];


        List sales_type_list = userInfo['sales_type_list'] ?? [];
        print('saleeesss::$sales_type_list}');
        List patient_type_list=userInfo['patient_type_list'] ??[];
        print('patienttttt::$patient_type_list}');
        List system_name_list=userInfo['system_name_list'] ?? [];
        print('system nameee::$system_name_list}');
        List system_diseases_list = userInfo['system_diseases_list'] ?? [];
        print('system disease list::$system_diseases_list');
        List patient_temperament_list=userInfo['patient_temperament_list'] ?? [];
        print('patient temperamenttt::$patient_temperament_list');
        List district_thana_list= userInfo['district_thana_list'] ?? [];
        print('District Thana List:: $district_thana_list');

        bool order_flag = userInfo['order_flag'];
        bool dcr_flag = userInfo['dcr_flag'];
        bool rx_flag = userInfo['rx_flag'];
        bool others_flag = userInfo['others_flag'];
        bool client_flag = userInfo['client_flag'];
        bool visit_plan_flag = userInfo['visit_plan_flag'];
        bool plagin_flag = userInfo['plagin_flag'];
        bool patientCallBoardMeeting = userInfo['board_meeting_flag'];
        print('board meeting flag:$patientCallBoardMeeting');
        bool examFlag = userInfo['exam_flag'];
        bool dcr_discussion = userInfo['dcr_discussion'];
        bool promo_flag = userInfo['promo_flag'];
        bool leave_flag = userInfo['leave_flag'];
        bool notice_flag = userInfo['notice_flag'];
        bool doc_flag = userInfo['doc_flag'];
        bool doc_edit_flag = userInfo['doc_edit_flag'];
        // bool notice_auto_scroll_flag = userInfo['notice_auto_scroll_flag'] ?? false;
        bool notice_auto_scroll_flag = userInfo['notice_auto_scroll_flag'] ?? false; ///false kore dite hbe
        bool attendance_approval_flag = userInfo['attendance_approval_flag'] ?? false;
        bool order_approval_flag = userInfo['order_approval_flag'] ?? false;
        String meter_reading_last = userInfo['meter_reading_last'] ?? '0';
        List exp_reject_reason = userInfo['exp_reject_reason'];
        bool exp_approval_flag = userInfo['exp_approval_flag'];
        List cause_for_non_execution = userInfo['cause_for_non_execution'];
        List expense_category_list = userInfo['expense_category_list'] ?? [];
        bool transport_mode = userInfo['transport_mode'] ?? true;
        bool auto_day_end = userInfo['auto_day_end'] ?? false;
        String startTime = userInfo['start_time'] ?? '';
        String endTime = userInfo['end_time'] ?? '';
        bool check_in_flag = userInfo['check_in_flag'] ?? false; ///newly added
        bool target_sales_achievement_flag = userInfo['target_sales_achievement_flag'] ?? false;
        int notice_api_timer = userInfo['notice_timer'] ?? 60;
        bool expense_flag = userInfo['expense_flag'] ?? false;
        //Check existing users Save data Delete if user does not match
        await AuthServices.checkExistingUser(user_id);

        //todo User basis level ar jonnno
//
        // List ff_list = userInfo['ff_list'];
        // ff_user_list.clear();
        // for (var element in ff_list) {
        //   ff_user_list.add(element);
        // }
        // box.put('ff_list', ff_user_list);
//
        user_basis_level_list.clear();
        box.put('user_basis_level_list', user_basis_level_list);
        if (userInfo['exp_approval_flag'] == true) {
          List user_basis_level = userInfo['user_basis_level'];
          for (var element in user_basis_level) {
            user_basis_level_list.add(element);
          }
          box.put('user_basis_level_list', user_basis_level_list);
        }
        //todo User basis lavel ar jonnno

        debugPrint("Rejected Reson is::::::$exp_reject_reason");

        debugPrint('Last Metter Reading ${meter_reading_last.isNotEmpty ? meter_reading_last : '0'}');

        dcr_visitedWithList.clear();
        for (int i = 0; i < dcr_visit_with_list.length; i++) {
          dcr_visitedWithList.add(dcr_visit_with_list[i]);
        }
        rxTypeList.clear();
        for (var element in rx_type_list) {
          rxTypeList.add(element);
        }

        salesTypeList.clear();
        for(var element in sales_type_list){
          salesTypeList.add(element);
        }
        patientTypeList.clear();
        for(var element in patient_type_list){
          patientTypeList.add(element);
        }
        systemNameList.clear();
        for(var element in system_name_list){
          systemNameList.add(element);
        }
        patientTemperamentList.clear();
        for(var element in patient_temperament_list){
          patientTemperamentList.add(element);
        }


        exp_reject_reasonList.clear();
        for (var element in exp_reject_reason) {
          exp_reject_reasonList.add(element);
        }
        causeForNonExecution.clear();
        for (var element in cause_for_non_execution) {
          causeForNonExecution.add(element);
        }

        // branchList.clear();
        // for (var element in branch_list) {
        //   branchList.add(element);
        // }

        debugPrint("NNNEWWW LISt is :::::::$exp_reject_reasonList");

        //todo Add data HIVe......

        // box.put('PASSWORD', user_pass);

        if (buttonNames != null) {
          await putButtonNames(buttonNames);
        }
        await box.put('update_new_app','');
        await box.put('update_new_app_url','');

        await box.put('CID', cid);
        await box.put("USER_ID", user_id);
        await box.put('areaPage', userInfo['area_page']);
        await box.put('userName', userName);
        await box.put('logo_url_1', logo_url_1);
        await box.put('logo_url_2', logo_url_2);
        await box.put('notice_reload_duration', notice_reload_duration);
        await box.put('user_id', user_id);
        await box.put('PASSWORD', password);
        await box.put('mobile_no', mobile_no);
        await box.put('offer_flag', offer_flag);
        await box.put('note_flag', note_flag!);
        await box.put('client_edit_flag', client_edit_flag!);
        await box.put('os_show_flag', os_show_flag!);
        await box.put('os_details_flag', os_details_flag!);
        await box.put('ord_history_flag', ord_history_flag!);
        await box.put('inv_histroy_flag', inv_histroy_flag!);
        await box.put('client_flag', client_flag);
        await box.put('rx_doc_must', rx_doc_must!);
        await box.put('rx_type_must', rx_type_must!);
        await box.put('rx_gallery_allow', rx_gallery_allow!);
        await box.put('order_flag', order_flag);
        await box.put('dcr_flag', dcr_flag);
        await box.put('timer_flag', timer_flag);
        await box.put('background_service', background_service);
        await box.put('auto_day_end', auto_day_end);
        await box.put('rx_flag', rx_flag);
        await box.put('others_flag', others_flag);
        await box.put('visit_plan_flag', visit_plan_flag);
        await box.put('plagin_flag', plagin_flag);
        await box.put('board_meeting_flag', patientCallBoardMeeting);
        await box.put('exam_flag', examFlag);
        await box.put('dcr_discussion', dcr_discussion);
        await box.put('promo_flag', promo_flag);




        await box.put('leave_flag', leave_flag);
        await box.put('notice_flag', notice_flag);
        await box.put('notice_auto_scroll_flag', notice_auto_scroll_flag);
        await box.put('doc_flag', doc_flag);
        await box.put('doc_edit_flag', doc_edit_flag);
        await box.put('target_sales_achievement_flag', target_sales_achievement_flag);
        await box.put('attendance_approval_flag', attendance_approval_flag);
        await box.put('order_approval_flag', order_approval_flag);
        await box.put('dcr_visit_with_list', dcr_visitedWithList);
        await box.put('meter_reading_last', meter_reading_last.isNotEmpty ? meter_reading_last : '0');
        await box.put('exp_approval_flag', exp_approval_flag);

        await box.put('rx_type_list', rxTypeList);
        await box.put('sales_type_list', salesTypeList);
        await box.put('patient_type_list', patientTypeList);
        await box.put('system_name_list', systemNameList);
        await box.put('system_diseases_list', system_diseases_list);
        await box.put('patient_temperament_list', patientTemperamentList);
        await box.put('district_thana_list', district_thana_list);

        await box.put('exp_reject_reason', exp_reject_reasonList);
        await box.put('cause_for_non_execution', causeForNonExecution);


        await box.put('expense_category_list', expense_category_list);
        await box.put('transport_mode', transport_mode);
        await Boxes.allData().put('withoutMReading', false);
        await box.put('check_in_flag', check_in_flag); //newly added
        await box.put('marketList', marketList); //newly added
        await box.put('branch_list', branch);
        await box.put('areaName', areaName); //newly added
        await box.put('userLevel', user_level); //newly added
        await box.put('notice_timer', notice_api_timer);
        await box.put('expense_flag', expense_flag);
        print("---------------------------- bg: ${background_service}");
        await secureStorage.write(key: 'cid', value: cid.toString().trim());
        await secureStorage.write(key: 'userId', value: userId.toString().trim());
        await secureStorage.write(key: 'password', value: password.toString().trim());
        await secureStorage.write(key: 'background_service', value: background_service.toString());
        await secureStorage.write(key: 'device_mac', value: deviceId.toString());
        await secureStorage.write(key: 'notice_api_hit' , value: 'true');///for background notice api hit

        ///already attendance
        if (startTime != '') {
          box.put('attendance', DateFormat('yyyy-MM-dd').format(DateTime.now()));
          box.put('attendanceUserId', user_id.toString());
          await secureStorage.write(key: 'notice_api_hit' , value: 'true');
        }
        if (startTime != '' && endTime != '') {
          box.put('attendance', '');
          await secureStorage.write(key: 'notice_api_hit' , value: 'true');
        }
        await box.put('startTime', startTime);
        await box.put('endTime', endTime);

        //todo! Add New  bg Service
        if (SameDeviceId == false) {
          debugPrint(SameDeviceId);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
          setState(() {});
        }

        //!Hive.openBox('data').then(
        //!  (value) {
        // var mymap = value.toMap().values.toList();
        //! List clientToken = value.toMap().values.toList();
        List clientToken = Hive.box("dcrListData").values.toList();

        if (clientToken.isNotEmpty && savedUserId == userId) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                userName: userName,
                user_id: user_id,
                userPassword: password,
              ),
            ),
          );
        } else {
          // if (background_service == true) {
          //   restartBackgroundService();
          // } else {
          //   stopBackgroundService();
          // }
          // Hive.openBox('data').then((value) => value.clear());
          // Hive.openBox('syncItemData').then((value) => value.clear());
          // Hive.openBox('dcrListData').then((value) => value.clear());
          // Hive.openBox('dcrGiftListData').then((value) => value.clear());
          // Hive.openBox('dcrSampleListData').then((value) => value.clear());
          // Hive.openBox('dcrPpmListData').then((value) => value.clear());
          // Hive.openBox('medicineList').then((value) => value.clear());

          await Hive.box('draftForExpense').clear();
          await Hive.box('VisitedWithNotes').clear();
          await Hive.box<MedicineListModel>('draftMdicinList').clear();
          await Hive.box<RxDcrDataModel>('RxdDoctor').clear();
          await Hive.box<DcrGSPDataModel>('selectedDcrGSP').clear();
          await Hive.box<DcrDataModel>('selectedDcr').clear();
          await Hive.box<CustomerDataModel>('customerHive').clear();
          await Hive.box<AddItemModel>('orderedItem').clear();
          await Hive.box("syncItemData").clear();
          // Hive.box("dcrListData").clear();//todo Old
          await Hive.box("mpoForDoctor").clear(); //todo New
          await Hive.box("dcrGiftListData").clear();
          await Hive.box("dcrSampleListData").clear();
          await Hive.box("dcrPpmListData").clear();
          // Hive.box("data").clear();//todo Old
          await Hive.box("mpoForClaient").clear(); //todo new
          await Hive.box("medicineList").clear();
          // var alldata = Hive.box("alldata");
          // alldata.put("startTime", "");
          // alldata.put("endTime", "");
          // alldata.put("present", "");

          await Hive.box("dcrDiscussionListData").clear();
          // deleteChace();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SyncDataTabScreen(
                cid: cid,
                userId: user_id,
                userPassword: password,
              ),
            ),
          );
        }
      } 
      else if (userInfo['ret_str'].toString().toLowerCase().contains('please download new version') && status == 'Failed')
        {

          int index = userInfo['ret_str'].toString().indexOf("http");

          update_app_notification = userInfo['ret_str'].toString().substring(0, index).trim();
          debugPrint(update_app_notification);

          update_app_url = userInfo['ret_str'].toString().substring(index).trim();
          debugPrint(update_app_url);
          await box.put('update_new_app',update_app_notification);
          await box.put('update_new_app_url',update_app_url);
          // AllServices().messageForUser(userInfo['ret_str'].toString());
          setState(() {});
        }
      else {
        AllServices().messageForUser(userInfo['ret_str'].toString());
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

}


