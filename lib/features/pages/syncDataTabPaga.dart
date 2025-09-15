// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../core/Rx/Medicine/syncMedicineListToHive.dart';
import '../../data/datasources/Sync_customer_items/syncItemsToHive.dart';
import '../../data/datasources/local_storage/boxes.dart';
import '../../data/service/network_connectivity.dart';
import '../Widgets/syncCustomButton.dart';
import 'DCR_section/dcr_saveToHive.dart';
import 'DCR_section/gift_sample_ppm_save&getTohive.dart';
import 'Expense/expense_type_in_hive.dart';
import 'homePage.dart';
import 'order_and_dcr_root_sync.dart';

class SyncDataTabScreen extends StatefulWidget {
  String cid;
  String userId;
  String userPassword;

  SyncDataTabScreen({
    Key? key,
    required this.cid,
    required this.userId,
    required this.userPassword,
  }) : super(key: key);

  @override
  State<SyncDataTabScreen> createState() => _SyncDataTabScreenState();
}

class _SyncDataTabScreenState extends State<SyncDataTabScreen> {
  // Box box=Hive.box('data');
  String sync_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  String userName = '';
  String user_id = '';
  String status = 'failed';
  String buttonTitle = '';
  bool _loading = false;
  bool orderFlag = false;
  bool dcrFlag = false;
  bool rxFlag = false;

  List data = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // List<SyncCustomerData>? data;

  final mydatabox = Boxes.allData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        cid = mydatabox.get("CID") ?? widget.cid;
        userId = mydatabox.get("USER_ID") ?? widget.userId;

        userPassword = mydatabox.get("PASSWORD") ?? widget.userPassword;

