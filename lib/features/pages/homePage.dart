// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_interpolation_to_compose_strings
// import 'dart:async';
// import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:physician_latest/features/pages/branch_selectiion_screen.dart';
import 'package:physician_latest/features/pages/patient_call_&_board_meeting.dart';
import 'package:physician_latest/features/pages/plugin_reports_page.dart';
import 'package:physician_latest/features/pages/reset_password.dart';
import 'package:physician_latest/features/pages/syncDataTabPaga.dart';
import 'package:physician_latest/features/pages/tour_plan_page.dart';
import 'package:url_launcher/link.dart';

import '../../core/Rx/rxDraftPage.dart';
import '../../core/Rx/rxPage.dart';
import '../../core/Rx/rx_report_page.dart';
import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';
import '../../data/service/all_service.dart';
import '../../data/service/apiCall.dart';
import '../../data/service/auth_services.dart';
import '../../data/service/network_connectivity.dart';
import '../../main.dart';
import '../Widgets/customassetIconbutton.dart';
import '../Widgets/custombutton.dart';
import '../exam_result_page.dart';
import 'DCR_section/dcr_report.dart';
import 'DCR_section/draft_dcr_page.dart';
import 'DCR_section/for_mpo_route_doc.dart';
import 'Expense/expense_section.dart';
import 'approval_page.dart';
import 'areaPage.dart';
import 'attendance_page.dart';
import 'board_meeting_report.dart';
import 'exam_page.dart';
import 'loginPage.dart';
import 'notice_board.dart';
import 'order_sections/activity_log.dart';
import 'order_sections/customerListPage.dart';
import 'order_sections/draft_order_page.dart';
import 'order_sections/for_mpo_route_claient.dart';
import 'order_sections/order_approval_area_page.dart';
import 'order_sections/order_report_page.dart';

