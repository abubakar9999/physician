// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, file_names, must_be_immutable, unused_local_variable, use_build_context_synchronously
// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:physician_latest/core/Rx/promotional_drawer.dart';
import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';
import '../../data/models/merged_item_model.dart';
import '../../data/service/all_service.dart';
import '../../data/service/network_connectivity.dart';
import '../../main.dart';
import '../../features/pages/homePage.dart';
import '../../features/pages/loginPage.dart';
import '../constant.dart';
import 'package:image/image.dart' as img;

import 'doctorListfromHive.dart';
import 'dxDrawer.dart';
import 'medicin_list_screen.dart';

var quantity = "";

class RxPage extends StatefulWidget {
  int dcrKey;
  int uniqueId;
  String ck;
  String docName;
  String dcrGrad;
  String docId;
  String areaName;
  String areaId;
  String address;
  String image1;
  String phnNum;
  String patientName;
  String gender;
  String dob;
  String stripWastage;
  String systemName;
  String disease;
  String patientTemperament;
  String beforeDiabetes;
  String afterDiabetes;
  String bloodSystolic;
  String bloodDiastolic;
  String oxygenLevel;
  String bodyTemperature;
  String weight;
  String heightFeet;
  String heightInch;
  String branch_id;
  List<MedicineListModel> draftRxMedicinItem;

  RxPage({
    Key? key,
    required this.dcrKey,
    required this.uniqueId,
    required this.ck,
    required this.docName,
    required this.dcrGrad,
    required this.docId,
    required this.areaName,
    required this.areaId,
    required this.address,
    required this.image1,
    required this.draftRxMedicinItem,
    required this.phnNum,
    required this.patientName,
    required this.gender,
    required this.dob,
    required this.stripWastage,
    required this.systemName,
    required this.disease,
    required this.patientTemperament,
    required this.beforeDiabetes,
    required this.afterDiabetes,
    required this.bloodSystolic,
    required this.bloodDiastolic,
    required this.oxygenLevel,
    required this.bodyTemperature,
    required this.weight,
    required this.heightFeet,
    required this.heightInch,
    required this.branch_id,
  }) : super(key: key);

  @override
  State<RxPage> createState() => _RxPageState();
}

class _RxPageState extends State<RxPage> {
  Map<String, TextEditingController> controllers = {};
  final TextEditingController phnNumberController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool isDateSelected = false;

  String address = "";

  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  Box? box;
  List doctorData = [];
  List medicineData = [];
  List<RxDcrDataModel> finalDoctorList = [];
  List<MedicineListModel> finalMedicineList = [];
  List finalDraftDoctorList = [];
  List finalDraftMedicineList = [];
  List rxMedicineDataList = [];
  List tempMedicineList = [];
  File? imagePath;
  XFile? file;
  String a = '';

  bool isMedicineSync = false;
  bool isRxDoctorSync = false;
  // File? _image;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int _currentSelected = 3;
  int _currentSelected2 = 2;
  int counterForDoctor = 0;
  int _counterforRx = 0;
  bool _isCameraClick = false;
  int objectImageId = 0;

  String? submit_url;
  String? photo_submit_url;
  String? cid;
  String? userId;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  // String? docId;
  double latitude = 0.0;
  double longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  bool _isLoading = true;
  bool _activeCounter = false;
  String dropdownRxTypevalue = 'Rx Type';