        userName = mydatabox.get("userName");
        user_id = mydatabox.get("user_id")!;
        orderFlag = mydatabox.get('order_flag') ?? false;
        dcrFlag = mydatabox.get('dcr_flag') ?? false;
        rxFlag = mydatabox.get('rx_flag') ?? false;
      });

      debugPrint("new order flag $orderFlag");
      debugPrint("dcr flag $dcrFlag");
      debugPrint("rx flag$rxFlag");
    }
    // });
  }

  void _submitToastforOrder3() {
    Fluttertoast.showToast(
        msg: 'No Internet Connection\nPlease check your internet connection.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xffD8E5F1),
      appBar: AppBar(
        title: const Text(
          'Sync Data',
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () async {
                              setState(() {
                                buttonTitle = 'Sync';

                                _loading = true;
                              });
                              bool result =
                                  await NetworkConnecticity.checkConnectivity();
                              if (result == true) {
                                dmPath(cid, context);
                                Future.delayed(const Duration(seconds: 7), () {
                                  setState(() {
                                    _loading = false;
                                  });
                                });
                              } else {
                                _submitToastforOrder3();
                              }
                            },
                            color: Colors.teal.withOpacity(.5),
                            title: 'Sync ALL',
                            sizeWidth: screenWidth,
                          ),
                        ),
                      ],
                    ),
                    orderFlag
                        ? Row(
                            children: [
                              // Expanded(
                              //   child: syncCustomBuildButton(
                              //     onClick: () async {
                              //       setState(() {
                              //         buttonTitle = 'ITEMS';
                              //         _loading = true;
                              //       });
                              //       bool result = await NetworkConnecticity
                              //           .checkConnectivity();
                              //       if (result == true) {
                              //         dmPath(cid, context);
                              //         Future.delayed(const Duration(seconds: 4),
                              //             () {
                              //           setState(() {
                              //             _loading = false;
                              //           });
                              //         });
                              //       } else {
                              //         _submitToastforOrder3();
                              //
                              //         // debugPrint('No internet :( Reason:');
                              //         // debugPrint(InternetConnectionChecker().lastTryResults);
                              //       }
                              //     },
                              //     color: Colors.white,
                              //     title: 'ITEMS',
                              //     sizeWidth: screenWidth,
                              //   ),
                              // ),
                              rxFlag
                                  ? Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      buttonTitle = 'MEDICINE';
                                      _loading = true;
                                    });
                                    bool result = await NetworkConnecticity
                                        .checkConnectivity();
                                    if (result == true) {
                                      dmPath(cid, context);
                                      Future.delayed(const Duration(seconds: 3),
                                              () {
                                            setState(() {
                                              _loading = false;
                                            });
                                          });
                                      // SyncMedicinetoHive().medicinetoHive(
                                      //     sync_url, cid, userId, userPassword, context);
                                    } else {
                                      _submitToastforOrder3();

                                      // debugPrint('No internet :( Reason:');
                                      // debugPrint(InternetConnectionChecker().lastTryResults);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'MEDICINE\n',
                                  sizeWidth: screenWidth,
                                ),
                              )
                                  : const Text(""),
                              Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      buttonTitle = 'CUSTOMER';
                                      _loading = true;
                                    });
                                    bool result = await NetworkConnecticity
                                        .checkConnectivity();
                                    if (result == true) {
                                      dmPath(cid, context);
                                      Future.delayed(const Duration(seconds: 4),
                                          () {
                                        setState(() {
                                          _loading = false;
                                        });
                                      });
                                      // _syncCustomerDataToHive();
                                    } else {
                                      _submitToastforOrder3();

                                      // debugPrint('No internet :( Reason:');
                                      // debugPrint(InternetConnectionChecker().lastTryResults);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'CUSTOMER',
                                  sizeWidth: screenWidth,
                                ),
                              ),
                            ],
                          )
                        : const Text(""),
                    Row(
                      children: [
                        dcrFlag
                            ? Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      buttonTitle = 'GIFT SAMPLE PPM';
                                      _loading = true;
                                    });
                                    bool result = await NetworkConnecticity
                                        .checkConnectivity();
                                    if (result == true) {
                                      dmPath(cid, context);
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        setState(() {
                                          _loading = false;
                                        });
                                      });
                                    } else {
                                      _submitToastforOrder3();

                                      // debugPrint('No internet :( Reason:');
                                      // debugPrint(InternetConnectionChecker().lastTryResults);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'GIFT\nSAMPLE PPM',
                                  sizeWidth: screenWidth,
                                ),
                              )
                            : const Text(""),
                        // rxFlag
                        //     ? Expanded(
                        //         child: syncCustomBuildButton(
                        //           onClick: () async {
                        //             setState(() {
                        //               buttonTitle = 'MEDICINE';
                        //               _loading = true;
                        //             });
                        //             bool result = await NetworkConnecticity
                        //                 .checkConnectivity();
                        //             if (result == true) {
                        //               dmPath(cid, context);
                        //               Future.delayed(const Duration(seconds: 3),
                        //                   () {
                        //                 setState(() {
                        //                   _loading = false;
                        //                 });
                        //               });
                        //               // SyncMedicinetoHive().medicinetoHive(
                        //               //     sync_url, cid, userId, userPassword, context);
                        //             } else {
                        //               _submitToastforOrder3();
                        //
                        //               // debugPrint('No internet :( Reason:');
                        //               // debugPrint(InternetConnectionChecker().lastTryResults);
                        //             }
                        //           },
                        //           color: Colors.white,
                        //           title: 'MEDICINE\n',
                        //           sizeWidth: screenWidth,
                        //         ),
                        //       )
                        //     : const Text(""),
                        dcrFlag || rxFlag
                        ?
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () async {
                              setState(() {
                                buttonTitle = 'DOCTOR';
                                _loading = true;
                              });
                              bool result = await NetworkConnecticity
                                  .checkConnectivity();
                              if (result == true) {
                                dmPath(cid, context);
                                Future.delayed(const Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        _loading = false;
                                      });
                                    });
                                // SyncDcrtoHive().syncDcrToHive(
                                //     sync_url, cid, userId, userPassword, context);
                              } else {
                                _submitToastforOrder3();

                                // debugPrint('No internet :( Reason:');
                                // debugPrint(InternetConnectionChecker().lastTryResults);
                              }
                            },
                            color: Colors.white,
                            title: 'Visit Office',
                            sizeWidth: screenWidth,
                          ),
                        )
                            : const Text(""),
                      ],
                    ),
                    // dcrFlag || rxFlag
                    //     ? Row(
                    //         children: [
                    //           Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   buttonTitle = 'DOCTOR';
                    //                   _loading = true;
                    //                 });
                    //                 bool result = await NetworkConnecticity
                    //                     .checkConnectivity();
                    //                 if (result == true) {
                    //                   dmPath(cid, context);
                    //                   Future.delayed(const Duration(seconds: 3),
                    //                       () {
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   });
                    //                   // SyncDcrtoHive().syncDcrToHive(
                    //                   //     sync_url, cid, userId, userPassword, context);
                    //                 } else {
                    //                   _submitToastforOrder3();
                    //
                    //                   // debugPrint('No internet :( Reason:');
                    //                   // debugPrint(InternetConnectionChecker().lastTryResults);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'Visit Office',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           ),
                    //           const Expanded(child: SizedBox())
                    //         ],
                    //       )
                    //     : const Text(""),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MyHomePage(
                                    // userName: userName,
                                    // user_id: user_id,
                                    // userPassword: userPassword,
                                    userName: "",
                                    user_id: "",
                                    userPassword: "",
                                  ),
                                ),
                              );
                            },
                            color: const Color(0xff56CCF2).withOpacity(.4),
                            title: 'Go to Home Page',
                            sizeWidth: screenWidth,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ///********************************* Dm Path function **********************************************************
  Future dmPath(String cid, context) async {
    String sync_url;
    try {
      debugPrint(

          //"dmpath1::http://192.168.100.219:8000/physician_api/dmpath_test/get_dmpath?cid=$cid"
          "dmpath1::https://w05.yeapps.com/dmpath/dmpath_phy/get_dmpath?cid=$cid"
      );
      final http.Response response = await http.get(
        Uri.parse(

           //"http://192.168.100.219:8000/physician_api/dmpath_test/get_dmpath?cid=$cid")
           "https://w05.yeapps.com/dmpath/dmpath_phy/get_dmpath?cid=$cid")
      );

      var userInfo = json.decode(response.body);
      var status = userInfo['res_data'];
      var login_url = status['login_url'];
      String sync_url = status['sync_url']??'';
      String submit_url = status['submit_url']??'';
      // String report_url = status['report_url'];
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

      String sync_notice_url = status['sync_notice_url']??'';

      // final prefs = await SharedPreferences.getInstance();
      mydatabox.put('sync_url', sync_url);
      mydatabox.put('submit_url', submit_url);
      // mydatabox.put('report_url', report_url);
      mydatabox.put('photo_submit_url', photo_submit_url);
      mydatabox.put('activity_log_url', activity_log_url);
      mydatabox.put('client_outst_url', client_outst_url);
      mydatabox.put('user_area_url', user_area_url);
      mydatabox.put('photo_url', photo_url);
      mydatabox.put('leave_request_url', leave_request_url);
      mydatabox.put('leave_report_url', leave_report_url);
      mydatabox.put('plugin_url', plugin_url);
      mydatabox.put('board_meeting_submit_url', board_meeting_submit_url);
      mydatabox.put('visit_office_add_url', visit_office_add_url);
      mydatabox.put('visit_office_edit_url', visit_office_edit_url);
      mydatabox.put('tour_plan_url', tour_plan_url);
      mydatabox.put('tour_compliance_url', tour_compliance_url);
      mydatabox.put('client_url', client_url);
      mydatabox.put('doctor_url', doctor_url);
      mydatabox.put('user_sales_coll_ach_url', user_sales_coll_ach_url);
      mydatabox.put('os_details_url', os_details_url);
      mydatabox.put('ord_history_url', ord_history_url);
      mydatabox.put('inv_history_url', inv_history_url);
      mydatabox.put('client_edit_url', client_edit_url);
      mydatabox.put('timer_track_url', timer_track_url);
      mydatabox.put('order_approval_url', order_approval_url);
      mydatabox.put('order_list_url', order_list_url);

      mydatabox.put('check_in_url', check_in_url);

      mydatabox.put('gift_url', gift_url);
      mydatabox.put('sample_url', sample_url);
      mydatabox.put('ppm_url', ppm_url);
      mydatabox.put('activity_log_areawise_url', activity_log_areawise_url);

      mydatabox.put('prescription_report_url', prescriptionReportUrl);
      mydatabox.put('visit_report_url', visiReportUrl);
      mydatabox.put('board_meeting_report_url', patientCallBoardMeetingReportUrl);
      mydatabox.put('exam_url', examUrl);
      mydatabox.put('exam_result_url', examResultUrl);


      mydatabox.put('sync_notice_url', sync_notice_url);

      if (response.statusCode == 200) {
        if (buttonTitle == 'Sync') {
          //SyncItemstoHive().syncItemsToHive(sync_url, cid, userId, userPassword, context);

          SyncDcrGSPtoHive().syncDcrGiftToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrSampleToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrPpmToHive(sync_url, cid, userId, userPassword, context);
          SyncMedicinetoHive().medicinetoHive(sync_url, cid, userId, userPassword, context);
          SyncDcrtoHive().syncDcrToHive(sync_url, cid, userId, userPassword, context); //for rx doctor
          ExpenseTypeData().expenseEntry(context);
          DcrAndOrderHive().dcrandOrder(context); //New order and decr for MPO
        }
        else if (buttonTitle == 'ITEMS') {
          SyncItemstoHive()
              .syncItemsToHive(sync_url, cid, userId, userPassword, context);
        }
        else if (buttonTitle == 'CUSTOMER') {
          // _syncCustomerDataToHive(sync_url,context);//todo Old
          DcrAndOrderHive().dcrandOrder(context); //new
        }
        else if (buttonTitle == 'GIFT SAMPLE PPM') {
          SyncDcrGSPtoHive()
              .syncDcrGiftToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrSampleToHive(
              sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive()
              .syncDcrPpmToHive(sync_url, cid, userId, userPassword, context);
          SyncDcrGSPtoHive().syncDcrDiscussiontToHive(
              sync_url, cid, userId, userPassword, context);
        }
        else if (buttonTitle == 'MEDICINE') {
          SyncMedicinetoHive()
              .medicinetoHive(sync_url, cid, userId, userPassword, context);
        }
        else if (buttonTitle == 'DOCTOR') {
          SyncDcrtoHive().syncDcrToHive(
              sync_url, cid, userId, userPassword, context); //todo Old
          DcrAndOrderHive().dcrandOrder(context); //todo New
        }
      }

      // return isLoading;
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
  }

}
