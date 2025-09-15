import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/service/apiCall.dart';


class AttendanceApprovalScreen extends StatefulWidget {
  const AttendanceApprovalScreen({super.key});

  @override
  State<AttendanceApprovalScreen> createState() =>
      _AttendanceApprovalScreenState();
}

class _AttendanceApprovalScreenState extends State<AttendanceApprovalScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final myData = Boxes.allData();
  final TextEditingController noteController = TextEditingController();
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
  String noteText = '';

  @override
  void initState() {
    userName = myData.get("USER_ID");
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      getAddress(value.latitude, value.longitude);
    }).catchError((error) {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Late Attendance Request"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Form(
                key: key,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ]')),
                  ],
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  controller: noteController
                    ..addListener(() {
                      setState(() {
                        noteText = noteController.text;
                      });
                    }),
                  minLines: 4,
                  maxLines: 50,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 138, 201, 149).withOpacity(.5),
                      contentPadding: EdgeInsets.all(8),
                      border:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Type reason here...',hintStyle:TextStyle(color: Colors.black.withOpacity(.2))),
                  onChanged: (value) {
                    // noteText = (noteController.text).replaceAll(
                    //     RegExp('[^A-Za-z0-9]'), " ");
                    noteText = value.toString();
                  },
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Please enter reason";
                    else
                      return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: isLoading == true
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: attendance.isEmpty
                              ? Colors.green.shade400
                              : Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 12.0)),
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          print("get Latlong");
                          getLatLong();
                          print("api hitted");
                          await attendanceApprovalAPI(context, noteText);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