  ////Gift//Sample//PPM////
  List<DcrGSPDataModel> addedDcrGSPList = [];
  bool isPromotional = false;
  bool isGiftSync = false;
  bool isSampleSync = false;
  bool isPPMSync = false;
  ///////////

  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];

  String itemString1 = '';

  String? branchId;

  List<String> rxTypeList = [];

  String? selectedSalesType;
  List<String> salesTypelist = [];

  String? selectedPatientType;
  List<String> patientTypeList = [];

  String finalImage = '';
  final databox = Boxes.allData();

  String? selectedGenderType;
  String? selectedStripWastageType;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> genderList = ['Male', 'Female', 'Others'];
  List<int> stripWastageList = [0, 1, 2, 3, 4];

  @override
  void initState() {
    debugPrint("id ${widget.uniqueId}");
    debugPrint("counterrx $_counterforRx");
    // debugPrint(widget.uniqueId);
    if (widget.docId != '') {
      docId = widget.docId;
      counterForDoctor = widget.uniqueId;
    }
    print("Brinch ID : ${widget.branch_id}");
    branchId = widget.branch_id;
    setState(() {
      ////gift//sample//PPM/////

      isGiftSync = databox.get('isGiftSync') ?? false;
      print('gift sync: $isGiftSync');
      isSampleSync = databox.get('isSampleSync') ?? false;
      print('sample sync: $isSampleSync');
      isPPMSync = databox.get('isPPMSync') ?? false;
      print('pppm sync: $isPPMSync');
      ///////////

      isMedicineSync = databox.get('isMedicineSync') ?? false;
      isRxDoctorSync = databox.get('isRxDoctorSync') ?? false;
      photo_submit_url = databox.get('photo_submit_url');
      latitude = databox.get("latitude") ?? 0.0;
      longitude = databox.get("longitude") ?? 0.0;
      submit_url = databox.get("submit_url");
      cid = databox.get("CID");
      userId = databox.get("USER_ID");
      print('iddddd:$userId');
      userPassword = databox.get("PASSWORD");
      userName = databox.get("userName")!;
      user_id = databox.get("user_id")!;
      deviceId = databox.get("deviceId");
      deviceBrand = databox.get("deviceBrand");
      deviceModel = databox.get("deviceModel");
      rx_doc_must = databox.get("rx_doc_must") ?? false;
      rx_type_must = databox.get("rx_type_must") ?? false;
      rx_gallery_allow = databox.get("rx_gallery_allow") ?? false;

      rxTypeList = databox.get("rx_type_list")!;
      print('rxTypeList:$rxTypeList');

      salesTypelist = databox.get('sales_type_list');
      print('sales type list: $salesTypelist');

      patientTypeList = databox.get('patient_type_list');
      print('patient type list: $patientTypeList');

      dropdownRxTypevalue = widget.dcrGrad.isEmpty ? rxTypeList.first : widget.dcrGrad;
      print('dropdownRxType1:$dropdownRxTypevalue');
      // if (widget.uniqueId == 0) {
      //   int? a = prefs.getInt('DCLCounter') ?? 0;

      //   setState(() {
      //     widget.uniqueId = a;
      //   });
      // }
    });

    finalMedicineList = widget.draftRxMedicinItem;
    tempCount = widget.draftRxMedicinItem.length;
    setState(() {});
    if (widget.ck != '') {
      phnNumberController.text = widget.phnNum;
      patientNameController.text = widget.patientName;
      selectedGenderType = widget.gender == "" ? null : widget.gender;
      dobController.text = widget.dob;
      selectedStripWastageType = widget.stripWastage == "" ? null : widget.stripWastage;
      print('patient type from draft: $selectedPatientType');
      selectedSystem = widget.systemName == "" ? null : widget.systemName;
      selectedDisease = widget.disease == "" ? null : widget.disease;
      selectedPatientTemperament = widget.patientTemperament == "" ? null : widget.patientTemperament;
      beforeDiabetesController.text = widget.beforeDiabetes;
      afterDiabetesController.text = widget.afterDiabetes;
      systolicController.text = widget.bloodSystolic;
      diastolicController.text = widget.bloodDiastolic;
      oxygenLevelController.text = widget.oxygenLevel;
      bodyTemperatureController.text = widget.bodyTemperature;
      weightController.text = widget.weight;
      feetController.text = widget.heightFeet;
      inchController.text = widget.heightInch;
      setState(() {
        _activeCounter = true;
      });

      int space = widget.image1.indexOf(" ");
      String removeSpace = widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');
      imagePath = File(finalImage);

      finalDoctorList.add(
        RxDcrDataModel(
          uiqueKey: widget.uniqueId,
          docName: widget.docName,
          docId: widget.docId,
          areaId: widget.areaId,
          areaName: widget.areaName,
          address: widget.address,
          presImage: finalImage,
          dcrGrad: dropdownRxTypevalue,
          phnNum: widget.phnNum,
          patientName: widget.patientName,
          gender: widget.gender,
          dob: widget.dob,
          stripWastage: widget.stripWastage,
          systemName: widget.systemName,
          disease: widget.disease,
          patientTemperament: widget.patientTemperament,
          diabetesBefore: widget.beforeDiabetes,
          diabetesAfter: widget.afterDiabetes,
          bloodSystolic: widget.bloodSystolic,
          bloodDiastolic: widget.bloodDiastolic,
          oxygenLevel: widget.oxygenLevel,
          bodyTemperature: widget.bodyTemperature,
          weight: widget.weight,
          heightFeet: widget.heightFeet,
          heightInch: widget.heightInch,
          branchId: branchId,
        ),
      );

      calculatingTotalitemString1();
    } else {
      phnNumberController.clear();
      patientNameController.clear();
      dobController.clear();
      selectedGenderType = null;
      selectedStripWastageType = null;
      selectedSalesType = null;
      selectedPatientType = null;

      selectedSystem = null;
      selectedDisease = null;
      selectedPatientTemperament = null;
      beforeDiabetesController.clear();
      afterDiabetesController.clear();
      systolicController.clear();
      diastolicController.clear();
      oxygenLevelController.clear();
      bodyTemperatureController.clear();
      weightController.clear();
      feetController.clear();
      inchController.clear();
      bmi = null;
      bmiStatus = null;
      bmiDetailedMessage = null;
      return;
    }
    super.initState();
  }

  // Future<void> checkAndFillPatientData(String phone) async {
  //   final url = Uri.parse("https://w05.yeapps.com/hamdard_physician_api/api_patient_auto_search/patient_list?cid=$cid&user_id=$userId&user_pass=$userPassword&phone_number=${phnNumberController.text}"); // Replace with your actual URL
  //   print('patient info url: $url');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"phone": phone}),
  //   );
  //   try{
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('API Response: $data');
  //
  //       if (data['status'] == "Success" &&
  //           data['patient_info'] != null &&
  //           data['patient_info'].isNotEmpty) {
  //         final patient = data['patient_info'][0];
  //
  //         patientNameController.text = patient['patient_name'] ?? '';
  //         selectedGenderType = patient['gender'] ?? null;
  //         dobController.text = patient['dob'] ?? '';
  //         isDateSelected = dobController.text.isNotEmpty;
  //
  //         setState(() {});
  //         return;
  //       }
  //     }
  //
  //     patientNameController.clear();
  //     dobController.clear();
  //     selectedGenderType = null;
  //     isDateSelected = false;
  //     setState(() {});
  //
  //   }catch (e) {
  //     print("Error fetching patient info: $e");
  //   }
  //
  // }

  Future<void> checkAndFillPatientData(String phone) async {
    try {
      String url = 'https://w05.yeapps.com/hamdard_physician_api/api_patient_auto_search/patient_list?cid=$cid&user_id=$userId&user_pass=$userPassword&phone_number=$phone';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      print('patient info url:: $url');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data');

        if (data['status'] == "Success" && data['patient_info'] != null && data['patient_info'].isNotEmpty) {
          List<dynamic> patientList = data['patient_info'];

          final matchedPatient = patientList.firstWhere((p) => p['phone_number'] == phone, orElse: () => null);

          if (matchedPatient != null) {
            setState(() {
              patientNameController.text = matchedPatient['patient_name'] ?? '';
              selectedGenderType = matchedPatient['gender'] ?? null;
              dobController.text = matchedPatient['dob'] ?? '';
              isDateSelected = matchedPatient['dob'] != null;
            });
            return;
          }
        }
      }
      setState(() {
        patientNameController.clear();
        dobController.clear();
        selectedGenderType = null;
        isDateSelected = false;
      });
      final data = jsonDecode(response.body);
      Fluttertoast.showToast(msg: data['ret_str'] ?? "No patient found.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 14.0);
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      setState(() {
        patientNameController.clear();
        dobController.clear();
        selectedGenderType = null;
        isDateSelected = false;
      });
      Fluttertoast.showToast(msg: "Please try again.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 14.0);
    } catch (e) {
      print('Error: $e');
    }
  }

  int _rxCounter() {
    var dt = DateFormat('HH:mm:ssss').format(DateTime.now());

    String time = dt.replaceAll(":", '');

    setState(() {
      _counterforRx = int.parse(time);
    });

    return _counterforRx;
  }

  void calculateRxItemString() {
    itemString = '';
    if (finalMedicineList.isNotEmpty) {
      for (var element in finalMedicineList) {
        if (itemString == '') {
          itemString = '${element.itemId}|${element.quantity}';
        } else {
          itemString += '||${element.itemId}|${element.quantity}';
        }
      }
    }
    print("============================= ${itemString}");
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      if ((widget.image1 != '' || imagePath != null) && finalMedicineList.isNotEmpty) {
        bool result = await NetworkConnecticity.checkConnectivity();
        if (result == true) {
          if (rx_doc_must == true) {
            if (finalDoctorList[0].docId != "") {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text("Are you sure you want to submit the Prescription?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // User clicked No, so close the dialog
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            rxImageUpload();
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
              );
            } else {
              _submitToastforDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text("Are you sure want to submit Prescription?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          rxImageUpload();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
            );
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // debugPrint(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 0) {
      print('aaaaa');
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      //   putAddedRxData();
      // } else if ((imagePath != null || widget.image1 != '') &&
      //     finalMedicineList.isNotEmpty) {

      // } else {
      //   _submitToastforphoto();
      // }
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 1) {
      _galleryFunctionality();
      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 3) {
      // if ((imagePath != null || widget.image1 != '')) {
      //   debugPrint("image will save on draft");
      //   finalDoctorList.add(
      //     RxDcrDataModel(
      //       uiqueKey: widget.uniqueId > 0 ? widget.uniqueId : _counterforRx,
      //       docName: widget.uniqueId > 0
      //           ? widget.uniqueId.toString()
      //           : _counterforRx.toString(),
      //       docId: '',
      //       areaId: '',
      //       areaName: 'areaName',
      //       address: 'address',
      //       presImage: imagePath.toString(),
      //     ),
      //   );
      //   for (var dcr in finalDoctorList) {
      //     final box = Boxes.rxdDoctor();

      //     box.add(dcr);
      //   }
      //   for (var d in finalMedicineList) {
      //     final box = Boxes.getMedicine();

      //     box.add(d);
      //   }
      // }
      if (widget.uniqueId == 0) {
        widget.uniqueId++;
      } else if (_counterforRx == 0) {
        _counterforRx++;
      }

      _cameraFuntionality();
      setState(() {
        _currentSelected = index;
      });
    }
  }

  void _onItemTapped2(int index) async {
    print('image path: $imagePath');
    if (index == 1) {
      // setState(() {
      //   _isLoading = false;
      // });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) && (finalMedicineList.isNotEmpty && phnNumberController.text.isNotEmpty && patientNameController.text.isNotEmpty && selectedGenderType != null && dobController.text.isNotEmpty && selectedSalesType != null && selectedPatientType != null)) {
        bool result = await NetworkConnecticity.checkConnectivity();

        if (result == true) {
          // if (rx_doc_must == true) {
          //   if (finalDoctorList[0].docId != "") {
          //     // _rxImageSubmit();
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text("Confirm"),
                  content: const Text("Are you sure want to submit Prescription?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // User clicked No, so close the dialog
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);

                        // // _rxImageSubmit();

                        rxImageUpload();
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
          );
          //   } else {
          //     _submitToastforDoctor();
          //     setState(() {
          //       _isLoading = true;
          //     });
          //   }
          // } else {
          //   // _rxImageSubmit();
          //   showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //       title: const Text("Confirm"),
          //       content: const Text("Are you sure you want to submit the RX?"),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             // User clicked No, so close the dialog
          //             Navigator.of(context).pop(false);
          //           },
          //           child: const Text("No"),
          //         ),
          //         TextButton(
          //           onPressed: () {
          //             // _rxImageSubmit();
          //             rxImageUpload();
          //           },
          //           child: const Text("Yes"),
          //         ),
          //       ],
          //     ),
          //   );
          // }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 0) {
      print('bbbb');
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
        Fluttertoast.showToast(
          msg: 'Save Drafts',
          // msg: 'Please Take Image and Select Medicine',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        _submitToastforphoto();
      }
      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 2) {
      print('imageeeee');
      // if (widget.uniqueId == 0) {
      //   widget.uniqueId++;
      // } else if (_counterforRx == 0) {
      //   _counterforRx++;
      // }
      _cameraFuntionality();
      setState(() {
        _currentSelected2 = index;
      });
    }
  }

  void _submitToastforOrder3() {
    Fluttertoast.showToast(msg: 'No Internet Connection\nPlease check your internet connection.', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  ////////Gift//Sample//PPM//////

  Future<void> getGitSamplePpmData() async {
    if (isGiftSync == true && isSampleSync == true && isPPMSync == true) {
      var mymap = Hive.box('dcrGiftListData').values.toList();
      var mymap1 = Hive.box('dcrSampleListData').values.toList();
      var mymap2 = Hive.box('dcrPpmListData').values.toList();

      if (mymap.isEmpty && mymap1.isEmpty && mymap2.isEmpty) {
        Fluttertoast.showToast(msg: "No Data Found", backgroundColor: Colors.red);
        doctorGiftlist.add('empty');
        doctorSamplelist.add('empty');
        doctorPpmlist.add('empty');
      } else {
        doctorGiftlist = mymap;
        doctorSamplelist = mymap1;
        doctorPpmlist = mymap2;
      }

      setState(() {});
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      Fluttertoast.showToast(msg: 'Please sync', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
    }
  }

  calculatingTotalitemString1() {
    itemString1 = '';
    String newString = '';

    //if (addedDcrGSPList.isNotEmpty) {
    for (var element in addedDcrGSPList) {
      if (newString.isEmpty) {
        newString = '${element.giftId}|${element.quantity}|${element.giftType}';
      } else {
        newString += '||${element.giftId}|${element.quantity}|${element.giftType}';
      }
    }
    setState(() {
      itemString1 = newString;
    });
    print('ItemString updated: $itemString1');
  }

  ///////////////////

  @override
  Widget build(BuildContext context) {
    List<MergedItem> combinedList1 = [];

    combinedList1.addAll(finalMedicineList.map((e) => MergedItem(type: 'medicine', item: e)).toList());

    combinedList1.addAll(addedDcrGSPList.map((e) => MergedItem(type: 'promotion', item: e)).toList());

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print('image:${widget.image1}');
    print('file:$file');
    print('final doctor list:$finalDoctorList');
    print('rx type must:$rx_type_must');
    print('dropdownRxType:$dropdownRxTypevalue');
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading == false) {
          return false;
        }
        return true;
      },
      child:
          _isLoading
              ? Scaffold(
                key: _scaffoldKey,
                drawer: const Dxdrawer(),
                endDrawer: PromotionalDrawer(
                  uniqueId: widget.uniqueId,
                  //uniqueId: _counter,
                  //doctorGiftlist: doctorGiftlist,
                  tempList: addedDcrGSPList,
                  tempListFunc: (value) {
                    addedDcrGSPList = value;
                    calculatingTotalitemString1();

                    setState(() {});
                  },
                  //doctorSamplelist: doctorSamplelist,
                  tempList1: addedDcrGSPList,

                  //doctorPpmlist: doctorPpmlist,
                  tempList2: addedDcrGSPList,
                ),
                endDrawerEnableOpenDragGesture: false,
                appBar: AppBar(
                  actions: const [SizedBox.shrink()],
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  automaticallyImplyLeading: false,
                  title: const Text('Prescription Capture', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            //flex: 7,
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 5,
                              child: Container(
                                height: screenHeight / 3.2,
                                decoration: const BoxDecoration(color: Colors.grey),
                                child:
                                    widget.image1 != ''
                                        ? InkWell(
                                          onDoubleTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomForRxDraftImage(finalImage)));
                                          },
                                          child: Hero(tag: "imageForDraft", child: Image.file(File(finalImage))),
                                        )
                                        : file == null
                                        ? Column(
                                          children: [
                                            Expanded(flex: 4, child: Image.asset('assets/images/default_document.png', fit: BoxFit.cover)),
                                            Expanded(
                                              // flex: 4,
                                              child: Container(width: screenWidth / 1.8, color: Colors.white, child: const Center(child: Text("Double tap to zoom", style: TextStyle(fontSize: 18)))),
                                            ),
                                          ],
                                        )
                                        : InkWell(
                                          onDoubleTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomForRxImage(imagePath)));
                                          },
                                          child: Hero(tag: "img", child: Image.file(imagePath!, fit: BoxFit.fill)),
                                        ),
                              ),
                            ),
                          ),
                          Expanded(
                            // flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 38,
                                        child: TextField(
                                          controller: phnNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: 'Phone Number',
                                            hintStyle: const TextStyle(fontSize: 14),
                                            suffixIcon: const Icon(Icons.star_sharp, color: Colors.red, size: 12),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                          ),
                                          // onChanged: (value) {
                                          //   if (!value.startsWith('88')) {
                                          //     phnNumberController.text = '88';
                                          //     phnNumberController.selection = TextSelection.fromPosition(
                                          //       TextPosition(offset: phnNumberController.text.length),
                                          //     );
                                          //   }
                                          // },
                                          onTap: () {
                                            if (phnNumberController.text.isEmpty) {
                                              phnNumberController.text = '88';
                                              phnNumberController.selection = TextSelection.fromPosition(TextPosition(offset: phnNumberController.text.length));
                                            }
                                          },
                                          onChanged: (value) async {
                                            if (!value.startsWith('88')) {
                                              phnNumberController.text = '88';
                                              phnNumberController.selection = TextSelection.fromPosition(TextPosition(offset: phnNumberController.text.length));
                                              return;
                                            }

                                            if (value.length == 13) {
                                              await checkAndFillPatientData(value);
                                            } else {
                                              patientNameController.clear();
                                              dobController.clear();
                                              selectedGenderType = null;
                                              isDateSelected = false;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        height: 38,
                                        child: TextField(
                                          controller: patientNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Patient Name',
                                            hintStyle: const TextStyle(fontSize: 14),
                                            suffixIcon: const Icon(Icons.star_sharp, color: Colors.red, size: 12),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          // Expanded(
                                          //   child: SizedBox(
                                          //     height: 35,
                                          //     child: TextField(
                                          //       readOnly: true,
                                          //       controller: dobController,
                                          //       onTap: () async {
                                          //         DateTime? pickedDate = await showDatePicker(
                                          //           context: context,
                                          //           initialDate: DateTime.now(),
                                          //           firstDate: DateTime(1900),
                                          //           lastDate: DateTime.now(),
                                          //         );
                                          //
                                          //         if (pickedDate != null) {
                                          //           //String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                                          //           String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                          //           setState(() {
                                          //             dobController.text = formattedDate;
                                          //             isDateSelected = true;
                                          //           });
                                          //         }
                                          //         print('dob::${dobController.text.toString()}');
                                          //       },
                                          //       decoration: InputDecoration(
                                          //         hintText: 'DOB',
                                          //         hintStyle: const TextStyle(fontSize: 13),
                                          //         suffixIcon: isDateSelected
                                          //             ? null
                                          //             : const Icon(
                                          //           Icons.star_sharp,
                                          //           color: Colors.red,
                                          //           size: 12,
                                          //         ),
                                          //         contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          //         enabledBorder: OutlineInputBorder(
                                          //           borderSide: const BorderSide(width: 2, color: Colors.grey),
                                          //           borderRadius: BorderRadius.circular(10),
                                          //         ),
                                          //         filled: true,
                                          //         fillColor: Colors.white,
                                          //         border: OutlineInputBorder(
                                          //           borderSide: const BorderSide(width: 2, color: Colors.grey),
                                          //           borderRadius: BorderRadius.circular(10),
                                          //         ),
                                          //         focusedBorder: OutlineInputBorder(
                                          //           borderSide: const BorderSide(width: 2, color: Colors.grey),
                                          //           borderRadius: BorderRadius.circular(10),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            flex: 3,
                                            child: SizedBox(
                                              height: 35,
                                              child: TextField(
                                                readOnly: true,
                                                controller: dobController,
                                                scrollPhysics: const BouncingScrollPhysics(),
                                                maxLines: 1,
                                                onTap: () async {
                                                  DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());

                                                  if (pickedDate != null) {
                                                    DateTime today = DateTime.now();

                                                    int years = today.year - pickedDate.year;
                                                    int months = today.month - pickedDate.month;
                                                    int days = today.day - pickedDate.day;

                                                    if (days < 0) {
                                                      months -= 1;
                                                      days += DateTime(today.year, today.month, 0).day;
                                                    }

                                                    if (months < 0) {
                                                      years -= 1;
                                                      months += 12;
                                                    }

                                                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                                    setState(() {
                                                      dobController.text = "$years years, $months months, $days days";
                                                      isDateSelected = true;
                                                    });
                                                    print('dob::${dobController.text.toString()}');
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'DOB',
                                                  hintStyle: const TextStyle(fontSize: 13),
                                                  suffixIcon: isDateSelected ? null : const Icon(Icons.star_sharp, color: Colors.red, size: 12),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(10)),
                                              child: Stack(
                                                children: [
                                                  DropdownButton<String>(
                                                    // value: selectedGenderType,
                                                    value: genderList.contains(selectedGenderType) ? selectedGenderType : null,
                                                    hint: const Center(child: Padding(padding: EdgeInsets.only(left: 4), child: Text('Gender', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)))),
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    items:
                                                        genderList.map((String value) {
                                                          return DropdownMenuItem<String>(value: value, child: Center(child: Padding(padding: const EdgeInsets.only(left: 4), child: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)))));
                                                        }).toList(),
                                                    onChanged: (newValue) {
                                                      //if (newValue != null) {
                                                      setState(() {
                                                        selectedGenderType = newValue;
                                                        //items=items;
                                                      });
                                                    },
                                                    // },
                                                  ),
                                                  const Positioned(top: 1, right: 2, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(10)),
                                              child: DropdownButton<String>(
                                                // value: selectedStripWastageType,
                                                value: stripWastageList.map((e) => e.toString()).contains(selectedStripWastageType) ? selectedStripWastageType : null,
                                                hint: const Center(child: Text('Strip Wastage', style: TextStyle(fontSize: 13))),
                                                padding: const EdgeInsets.only(left: 2),
                                                isExpanded: true,
                                                underline: const SizedBox(),
                                                items:
                                                    stripWastageList.map((int value) {
                                                      return DropdownMenuItem<String>(value: value.toString(), child: Center(child: Text(value.toString(), style: const TextStyle(fontSize: 14))));
                                                    }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedStripWastageType = newValue!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Scaffold.of(context).openEndDrawer();
                                            _scaffoldKey.currentState?.openDrawer();
                                          },

                                          // onTap: (){
                                          //   if (imagePath != null || (widget.image1 != "" && widget.image1.isNotEmpty)) {
                                          //     _scaffoldKey.currentState?.openDrawer();
                                          //   }
                                          //   else{
                                          //     Fluttertoast.showToast(
                                          //         msg: 'Please Take Image First ',
                                          //         toastLength: Toast.LENGTH_SHORT,
                                          //         gravity: ToastGravity.CENTER,
                                          //         backgroundColor: Colors.red,
                                          //         textColor: Colors.white,
                                          //         fontSize: 16.0);
                                          //   }
                                          // },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Image.asset(
                                                  // height: 60,
                                                  // width: 60,
                                                  'assets/images/diagnosis.png',
                                                  // color: Colors.teal,
                                                  // width: screenWidth / 9,
                                                  //height: screenWidth /9,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              const Positioned(top: -1, left: -2, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (isMedicineSync == true) {
                                              debugPrint(imagePath.toString());
                                              setState(() {});

                                              if (imagePath != null) {
                                                if (widget.uniqueId >= 0 && finalDoctorList.isNotEmpty) {
                                                  getMedicine();
                                                  // debugPrint(widget.uniqueId);
                                                } else if (_activeCounter == false) {
                                                  // debugPrint('activeCounter:$_activeCounter');
                                                  _rxCounter();
                                                  getMedicine();
                                                  // debugPrint('test:${widget.uniqueId}');
                                                  setState(() {
                                                    _activeCounter = true;
                                                  });
                                                } else if (_activeCounter == true) {
                                                  getMedicine();
                                                }
                                              } else if (widget.image1 != "") {
                                                if (widget.uniqueId >= 0 && finalDoctorList.isNotEmpty) {
                                                  getMedicine();
                                                  // debugPrint(widget.uniqueId);
                                                } else if (_activeCounter == false) {
                                                  // debugPrint('activeCounter:$_activeCounter');
                                                  _rxCounter();
                                                  getMedicine();
                                                  // debugPrint('test:${widget.uniqueId}');
                                                  setState(() {
                                                    _activeCounter = true;
                                                  });
                                                } else if (_activeCounter == true) {
                                                  getMedicine();
                                                }
                                              } else {
                                                Fluttertoast.showToast(msg: 'Please Take Image First ', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: 'Please Sync Medicine', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Image.asset(
                                                  'assets/images/medicine.png',
                                                  // color: Colors.teal,
                                                  //width: screenWidth / 8,
                                                  //height: screenWidth /9,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              const Positioned(top: 0, left: -3, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   isPromotional=true;
                                            // });
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) =>  PromotionalScreen(uniqueId:widget.uniqueId,),));

                                            //_scaffoldKey.currentState?.openEndDrawer();

                                            setState(() {
                                              getGitSamplePpmData();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.asset(
                                              'assets/images/items.png',
                                              // color: Colors.teal,
                                              height: screenHeight / 12,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      ///*********************************doctor info******************************************///
                      SizedBox(
                        height: screenHeight / 11,
                        child: Card(
                          color: const Color(0xffDDEBF7),
                          elevation: 10,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.white70, width: 1)),
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: const BoxDecoration(color: Color(0xffDDEBF7)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                children: [
                                  // Expanded(
                                  //   flex: 5,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //     CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         '${finalDoctorList[0].docName}'
                                  //             '(${finalDoctorList[0].docId})',
                                  //         style: const TextStyle(
                                  //           color: Colors.black,
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //       FittedBox(
                                  //         child: Text(
                                  //           '${finalDoctorList[0].areaName}(${finalDoctorList[0].areaId}) , ${finalDoctorList[0].address}',
                                  //           style: const TextStyle(
                                  //             color: Colors.black,
                                  //             // fontSize: 19,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        DropdownButtonFormField(
                                          decoration: const InputDecoration(enabled: false),
                                          isExpanded: true,
                                          // value: selectedSalesType,
                                          value: salesTypelist.contains(selectedSalesType) ? selectedSalesType : null,
                                          hint: const Center(
                                            child: Text(
                                              'Sales Type',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                // fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                          items:
                                              salesTypelist.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      // fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedSalesType = newValue!;
                                            });
                                          },
                                        ),
                                        const Positioned(top: 18, right: 20, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  rx_type_must == true
                                      ?
                                      // Expanded(
                                      //   flex: 3,
                                      //   child: Stack(
                                      //     children: [
                                      //       DropdownButtonFormField(
                                      //         decoration: const InputDecoration(enabled: false),
                                      //         isExpanded: true,
                                      //         value: dropdownRxTypevalue,
                                      //         icon: const Icon(
                                      //           Icons.keyboard_arrow_down,
                                      //           color: Colors.black,
                                      //         ),
                                      //         // Array list of items
                                      //         items: rxTypeList.map((String items) {
                                      //           return DropdownMenuItem(
                                      //             value: items,
                                      //             child: Text(
                                      //               items,
                                      //               style: const TextStyle(
                                      //                 color: Colors.black,
                                      //                 // fontSize: 16,
                                      //               ),
                                      //             ),
                                      //           );
                                      //         }).toList(),
                                      //
                                      //         onChanged:
                                      //             (String? newValue) {
                                      //           setState(() {
                                      //             dropdownRxTypevalue =
                                      //             newValue!;
                                      //           });
                                      //         },
                                      //       ),
                                      //       const Positioned(
                                      //         top: 18,
                                      //         right: 20,
                                      //         child: Icon(Icons.star_sharp, color: Colors.red, size: 12),
                                      //       ),
                                      //     ],
                                      //   )
                                      //
                                      // )
                                      Expanded(
                                        flex: 3,
                                        child: Stack(
                                          children: [
                                            DropdownButtonFormField(
                                              decoration: const InputDecoration(enabled: false),
                                              isExpanded: true,
                                              // value: selectedPatientType,
                                              value: patientTypeList.contains(selectedPatientType) ? selectedPatientType : null,
                                              hint: const Center(
                                                child: Text(
                                                  'Patient Type',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                              items:
                                                  patientTypeList.map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(
                                                        items,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          // fontSize: 16,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),

                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedPatientType = newValue!;
                                                  print('selected patient type: $selectedPatientType');
                                                });
                                              },
                                            ),
                                            const Positioned(top: 18, right: 20, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
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

                      // ////////////////////////////////medicine List View////////////////
                      // finalMedicineList.isNotEmpty
                      //     ? Expanded(
                      //       child: SingleChildScrollView(
                      //         child: ListView.builder(
                      //           shrinkWrap: true,
                      //           itemCount: finalMedicineList.length,
                      //           physics: const BouncingScrollPhysics(),
                      //          // padding: const EdgeInsets.only(bottom: 200.0),
                      //           itemBuilder: (BuildContext itemBuilder, index) {
                      //             return Card(
                      //               elevation: 10,
                      //               color: const Color.fromARGB(255, 217, 248, 219),
                      //               shape: RoundedRectangleBorder(
                      //                 side: const BorderSide(color: Colors.white70, width: 1),
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               child: Container(
                      //                 height: 70,
                      //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                     children: [
                      //                       Row(
                      //                         children: [
                      //                           Expanded(
                      //                             flex: 2,
                      //                             child: Text(
                      //                               '${finalMedicineList[index].name} ''(${finalMedicineList[index].itemId})',
                      //                               style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 // fontWeight:
                      //                                 // FontWeight.bold,
                      //                                 fontSize: 14,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           // IconButton(
                      //                           //     onPressed: () {
                      //                           //       // var x =
                      //                           //       if (finalMedicineList[
                      //                           //       index]
                      //                           //           .quantity >
                      //                           //           1) {
                      //                           //         finalMedicineList[
                      //                           //         index]
                      //                           //             .quantity--;
                      //                           //       }
                      //                           //
                      //                           //       // calculateRxItemString(
                      //                           //       //     x.toString());
                      //                           //       setState(() {});
                      //                           //     },
                      //                           //     icon: const Icon(
                      //                           //         Icons.remove)),
                      //                           Container(
                      //                             width: 40,
                      //                             height: 30,
                      //                             decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                      //                             // color: !pressAttention
                      //                             //     ? Colors.white
                      //                             //     : Colors.blueAccent,
                      //                             child: Padding(
                      //                               padding: const EdgeInsets.all(6),
                      //                               child: Text(
                      //                                 textAlign: TextAlign.center,
                      //                                 finalMedicineList[index].quantity.toString(),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           // IconButton(
                      //                           //   onPressed: () {
                      //                           //     // var y =
                      //                           //     finalMedicineList[index]
                      //                           //         .quantity++;
                      //                           //     // calculateRxItemString(
                      //                           //     //     y.toString());
                      //                           //     setState(() {});
                      //                           //   },
                      //                           //   icon: const Icon(Icons.add),
                      //                           // ),
                      //                           IconButton(
                      //                             // color: Colors.red,
                      //                             onPressed: () {
                      //                               _showMyDialog(index);
                      //                             },
                      //                             icon: const Icon(Icons.clear, color: Colors.grey,
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     )
                      //     :  Expanded(child: Container()),
                      //
                      //
                      // ////////////////Gift//Sample//PPM/////////
                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     child: ListView.builder(
                      //       shrinkWrap: true,
                      //       itemCount: addedDcrGSPList.length,
                      //       physics: const BouncingScrollPhysics(),
                      //       itemBuilder: (BuildContext itemBuilder, index) {
                      //         print('promotional list: ${addedDcrGSPList.length}');
                      //         print('name: ${addedDcrGSPList[index].giftName}');
                      //         return Card(
                      //           color: Colors.white,
                      //           elevation: 15,
                      //           shape: RoundedRectangleBorder(
                      //             side: const BorderSide(color: Colors.white70, width: 1),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Container(
                      //             height: 90,
                      //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   Expanded(
                      //                     flex: 3,
                      //                     child: Row(
                      //                       children: [
                      //                         Expanded(
                      //                           flex: 10,
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                             MainAxisAlignment.spaceBetween,
                      //                             children: [
                      //                               Expanded(
                      //                                 child: Text(
                      //                                   addedDcrGSPList[index].giftName,
                      //                                   style: const TextStyle(
                      //                                       color: Color.fromARGB(255, 9, 38, 61),
                      //                                       fontWeight: FontWeight.w400,
                      //                                       fontSize: 16),
                      //                                 ),
                      //                               ),
                      //                               // Text(
                      //                               //   '(${addedDcrGSPList[index].giftType})',
                      //                               //   style: const TextStyle(
                      //                               //       fontSize: 16),
                      //                               // ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         const SizedBox(
                      //                           width: 10,
                      //                         ),
                      //                         IconButton(
                      //                           onPressed: () {
                      //                             _showMyDialog(index);
                      //                           },
                      //                           icon: const Icon(Icons.clear, color: Colors.grey,
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Expanded(
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                       children: [
                      //                         addedDcrGSPList[index].giftType !=
                      //                             "Discussion"
                      //                             ? Row(
                      //                           children: [
                      //                             const Text(
                      //                               'Qt:  ',
                      //                               style: TextStyle(
                      //                                   fontSize: 16,
                      //                                   color: Color.fromARGB(
                      //                                       255, 9, 38, 61)),
                      //                             ),
                      //                             Text(
                      //                               addedDcrGSPList[index]
                      //                                   .quantity
                      //                                   .toString(),
                      //                               style: const TextStyle(
                      //                                   color: Color.fromARGB(
                      //                                       255, 9, 38, 61),
                      //                                   fontSize: 16,
                      //                                   fontWeight:
                      //                                   FontWeight.bold),
                      //                             ),
                      //                           ],
                      //                         )
                      //                             : const Text(""),
                      //                         const Spacer(),
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               '(${addedDcrGSPList[index].giftType})',
                      //                               style: const TextStyle(
                      //                                 color: Color.fromARGB(
                      //                                     255, 9, 38, 61),
                      //                                 fontSize: 16,
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // // Expanded(
                      // //   child: Row(
                      // //     crossAxisAlignment: CrossAxisAlignment.start,
                      // //     children: [
                      // //       ////////////////////////////////medicine List View////////////////
                      // //       finalMedicineList.isNotEmpty
                      // //           ? Expanded(
                      // //         child: SingleChildScrollView(
                      // //           child: ListView.builder(
                      // //             shrinkWrap: true,
                      // //             itemCount: finalMedicineList.length,
                      // //             physics: const BouncingScrollPhysics(),
                      // //             // padding: const EdgeInsets.only(bottom: 200.0),
                      // //             itemBuilder: (BuildContext itemBuilder, index) {
                      // //               return Card(
                      // //                 elevation: 10,
                      // //                 color: const Color.fromARGB(255, 217, 248, 219),
                      // //                 shape: RoundedRectangleBorder(
                      // //                   side: const BorderSide(color: Colors.white70, width: 1),
                      // //                   borderRadius: BorderRadius.circular(10),
                      // //                 ),
                      // //                 child: Container(
                      // //                   height: 80,
                      // //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      // //                   ),
                      // //                   child: Column(
                      // //                     crossAxisAlignment:
                      // //                     CrossAxisAlignment.start,
                      // //                     children: [
                      // //                       Row(
                      // //                         children: [
                      // //                           Expanded(
                      // //                             flex: 2,
                      // //                             child: Text(
                      // //                               '${finalMedicineList[index].name} ''(${finalMedicineList[index].itemId})',
                      // //                               style: const TextStyle(
                      // //                                 color: Colors.black,
                      // //                                 // fontWeight:
                      // //                                 // FontWeight.bold,
                      // //                                 fontSize: 14,
                      // //                               ),
                      // //                             ),
                      // //                           ),
                      // //                           // IconButton(
                      // //                           //     onPressed: () {
                      // //                           //       // var x =
                      // //                           //       if (finalMedicineList[
                      // //                           //       index]
                      // //                           //           .quantity >
                      // //                           //           1) {
                      // //                           //         finalMedicineList[
                      // //                           //         index]
                      // //                           //             .quantity--;
                      // //                           //       }
                      // //                           //
                      // //                           //       // calculateRxItemString(
                      // //                           //       //     x.toString());
                      // //                           //       setState(() {});
                      // //                           //     },
                      // //                           //     icon: const Icon(
                      // //                           //         Icons.remove)),
                      // //                           Container(
                      // //                             width: 40,
                      // //                             height: 30,
                      // //                             decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                      // //                             // color: !pressAttention
                      // //                             //     ? Colors.white
                      // //                             //     : Colors.blueAccent,
                      // //                             child: Padding(
                      // //                               padding: const EdgeInsets.all(6),
                      // //                               child: Text(
                      // //                                 textAlign: TextAlign.center,
                      // //                                 finalMedicineList[index].quantity.toString(),
                      // //                               ),
                      // //                             ),
                      // //                           ),
                      // //                           // IconButton(
                      // //                           //   onPressed: () {
                      // //                           //     // var y =
                      // //                           //     finalMedicineList[index]
                      // //                           //         .quantity++;
                      // //                           //     // calculateRxItemString(
                      // //                           //     //     y.toString());
                      // //                           //     setState(() {});
                      // //                           //   },
                      // //                           //   icon: const Icon(Icons.add),
                      // //                           // ),
                      // //                           IconButton(
                      // //                             // color: Colors.red,
                      // //                             onPressed: () {
                      // //                               _showMyDialog(index);
                      // //                             },
                      // //                             icon: const Icon(Icons.clear, color: Colors.grey,
                      // //                             ),
                      // //                           ),
                      // //                         ],
                      // //                       ),
                      // //                     ],
                      // //                   ),
                      // //                 ),
                      // //               );
                      // //             },
                      // //           ),
                      // //         ),
                      // //       )
                      // //           :  Expanded(child: Container()),
                      // //
                      // //       // ////////////////Gift//Sample//PPM/////////
                      // //       Expanded(
                      // //         child: SingleChildScrollView(
                      // //           child: ListView.builder(
                      // //             shrinkWrap: true,
                      // //             itemCount: addedDcrGSPList.length,
                      // //             physics: const BouncingScrollPhysics(),
                      // //             itemBuilder: (BuildContext itemBuilder, index) {
                      // //               return Card(
                      // //                 color: Colors.white,
                      // //                 elevation: 15,
                      // //                 shape: RoundedRectangleBorder(
                      // //                   side: const BorderSide(color: Colors.white70, width: 1),
                      // //                   borderRadius: BorderRadius.circular(10),
                      // //                 ),
                      // //                 child: Container(
                      // //                   padding: const EdgeInsets.all(6),
                      // //                   height: 80,
                      // //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      // //                   ),
                      // //                   child: Column(
                      // //                     mainAxisAlignment: MainAxisAlignment.start,
                      // //                     children: [
                      // //                       Expanded(
                      // //                         flex: 3,
                      // //                         child: Row(
                      // //                           children: [
                      // //                             Expanded(
                      // //                               flex: 10,
                      // //                               child: Row(
                      // //                                 mainAxisAlignment:
                      // //                                 MainAxisAlignment.spaceBetween,
                      // //                                 children: [
                      // //                                   Expanded(
                      // //                                     child: Text(
                      // //                                       addedDcrGSPList[index].giftName,
                      // //                                       style: const TextStyle(
                      // //                                           color: Color.fromARGB(255, 9, 38, 61),
                      // //                                           fontWeight: FontWeight.w400,
                      // //                                           fontSize: 16),
                      // //                                     ),
                      // //                                   ),
                      // //                                   // Text(
                      // //                                   //   '(${addedDcrGSPList[index].giftType})',
                      // //                                   //   style: const TextStyle(
                      // //                                   //       fontSize: 16),
                      // //                                   // ),
                      // //                                 ],
                      // //                               ),
                      // //                             ),
                      // //                             const SizedBox(
                      // //                               width: 10,
                      // //                             ),
                      // //                             IconButton(
                      // //                               onPressed: () {
                      // //                                 _showMyDialog(index);
                      // //                               },
                      // //                               icon: const Icon(Icons.clear, color: Colors.grey,
                      // //                               ),
                      // //                             ),
                      // //                           ],
                      // //                         ),
                      // //                       ),
                      // //                       Expanded(
                      // //                         child: Row(
                      // //                           mainAxisAlignment:
                      // //                           MainAxisAlignment.start,
                      // //                           children: [
                      // //                             addedDcrGSPList[index].giftType !=
                      // //                                 "Discussion"
                      // //                                 ? Row(
                      // //                               children: [
                      // //                                 const Text(
                      // //                                   'Qt:  ',
                      // //                                   style: TextStyle(
                      // //                                       fontSize: 16,
                      // //                                       color: Color.fromARGB(
                      // //                                           255, 9, 38, 61)),
                      // //                                 ),
                      // //                                 Text(
                      // //                                   addedDcrGSPList[index]
                      // //                                       .quantity
                      // //                                       .toString(),
                      // //                                   style: const TextStyle(
                      // //                                       color: Color.fromARGB(
                      // //                                           255, 9, 38, 61),
                      // //                                       fontSize: 16,
                      // //                                       fontWeight:
                      // //                                       FontWeight.bold),
                      // //                                 ),
                      // //                               ],
                      // //                             )
                      // //                                 : const Text(""),
                      // //                             const Spacer(),
                      // //                             Row(
                      // //                               children: [
                      // //                                 Text(
                      // //                                   '(${addedDcrGSPList[index].giftType})',
                      // //                                   style: const TextStyle(
                      // //                                     color: Color.fromARGB(
                      // //                                         255, 9, 38, 61),
                      // //                                     fontSize: 16,
                      // //                                   ),
                      // //                                 ),
                      // //                               ],
                      // //                             ),
                      // //                           ],
                      // //                         ),
                      // //                       ),
                      // //                     ],
                      // //                   ),
                      // //                 ),
                      // //               );
                      // //             },
                      // //           ),
                      // //         ),
                      // //       ),
                      // //     ],
                      // //   ),
                      // //   ),
                      // // ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: combinedList1.length,
                          itemBuilder: (context, index) {
                            print('merged item length: ${combinedList1.length}');

                            final mergedItem = combinedList1[index];

                            if (mergedItem.type == 'medicine') {
                              final med = mergedItem.item;

                              return Card(
                                elevation: 10,
                                color: const Color.fromARGB(255, 217, 248, 219),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 90,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Text('${med.name} (${med.itemId})', style: const TextStyle(fontSize: 14))),
                                      IconButton(
                                        onPressed: () {
                                          if (finalMedicineList[index].quantity > 1) {
                                            finalMedicineList[index].quantity--;
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Container(width: 40, height: 30, decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)), child: Center(child: Text(med.quantity.toString()))),
                                      IconButton(
                                        onPressed: () {
                                          finalMedicineList[index].quantity++;
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () => _showMyDialog(index)),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final promo = mergedItem.item;
                              return Card(
                                color: Colors.white,
                                elevation: 15,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 90,
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(children: [Expanded(child: Text(promo.giftName, style: const TextStyle(color: Color.fromARGB(255, 9, 38, 61), fontWeight: FontWeight.w400, fontSize: 16))), IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () => _showMyDialogforGiftSamplePpm(index))]),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          promo.giftType != "Discussion" ? Row(children: [const Text('Qt: ', style: TextStyle(fontSize: 16)), Text(promo.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold))]) : const SizedBox.shrink(),
                                          Text('(${promo.giftType})'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar:
                    rx_gallery_allow == true
                        ? BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          onTap: _onItemTapped,
                          currentIndex: _currentSelected,
                          showUnselectedLabels: true,
                          unselectedItemColor: Colors.grey[800],
                          selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                          items: const <BottomNavigationBarItem>[BottomNavigationBarItem(label: 'Save Drafts', icon: Icon(Icons.drafts)), BottomNavigationBarItem(label: 'Gallery', icon: Icon(Icons.add_photo_alternate)), BottomNavigationBarItem(label: 'Submit', icon: Icon(Icons.save)), BottomNavigationBarItem(label: 'Camera', icon: Icon(Icons.camera_alt))],
                        )
                        : BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          onTap: _onItemTapped2,
                          currentIndex: _currentSelected2,
                          showUnselectedLabels: true,
                          unselectedItemColor: Colors.grey[800],
                          selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                          items: const <BottomNavigationBarItem>[BottomNavigationBarItem(label: 'Save Drafts', icon: Icon(Icons.drafts)), BottomNavigationBarItem(label: 'Submit', icon: Icon(Icons.save)), BottomNavigationBarItem(label: 'Camera', icon: Icon(Icons.camera_alt))],
                        ),
              )
              : Container(padding: const EdgeInsets.all(100), color: Colors.white, child: const Center(child: CircularProgressIndicator())),
    );
  }

  // rx Submitt................................................
  Future<dynamic> rxSubmit(String fileName) async {
    debugPrint("File Name :::::::$fileName");
    double lat = 0.0;
    double long = 0.0;
    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);
        setState(() {
          lat = position.latitude;
          long = position.longitude;

          address = "${placemarks[0].street!} ${placemarks[0].country!}";
        });
      }
    } on Exception catch (e) {
      debugPrint("Exception geolocator section: $e");
    }

    // debugPrint(
    //     '${submit_url!}api_rx_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword'
    //         '&device_id=$deviceId&app_version=$appVersion'
    //         '&doctor_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId}'
    //         '&area_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId}&rx_type=$dropdownRxTypevalue'
    //         '&latitude=$lat&longitude=$long&image_name=$fileName&cap_time=${"dt"}&item_list=$itemString');

    debugPrint(
      'prescription submit:: ${submit_url!}api_prescription_submit/submit_data'
      //'prescription submit:: http://192.168.100.219:8000/physician_api/api_prescription_submit/submit_data'
      '?cid=$cid'
      '&user_id=$userId'
      '&user_pass=$userPassword'
      '&device_id=$deviceId'
      '&sales_type=$selectedSalesType'
      '&patient_type=$selectedPatientType'
      '&patient_name=${patientNameController.text}'
      '&number=${phnNumberController.text}'
      '&gender=$selectedGenderType'
      '&dob=${dobController.text}'
      '&strip_wastage=$selectedStripWastageType'
      '&system_name=$selectedDiseasesText'
      '&disesses=$selectedDiseasesText'
      '&patient_temperament=$selectedPatientTemperamentsText'
      '&diabetes_before=${beforeDiabetesController.text}'
      '&diabetes_after=${afterDiabetesController.text}'
      '&pressure_systolic=${systolicController.text}'
      '&pressure_diastolic=${diastolicController.text}'
      '&oxygen_level=${oxygenLevelController.text}'
      '&body_temp=${bodyTemperatureController.text}'
      '&weight=${weightController.text}'
      '&height_feet=${feetController.text}'
      '&height_inch=${inchController.text}'
      '&latitude=$lat'
      '&longitude=$long'
      '&image_name=$fileName'
      '&cap_time=${"dt"}'
      '&item_list=$itemString'
      '&app_version=$appVersion'
      '&item_list_gsp=$itemString1'
      '&branch_id=$branchId',
    );
    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    String time = dt.replaceAll(":", '');
    String a = '${user_id}_$time';

    try {
      final Map<String, dynamic> body = {
        'cid': cid,
        'user_id': userId,
        'user_pass': userPassword,
        'device_id': deviceId,
        'sales_type': selectedSalesType,
        'patient_type': selectedPatientType,
        'patient_name': patientNameController.text,
        'number': phnNumberController.text,
        'gender': selectedGenderType,
        'dob': dobController.text,
        'strip_wastage': selectedStripWastageType,
        'system_name': selectedSystemsText,
        'disesses': selectedDiseasesText,
        'patient_temperament': selectedPatientTemperamentsText,
        'diabetes_before': beforeDiabetesController.text,
        'diabetes_after': afterDiabetesController.text,
        'pressure_systolic': systolicController.text,
        'pressure_diastolic': diastolicController.text,
        'oxygen_level': oxygenLevelController.text,
        'body_temp': bodyTemperatureController.text,
        'weight': weightController.text,
        'height_feet': feetController.text,
        'height_inch': inchController.text,
        "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
        'longitude': (minLongitude <= long && long <= maxLongitude) ? long : '',
        'image_name': fileName,
        'cap_time': dt.toString(),
        "item_list": itemString,
        'app_version': appVersion,
        'item_list_gsp': itemString1,
        'branch_id': branchId,
      };
      final String url = '${submit_url!}api_prescription_submit/submit_data';
      debugPrint("Submit Url : $url");

      final http.Response response = await http.post(
        Uri.parse(
          '${submit_url!}api_prescription_submit/submit_data',
          //'http://192.168.100.219:8000/physician_api/api_prescription_submit/submit_data'
        ),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        // body: jsonEncode(
        //   <String, dynamic>{
        //     'cid': cid,
        //     'user_id': userId,
        //     'user_pass': userPassword,
        //     'device_id': deviceId,
        //     'doctor_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId,
        //     'area_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId,
        //     'rx_type': dropdownRxTypevalue,
        //     "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
        //     'longitude': (minLongitude <= long && long <= maxLongitude) ? long : '',
        //     'image_name': fileName,
        //     'cap_time': dt.toString(),
        //     "item_list": itemString,
        //     'app_version' : appVersion,
        //   },
        // ),
        // body: jsonEncode(<String, dynamic>{
        //   'cid': cid,
        //   'user_id': userId,
        //   'user_pass': userPassword,
        //   'device_id': deviceId,
        //   'sales_type': selectedSalesType,
        //   'patient_type': selectedPatientType,
        //   'patient_name': patientNameController.text,
        //   'number': phnNumberController.text,
        //   'gender': selectedGenderType,
        //   'dob': dobController.text,
        //   'strip_wastage': selectedStripWastageType,
        //   'system_name': selectedSystem,
        //   'disesses': selectedDisease,
        //   'patient_temperament': selectedPatientTemperament,
        //   'diabetes_before': beforeDiabetesController.text,
        //   'diabetes_after': afterDiabetesController.text,
        //   'pressure_systolic': systolicController.text,
        //   'pressure_diastolic': diastolicController.text,
        //   'oxygen_level': oxygenLevelController.text,
        //   'body_temp': bodyTemperatureController.text,
        //   'weight': weightController.text,
        //   'height_feet': feetController.text,
        //   'height_inch': inchController.text,
        //   "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
        //   'longitude': (minLongitude <= long && long <= maxLongitude) ? long : '',
        //   'image_name': fileName,
        //   'cap_time': dt.toString(),
        //   "item_list": itemString,
        //   'app_version': appVersion,
        //   'item_list_gsp': itemString1,
        //   'branch_id': branchId,
        // },
        body: jsonEncode(body),
      );

      debugPrint("Submit Data : $body");
      var orderInfo = json.decode(response.body);
      String status = orderInfo['status'];
      debugPrint('status::${orderInfo['status']}');

      var ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        if (widget.ck != '') {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            // deleteMedicinItem(widget.dcrKey);//this one is Old
            deleteMedicinItem(widget.uniqueId); //! this is new one like Rx

            // finalItemDataList.clear();
            setState(() {});
          }

          // deleteRxDoctor(widget.dcrKey);//this one is Old
          deleteRxDoctor(widget.uniqueId); //! This one is New One like RX
        }
        //todo! Add New Like RX
        else {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(objectImageId);

            // finalItemDataList.clear();
            setState(() {});
          }

          deleteRxDoctor(objectImageId);
        }

        print("===============================");

        setState(() {
          widget.image1 = '';
          imagePath = null;
          file = null;
          finalMedicineList.clear();
          finalImage = '';
          beforeDiabetesController.clear();
          afterDiabetesController.clear();
          systolicController.clear();
          diastolicController.clear();
          oxygenLevelController.clear();
          bodyTemperatureController.clear();
          weightController.clear();
          feetController.clear();
          inchController.clear();
          phnNumberController.clear();
          patientNameController.clear();
          dobController.clear();
          selectedGenderType = null;
          selectedStripWastageType = null;
          selectedSalesType = null;
          selectedPatientType = null;
          selectedSystem = null;
          selectedDisease = null;
          selectedPatientTemperament = null;
          itemString1 = '';
          addedDcrGSPList.clear();
          bmi = null;
          bmiStatus = null;
          bmiDetailedMessage = null;
        });
        print('suceesssss');

        _submitToastforOrder(ret_str);
      } else if (orderInfo['ret_str'].toString().toLowerCase().contains('http') && status == 'Failed') {
        String update_app_url = '';
        String update_app_notification = '';
        if (orderInfo['ret_str'].toString().contains('http')) {
          int index = orderInfo['ret_str'].toString().indexOf("http");
          //
          // String update_app_notification = orderInfo['ret_str'].toString().substring(0, index).trim();
          // debugPrint(update_app_notification);

          update_app_notification = orderInfo['ret_str'].toString().substring(0, index).trim() ?? '';
          update_app_url = orderInfo['ret_str'].toString().substring(index).trim() ?? '';
          await databox.put('update_new_app', update_app_notification);
          await databox.put('update_new_app_url', update_app_url);
        }
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('${orderInfo['ret_str']}'),
        //     backgroundColor: Colors.red));
        AllServices().messageForUser(orderInfo['ret_str']);
        setState(() {
          _isLoading = true;
        });
        // debugPrint(update_app_url);
        // await databox.put('update_new_app',update_app_notification);
        // await databox.put('update_new_app_url',update_app_url);
        if (update_app_url != null || update_app_url != '') {
          AllServices().showMap(update_app_url);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${orderInfo['ret_str']}'), backgroundColor: Colors.red));
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error on server'), backgroundColor: Colors.red));
      print('faileddd');
      throw Exception("Error on server");
    } finally {
      setState(() {
        _isLoading = true;
      });
    }
  }

  // ------------------------ Rx Submit (Kamrul) --------------
  Future<dynamic> rxImageUpload() async {
    setState(() {
      _isLoading = false;
    });

    // final compressfileForImage = await compressFile(imagePath!);

    var dt = DateFormat('HH:mm:ss').format(DateTime.now());
    calculateRxItemString();
    calculatingTotalitemString1();

    // String time = dt.replaceAll(":", '');

    var postUri = Uri.parse(photo_submit_url.toString()!);
    // var postUri = Uri.parse("http://52.230.87.124/image_up/api_image_upload/image_upload");

    log(postUri.toString(), name: "photo url");

    http.MultipartRequest request = await http.MultipartRequest("POST", postUri);
    if (widget.image1 != '') {
      // final compressesImage = await compressAndResizeImage(finalImage);
      // final compressfileForImage = File(compressesImage);
      final compressfileForImage = await compressFile(File(finalImage));

      setState(() {
        finalImage = compressfileForImage.toString();
      });

      int space = finalImage.indexOf(" ");
      String removeSpace = finalImage.substring(space + 1, finalImage.length);
      finalImage = removeSpace.replaceAll("'", '');

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage',
        finalImage.toString(),
        // filename: a,
        // filename: finalImage.split("-").last
      );

      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);

      final status = jsonData["res_data"]["status"];
      final fileName = jsonData["res_data"]["ret_str"];

      // print(fileName);
      if (fileName != '' && status == "Success") {
        // submitAddress = await getAddress(latitude, longitude);
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rx Image submit Failed'), backgroundColor: Colors.red));
      }
      // print(response.statusCode);
    } else {
      final compressfileForImage = await compressFile(imagePath!);

      String rxImage = '';

      setState(() {
        rxImage = compressfileForImage.toString();
        debugPrint("compressed image path   :::::::::::::::::::   ${compressfileForImage?.path.toString()}");
      });

      int space = rxImage.indexOf(" ");
      String removeSpace = rxImage.substring(space + 1, rxImage.length);
      finalImage = removeSpace.replaceAll("'", '');

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage',
        finalImage,

        // filename: a,  "-").last
      );

      //request.fields["rxImage"] = finalImage;
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();

      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);
      // print(jsonData["res_data"]["ret_str"]);
      print("result 2nd condition rx image ${jsonData}");
      final status = jsonData["res_data"]["status"];
      final fileName = jsonData["res_data"]["ret_str"];

      // print(fileName);
      if (fileName != '' && status == "Success") {
        // submitAddress = await getAddress(latitude, longitude);
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rx Image submit Failed'), backgroundColor: Colors.red));
      }
    }
  }
  // Future rxImageUpload({dynamic imageFile}) async {
  //   print("image path-------------------------------------${imageFile.path}");
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   await Future.delayed(Duration(milliseconds: 500));
  //   try {
  //     print("-------------------------------------1");
  //     calculateRxItemString();
  //     print("-------------------------------------2");
  //     dynamic _image;
  //     if (widget.image1.isNotEmpty) {
  //       print("-------------------------------------3");
  //       _image = File('${finalImage}');
  //     } else {
  //       print("-------------------------------------4");
  //       _image = imageFile;
  //     }
  //     // await Future.delayed(Duration(milliseconds: 50));
  //     print("-------------------------------------5");
  //
  //     img.Image? imageTemp = img.decodeImage(_image.readAsBytesSync());
  //     print("-------------------------------------6");
  //
  //     int desiredFileSizeInBytes = 900 * 1024;
  //     print("-------------------------------------7");
  //
  //
  //     //final int initialQuality = 90; // Initial quality value
  //     final int initialQuality = 50; // Initial quality value
  //     int currentQuality = initialQuality;
  //     print("-------------------------------------8");
  //
  //
  //     List<int> imageBytes;
  //     do {
  //       print("-------------------------------------9");
  //
  //       imageBytes = img.encodeJpg(imageTemp!, quality: currentQuality);
  //       currentQuality -= 10; // Decrease quality in steps
  //     } while (
  //     imageBytes.length > desiredFileSizeInBytes && currentQuality >= 10);
  //
  //     await Future.delayed(Duration(milliseconds: 50));
  //     print("-------------------------------------10");
  //     log(photo_submit_url.toString() , name: "photo_submit_url");
  //     log(imageBytes.length.toString() , name: "imageBytes");
  //
  //     final request =
  //     http.MultipartRequest('POST', Uri.parse("$photo_submit_url"))
  //       ..files.add(
  //
  //         // await http.MultipartFile.fromBytes(
  //         //   'productImage',
  //         //   imageBytes,
  //         //   filename: 'resized_image.jpg',
  //         // ),
  //       );
  //     print("-------------------------------------11");
  //
  //     var response = await request.send();
  //
  //     print("-------------------------------------12");
  //
  //
  //     if (response.statusCode == 200) {
  //       var res = await http.Response.fromStream(response);
  //       debugPrint("111111111111111111111111111111111111111111111");
  //       var imgData = jsonDecode(res.body);
  //       debugPrint("22222222222222222222222222222222222222222222");
  //       var imageName = '';
  //       if (imgData['res_data']['status'] == 'Success') {
  //         debugPrint("333333333333333333333333333333333333333333");
  //         imageName = "${imgData['res_data']['ret_str'].toString()}";
  //         debugPrint("44444444444444444444444444444444444444444444");
  //         rxSubmit(imageName);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text('Rx Image submit Failed'),
  //               backgroundColor: Colors.red),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // ..........Rx Image Submit.................................
  // Future<dynamic> _rxImageSubmit() async {
  //   setState(() {
  //     calculateRxItemString();
  //   });

  //   var dt = DateFormat('HH:mm:ss').format(DateTime.now());

  //   String time = dt.replaceAll(":", '');

  //   var postUri = Uri.parse(photo_submit_url!);

  //   http.MultipartRequest request = http.MultipartRequest("POST", postUri);
  //   if (widget.image1 != '') {
  //     final compressfileForImage = await compressFile(File(finalImage));

  //     setState(() {
  //       finalImage = compressfileForImage.toString();
  //     });

  //     int space = finalImage.indexOf(" ");
  //     String removeSpace = finalImage.substring(space + 1, finalImage.length);
  //     finalImage = removeSpace.replaceAll("'", '');

  //     http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       'productImage', finalImage.toString(),
  //       // filename: a,
  //       // filename: finalImage.split("-").last
  //     );

  //     request.files.add(multipartFile);
  //     http.StreamedResponse response = await request.send();
  //     var res = await http.Response.fromStream(response);
  //     final jsonData = json.decode(res.body);
  //     debugPrint("result 2nd condition rx image $jsonData");
  //     final fileName = jsonData['fileName'];

  //     // debugPrint(fileName);
  //     if (fileName != '') {
  //       rxSubmit(fileName);
  //     } else {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //     // debugPrint(response.statusCode);
  //   } else {
  //     final compressfileForImage = await compressFile(imagePath!);
  //     String rxImage = '';

  //     setState(() {
  //       rxImage = compressfileForImage.toString();
  //     });

  //     int space = rxImage.indexOf(" ");
  //     String removeSpace = rxImage.substring(space + 1, rxImage.length);
  //     finalImage = removeSpace.replaceAll("'", '');

  //     http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       'productImage', finalImage,
  //       // filename: a,
  //       // filename: finalImage.split("-").last
  //     );

  //     //request.fields["rxImage"] = finalImage;
  //     request.files.add(multipartFile);
  //     http.StreamedResponse response = await request.send();

  //     var res = await http.Response.fromStream(response);
  //     final jsonData = json.decode(res.body);
  //     final fileName = jsonData['fileName'];

  //     // debugPrint(fileName);
  //     if (fileName != '') {
  //       rxSubmit(fileName);
  //     } else {
  //       setState(() {
  //         _isLoading = true;
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Rx Image submit Failed'),
  //             backgroundColor: Colors.red),
  //       );
  //     }
  //   }
  // }

  // .......... Submit Toast messege..............
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(msg: "Prescription Submitted\n$ret_str", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, backgroundColor: Colors.green.shade900, textColor: Colors.white, fontSize: 16.0);
  }

  deleteRxDoctor(int id) {
    final box = Hive.box<RxDcrDataModel>("RxdDoctor");

    final Map<dynamic, RxDcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  // Save RX data to Hive......................................

  deleteMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future putAddedRxData() async {
    if (widget.ck != '') {
      for (int i = 0; i <= finalMedicineList.length; i++) {
        deleteMedicinItem(widget.dcrKey);

        setState(() {});
      }
      // deleteRxDoctor(widget.uniqueId);

      final Doctorbox = Boxes.rxdDoctor();
      Doctorbox.toMap().forEach((key, value) {
        if (value.uiqueKey == widget.dcrKey) {
          value.docName = finalDoctorList[0].docName;
          value.docId = finalDoctorList[0].docId;
          value.address = finalDoctorList[0].address;
          value.areaId = finalDoctorList[0].areaId;
          value.areaName = finalDoctorList[0].areaName;
          value.dcrGrad = dropdownRxTypevalue;

          value.phnNum = phnNumberController.text;
          value.patientName = patientNameController.text;
          value.gender = selectedGenderType ?? '';
          value.dob = dobController.text;
          value.stripWastage = selectedStripWastageType ?? '';
          value.systemName = selectedSystem ?? '';
          value.disease = selectedDisease ?? '';
          value.patientTemperament = selectedPatientTemperament ?? '';
          value.diabetesBefore = beforeDiabetesController.text;
          value.diabetesAfter = afterDiabetesController.text;
          value.bloodSystolic = systolicController.text;
          value.bloodDiastolic = diastolicController.text;
          value.oxygenLevel = oxygenLevelController.text;
          value.bodyTemperature = bodyTemperatureController.text;
          value.weight = weightController.text;
          value.heightFeet = feetController.text;
          value.heightInch = inchController.text;

          Doctorbox.put(key, value);
        }
      });

      for (var d in finalMedicineList) {
        d.uiqueKey = widget.dcrKey;
        final box = Boxes.getMedicine();
        box.add(d);
      }
    } else {
      for (var dcr in finalDoctorList) {
        debugPrint('uiniquIdD:${dcr.uiqueKey}');
        final box = Boxes.rxdDoctor();
        final medicineBox = Boxes.getMedicine();
        print('boxxxx:$medicineBox');
        dcr.uiqueKey = objectImageId;
        box.toMap().forEach((key, value) {
          if (dcr.uiqueKey == value.uiqueKey) {
            value.docName = dcr.docName;
            value.docId = dcr.docId;
            value.areaName = dcr.areaName;
            value.areaId = dcr.areaId;
            value.address = dcr.address;
            value.dcrGrad = dropdownRxTypevalue.toString();

            value.phnNum = phnNumberController.text;
            value.patientName = patientNameController.text;
            value.gender = selectedGenderType ?? '';
            value.dob = dobController.text;
            value.stripWastage = selectedStripWastageType ?? '';
            value.systemName = selectedSystem ?? '';
            value.disease = selectedDisease ?? '';
            value.patientTemperament = selectedPatientTemperament ?? '';
            value.diabetesBefore = beforeDiabetesController.text;
            value.diabetesAfter = afterDiabetesController.text;
            value.bloodSystolic = systolicController.text;
            value.bloodDiastolic = diastolicController.text;
            value.oxygenLevel = oxygenLevelController.text;
            value.bodyTemperature = bodyTemperatureController.text;
            value.weight = weightController.text;
            value.heightFeet = feetController.text;
            value.heightInch = inchController.text;

            box.put(key, value);
            if (finalMedicineList.isNotEmpty) {
              for (var element in finalMedicineList) {
                element.uiqueKey = objectImageId;
                medicineBox.add(element);
              }
            }
          }
        });
      }
    }
    // /// Pro Dx cus info add edit
    // ///
    // print('xxxxxxxxxxxxxx');
    // print(dxDataMap);
    // if (finalDoctorList.isNotEmpty) {
    //   for (var element in finalDoctorList) {
    //     element.uiqueKey = objectImageId;
    //     await Boxes.proDxCusBox().put("${element.uiqueKey}",dxDataMap);
    //   }
    //   dxDataMap.clear();
    //
    //   phnNumberController.clear();
    //   patientNameController.clear();
    //   dobController.clear();
    //   selectedGenderType=null;
    //   selectedStripWastageType=null;
    //   selectedSalesType=null;
    //   selectedPatientType=null;
    //
    //   selectedSystem=null;
    //   selectedDisease=null;
    //   selectedPatientTemperament=null;
    //   beforeDiabetesController.clear();
    //   afterDiabetesController.clear();
    //   systolicController.clear();
    //   diastolicController.clear();
    //   oxygenLevelController.clear();
    //   bodyTemperatureController.clear();
    //   weightController.clear();
    //   feetController.clear();
    //   inchController.clear();
    //
    // }
    // if (finalDoctorList.isNotEmpty) {
    //   for (var element in finalDoctorList) {
    //     element.uiqueKey = objectImageId;
    //     final data= Boxes.proDxCusBox().get("${element.uiqueKey}");
    //     debugPrint('Hive Data for ${element.uiqueKey}: $data');
    //     print ('in hive');
    //     //print(data);
    //   }}
    //
    // /// end

    setState(() {
      widget.image1 = '';
      imagePath = null;
      file = null;
      finalMedicineList.clear();
      finalImage = '';

      phnNumberController.clear();
      patientNameController.clear();
      dobController.clear();
      selectedGenderType = null;
      selectedStripWastageType = null;
      selectedSalesType = null;
      selectedPatientType = null;

      selectedSystem = null;
      selectedDisease = null;
      selectedPatientTemperament = null;
      beforeDiabetesController.clear();
      afterDiabetesController.clear();
      systolicController.clear();
      diastolicController.clear();
      oxygenLevelController.clear();
      bodyTemperatureController.clear();
      weightController.clear();
      feetController.clear();
      inchController.clear();
      bmi = null;
      bmiStatus = null;
      bmiDetailedMessage = null;
    });
  }

  //! Future openBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('dcrListData');
  //! }

  ////////////////////////////docotr//////////////////////////
  getRxDoctorData() {
    //! await openBox();
    var box = Hive.box("dcrListData");
    var mymap = box.toMap().values.toList();
    if (mymap.isNotEmpty) {
      doctorData = mymap;

      if (_activeCounter == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DoctorListFromHiveData(
                  counterCallback: (value) {
                    counterForDoctor = value;

                    setState(() {});
                  },
                  a: a,
                  doctorData: doctorData,
                  tempList: finalDoctorList,
                  counterForDoctorList:
                      widget.uniqueId > 0
                          ? widget.uniqueId
                          : _isCameraClick == true
                          ? objectImageId
                          : _counterforRx,
                  tempListFunc: (value) {
                    finalDoctorList = value;
                    for (var element in finalDoctorList) {
                      docId = element.docId;
                      //todo! for last Doctor
                      tempdocName = element.docName;
                      areaName = element.areaName;
                      areaid = element.areaId;
                      address = element.address;
                    }

                    setState(() {});
                  },
                ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DoctorListFromHiveData(
                  counterCallback: (value) {
                    counterForDoctor = value;

                    // setState(() {});
                  },
                  a: a,
                  doctorData: doctorData,
                  tempList: finalDoctorList,
                  counterForDoctorList: widget.uniqueId > 0 ? widget.uniqueId : counterForDoctor,
                  tempListFunc: (value) {
                    finalDoctorList = value;
                    for (var element in finalDoctorList) {
                      docId = element.docId;
                      //todo for set last Doctor
                      tempdocName = element.docName;
                      areaName = element.areaName;
                      areaid = element.areaId;
                      address = element.address;
                    }

                    setState(() {});
                  },
                ),
          ),
        );
      }
    } else {
      doctorData.add('Empty');
    }
  }

  ///////////////////////////////medicine///////////////////////////////
  //! Future openBox1() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('medicineList');
  //! }

  getMedicine() {
    //! await openBox1();
    var box = Hive.box('medicineList');
    var mymap = box.toMap().values.toList();
    if (mymap.isNotEmpty) {
      medicineData = mymap;
      // debugPrint('test1:$counterForDoctor');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => MedicinListScreen(
                counter:
                    (finalDoctorList.isNotEmpty && finalDoctorList[0].docId != '')
                        ? counterForDoctor
                        : _isCameraClick == true
                        ? objectImageId
                        : widget.uniqueId > 0
                        ? widget.uniqueId
                        : _counterforRx,
                medicineData: medicineData,
                tempList: finalMedicineList,
                tempListFunc: (value) {
                  finalMedicineList = value;
                  setState(() {});
                },
                img1: finalImage,
                img: imagePath,
              ),
        ),
      );
    } else {
      medicineData.add('Empty');
    }
  }

  deleteMedicineItem(int id, int index) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");
    final Map<dynamic, MedicineListModel> medicineMap = box.toMap();
    dynamic newKey;
    medicineMap.forEach((key, value) {
      if (value.uiqueKey == id) {
        newKey = key;
      }
    });
    box.delete(newKey);
    finalMedicineList.removeAt(index);
  }

  // void _submitToastforSelectDoctor() {
  //   Fluttertoast.showToast(
  //       msg: 'Please Select Doctor First',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(child: Column(children: const <Widget>[Text('Do you want to delete this medicine?')])),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (widget.ck != '') {
                  final medicineUniqueKey = finalMedicineList[index].uiqueKey;

                  deleteMedicineItem(medicineUniqueKey, index);
                  setState(() {});
                } else {
                  finalMedicineList.removeAt(index);
                  setState(() {});
                }
                // debugPrint('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogforGiftSamplePpm(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(child: Column(children: const <Widget>[Text('Are you sure to remove the Item?')])),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (widget.ck != '') {
                  final uniqueKey = widget.dcrKey;
                  deleteSingleGSPItem(uniqueKey, index);

                  setState(() {});
                } else {
                  addedDcrGSPList.removeAt(index);
                  setState(() {});
                }
                // debugPrint('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteSingleGSPItem(int rxDcrUniqueKey, int index) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == rxDcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    addedDcrGSPList.removeAt(index);

    setState(() {});
  }

  int uniqueIdForImage() {
    int id = 0;
    id = int.parse(DateFormat('HH:mm:ssss').format(DateTime.now()).replaceAll(":", ''));
    setState(() {
      objectImageId = id;
    });
    return id;
  }

  Future<void> _cameraFuntionality() async {
    setState(() {
      debugPrint('changebefore: $_isCameraClick');
      _isCameraClick = true;
      debugPrint('changeafter: $_isCameraClick');
    });
    file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      //preferredCameraDevice: CameraDevice.rear,
      // maxHeight: 800,
      // maxWidth: 700,
    );
    if (file != null) {
      debugPrint("file from cam $file");
      setState(() {
        file;
        imagePath = File(file!.path);
        widget.image1 = '';
        debugPrint("image path from cam$imagePath");

        if (imagePath != null && widget.ck == "") {
          // if (finalDoctorList.)
          debugPrint("image will save on draft");
          if (finalDoctorList.isEmpty) {
            finalDoctorList.add(
              RxDcrDataModel(
                // uiqueKey:
                //     widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                // docName: objectImageId.toString(),
                // docId: '',
                // areaId: '',
                // areaName: 'areaName',
                // address: 'address',
                // presImage: imagePath.toString(),
                uiqueKey: widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName: tempdocName == "" ? objectImageId.toString() : tempdocName,
                docId: docId == '' ? "" : docId,
                areaId: areaid == "" ? "" : areaid,
                areaName: areaName == '' ? "areaName" : areaName,
                address: address == '' ? "address" : address,
                presImage: imagePath.toString(),
                dcrGrad: dropdownRxTypevalue.toString(),
                phnNum: phnNumberController.text,
                patientName: patientNameController.text,
                gender: selectedGenderType.toString(),
                dob: dobController.text,
                stripWastage: selectedStripWastageType.toString(),
                systemName: selectedSystem.toString(),
                disease: selectedDisease.toString(),
                patientTemperament: selectedPatientTemperament.toString(),
                diabetesBefore: beforeDiabetesController.text,
                diabetesAfter: afterDiabetesController.text,
                bloodSystolic: systolicController.text,
                bloodDiastolic: diastolicController.text,
                oxygenLevel: oxygenLevelController.text,
                bodyTemperature: bodyTemperatureController.text,
                weight: weightController.text,
                heightFeet: feetController.text,
                heightInch: inchController.text,
                branchId: branchId,
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          } else {
            finalDoctorList.clear();
            finalDoctorList.add(
              RxDcrDataModel(
                // uiqueKey:
                //     widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                // docName: objectImageId.toString(),
                // docId: '',
                // areaId: '',
                // areaName: 'areaName',
                // address: 'address',
                // presImage: imagePath.toString(),
                uiqueKey: widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName: tempdocName == "" ? objectImageId.toString() : tempdocName,
                docId: docId == "" ? '' : docId,
                areaId: areaid == '' ? "" : areaid,
                areaName: areaName == '' ? "areaName" : areaName,
                address: address == '' ? "address" : address,
                presImage: imagePath.toString(),
                dcrGrad: dropdownRxTypevalue.toString(),
                phnNum: phnNumberController.text,
                patientName: patientNameController.text,
                gender: selectedGenderType.toString(),
                dob: dobController.text,
                stripWastage: selectedStripWastageType.toString(),
                systemName: selectedSystem.toString(),
                disease: selectedDisease.toString(),
                patientTemperament: selectedPatientTemperament.toString(),
                diabetesBefore: beforeDiabetesController.text,
                diabetesAfter: afterDiabetesController.text,
                bloodSystolic: systolicController.text,
                bloodDiastolic: diastolicController.text,
                oxygenLevel: oxygenLevelController.text,
                bodyTemperature: bodyTemperatureController.text,
                weight: weightController.text,
                heightFeet: feetController.text,
                heightInch: inchController.text,
                branchId: branchId,
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          }
        } else if (imagePath != null && widget.ck != '') {
          final Doctorbox = Boxes.rxdDoctor();
          Doctorbox.toMap().forEach((key, value) {
            if (value.uiqueKey == widget.dcrKey) {
              value.presImage = imagePath.toString();
              Doctorbox.put(key, value);
            }
          });
          // widget.image1 = imagePath.toString();
          debugPrint("This Print is Total Darft data${Doctorbox.values.length}");
          // int langth=Doctorbox.values.toList().length.toInt();
          // widget.callback(langth);
        }
      });
    }
  }

  Future<void> _galleryFunctionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      maxHeight: 800,
      maxWidth: 700,
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
      });
    }
  }

  void _submitToastforphoto() {
    Fluttertoast.showToast(
      msg: 'Please Select Required Data',
      // msg: 'Please Take Image and Select Medicine',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _submitToastforDoctor() {
    Fluttertoast.showToast(msg: 'Please Select Doctor.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  // Future<File> compressFile(File file) async {
  //   final filePath = file.absolute.path;
  //
  //   // Create output file path
  //   // eg:- "Volume/VM/abcd_out.jpeg"
  //   final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  //   final splitted = filePath.substring(0, (lastIndex));
  //   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  //   debugPrint("file path${file.absolute.path}");
  //   debugPrint("out path$outPath");
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //       file.absolute.path, outPath,
  //       quality: 95, minHeight: 800, minWidth: 800);
  //
  //   print(file.lengthSync());
  //   print(result!.lengthSync());
  //   debugPrint("result $result");
  //
  //   return result;
  // }

  Future<File> compressFile(File file) async {
    try {
      // Read the image file
      final imageBytes = await file.readAsBytes();

      // Decode the image
      final originalImage = await Isolate.run(() => img.decodeImage(imageBytes));
      debugPrint(originalImage.runtimeType.toString());
      debugPrint("The image is decoded");
      if (originalImage == null) {
        throw Exception('Failed to decode image.');
      }

      // Resize the image to a smaller size (e.g., max width: 800px, height proportional)
      const maxWidth = 800;
      final resizedImage = await img.copyResize(originalImage, width: originalImage.width > maxWidth ? maxWidth : originalImage.width);

      // Compress the image (JPEG with 75% quality)
      final compressedImageBytes = await img.encodeJpg(resizedImage, quality: 50);

      // Create a new file to store the compressed image
      final compressedFile = File('${file.parent.path}/compressed_${file.uri.pathSegments.last}');
      await compressedFile.writeAsBytes(compressedImageBytes);

      return compressedFile;
    } catch (e) {
      throw Exception('Error compressing image: $e');
    }
  }
}

class ZoomForRxImage extends StatelessWidget {
  File? img;
  ZoomForRxImage(this.img, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(child: Hero(tag: 'imageHero', child: PhotoView(imageProvider: FileImage(img!)))),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ZoomForRxDraftImage extends StatelessWidget {
  String? draftFinalImage;
  ZoomForRxDraftImage(this.draftFinalImage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(child: Hero(tag: 'imageForDraft', child: PhotoView(imageProvider: FileImage(File(draftFinalImage!))))),
        onTap: () {
          Navigator.of(context);
        },
      ),
    );
  }
}