var tempdocName = "";
String areaName = "";
String areaid = "";
String docId = "";

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  String userName;
  String user_id;
  String? userPassword;
  int? data;
  // bool offer_flag;
  // bool note_flag;
  // bool client_edit_flag;
  // bool os_show_flag;
  // bool os_details_flag;
  // bool ord_history_flag;
  // bool inv_histroy_flag;
  // bool rx_doc_must;
  // bool rx_type_must;
  // bool rx_gallery_allow;
  // String endTime;

  MyHomePage({Key? key, required this.userName, required this.user_id, this.userPassword, this.data}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  Box? box;
  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String report_sales_url = '';
  String report_dcr_url = '';
  String report_rx_url = '';
  String leave_request_url = '';
  String leave_report_url = '';
  String check_in_url = '';
  // String plugin_url = '';
  // String tour_plan_url = '';
  String tour_compliance_url = '';
  // String activity_log_url = '';
  // String approval_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  String? logo_url_1;
  String? logo_url_2;
  bool areaPage = false;
  bool exp_approval_flag = false;
  String? userName;
  String? startTime;
  String user_sales_coll_ach_url = '';
  String timer_track_url = '';
  String? user_id;
  String deviceId = "";
  String mobile_no = '';
  String? endTime;
  bool orderFlag = false;
  bool dcrFlag = false;
  bool rxFlag = false;
  bool leaveFlag = false;
  bool othersFlag = false;
  bool visitPlanFlag = false;
  bool pluginFlag = false;
  bool patientCallBoardMeeting = false;
  bool examFlag = false;

  bool leave_flag = false;
  bool notice_flag = false;
  bool timer_flag = false;
  int notice_reload_duration = 60;
  String notice = '';
  String targetAmount = '0';
  String salesAmount = '0';
  String achievementAmount = '0';
  Box? buttonNames;
  bool target_sales_achievement_flag = false;
  bool notice_auto_scroll_flag = false;
  String order_approval_url = "";
  String order_list = "";
  bool order_approval_flag = false;
  String? lat;
  String? long;
  String? address;
  bool loading = false;
  bool check_in_flag = false;
  String marketList = "";
  String areaName = "";
  String noticeCount = '0';
  String examCount = '0';

  String user_level = "";
  List<dynamic> branchList = [];
  String branchText = '';

  bool first_notice_api_hit = false;
  bool expense_flag = false;
  String update_app_notification = '';
  String update_app_url = '';

  // List noticeList = [];

  String version = 'test';
  var prefix;
  var prefix2;
  // Location location = Location();
  List<NoticeListModel> noticeList = [];
  final mydatabox = Boxes.allData();
  final seenNoticeCount = Hive.box('checkData');
  final noticeBox = Hive.box<NoticeListModel>('noticeList');
  Timer? _timer;

  Future<void> checkInOut_submit(BuildContext context, String submitType) async {
    try {
      await NetworkConnecticity.checkConnectivity().then((internet) async {
        if (internet == true) {
          if (lat == null || long == null || address == null) {
            await getLatLong();
          }
          if (lat != null && long != null && address != null) {
            // var url = "http://192.168.100.246:8000/hamdard_api/api_instant_checkin/submit_instant_checkin?cid=$cid&user_id=5968&user_pass=1906&device_id=$deviceId&latitude=${lat.toString()}&longitude=${long.toString()}&address=${address.toString()}&submit_type=$submitType";
            var url = "$check_in_url?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&latitude=${lat.toString()}&longitude=${long.toString()}&address=${address.toString()}&submit_type=$submitType";
            // var url = "${sync_url}api_attendance_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&latitude=${lat.toString()}&longitude=${long.toString()}&address=${address.toString()}&submit_type=$submitType";
            print("check in url:$url");
            final response = await http.get(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'});
            Map<String, dynamic> data = json.decode(response.body);
            final status = data['status'] ?? '';
            var message = data['ret_str'] ?? '';
            // var startTimeStr = data['start_time'] ?? '';
            // var endTimeStr = data['end_time'] ?? '';
            // var prefs = await SharedPreferences.getInstance();
            print(message);

            if (status.toString().toLowerCase() == "success") {
              lat = null;
              long = null;
              address = '';
              Fluttertoast.showToast(msg: "Check In Successful");
              setState(() {});
            } else if (status == 'Failed') {
              Fluttertoast.showToast(msg: message);
            }
          } else {
            print("Latitude and longitude are null.");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please turn on location")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please turn on internet connection")));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!"), backgroundColor: Colors.red));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> loadExamCount() async {
    final box = await Hive.openBox('exam_count');
    setState(() {
      examCount = box.get('total_exam', defaultValue: 0).toString();
      print('exam count: $examCount');
    });
  }

  // getLatLong() {
  //   Future<geo.Position> data = AllServices().determinePosition();
  //   data.then((value) {
  //     debugPrint("value $value");
  //     setState(() {
  //       lat = value.latitude.toString();
  //       long = value.longitude.toString();
  //       getAddress(value.latitude, value.longitude);
  //
  //       debugPrint("Splass Screen Lat Long :::::::::::::  $lat : $long");
  //
  //       // mydatabox.put("latitude", latitude);
  //       // mydatabox.put("longitude", longitude);
  //     });
  //   }).catchError((error) {
  //     // debugPrint("Error $error");
  //   });
  // }

  Future<void> getLatLong() async {
    try {
      geo.Position value = await AllServices().determinePosition();
      debugPrint("value $value");

      setState(() {
        lat = value.latitude.toString();
        long = value.longitude.toString();
      });

      await getAddress(value.latitude, value.longitude);

      debugPrint("Splash Screen Lat Long :::::::::::::  $lat : $long");
    } catch (error) {
      debugPrint("Error in getting location: $error");
    }
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    debugPrint("$placemarks");
    if (mounted) {
      setState(() {
        address = "${placemarks[0].street!} ${placemarks[0].country!}";
      });
    }
    for (int i = 0; i < placemarks.length; i++) {}
  }

  @override
  void initState() {
    super.initState();
    loadExamCount();
    getLatLong();
    print('getlatlon:$getLatLong()');
    AllServices().getPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mydatabox.get('auto_day_end') == true && mydatabox.get('attendance').toString() != AllServices().getTodayDate()) {
        log('auto day end new date');
        mydatabox.put('attendance', '');
        mydatabox.put("startTime", '');
        mydatabox.put("endTime", '');
        // mydatabox.put('first_notice_api_hit',false);
      }
      if (mydatabox.get('attendance').toString() == AllServices().getTodayDate() &&
          // (mydatabox.get('attendance').toString().isNotEmpty ||
          //         mydatabox.get('attendance') != null) &&
          mydatabox.get('attendanceUserId') == mydatabox.get("USER_ID")) {
        const SizedBox.shrink();
      } else {
        if (mydatabox.get('attendanceUserId') != mydatabox.get("USER_ID")) {
          mydatabox.put('attendance', '');
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
      }

      userPassword = mydatabox.get("PASSWORD") ?? widget.userPassword;
      startTime = mydatabox.get("startTime") ?? '';
      endTime = mydatabox.get("endTime") ?? '';
      report_sales_url = mydatabox.get("report_sales_url") ?? '';
      notice_reload_duration = mydatabox.get('notice_reload_duration') ?? 60;
      report_dcr_url = mydatabox.get("report_dcr_url") ?? '';
      report_rx_url = mydatabox.get("report_rx_url") ?? '';
      leave_request_url = mydatabox.get("leave_request_url") ?? '';
      leave_report_url = mydatabox.get("leave_report_url") ?? '';
      // tour_plan_url = mydatabox.get("tour_plan_url") ?? '';
      tour_compliance_url = mydatabox.get("tour_compliance_url") ?? '';
      // activity_log_url = mydatabox.get("activity_log_url") ?? '';
      // plugin_url = mydatabox.get("plugin_url") ?? '';
      user_sales_coll_ach_url = mydatabox.get("user_sales_coll_ach_url") ?? '';
      timer_track_url = mydatabox.get("timer_track_url") ?? '';
      // approval_url = mydatabox.get("approval_url") ?? '';
      cid = mydatabox.get("CID");
      userId = mydatabox.get("USER_ID") ?? widget.user_id;
      logo_url_1 = mydatabox.get('logo_url_1') ?? null;
      logo_url_2 = mydatabox.get('logo_url_2') ?? null;
      areaPage = mydatabox.get("areaPage")!;
      userName = mydatabox.get("userName");
      user_id = mydatabox.get("user_id");
      mobile_no = mydatabox.get("mobile_no") ?? '';
      deviceId = mydatabox.get("deviceId") ?? '';
      orderFlag = mydatabox.get('order_flag') ?? false;
      dcrFlag = mydatabox.get('dcr_flag') ?? false;
      rxFlag = mydatabox.get('rx_flag') ?? false;
      othersFlag = mydatabox.get('others_flag') ?? false;
      visitPlanFlag = mydatabox.get('visit_plan_flag') ?? false;
      pluginFlag = mydatabox.get('plagin_flag') ?? false;
      patientCallBoardMeeting = mydatabox.get('board_meeting_flag') ?? false;
      print('patient call board meeting:$patientCallBoardMeeting');
      examFlag = mydatabox.get('exam_flag') ?? false;
      leave_flag = mydatabox.get('leave_flag') ?? false;
      notice_flag = mydatabox.get('notice_flag') ?? false;
      timer_flag = mydatabox.get('timer_flag') ?? false;
      exp_approval_flag = mydatabox.get('exp_approval_flag') ?? false;
      target_sales_achievement_flag = mydatabox.get('target_sales_achievement_flag') ?? false;
      notice_auto_scroll_flag = mydatabox.get('notice_auto_scroll_flag') ?? false;
      order_approval_url = mydatabox.get('order_approval_url') ?? "";
      order_list = mydatabox.get('order_list') ?? order_list;
      order_approval_flag = mydatabox.get('order_approval_flag') ?? false;
      check_in_flag = mydatabox.get("check_in_flag") ?? false;
      // check_in_flag = true;
      check_in_url = mydatabox.get('check_in_url') ?? "sample_base_url";
      marketList = mydatabox.get('marketList') ?? "";
      areaName = mydatabox.get('areaName') ?? "";
      user_level = mydatabox.get('userLevel') ?? "";
      print('user_level: $user_level');

      branchList = mydatabox.get('branch_list', defaultValue: []);
      print('branch list: $branchList');
      branchText = branchList
          .map((b) => b.values.first) // get branch name like "Sitakunda Branch"
          .join(', ');
      print('branch list text: $branchText');

      expense_flag = mydatabox.get('expense_flag') ?? false;
      debugPrint(marketList.toString());
      update_app_notification = mydatabox.get('update_new_app') ?? '';
      update_app_url = mydatabox.get('update_new_app_url') ?? '';

      ///change to false///
      print("......................................");
      getButtonNames();
      print("......................................");

      debugPrint('timer flag ::::$timer_flag');

      var parts = startTime?.split(' ');

      prefix = parts![0].trim();
      // debugPrint("prefix ashbe $prefix");
      String dt = DateTime.now().toString();
      var parts2 = dt.split(' ');
      prefix2 = parts2[0].trim();
      // debugPrint("dateTime ashbe$prefix2");

      debugPrint("first_notice_api_hit before calling-------------------------------------------------------------------$first_notice_api_hit");
      first_notice_api_hit = mydatabox.get('first_notice_api_hit');
      debugPrint("first_notice_api_hit-------------------------------------------------------------------$first_notice_api_hit");

      if (first_notice_api_hit == false) {
        getNotice();
      }
      await fetchNoticeList();
      if (mounted) {
        setState(() {});
      }

      // await getNoticeApi();

      debugPrint("notice_auto_scroll_flag::::::::::::::::::::::::::::::::::::::$notice_auto_scroll_flag");
      debugPrint("notice_auto_scroll_flag::::::::::::::::::::::::::::::::::::::$notice");
      debugPrint("target_sales_achievement_flag::::::::::::::::::::::::::::::::::::::::$target_sales_achievement_flag");
    });

    // if (background_service == true) {
    //   if (mydatabox.get('timer_flag') == true) {

    //   } else {
    //     FlutterBackgroundService().isRunning().then((value) {
    //       if (value) {
    //         FlutterBackgroundService().invoke("stopService");
    //       }
    //     });
    //   }
    // } else {
    //   FlutterBackgroundService().isRunning().then((value) {
    //     if (value) {
    //       FlutterBackgroundService().invoke("stopService");
    //     }
    //   });
    // }

    debugPrint(report_sales_url);
    debugPrint(report_dcr_url);
    debugPrint(report_rx_url);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      // Subscribe only if the route is a PageRoute
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPopNext() async {
    debugPrint("The didpopnext fucntion is calling--------------------------------------------");
    await fetchNoticeList();
    update_app_notification = mydatabox.get('update_new_app') ?? '';
    update_app_url = mydatabox.get('update_new_app_url') ?? '';
    setState(() {});
    debugPrint("notice count in homescreen ::::::::::::::::::::::::::::::: $noticeCount");
    debugPrint("The didpopnext fucntion is callied//////////////////////////////////////////");
  }

  Future<void> fetchNoticeList() async {
    print('entered to fetch');
    print('noticebox called');

    if (mounted) {
      setState(() {
        targetAmount = mydatabox.get('target_amount') ?? "0";
        print('targetAmount $targetAmount');
        salesAmount = mydatabox.get('sales_amount') ?? "0";
        achievementAmount = mydatabox.get('achievement_amount') ?? "0";
        noticeCount = seenNoticeCount.get('noticeCount') ?? "0";
        noticeList = noticeBox.values.toList();
        debugPrint("noticeList length :::::: ${noticeList.length}");
        if (noticeList.isNotEmpty) {
          List<String> notices = noticeList.where((element) => element.status == 'ACTIVE').map((item) => "${item.notice_title}  ◉  ${item.notice_details}").toList();
          print(notices);
          notice = notices.join("      ■ ■ ■      ");
        } else {
          notice = "";
        }
      });
    }

    print("notice ----------------  $notice");
  }

  Future<void> getButtonNames() async {
    try {
      buttonNames = Hive.box('buttonNames');
      debugPrint("Retrieved buttonNames: ${buttonNames?.values}");
    } catch (e) {
      debugPrint("Error retrieving buttonNames: $e");
    }
  }

  Future<void> getNotice() async {
    debugPrint("hitting api from homeeeeeeeeeeeeeessssssssssssssscccccccccccccrrrrrrrrrrrrreeeeeeeeeeeeeeeeennnnnnnnnnnnnnnnnnnnn");
    List<NoticeListModel> apiNoticeList = await noticeEvent();

    debugPrint("api hitted");

    List noticeSeenCount = seenNoticeCount.get('notice_Id', defaultValue: []);
    List<String> currentNoticeIds = apiNoticeList.map((notice) => notice.notice_id ?? '').toList();
    noticeSeenCount = noticeSeenCount.where((id) => currentNoticeIds.contains(id)).toList();
    seenNoticeCount.put('notice_Id', noticeSeenCount);
    await noticeBox.clear();
    for (var noticeMap in apiNoticeList) {
      NoticeListModel noticeModel = NoticeListModel(uiqueKey: noticeMap.uiqueKey ?? 0, notice_date: noticeMap.notice_date ?? '', notice_title: noticeMap.notice_title ?? '', notice_details: noticeMap.notice_details ?? '', notice_id: noticeMap.notice_id ?? '', status: noticeMap.status ?? '');

      await noticeBox.add(noticeModel);
    }

    String noticeCount = (apiNoticeList.length - noticeSeenCount.length).toString();
    seenNoticeCount.put('noticeCount', noticeCount);
    mydatabox.put('first_notice_api_hit', true);

    fetchNoticeList();
    debugPrint("Notice List Length: ${apiNoticeList.length}");
    debugPrint("Seen Notice Count Length: ${noticeSeenCount.length}");
    debugPrint("Notice Count: $noticeCount");
  }

  ///...............................Apex Pharma..................................///
  //   restartBackgroundService()async{
  //  await getPermission();

  //   }

  // getPermission() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   if (_serviceEnabled &&
  //       _permissionGranted == PermissionStatus.granted &&
  //       timer_flag == true) {
  //     //await initializeService();

  //     BGservice.serviceOn();
  //     debugPrint('Starting Background Service...');

  //     debugPrint('Starting Background Service...');
  //   }

  //   setState(() {});
  // }

  // getLoc() {
  //   String location = "";
  //   Timer.periodic(const Duration(minutes: 3), (timer) {
  //     getLatLong();
  //     if (lat != 0.0 && long != 0.0) {
  //       if (location == "") {
  //         location = lat.toString() + "|" + long.toString();
  //       } else {
  //         location = location + "||" + lat.toString() + "|" + long.toString();
  //       }
  //     }

  //     debugPrint(location.split('||').length);
  //     // debugPrint(location.length);
  //   });
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // getLatLong() {
  //   Future<Position> data = _determinePosition();
  //   data.then((value) {
  //     setState(() {
  //       lat = value.latitude;
  //       long = value.longitude;
  //     });
  //     getAddress(value.latitude, value.longitude);
  //   }).catchError((error) {});
  // }

  // getAddress(lat, long) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  //   setState(() {
  //     address = placemarks[0].street! + " " + placemarks[0].country!;
  //   });
  //   // for (int i = 0; i < placemarks.length; i++) {}
  // }

  int _currentSelected = 0;
  _onItemTapped(int index) async {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BranchSelectiionScreen()));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder:
      //         (_) => RxPage(
      //           address: '',
      //           areaId: '',
      //           areaName: '',
      //           ck: '',
      //           dcrKey: 0,
      //           docId: '',
      //           docName: '',
      //           uniqueId: 0,
      //           draftRxMedicinItem: [],
      //           image1: '',
      //           dcrGrad: '',

      //           phnNum: '',
      //           patientName: '',
      //           gender: '',
      //           dob: '',
      //           stripWastage: '',
      //           systemName: '',
      //           disease: '',
      //           patientTemperament: '',
      //           beforeDiabetes: '',
      //           afterDiabetes: '',
      //           bloodSystolic: '',
      //           bloodDiastolic: '',
      //           oxygenLevel: '',
      //           bodyTemperature: '',
      //           weight: '',
      //           heightFeet: '',
      //           heightInch: '',
      //           branch_id: 'Test',
      //         ),
      //   ),
      // );

      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    log('leave:$leave_flag');
    debugPrint('draft visit count: ${Boxes.dcrUsers().length}');
    debugPrint('draft prescription count: ${Boxes.rxdDoctor().length}');

    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Do you exit app?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("NO"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("YES", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
        ));
      },
      child: Scaffold(
        // key: _drawerKey,
        endDrawer: Drawer(
          child: SizedBox(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 138, 201, 149)),
                  child: SizedBox(
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                      // logo_url_2 != null
                      // ? CachedNetworkImage(
                      //     imageUrl: logo_url_2!,
                      //     errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                      //   )
                      // : Image.asset("assets/images/mRep7_logo.png"),
                      Image.asset('assets/images/c_logo_1.png', fit: BoxFit.contain),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.sync_outlined, color: Colors.blueAccent),
                  title: const Text('Sync Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SyncDataTabScreen(cid: cid, userId: userId, userPassword: userPassword)));
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.vpn_key, color: Colors.blueAccent),
                  title: const Text('Change password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blueAccent),
                  title: const Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                  onTap: () async {
                    await AuthServices.logOut(context);
                    // final prefs = await SharedPreferences.getInstance();
                    // timer_flag=false;

                    // await mydatabox.put('CID', '');
                    // await mydatabox.clear();
                    // await mydatabox.put('USER_ID','');
                    // await mydatabox.put('timer_flag',timer_flag);
                    // await mydatabox.put('deviceId',"");

                    // debugPrint("timer flag : $timer_flag");

                    // setState(() {});
                    // if (await FlutterBackgroundService().isRunning()) {
                    //   FlutterBackgroundService().invoke("stopService");
                    // }
                    // await deleteChace();
                    // if (await FlutterBackgroundService().isRunning()) {
                    //   FlutterBackgroundService().invoke("stopService");
                    //   await Future.delayed(Duration.zero);
                    // }
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6), // Adjust padding as needed
            child:
            // logo_url_1 != null
            //     ? CachedNetworkImage(
            //         imageUrl: logo_url_1!,
            //         errorWidget: (context, url, error) => SizedBox.shrink(),
            //       )
            //     : SizedBox.shrink(),
            Image.asset('assets/images/c_logo_1.png'),
          ),
          backgroundColor: Colors.blue,
          title:
              // notice = "" ? Container(
              //   margin: EdgeInsets.only(left: 0.0), // Adjust margin to control the gap
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(5),
              //     border: Border.all(color: Colors.black, width: 1.0),
              //   ),
              //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              //   child: FittedBox(
              //     child: Text(
              //       'MREPORTING $appVersion',
              //     ),
              //   ),
              // ),
              notice == "" || notice_auto_scroll_flag == false
                  ? Container(
                    margin: EdgeInsets.only(left: 0.0), // Adjust margin to control the gap
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black, width: 1.0)),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: FittedBox(child: Text('MREPORTING $appVersion')),
                  )
                  : GestureDetector(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NoticeScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black, width: 1.0), color: Colors.white),
                      child: Center(
                        child: Marquee(
                          text: notice,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 300,
                          velocity: 50.0,
                          startPadding: 10.0,
                          accelerationDuration: const Duration(seconds: 0),
                          accelerationCurve: Curves.bounceIn,
                          decelerationDuration: const Duration(milliseconds: 0),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ),
          titleTextStyle: const TextStyle(color: Color.fromARGB(255, 27, 56, 34), fontWeight: FontWeight.w500, fontSize: 20),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar:
            rxFlag == true
                ? BottomNavigationBar(onTap: _onItemTapped, currentIndex: _currentSelected, unselectedItemColor: Colors.grey[800], selectedItemColor: const Color.fromRGBO(10, 135, 255, 1), items: const <BottomNavigationBarItem>[BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)), BottomNavigationBarItem(label: 'Camera', icon: Icon(Icons.photo_camera_outlined, color: Colors.black87))])
                : const Text(""),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  update_app_notification == ''
                      ? const SizedBox.shrink()
                      : Center(
                        child: GestureDetector(
                          onTap: () {
                            AllServices().showMap(update_app_url);
                          },
                          child: Container(color: Colors.red, height: 20, width: double.infinity, child: Text(textAlign: TextAlign.center, "Please click here to download new version", style: TextStyle(color: Colors.white))),
                        ),
                      ),
                  update_app_notification == '' ? const SizedBox.shrink() : const SizedBox(height: 8),

                  ///*****************************************************  User information Section  ***********************************************///
                  Container(
                    //height: screenHeight / 9.3,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromARGB(255, 222, 237, 250),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    "User: $user_id | $userName",
                                    // ' $userName',
                                    style: const TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FittedBox(child: Text("Branch: $branchText", style: const TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 14, fontWeight: FontWeight.bold), maxLines: 4, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                                  }),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child:
                                        prefix != prefix2
                                            ? const Text(
                                              '[Attendance]'
                                              '\n'
                                              'Start: '
                                              " "
                                              '\n'
                                              "End: "
                                              " ",
                                              style: TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 18),
                                            )
                                            : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Attendance', style: TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 18, fontWeight: FontWeight.w600)),
                                                Text('Start: ' + startTime.toString(), style: const TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 18)),
                                                Text("End: " + endTime.toString(), style: const TextStyle(color: Color.fromARGB(255, 15, 53, 85), fontSize: 18)),
                                              ],
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),

                  ///************************************************ Target Sales Achievement *********************************************///
                  target_sales_achievement_flag == true
                      ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)), color: const Color(0xff70BA85).withOpacity(0.3)),
                              child: const Row(
                                children: [
                                  Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Target", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.5))]))),
                                  Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Sales", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.5))]))),
                                  Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Achievement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.5))]))),
                                ],
                              ),
                            ),
                            const Divider(height: 2, color: Colors.white),
                            Container(
                              height: 50,
                              color: const Color.fromARGB(255, 222, 237, 250),
                              child: Row(
                                children: [
                                  Expanded(child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(targetAmount, style: const TextStyle(height: 1.5))))),
                                  Expanded(child: Container(color: const Color(0xff70BA85).withOpacity(0.3), child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(salesAmount, style: TextStyle(height: 1.5)))))),
                                  Expanded(child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(achievementAmount, style: TextStyle(height: 1.5))))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox(),
                  SizedBox(height: target_sales_achievement_flag ? 5 : 0),

                  ///************************************************ Order area Field *********************************************///

                  // orderFlag
                  //     ? Container(
                  //   height: screenHeight / 3.5,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(color: const Color(0xFFE2EFDA), borderRadius: BorderRadius.circular(12)),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: customBuildIconButton(
                  //                   height: 50,
                  //                   width: 50,
                  //                   icon: "assets/icons/neworder.png",
                  //                   onClick: () async {
                  //                     if (areaPage == false) {
                  //                       await Navigator.push(context, MaterialPageRoute(builder:
                  //                           (context) => const ClaientRoutePage()));
                  //                       //  await getAllCustomarData(); //todo old without route
                  //                       await  getNotice();
                  //                       //Fluttertoast.showToast(msg: notice);
                  //                       setState(() {
                  //                         //     Box box= Hive.box('mpoForClaient');
                  //                         // print("*******client ${ box.values.toList()}");
                  //                       });
                  //                     } else {
                  //                       await Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(builder: (_) => AreaPage()),
                  //
                  //                       );
                  //                       await  getNotice();
                  //                       //Fluttertoast.showToast(msg: notice);
                  //                       setState(() {});
                  //                     }
                  //
                  //                     //  debugPrint(areaPage);
                  //                   },
                  //                   title: buttonNames?.get('new_order') == "" ? 'New Order' : buttonNames?.get('new_order') ?? 'New Order',
                  //                   sizeWidth: screenWidth,
                  //                   inputColor: const Color(0xff70BA85).withOpacity(.3),
                  //                 ),
                  //               ),
                  //               order_approval_flag == true ? SizedBox(width: 5) : SizedBox.shrink(),
                  //               order_approval_flag == true
                  //                   ? Expanded(
                  //                 child: customBuildIconButton(
                  //                   height: 50,
                  //                   width: 50,
                  //                   icon: "assets/icons/order_approval.png",
                  //                   onClick: () async {
                  //                     {
                  //                       await Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(builder: (_) => OrderApprovalAreaScreen()),
                  //                       );
                  //                       await  getNotice();
                  //                       //Fluttertoast.showToast(msg: notice);
                  //                       setState(() {});
                  //                     }
                  //
                  //                     //  debugPrint(areaPage);
                  //                   },
                  //                   title: buttonNames?.get('order_approval') == "" ? 'Order Approval' : buttonNames?.get('order_approval') ?? 'Order Approval',
                  //                   sizeWidth: screenWidth,
                  //                   inputColor: const Color(0xff70BA85).withOpacity(.3),
                  //                 ),
                  //               )
                  //                   : SizedBox.shrink(),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Stack(
                  //                   children: [
                  //                     customBuildIconButton(
                  //                       height: 50,
                  //                       width: 50,
                  //                       icon: "assets/icons/draft.png",
                  //                       onClick: () async {
                  //                         await Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                             builder: (_) => const DraftOrderPage(),
                  //                           ),
                  //                         );
                  //                         await  getNotice();
                  //                         //Fluttertoast.showToast(msg: notice);
                  //                         setState(() {});
                  //                       },
                  //                       title: buttonNames?.get('draft_order') == "" ? 'Draft Order' : buttonNames?.get('draft_order') ?? 'Draft Order',
                  //                       sizeWidth: screenWidth,
                  //                       inputColor: Colors.white,
                  //                     ),
                  //                     Positioned(
                  //                         right: 0,
                  //                         child: Container(
                  //                           height: 35,
                  //                           width: 35,
                  //                           decoration: BoxDecoration(
                  //                             color: const Color.fromARGB(135, 2, 160, 68),
                  //                             borderRadius: BorderRadius.circular(15),
                  //                           ),
                  //                           child: Center(
                  //                             child: Text(Boxes.getCustomerUsers().length.toString(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  //                           ),
                  //                         ))
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //               Expanded(
                  //                 child: customBuildIconButton(
                  //                   height: 45,
                  //                   width: 45,
                  //                   icon: "assets/icons/documents.png",
                  //                   onClick: () async {
                  //                     await Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                         builder: (context) => OrderReportWebViewScreen(
                  //                           report_url: report_sales_url,
                  //                           cid: cid,
                  //                           userId: userId,
                  //                           userPassword: userPassword,
                  //                         ),
                  //                       ),
                  //                     );
                  //                     await  getNotice();
                  //                     //Fluttertoast.showToast(msg: notice);
                  //                   },
                  //                   title: buttonNames?.get('order_report') == "" ? 'Report' : buttonNames?.get('order_report') ?? 'Report',
                  //                   sizeWidth: screenWidth,
                  //                   inputColor: Colors.white,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     : Container(),
                  // orderFlag
                  //     ? const SizedBox(
                  //   height: 10,
                  // )
                  //     : const SizedBox.shrink(),

                  ///********************************************* New Rx section **************************************///
                  rxFlag
                      ? Container(
                        height: screenHeight / 3.5,
                        decoration: BoxDecoration(color: const Color(0xFFE2EFDA), borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: customBuildIconButton(
                                        height: 42,
                                        width: 42,
                                        icon: "assets/icons/prescriptionRx.png",
                                        onClick: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (context) => BranchSelectiionScreen()));
                                          // await Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => RxPage(
                                          //       address: '',
                                          //       areaId: '',
                                          //       areaName: '',
                                          //       ck: '',
                                          //       dcrKey: 0,
                                          //       docId: '',
                                          //       docName: '',
                                          //       uniqueId: 0,
                                          //       draftRxMedicinItem: [],
                                          //       image1: '',
                                          //       dcrGrad: '',

                                          //       phnNum: '',
                                          //       patientName: '',
                                          //       gender: '',
                                          //       dob: '',
                                          //       stripWastage: '',
                                          //       systemName: '',
                                          //       disease: '',
                                          //       patientTemperament: '',
                                          //       beforeDiabetes: '',
                                          //       afterDiabetes: '',
                                          //       bloodSystolic: '',
                                          //       bloodDiastolic: '',
                                          //       oxygenLevel: '',
                                          //       bodyTemperature: '',
                                          //       weight: '',
                                          //       heightFeet: '',
                                          //       heightInch: '',
                                          //     ),
                                          //   ),
                                          // );
                                          await getNotice();
                                          //Fluttertoast.showToast(msg: notice);
                                          setState(() {});
                                        },
                                        title: buttonNames?.get('seen_rx_capture') == "" ? 'Prescription Capture' : buttonNames?.get('seen_rx_capture') ?? 'Prescription Capture',
                                        sizeWidth: screenWidth,
                                        inputColor: const Color(0xff70BA85).withOpacity(.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          customBuildIconButton(
                                            height: 39,
                                            width: 39,
                                            icon: "assets/icons/folderRx.png",
                                            onClick: () async {
                                              await Navigator.push(context, MaterialPageRoute(builder: (_) => const RxDraftPage()));
                                              await getNotice();
                                              //Fluttertoast.showToast(msg: notice);

                                              setState(() {});
                                            },
                                            title: buttonNames?.get('draft_seen_rx') == "" ? 'Draft Prescription' : buttonNames?.get('draft_seen_rx') ?? 'Draft Prescription',
                                            sizeWidth: screenWidth,
                                            //inputColor: Colors.white,
                                            inputColor: const Color(0xff70BA85).withOpacity(.3),
                                          ),
                                          Boxes.rxdDoctor().length == 0
                                              ? const SizedBox.shrink()
                                              : Positioned(right: 0, child: Container(height: 35, width: 35, decoration: BoxDecoration(color: const Color.fromARGB(135, 2, 160, 68), borderRadius: BorderRadius.circular(15)), child: Center(child: Text(Boxes.rxdDoctor().length.toString(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: customBuildIconButton(
                                        height: 42,
                                        width: 42,
                                        icon: "assets/icons/rxreport.png",
                                        onClick: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (_) => PrescriptionReportPage()));
                                          await getNotice();
                                        },
                                        title: buttonNames?.get('seen_rx_report') == "" ? 'Prescription Report' : buttonNames?.get('seen_rx_report') ?? 'Prescription Report',
                                        sizeWidth: screenWidth,
                                        //inputColor: Colors.white,
                                        inputColor: const Color(0xff70BA85).withOpacity(.3),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  rxFlag ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  ///******************************************** Visit Section ********************************************///
                  dcrFlag
                      ? Container(
                        height: screenHeight / 3.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: const Color(0xFFDDEBF7), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: customBuildIconButton(
                                icon: "assets/icons/newdcr2.png",
                                onClick: () async {
                                  if (areaPage == false) {
                                    print('xxx');
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorTerritoryPage()));
                                    await getNotice();
                                    setState(() {});
                                  } else {
                                    print('yyy');
                                    await Navigator.push(context, MaterialPageRoute(builder: (_) => AreaPage(isdcr: "dcr")));
                                    await getNotice();
                                    setState(() {});
                                  }
                                },
                                title: buttonNames?.get('new_dcr') == "" ? 'New Visit' : buttonNames?.get('new_dcr') ?? 'New Visit',
                                sizeWidth: screenWidth,
                                inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                height: 50,
                                width: 50,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      customBuildIconButton(
                                        height: 40,
                                        width: 40,
                                        icon: "assets/icons/first-aid-kit.png",
                                        onClick: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DraftDCRScreen()));
                                          await getNotice();
                                          //Fluttertoast.showToast(msg: notice);
                                          setState(() {});
                                        },
                                        title: buttonNames?.get('draft_dcr') == "" ? 'Draft Visit' : buttonNames?.get('draft_dcr') ?? 'Draft Visit',
                                        sizeWidth: screenWidth,
                                        //inputColor: Colors.white,
                                        inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                      ),
                                      Boxes.dcrUsers().length == 0
                                          ? const SizedBox.shrink()
                                          : Positioned(right: 0, child: Container(height: 35, width: 35, decoration: BoxDecoration(color: const Color.fromARGB(135, 2, 160, 68), borderRadius: BorderRadius.circular(15)), child: Center(child: Text(Boxes.dcrUsers().length.toString(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: customBuildIconButton(
                                    height: 50,
                                    width: 50,
                                    icon: "assets/icons/dcrReport.png",
                                    onClick: () async {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => VisitReportPage()));
                                      await getNotice();
                                      //Fluttertoast.showToast(msg: notice);
                                    },
                                    title: buttonNames?.get('dcr_report') == "" ? "Visit Report" : buttonNames?.get('dcr_report') ?? 'Visit Report',
                                    sizeWidth: screenWidth,
                                    //inputColor: Colors.white,
                                    inputColor: const Color(0xff56CCF2).withOpacity(.3),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  dcrFlag ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  ///*********************************** Patient Call & Board Meeting, Reports *************************************************///
                  patientCallBoardMeeting
                      ? Container(
                        height: screenHeight / 7,
                        decoration: BoxDecoration(
                          //color: const Color(0xFFDDE0F7),
                          color: const Color(0xFFDDE0F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 5,
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                          width: screenWidth,
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PatientCallBoardMeeting()));
                                                await getNotice();
                                              },
                                              label: const Text(
                                                //buttonNames?.get('plug_in_reports') == " " ? 'Patient Call & Board Meeting' : buttonNames?.get('plug_in_reports') ?? 'Patient Call & Board Meeting',
                                                'Patient Call & Board Meeting',
                                                style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              icon: const Icon(Icons.phone_android_sharp, color: Color.fromARGB(255, 27, 56, 34), size: 28),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 5,
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                          width: screenWidth,
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoardMeetingReport()));
                                                await getNotice();
                                              },
                                              label: const Text(
                                                //buttonNames?.get('activity_log') == "" ? 'Report' : buttonNames?.get('activity_log') ?? 'Report',
                                                'Report',
                                                style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              icon: const Icon(
                                                //Icons.fact_check_outlined,
                                                //Icons.note_alt_outlined,
                                                //Icons.event_note_outlined,
                                                Icons.note_alt,
                                                color: Color.fromARGB(255, 27, 56, 34),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  patientCallBoardMeeting == true ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  ///*********************************** Exam & Result *************************************************///
                  examFlag
                      ? Container(
                        height: screenHeight / 7,
                        decoration: BoxDecoration(
                          //color: const Color(0xFFDDEBF7),
                          color: const Color(0xFFE2EFDA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            elevation: 5,
                                            child: Container(
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                              width: screenWidth,
                                              height: MediaQuery.of(context).size.height / 8,
                                              child: Padding(
                                                padding: const EdgeInsets.all(6),
                                                child: TextButton.icon(
                                                  onPressed: () async {
                                                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExamPage()));
                                                    await getNotice();
                                                  },
                                                  label: const Text(
                                                    //buttonNames?.get('plug_in_reports') == " " ? 'Exam' : buttonNames?.get('plug_in_reports') ?? 'Exam',
                                                    'Exam',
                                                    style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                                                  ),
                                                  icon: const Icon(Icons.note_alt_outlined, color: Color.fromARGB(255, 27, 56, 34), size: 28),
                                                ),
                                              ),
                                            ),
                                          ),
                                          examCount == 0 ? Positioned(right: 0, child: Container(height: 35, width: 35, decoration: BoxDecoration(color: const Color.fromARGB(135, 2, 160, 68), borderRadius: BorderRadius.circular(15)), child: Center(child: Text(examCount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))) : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 5,
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                          width: screenWidth,
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExamResultPage()));
                                                await getNotice();
                                              },
                                              label: const Text(
                                                //buttonNames?.get('activity_log') == "" ? 'Result' : buttonNames?.get('activity_log') ?? 'Result',
                                                'Result',
                                                style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              icon: const Icon(
                                                Icons.fact_check_outlined,
                                                //Icons.note_alt_outlined,
                                                //Icons.event_note_outlined,
                                                //Icons.note_alt,
                                                color: Color.fromARGB(255, 27, 56, 34),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  examFlag == true ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  ///*******************************************Expense and Attendance  section ***********************************///
                  // othersFlag
                  //     ? Container(
                  //   height: screenHeight / 6.9,
                  //   decoration: BoxDecoration(color: const Color(0xFFE2EFDA), borderRadius: BorderRadius.circular(12)),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: customBuildButton(
                  //               onClick: () async {
                  //                 await Navigator.push(context,
                  //                     MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                  //                 await  getNotice();
                  //                 //Fluttertoast.showToast(msg: notice);
                  //               },
                  //               icon: Icons.assignment_turned_in_sharp,
                  //               title: buttonNames?.get('attendance') == "" ? 'Attendance' : buttonNames?.get('attendance') ?? 'Attendance',
                  //               sizeWidth: screenWidth,
                  //               inputColor: Colors.white,
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           Expanded(
                  //             child: customBuildButton(
                  //               icon: Icons.add,
                  //               onClick: expense_flag ? () async {
                  //                 await Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) => const ExpensePage(),
                  //                   ),
                  //                 );
                  //                 await  getNotice();
                  //                 //Fluttertoast.showToast(msg: notice);
                  //               } : (){},
                  //               title: buttonNames?.get('expense') == "" ? 'Expense' : buttonNames?.get('expense') ?? 'Expense',
                  //               sizeWidth: screenWidth,
                  //               inputColor: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     : Container(),
                  // othersFlag
                  //     ? const SizedBox(
                  //   height: 10,
                  // )
                  //     : const SizedBox.shrink(),

                  ///******************************************* Leave Request and Leave Report **********************************///
                  // leave_flag
                  //     ? Container(
                  //   height: screenHeight / 6.9,
                  //   decoration: BoxDecoration(color: const Color(0xFFE2EFDA), borderRadius: BorderRadius.circular(12)),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: Link(
                  //               uri: Uri.parse('$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //               target: LinkTarget.blank,
                  //               builder: (BuildContext ctx, FollowLink? openLink) {
                  //                 // debugPrint(
                  //                 //     "$leave_request_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword");
                  //                 return Card(
                  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //                   elevation: 5,
                  //                   child: Container(
                  //                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  //                     width: screenWidth,
                  //                     height: MediaQuery.of(context).size.height / 8,
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(10.0),
                  //                       child: TextButton.icon(
                  //                         onPressed: openLink,
                  //                         label: Text(
                  //                           buttonNames?.get('leave_request') == "" ? 'Leave Request' : buttonNames?.get('leave_request') ?? 'Leave Request',
                  //                           style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                  //                         ),
                  //                         icon: const Icon(
                  //                           Icons.leave_bags_at_home_rounded,
                  //                           color: Color.fromARGB(255, 27, 56, 34),
                  //                           size: 28,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           Expanded(
                  //             child: Link(
                  //               uri: Uri.parse('$leave_report_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                  //               target: LinkTarget.blank,
                  //               builder: (BuildContext ctx, FollowLink? openLink) {
                  //                 return Card(
                  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //                   elevation: 5,
                  //                   child: Container(
                  //                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  //                     width: screenWidth,
                  //                     height: MediaQuery.of(context).size.height / 8,
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(10.0),
                  //                       child: TextButton.icon(
                  //                         onPressed: openLink,
                  //                         label: Text(
                  //                           buttonNames?.get('leave_report') == "" ? 'Leave Report' : buttonNames?.get('leave_report') ?? 'Leave Report',
                  //                           style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                  //                         ),
                  //                         icon: const Icon(
                  //                           Icons.insert_drive_file,
                  //                           color: Color.fromARGB(255, 27, 56, 34),
                  //                           size: 28,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     : Container(),
                  // othersFlag
                  //     ? const SizedBox(
                  //   height: 5,
                  // )
                  //     : const SizedBox.shrink(),

                  ///******************************************  Tour Plan *********************************************///
                  // !visitPlanFlag
                  //     ? SizedBox.shrink()
                  //     : visitPlanFlag
                  //     ? Container(
                  //   height: screenHeight / 7,
                  //   decoration: BoxDecoration(color: const Color(0xFFDDEBF7), borderRadius: BorderRadius.circular(12)),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Card(
                  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //                   elevation: 5,
                  //                   child: Container(
                  //                     decoration: BoxDecoration(color: const Color.fromARGB(255, 217, 224, 250), borderRadius: BorderRadius.circular(12)),
                  //                     width: screenWidth,
                  //                     height: MediaQuery.of(context).size.height / 8,
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(10.0),
                  //                       child: TextButton.icon(
                  //                         onPressed: () async {
                  //                           await Navigator.of(context).push(MaterialPageRoute(
                  //                             builder: (context) => TourPlanPage(),
                  //                           ));
                  //                           await  getNotice();
                  //                           //Fluttertoast.showToast(msg: notice);
                  //                         },
                  //                         label: Text(
                  //                           buttonNames?.get('tour_plan') == "" ? 'Tour Plan' : buttonNames?.get('tour_plan') ?? 'Tour Plan',
                  //                           style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500),
                  //                         ),
                  //                         icon: const Icon(
                  //                           Icons.tour_sharp,
                  //                           color: Color.fromARGB(255, 27, 56, 34),
                  //                           size: 28,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //               // ggggg
                  //               Expanded(
                  //                 child: Card(
                  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //                   elevation: 5,
                  //                   child: Container(
                  //                     decoration: BoxDecoration(color: const Color.fromARGB(255, 217, 224, 250), borderRadius: BorderRadius.circular(12)),
                  //                     width: screenWidth,
                  //                     height: MediaQuery.of(context).size.height / 8,
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(10.0),
                  //                       child: TextButton.icon(
                  //                         onPressed: exp_approval_flag
                  //                             ? () async {
                  //                           await Navigator.of(context).push(
                  //                             MaterialPageRoute(
                  //                               builder: (context) => ApprovalPage(),
                  //                             ),
                  //                           );
                  //                           await  getNotice();
                  //                           //Fluttertoast.showToast(msg: notice);
                  //                         }
                  //                             : () {
                  //                           AllServices().messageForUser("You are not Authorized");
                  //                         },
                  //                         label: Text(
                  //                           buttonNames?.get('approval') == "" ? 'Approval' : buttonNames?.get('approval') ?? 'Approval',
                  //                           // 'Approval & Compliance',
                  //                           style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 15, fontWeight: FontWeight.w500),
                  //                         ),
                  //                         icon: const Icon(
                  //                           Icons.touch_app_rounded,
                  //                           color: Color.fromARGB(255, 27, 56, 34),
                  //                           size: 28,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     : Container(),
                  // visitPlanFlag
                  //     ? const SizedBox(
                  //   height: 5,
                  // )
                  //     : const SizedBox.shrink(),

                  ///***********************************  Plugg-in & Reports *************************************************///
                  pluginFlag
                      ? Container(
                        height: screenHeight / 7,
                        decoration: BoxDecoration(color: const Color(0xFFDDEBF7), borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 5,
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                          width: screenWidth,
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlugInReportsPage()));
                                                await getNotice();
                                                //Fluttertoast.showToast(msg: notice);
                                              },
                                              label: Text(buttonNames?.get('plug_in_reports') == " " ? 'Plug-in &  Reports' : buttonNames?.get('plug_in_reports') ?? 'Plug-in &  Reports', style: const TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500)),
                                              icon: const Icon(Icons.insert_drive_file, color: Color.fromARGB(255, 27, 56, 34), size: 28),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 5,
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                          width: screenWidth,
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityLog()));
                                                await getNotice();
                                                //Fluttertoast.showToast(msg: notice);
                                              },
                                              label: Text(buttonNames?.get('activity_log') == "" ? 'Activity Log' : buttonNames?.get('activity_log') ?? 'Activity Log', style: TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500)),
                                              icon: const Icon(Icons.local_activity_rounded, color: Color.fromARGB(255, 27, 56, 34), size: 28),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  pluginFlag == true ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  ///****************************************** Sync Data************************************************///
                  Container(
                    height: screenHeight / 7,
                    width: screenWidth,
                    decoration: BoxDecoration(color: const Color(0xFFE2EFDA), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //==========================================================Notice flag +Notice url will be here====================================
                            notice_flag
                                ? Expanded(
                                  child: Stack(
                                    children: [
                                      customBuildButton(
                                        icon: Icons.note_alt,
                                        onClick: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const NoticeScreen()));
                                          await getNotice();
                                          //Fluttertoast.showToast(msg: notice);
                                        },
                                        title: buttonNames?.get('notice') == "" ? 'Notice' : buttonNames?.get('notice') ?? 'Notice',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                      noticeCount.isNotEmpty ? const SizedBox.shrink() : Positioned(right: 0, child: Container(height: 35, width: 35, decoration: BoxDecoration(color: const Color.fromARGB(135, 2, 160, 68), borderRadius: BorderRadius.circular(15)), child: Center(child: Text(noticeCount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
                                    ],
                                  ),
                                )
                                : const SizedBox.shrink(),
                            const SizedBox(width: 5),
                            Expanded(
                              child: customBuildButton(
                                icon: Icons.sync,
                                onClick: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (_) => SyncDataTabScreen(cid: cid, userId: userId, userPassword: userPassword)));
                                  await getNotice();
                                  //Fluttertoast.showToast(msg: notice);
                                },
                                title: buttonNames?.get('sync_data') == "" ? 'Sync Data' : buttonNames?.get('sync_data') ?? 'Sync Data',
                                sizeWidth: screenWidth,
                                inputColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///*****************************************Check in button****************************************************///
                  check_in_flag == true ? const SizedBox(height: 10) : const SizedBox.shrink(),
                  check_in_flag
                      ? Container(
                        height: screenHeight / 7,
                        decoration: BoxDecoration(color: const Color(0xFFDDEBF7), borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.of(context).size.width,
                        child:
                            loading
                                ? const Center(child: CircularProgressIndicator())
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Card(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                elevation: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                  width: screenWidth,
                                                  height: MediaQuery.of(context).size.height / 8,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextButton.icon(
                                                      onPressed: () async {
                                                        loading = true;
                                                        setState(() {});
                                                        getLatLong();
                                                        await checkInOut_submit(context, 'CHECKIN');
                                                        loading = false;
                                                        setState(() {});
                                                      },
                                                      label: Text(buttonNames?.get('check_in') == " " ? 'Check In' : buttonNames?.get('check_in') ?? 'Check In', style: const TextStyle(color: Color.fromARGB(255, 29, 67, 78), fontSize: 16, fontWeight: FontWeight.w500)),
                                                      icon: const Icon(Icons.my_location, color: Color.fromARGB(255, 27, 56, 34), size: 28),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                      )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getAllCustomarData() async {
    // await openBox();
    final box = Hive.box('data');
    var mymap = box.toMap().values.toList();

    if (mymap.isEmpty) {
      data.add('empty');
    } else {
      data = mymap;

      await Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerListScreen(terrorId: "", terrorName: '', data: data)));
    }
  }
}
