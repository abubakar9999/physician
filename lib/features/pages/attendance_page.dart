// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:async';
import 'package:intl/intl.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/service/all_service.dart';
import '../../data/service/apiCall.dart';
import '../../data/service/auth_services.dart';
import 'attendace_approval_report_page.dart';
import 'attendance_approval_page.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with WidgetsBindingObserver {
  TextEditingController mtrReading = TextEditingController();
  late AnimationController controller;
  var dt = DateFormat('h:m a').format(DateTime.now());

  String? userPass;
  String? cid;
  String? userId;

  String? sync_url;
  String userName = '';
  String user_id = '';
  String? deviceId = '';
  var status;
  double? long;
  double? lat;

  String address = "";
  String meter_reading_last = "";
  bool reportAttendance = true;
  String startTime = '';
  bool isStart = false;
  bool isEnd = false;
  final databox = Boxes.allData();
  bool? dayStart;
  bool withoutMReading = false;
  var attendance = '';
  bool needApproval = false;
  bool isWithoutMTR = false;
  bool isLoading = false;
  bool transport_mode = false;
  String? logo_url_1;
  String? logo_url_2;
  bool attendance_approval_flag = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLatLong();
    if (mounted) {
      databox.get('submitType').toString() == "START" ? dayStart = true : dayStart = false;

      attendance = databox.get('attendance') ?? '';
      // attendance = '';

      setState(() {
        if ((databox.get("CID") == null) || (databox.get("USER_ID") == null) || databox.get("PASSWORD") == null) {
          return;
        } else {
          cid = databox.get("CID");
          userId = databox.get("USER_ID");
          userPass = databox.get("PASSWORD");
          sync_url = databox.get("sync_url")!;
          userName = databox.get("userName")!;
          user_id = databox.get("user_id")!;
          deviceId = databox.get("deviceId");
          logo_url_1 = databox.get('logo_url_1') ?? null;
          logo_url_2 = databox.get('logo_url_2') ?? null;
          meter_reading_last = databox.get('meter_reading_last')!;
          transport_mode = databox.get('transport_mode') ?? false;
          withoutMReading = databox.get('withoutMReading') ?? false;
          needApproval = databox.get('need_approval') ?? false;
          attendance_approval_flag = databox.get('attendance_approval_flag') ?? false;
          print("attendance_approval_flag $attendance_approval_flag");
        }

        print("------------- ${meter_reading_last}");
      });
    }
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
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

  Future<void> getLatLong() async {
    try {
      geo.Position value = await AllServices().determinePosition();
      debugPrint("value $value");

      setState(() {
        lat = value.latitude;
        long = value.longitude;
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLatLong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async =>
      //     await databox.get('present') != AllServices().isAttandanceSubmit()
      //         ? false
      //         : true,
      onWillPop: () async {
        var _attendance = await databox.get('attendance') ?? '';
        if (_attendance.toString().isEmpty) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text("Attendance", style: TextStyle(color: Colors.white)), centerTitle: true, backgroundColor: Colors.blue),
        endDrawer: Drawer(
          child: SizedBox(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 138, 201, 149)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                    // logo_url_2 != null ?  CachedNetworkImage(
                    //   imageUrl: logo_url_2!,
                    //   errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                    // )
                    //     : Image.asset("assets/images/mRep7_logo.png"),
                    Image.asset('assets/images/c_logo_1.png', fit: BoxFit.contain),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blueAccent),
                  title: const Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                  onTap: () async {
                    AuthServices.logOut(context);
                    // final prefs = await SharedPreferences.getInstance();
                    // timer_flag=false;
                    // await databox.put('PASSWORD', '');
                    // await mydatabox.put('USER_ID','');
                    // await mydatabox.put('timer_flag',timer_flag);
                    // await mydatabox.put('deviceId',"");

                    // debugPrint("timer flag : $timer_flag");

                    // setState(() {});
                    // if (await FlutterBackgroundService().isRunning()) {
                    //   FlutterBackgroundService().invoke("stopService");
                    // }
                    // LogOut().logoutpage(context);
                  },
                ),
                attendance_approval_flag
                    ? ListTile(
                      leading: const Icon(Icons.fact_check_outlined, color: Colors.blueAccent),
                      title: const Text('Late Attendance Request', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceApprovalScreen()));
                        // final prefs = await SharedPreferences.getInstance();
                        // timer_flag=false;
                        // await databox.put('PASSWORD', '');
                        // await mydatabox.put('USER_ID','');
                        // await mydatabox.put('timer_flag',timer_flag);
                        // await mydatabox.put('deviceId',"");

                        // debugPrint("timer flag : $timer_flag");

                        // setState(() {});
                        // if (await FlutterBackgroundService().isRunning()) {
                        //   FlutterBackgroundService().invoke("stopService");
                        // }
                        // LogOut().logoutpage(context);
                      },
                    )
                    : SizedBox.shrink(),
                attendance_approval_flag
                    ? ListTile(
                      leading: const Icon(Icons.sticky_note_2_outlined, color: Colors.blueAccent),
                      title: const Text('Late Attendance Report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 15, 53, 85))),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceApprovalReportScreen()));
                        // final prefs = await SharedPreferences.getInstance();
                        // timer_flag=false;
                        // await databox.put('PASSWORD', '');
                        // await mydatabox.put('USER_ID','');
                        // await mydatabox.put('timer_flag',timer_flag);
                        // await mydatabox.put('deviceId',"");

                        // debugPrint("timer flag : $timer_flag");

                        // setState(() {});
                        // if (await FlutterBackgroundService().isRunning()) {
                        //   FlutterBackgroundService().invoke("stopService");
                        // }
                        // LogOut().logoutpage(context);
                      },
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child:
              (lat == null && long == null)
                  ? const Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Center(child: Text("Please On your Device Location")), Center(child: CircularProgressIndicator())])
                  : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DataTable(
                          dataRowHeight: 70,
                          columns: const [DataColumn(label: Text("")), DataColumn(label: Text(""))],
                          rows: [
                            DataRow(cells: [const DataCell(Text("Name", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(userName, style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            DataRow(cells: [const DataCell(Text("ID", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(user_id, style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            DataRow(cells: [const DataCell(Text("Latitude", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(lat.toString(), style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            DataRow(cells: [const DataCell(Text("Longitude", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text("$long", style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            DataRow(cells: [const DataCell(Text("Address", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(address, style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            DataRow(cells: [const DataCell(Text("Time", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(dt, style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                            if (transport_mode == true) ...[
                              DataRow(cells: [const DataCell(Text("Last MTR Reading", style: TextStyle(color: Colors.black, fontSize: 18))), DataCell(Text(meter_reading_last, style: const TextStyle(color: Colors.black, fontSize: 18)))]),
                              DataRow(
                                color: MaterialStateProperty.all(const Color.fromARGB(255, 230, 179, 192)),
                                cells: [
                                  DataCell(
                                    RichText(text: const TextSpan(text: 'Meter Reading', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400), children: <TextSpan>[TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w400))])),
                                    // Text(
                                    //   "Meter Reading",
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.w400),
                                    // ),
                                  ),
                                  DataCell(TextField(controller: mtrReading, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500), inputFormatters: [FilteringTextInputFormatter.digitsOnly], keyboardType: TextInputType.number)),
                                ],
                              ),
                            ],
                          ],
                        ),
                        needApproval && attendance.isEmpty
                            ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: attendance,
                                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.5)),
                                      contentPadding: EdgeInsets.all(4),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(.5)), borderRadius: BorderRadius.circular(4)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.green.shade400), borderRadius: BorderRadius.circular(4)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            )
                            : SizedBox(),
                        // transport_mode
                        //     ? DataTable(
                        //         dataRowHeight: 70,
                        //         columns: const [
                        //           DataColumn(label: Text("")),
                        //           DataColumn(label: Text(""))
                        //         ],
                        //         rows: [
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Latitude",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   lat.toString(),
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Longitude",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   "$long",
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Address",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   address,
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Time",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   dt,
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Last MTR Reading",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   meter_reading_last,
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           withoutMReading
                        //               ? DataRow(
                        //                   cells: [
                        //                     DataCell(Text("")),
                        //                     DataCell(Text("")),
                        //                   ],
                        //                 )
                        //               : DataRow(
                        //                   color: MaterialStateProperty.all(
                        //                       const Color.fromARGB(
                        //                           255, 230, 179, 192)),
                        //                   cells: [
                        //                     DataCell(RichText(
                        //                       text: const TextSpan(
                        //                         text: 'Meter Reading',
                        //                         style: TextStyle(
                        //                             color: Colors.black,
                        //                             fontSize: 18,
                        //                             fontWeight: FontWeight.w400),
                        //                         children: <TextSpan>[
                        //                           TextSpan(
                        //                               text: ' *',
                        //                               style: TextStyle(
                        //                                   color: Colors.red,
                        //                                   fontSize: 18,
                        //                                   fontWeight:
                        //                                       FontWeight.w400)),
                        //                         ],
                        //                       ),
                        //                     )
                        //                         // Text(
                        //                         //   "Meter Reading",
                        //                         //   style: TextStyle(
                        //                         //       color: Colors.black,
                        //                         //       fontSize: 18,
                        //                         //       fontWeight: FontWeight.w400),
                        //                         // ),
                        //                         ),
                        //                     DataCell(
                        //                       TextField(
                        //                         controller: mtrReading,
                        //                         style: const TextStyle(
                        //                             color: Colors.black,
                        //                             fontWeight: FontWeight.w500),
                        //                         inputFormatters: [
                        //                           FilteringTextInputFormatter
                        //                               .digitsOnly
                        //                         ],
                        //                         keyboardType:
                        //                             TextInputType.number,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )
                        //         ],
                        //       )
                        //     : DataTable(
                        //         dataRowHeight: 70,
                        //         columns: const [
                        //           DataColumn(label: Text("")),
                        //           DataColumn(label: Text(""))
                        //         ],
                        //         rows: [
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Latitude",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   lat.toString(),
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Longitude",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   "$long",
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Address",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   address,
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           DataRow(
                        //             cells: [
                        //               const DataCell(
                        //                 Text(
                        //                   "Time",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                 Text(
                        //                   dt,
                        //                   style: const TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        cid.toString().toUpperCase() == "BIOPHARMA"
                            ? Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isWithoutMTR,
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        isWithoutMTR = value!;
                                      });
                                    },
                                  ),
                                  Text("Without Meter Reading"),
                                ],
                              ),
                            )
                            : SizedBox(),
                        //Spacer(),
                        SizedBox(height: 30.0),
                        Container(
                          alignment: Alignment.center,
                          child:
                              isLoading == true
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: attendance.isEmpty ? Colors.blue : Colors.blueGrey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0)),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      getLatLong();
                                      if (cid.toString().toUpperCase() == "BIOPHARMA") {
                                        if (isWithoutMTR == true) {
                                          if (attendance.isEmpty) {
                                            await attendanceAPI(context, "START", reportAttendance, userName, "", lat, long, address);
                                          } else {
                                            await attendanceAPI(context, "END", reportAttendance, userName, "", lat, long, address);
                                          }
                                        } else {
                                          if (mtrReading.text.isNotEmpty) {
                                            if (double.parse(meter_reading_last.toString()) <= double.parse(mtrReading.text)) {
                                              if (attendance.isEmpty) {
                                                await attendanceAPI(context, "START", reportAttendance, userName, mtrReading.text.toString(), lat, long, address);
                                              } else {
                                                await attendanceAPI(context, "END", reportAttendance, userName, mtrReading.text.toString(), lat, long, address);
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: 'Enter Valid Meter Reading', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                            }
                                          } else {
                                            Fluttertoast.showToast(msg: 'Please Input Meter Reading', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                          }
                                        }
                                      } else {
                                        if (transport_mode == true) {
                                          if (mtrReading.text.isNotEmpty) {
                                            if (double.parse(meter_reading_last.toString()) <= double.parse(mtrReading.text)) {
                                              if (attendance.isEmpty) {
                                                await attendanceAPI(context, "START", reportAttendance, userName, mtrReading.text.toString(), lat, long, address);
                                              } else {
                                                await attendanceAPI(context, "END", reportAttendance, userName, mtrReading.text.toString(), lat, long, address);
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: 'Enter Valid Meter Reading', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                            }
                                          } else {
                                            Fluttertoast.showToast(msg: 'Please Input Meter Reading', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                          }
                                        } else {
                                          if (attendance.isEmpty) {
                                            await attendanceAPI(context, "START", reportAttendance, userName, "", lat, long, address);
                                          } else {
                                            await attendanceAPI(context, "END", reportAttendance, userName, "", lat, long, address);
                                          }
                                        }
                                      }

                                      ////this code off 25-09-2023(no option to submit without mtr reading)
                                      // if (isWithoutMTR == true ||
                                      //     transport_mode == false ||
                                      //     withoutMReading == true) {
                                      //   if (attendance.isEmpty) {
                                      //     await databox.put(
                                      //         'withoutMReading', true);
                                      //     await attendanceAPI(
                                      //         context,
                                      //         "START",
                                      //         reportAttendance,
                                      //         userName,
                                      //         '',
                                      //         lat,
                                      //         long,
                                      //         address);
                                      //   } else {
                                      //     await databox.put(
                                      //         'withoutMReading', false);
                                      //     await attendanceAPI(
                                      //         context,
                                      //         "END",
                                      //         reportAttendance,
                                      //         userName,
                                      //         '',
                                      //         lat,
                                      //         long,
                                      //         address);
                                      //   }
                                      // } else {
                                      //   if (mtrReading.text.isNotEmpty) {
                                      //     if (double.parse(
                                      //             meter_reading_last.toString()) <=
                                      //         double.parse(mtrReading.text)) {
                                      //       if (attendance.isEmpty) {
                                      //         await attendanceAPI(
                                      //             context,
                                      //             "START",
                                      //             reportAttendance,
                                      //             userName,
                                      //             mtrReading.text.toString(),
                                      //             lat,
                                      //             long,
                                      //             address);
                                      //       } else {
                                      //         await attendanceAPI(
                                      //             context,
                                      //             "END",
                                      //             reportAttendance,
                                      //             userName,
                                      //             mtrReading.text.toString(),
                                      //             lat,
                                      //             long,
                                      //             address);
                                      //       }
                                      //     } else {
                                      //       Fluttertoast.showToast(
                                      //           msg: 'Enter Valid Meter Reading',
                                      //           toastLength: Toast.LENGTH_LONG,
                                      //           gravity: ToastGravity.SNACKBAR,
                                      //           backgroundColor: Colors.red,
                                      //           textColor: Colors.white,
                                      //           fontSize: 16.0);
                                      //     }
                                      //   } else {
                                      //     Fluttertoast.showToast(
                                      //         msg: 'Please Input Meter Reading',
                                      //         toastLength: Toast.LENGTH_LONG,
                                      //         gravity: ToastGravity.SNACKBAR,
                                      //         backgroundColor: Colors.red,
                                      //         textColor: Colors.white,
                                      //         fontSize: 16.0);
                                      //   }
                                      // }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: Text(attendance.isEmpty ? "Day Start" : "Day End", style: TextStyle(fontSize: 22)),
                                  ),
                        ),

                        // pevious attendance code
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     dayStart != true
                        //         ? SizedBox(
                        //             width:
                        //                 MediaQuery.of(context).size.width * 0.4,
                        //             height:
                        //                 MediaQuery.of(context).size.height * 0.07,
                        //             child: isStart == true
                        //                 ? const SizedBox(
                        //                     height: 100,
                        //                     width: 50,
                        //                     child: Center(
                        //                         child:
                        //                             CircularProgressIndicator()),
                        //                   )
                        //                 : ElevatedButton(
                        //                     style: ElevatedButton.styleFrom(
                        //                       foregroundColor: Colors.white,
                        //                       backgroundColor:
                        //                           Colors.teal.withOpacity(0.5),
                        //                       shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(15)),
                        //                     ),
                        //                     onPressed: () async {
                        //                       if (isWithoutMTR == true) {
                        //                         if (reportAttendance == true) {
                        //                           setState(() {
                        //                             isStart = true;
                        //                           });

                        //                           await attendanceAPI(
                        //                               context,
                        //                               "START",
                        //                               reportAttendance,
                        //                               userName,
                        //                               '',
                        //                               lat,
                        //                               long,
                        //                               address);
                        //                           reportAttendance = false;
                        //                           isStart = false;
                        //                           mtrReading.clear();
                        //                         } else {
                        //                           Fluttertoast.showToast(
                        //                               msg:
                        //                                   'Start Time has been Submitted for Today',
                        //                               toastLength:
                        //                                   Toast.LENGTH_LONG,
                        //                               gravity:
                        //                                   ToastGravity.SNACKBAR,
                        //                               backgroundColor: Colors.red,
                        //                               textColor: Colors.white,
                        //                               fontSize: 16.0);
                        //                         }
                        //                       } else {
                        //                         if (mtrReading.text != "") {
                        //                           if (reportAttendance == true) {
                        //                             setState(() {
                        //                               isStart = true;
                        //                             });

                        //                             await attendanceAPI(
                        //                                 context,
                        //                                 "START",
                        //                                 reportAttendance,
                        //                                 userName,
                        //                                 mtrReading.text
                        //                                     .toString(),
                        //                                 lat,
                        //                                 long,
                        //                                 address);
                        //                             reportAttendance = false;
                        //                             isStart = false;
                        //                             mtrReading.clear();
                        //                           } else {
                        //                             Fluttertoast.showToast(
                        //                                 msg:
                        //                                     'Start Time has been Submitted for Today',
                        //                                 toastLength:
                        //                                     Toast.LENGTH_LONG,
                        //                                 gravity:
                        //                                     ToastGravity.SNACKBAR,
                        //                                 backgroundColor:
                        //                                     Colors.red,
                        //                                 textColor: Colors.white,
                        //                                 fontSize: 16.0);
                        //                           }
                        //                         } else {
                        //                           Fluttertoast.showToast(
                        //                               msg:
                        //                                   'Please Input Meter Reading',
                        //                               toastLength:
                        //                                   Toast.LENGTH_LONG,
                        //                               gravity:
                        //                                   ToastGravity.SNACKBAR,
                        //                               backgroundColor: Colors.red,
                        //                               textColor: Colors.white,
                        //                               fontSize: 16.0);
                        //                         }
                        //                       }
                        //                     },
                        //                     child: const Text(
                        //                       "Day Start",
                        //                       style: TextStyle(fontSize: 20),
                        //                     ),
                        //                   ),
                        //           )
                        //         : const SizedBox.shrink(),
                        //     const SizedBox(
                        //       width: 20,
                        //     ),
                        //     dayStart == true
                        //         ? SizedBox(
                        //             width:
                        //                 MediaQuery.of(context).size.width * 0.4,
                        //             height:
                        //                 MediaQuery.of(context).size.height * 0.07,
                        //             child: isEnd == true
                        //                 ? const SizedBox(
                        //                     height: 100,
                        //                     width: 50,
                        //                     child: Center(
                        //                         child:
                        //                             CircularProgressIndicator()),
                        //                   )
                        //                 : ElevatedButton(
                        //                     style: ElevatedButton.styleFrom(
                        //                         foregroundColor: Colors.white,
                        //                         backgroundColor: Colors.blueGrey,
                        //                         shape: RoundedRectangleBorder(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     15))),
                        //                     onPressed: () async {
                        //                       if (isWithoutMTR == true) {
                        //                         setState(() {
                        //                           isEnd = true;
                        //                         });

                        //                         await attendanceAPI(
                        //                             context,
                        //                             "END",
                        //                             reportAttendance,
                        //                             userName,
                        //                             '',
                        //                             lat,
                        //                             long,
                        //                             address);
                        //                         isEnd = false;
                        //                         mtrReading.clear();
                        //                       } else {
                        //                         if (mtrReading.text != "") {
                        //                           //  if(await databox.get('present')==AllServices().isAttandanceSubmit()){
                        //                           setState(() {
                        //                             isEnd = true;
                        //                           });

                        //                           await attendanceAPI(
                        //                               context,
                        //                               "END",
                        //                               reportAttendance,
                        //                               userName,
                        //                               mtrReading.text.toString(),
                        //                               lat,
                        //                               long,
                        //                               address);
                        //                           isEnd = false;
                        //                           mtrReading.clear();

                        //                           // } else{
                        //                           //    Fluttertoast.showToast(
                        //                           //         msg: 'Please Day start Frist',
                        //                           //         toastLength: Toast.LENGTH_LONG,
                        //                           //         gravity: ToastGravity.SNACKBAR,
                        //                           //         backgroundColor: Colors.red,
                        //                           //         textColor: Colors.white,
                        //                           //         fontSize: 16.0);
                        //                           // }
                        //                         } else {
                        //                           Fluttertoast.showToast(
                        //                               msg:
                        //                                   'Please Input Meter Reading',
                        //                               toastLength:
                        //                                   Toast.LENGTH_LONG,
                        //                               gravity:
                        //                                   ToastGravity.SNACKBAR,
                        //                               backgroundColor: Colors.red,
                        //                               textColor: Colors.white,
                        //                               fontSize: 16.0);
                        //                         }
                        //                       }
                        //                     },
                        //                     child: const Text(
                        //                       "Day End",
                        //                       style: TextStyle(fontSize: 20),
                        //                     ),
                        //                   ),
                        //           )
                        //         : const SizedBox.shrink(),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
