// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, unnecessary_null_comparison
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:physician_latest/features/pages/DCR_section/ppm.dart';
import 'package:physician_latest/features/pages/DCR_section/sample.dart';
import 'package:physician_latest/features/pages/DCR_section/show_dcr_discussionData.dart';
import 'package:physician_latest/features/pages/DCR_section/show_dcr_gitfData.dart';
import 'package:physician_latest/features/pages/DCR_section/show_dcr_ppmData.dart';
import 'package:physician_latest/features/pages/DCR_section/show_dcr_sampleData.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/Rx/medicin_list_screen.dart';
import '../../../core/constant.dart';
import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/datasources/local_storage/hive_data_model.dart';
import '../../../data/service/all_service.dart';
import '../../../data/service/apiCall.dart';
import '../../../data/service/network_connectivity.dart';
import '../../../main.dart';
import '../../Widgets/custom_dialog.dart';
import 'gift.dart';
import 'last_doctor_visit_page.dart';

// ignore: must_be_immutable
class DcrGiftSamplePpmPage extends StatefulWidget {
  int dcrKey;
  int uniqueId;
  String ck;
  String officeName;
  String officeId;
  String areaName;
  String areaId;
  String address;
  List<DcrGSPDataModel> draftOrderItem;
  String dVisitedWith;
  String note;
  String nonExcution;
  String selectedDeliveryTime;
  String image1;
  String visitedPerson;
  int phnNum;
  String orgName;
  String brandId;
  String category;
  DcrGiftSamplePpmPage({
    Key? key,
    required this.dcrKey,
    required this.uniqueId,
    required this.ck,
    required this.officeName,
    required this.officeId,
    required this.areaName,
    required this.areaId,
    required this.address,
    required this.draftOrderItem,
    required this.dVisitedWith,
    required this.note,
    required this.nonExcution,
    required this.selectedDeliveryTime,
    required this.image1,
    required this.visitedPerson,
    required this.phnNum,
    required this.orgName,
    required this.brandId,
    required this.category,
  }) : super(key: key);

  @override
  State<DcrGiftSamplePpmPage> createState() => _DcrGiftSamplePpmPageState();
}

class _DcrGiftSamplePpmPageState extends State<DcrGiftSamplePpmPage> {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  // List<DcrGiftDataModel> addedDcrGift = [];
  List<DcrGSPDataModel> addedDcrGSPList = [];

  List addedDcrsample = [];
  List addedDcrPpm = [];
  bool isGiftSync = false;
  bool isSampleSync = false;
  bool isPPMSync = false;

  Box? box;

  int _currentSelected = 2;
  int _currentSelected2 = 2;

  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];
  List doctorDiscussionlist = [];
  List<String> dcr_visitedWithList = [];
  int dropDownNumber = 0;
  String noteText = '';
  String submit_url = '';
  String? cid;
  String? userId;
  String? syncUrl;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  List visitedWith = [];
  double? latitude;
  double? longitude;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? dropdownVisitWithValue = '_';
  String doctor_url_edit = "";
  List<String> deliveryTime = ['Morning', 'Afternoon', 'Evening'];
  String? selectedDeliveryTime = 'Morning';
  bool _isLoading = true;
  bool dcr_discussion = true;
  bool areaPage = false;

  bool docEditFlag = false;
  var dcrString = '';
  var newString;
  String visitedWithString = '';
  String drftVisitShow = '';
  List<String> CauseForNonExecution = [];
  String causeData = '';
  //final jobRoleCtrl = TextEditingController();
  final TextEditingController jobRoleCtrl = TextEditingController();
  final TextEditingController visitedPersonController = TextEditingController();
  String? logo_url_2;
  final mydata = Boxes.allData();
  bool _isCameraClick = false;
  File? imagePath;
  XFile? file;
  String? imageFileName;
  bool _activeCounter = false;
  String finalImage = '';
  List<int> selectedVisitedIndexes = [];
  String? photo_submit_url;

  bool isGiftLoading = false;
  bool isSampleLoading = false;
  bool isPPMLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isGiftSync = mydata.get('isGiftSync') ?? false;
      isSampleSync = mydata.get('isSampleSync') ?? false;
      isPPMSync = mydata.get('isPPMSync') ?? false;
      startTime = mydata.get("startTime") ?? '';
      endTime = mydata.get("endTime") ?? '';
      doctor_url_edit = mydata.get("doctor_edit_url")!;
      photo_submit_url = mydata.get('photo_submit_url');
      submit_url = mydata.get("submit_url")!;
      print('submit:$submit_url');
      cid = mydata.get("CID");
      areaPage = mydata.get("areaPage")!;
      userId = mydata.get("USER_ID");
      syncUrl = mydata.get('sync_url');
      userPassword = mydata.get("PASSWORD");
      userName = mydata.get("userName")!;
      user_id = mydata.get("user_id")!;
      latitude = mydata.get("latitude");
      longitude = mydata.get("longitude");
      deviceId = mydata.get("deviceId");
      deviceBrand = mydata.get("deviceBrand");
      deviceModel = mydata.get("deviceModel");
      dcr_discussion = mydata.get("dcr_discussion") ?? false;
      docEditFlag = mydata.get("doc_edit_flag") ?? false;
      dcr_visitedWithList = mydata.get("dcr_visit_with_list")!;
      CauseForNonExecution = mydata.get("cause_for_non_execution")!;
      print('cause_for_non_execution:$CauseForNonExecution');
      logo_url_2 = databox.get('logo_url_2') ?? null;
      dropdownVisitWithValue = dcr_visitedWithList.first;
    });
    getDcrGitData();
    getDcrSampleData();
    getDcrPpmData();
    addedDcrGSPList = widget.draftOrderItem;
    setState(() {});
    if (widget.ck != '') {
      //selectedDeliveryTime = widget.selectedDeliveryTime;
      selectedDeliveryTime = widget.selectedDeliveryTime == "" ? null : widget.selectedDeliveryTime;
      jobRoleCtrl.text = widget.nonExcution;
      causeData = widget.nonExcution;
      visitedPersonController.text = widget.visitedPerson;
      if (jobRoleCtrl.text.isNotEmpty) {
        addedDcrGSPList.clear();
      }
      debugPrint("New Drtft Data *************** $selectedDeliveryTime");

      // if (widget.dVisitedWith.contains("|")) {
      //   visitedWithString = widget.dVisitedWith;
      //   drftVisitShow = widget.dVisitedWith.replaceAll("|", ",");
      //
      //   debugPrint(visitedWithString);
      // } else {
      //   visitedWithString = widget.dVisitedWith;
      //   drftVisitShow = visitedWithString;
      // }

      if (widget.dVisitedWith != null && widget.dVisitedWith.isNotEmpty) {
        visitedWithString = widget.dVisitedWith;
        if (visitedWithString.contains("|")) {
          drftVisitShow = visitedWithString.replaceAll("|", ",");
        } else {
          drftVisitShow = visitedWithString;
        }
      } else {
        visitedWithString = '';
        drftVisitShow = '';
      }

      noteController.text = widget.note;
      noteText = widget.note;

      int space = widget.image1.indexOf(" ");
      String removeSpace = widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');
      imagePath = File(finalImage);

      calculatingTotalitemString();
    } else {
      return;
    }
    if (widget.ck != '') {
      setState(() {
        _activeCounter = true;
      });

      int space = widget.image1.indexOf(" ");
      String removeSpace = widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');
      imagePath = File(finalImage);

      // finalDoctorList.add(RxDcrDataModel(
      //   uiqueKey: widget.uniqueId,
      //   docName: widget.docName,
      //   docId: widget.docId,
      //   areaId: widget.areaId,
      //   areaName: widget.areaName,
      //   address: widget.address,
      //   presImage: finalImage,
      //   dcrGrad: dropdownRxTypevalue,
      // ));
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    noteController.dispose();
    paymentfieldController.dispose();
    timefieldController.dispose();
    datefieldController.dispose();
    super.dispose();
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: const SingleChildScrollView(child: Column(children: <Widget>[Text('Are you sure to remove the Item?')])),
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

  _onItemTapped(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == 0) {
      if (imagePath != null || widget.image1 != '' || causeData.isNotEmpty) {
        await putAddedDcrGSPData(visitedWithString);
        Fluttertoast.showToast(
          msg: 'Save Drafts',
          // msg: 'Please Take Image and Select Medicine',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      } else {
        return Fluttertoast.showToast(
          msg: 'Please Select Image First',
          // msg: 'Please Take Image and Select Medicine',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      setState(() {
        _currentSelected = index;
      });

      print("xxxxxxx:$selectedDeliveryTime");
    } else {}

    // if (index == 1) {
    //   print('area page:$areaPage');
    //   //if (areaPage == false) {
    //     print('added dcr gsp list:$addedDcrGSPList');
    //     print('jobRoleCtrl:${jobRoleCtrl.text}');
    //     if (((imagePath != null || widget.image1 != '') &&
    //         (selectedDeliveryTime!.isNotEmpty && visitedPersonController.text.isNotEmpty && visitedWithString.isNotEmpty ))
    //         && ((selectedDeliveryTime!.isNotEmpty && visitedPersonController.text.isNotEmpty && visitedWithString.isNotEmpty ) &&
    //           (addedDcrGSPList.isNotEmpty || itemString.isNotEmpty || jobRoleCtrl.text != "" || causeData.isNotEmpty)) )
    //     {
    //       // setState(() {
    //       //   _isLoading = false;
    //       // });
    //       bool result = await NetworkConnecticity.checkConnectivity();
    //       if (result == true) {
    //         showDialog(
    //           context: context,
    //           builder: (context) => AlertDialog(
    //             title: const Text("Confirm"),
    //             content: const Text("Are you sure want to submit Visit?"),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   // User clicked No, so close the dialog
    //                   Navigator.of(context).pop(false);
    //                 },
    //                 child: const Text("No"),
    //               ),
    //               TextButton(
    //                 onPressed: () {
    //                   setState(() {
    //                     _isLoading = false;
    //                   });
    //                   //orderGSPSubmit(visitedWithString);
    //                   rxImageUpload();
    //                   Navigator.of(context).pop(true);
    //                 },
    //                 child: const Text("Yes"),
    //               ),
    //             ],
    //           ),
    //         );
    //       } else {
    //         _submitToastforOrder3();
    //         setState(() {
    //           _isLoading = true;
    //         });
    //         // debugPrint(InternetConnectionChecker().lastTryResults);
    //       }
    //     } else {
    //       // Fluttertoast.showToast(
    //       //     msg: 'Please add something',
    //       //     toastLength: Toast.LENGTH_LONG,
    //       //     gravity: ToastGravity.SNACKBAR,
    //       //     backgroundColor: Colors.red,
    //       //     textColor: Colors.white,
    //       //     fontSize: 16.0);
    //
    //       Fluttertoast.showToast(
    //           msg: 'Please Select Required Data',
    //           // msg: 'Please Take Image and Select Medicine',
    //           toastLength: Toast.LENGTH_LONG,
    //           gravity: ToastGravity.CENTER,
    //           backgroundColor: Colors.red,
    //           textColor: Colors.white,
    //           fontSize: 16.0);
    //     }
    //   // }
    //   // else {
    //   //   // setState(() {
    //   //   //   _isLoading = false;
    //   //   // });
    //   //   bool result = await NetworkConnecticity.checkConnectivity();
    //   //   if (result == true) {
    //   //     showDialog(
    //   //       context: context,
    //   //       builder: (context) => AlertDialog(
    //   //         title: const Text("Confirm"),
    //   //         content: const Text("Are you sure want to submit Doctor.?"),
    //   //         actions: [
    //   //           TextButton(
    //   //             onPressed: () {
    //   //               // User clicked No, so close the dialog
    //   //               Navigator.of(context).pop(false);
    //   //             },
    //   //             child: const Text("No"),
    //   //           ),
    //   //           TextButton(
    //   //             onPressed: () {
    //   //               setState(() {
    //   //                 _isLoading = false;
    //   //               });
    //   //               orderGSPSubmit(visitedWithString);
    //   //               Navigator.of(context).pop(true);
    //   //             },
    //   //             child: const Text("Yes"),
    //   //           ),
    //   //         ],
    //   //       ),
    //   //     );
    //   //   } else {
    //   //     _submitToastforOrder3();
    //   //     setState(() {
    //   //       _isLoading = true;
    //   //     });
    //   //     // debugPrint(InternetConnectionChecker().lastTryResults);
    //   //   }
    //   // }
    //
    //   setState(() {
    //     _currentSelected = index;
    //   });
    // }

    if (index == 1) {
      bool hasNonExecution = causeData.isNotEmpty;

      bool hasMinimalVisitInfo = hasNonExecution || ((imagePath != null || widget.image1 != '') && selectedDeliveryTime!.isNotEmpty && visitedPersonController.text.isNotEmpty);

      if (!hasMinimalVisitInfo) {
        Fluttertoast.showToast(msg: 'Please Select Required Data', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
        return;
      }

      bool result = await NetworkConnecticity.checkConnectivity();
      if (!result) {
        _submitToastforOrder3();
        setState(() => _isLoading = true);
        return;
      }

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to submit this Visit?"),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("No")),
                TextButton(
                  onPressed: () {
                    setState(() => _isLoading = false);

                    if (hasNonExecution) {
                      orderGSPSubmit(visitedWithString); // Non-execution path

                      print("Visite Submit Data");
                    }

                    rxImageUpload();

                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
      );

      setState(() => _currentSelected = index);
      return;
    }

    if (index == 2) {
      _cameraFuntionality();
      setState(() {
        _currentSelected2 = index;
      });
    }
  }

  // Future<void> _cameraFuntionality() async {
  //   setState(() {
  //     debugPrint('changebefore: $_isCameraClick');
  //     _isCameraClick = true;
  //     debugPrint('changeafter: $_isCameraClick');
  //   });
  //   file = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 85
  //
  //   );
  //   if (file != null) {
  //     debugPrint("file from cam ${file.toString()}");
  //     setState(() {
  //       file;
  //       imagePath = File(file!.path);
  //
  //     });
  //   }
  // }

  Future<void> _cameraFuntionality() async {
    setState(() {
      debugPrint('changebefore: $_isCameraClick');
      _isCameraClick = true;
      debugPrint('changeafter: $_isCameraClick');
    });

    //final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85,);
    file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      //preferredCameraDevice: CameraDevice.rear,
      // maxHeight: 800,
      // maxWidth: 700,
    );

    if (file != null) {
      // debugPrint("file from cam: ${pickedFile.path}");
      //
      // // Extract file extension dynamically (e.g., jpg, png)
      // final String extension = pickedFile.path.split('.').last;
      //
      // // Generate unique name with correct extension
      // final String fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

      setState(() {
        // file = pickedFile;
        // imagePath = File(pickedFile.path);
        // imageFileName = fileName;
        file;
        imagePath = File(file!.path);
        widget.image1 = '';
        debugPrint("image path from cam$imagePath");
      });

      debugPrint("Generated image file name: $imageFileName");
    } else {
      debugPrint("No image selected.");
    }
  }

  void _submitToastforOrder3() {
    Fluttertoast.showToast(msg: 'No Internet Connection\nPlease check your internet connection.', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print('image:${widget.image1}');
    print('file:${file.toString()}');
    return _isLoading
        ? Scaffold(
          resizeToAvoidBottomInset: false,
          key: _drawerKey,
          appBar: AppBar(
            backgroundColor: Colors.blue,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: const Text('Visit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20)),
            centerTitle: true,
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Column(
                    children: [
                      // logo_url_2 != null ?  CachedNetworkImage(
                      //   height: screenHeight*.11,
                      //   imageUrl: logo_url_2!,
                      //   errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                      // )
                      //     : Image.asset("assets/images/mRep7_logo.png"),
                      Image.asset('assets/images/c_logo_1.png', fit: BoxFit.contain, height: screenHeight * .10),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Text(
                                    widget.officeName,
                                    // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                                    style: const TextStyle(color: Color.fromARGB(255, 11, 22, 13), fontWeight: FontWeight.w500, fontSize: 20),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    widget.officeId,
                                    // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                                    style: const TextStyle(color: Color.fromARGB(255, 11, 22, 13), fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: ElevatedButton(
                //     onPressed: () async {
                //
                //       Navigator.pop(context);
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => Gift(
                //             docId: widget.officeId,
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     child: const Text(
                //       "Gift",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: ElevatedButton(
                //     onPressed: () async {
                //
                //       Navigator.pop(context);
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => Sample(
                //             docId: widget.officeId,
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     child: const Text(
                //       "Sample",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: ElevatedButton(
                //     onPressed: () async {
                //
                //       Navigator.pop(context);
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => PPM(
                //             docId: widget.officeId,
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     child: const Text(
                //       "PPM",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(child: Text("${widget.officeName} | ${widget.orgName}", style: const TextStyle(color: Color.fromARGB(255, 2, 3, 2), fontSize: 20, fontWeight: FontWeight.w500))),
                            const SizedBox(height: 5.0),
                            FittedBox(child: Text("${widget.areaName} | ${widget.areaId} | ${widget.category}", style: const TextStyle(color: Color.fromARGB(255, 5, 10, 6), fontSize: 14))),
                            const SizedBox(height: 3),
                            // Text(
                            //   "Phn Num: ${widget.phnNum}",
                            //   style: const TextStyle(
                            //       color:
                            //       Color.fromARGB(255, 5, 10, 6),
                            //       fontSize: 14),
                            // ),
                            GestureDetector(
                              onTap: () async {
                                final Uri phoneUri = Uri(scheme: 'tel', path: "${widget.phnNum}");
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot launch phone dialer')));
                                }
                              },
                              child: Text("${widget.phnNum}", style: const TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Row(
                      children: [
                        const Text('Non Execution:', style: TextStyle(fontSize: 16, color: Colors.black)),
                        const SizedBox(width: 5),
                        // Stack(
                        //   children:[
                        SizedBox(
                          height: 28,
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                            hint: const Text("", style: TextStyle(fontSize: 14, color: Colors.black)),
                            value: causeData.isEmpty ? null : causeData,
                            items:
                                CauseForNonExecution.map((value) {
                                  return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14)));
                                }).toList(),
                            onChanged: (value) {
                              if (value == null) return;

                              if (addedDcrGSPList.isNotEmpty) {
                                customDialog(
                                  title: "Confirmation",
                                  content: "If you select non-execution the added item will be cleared",
                                  cancelOnTap: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      jobRoleCtrl.clear();
                                      causeData = '';
                                    });
                                  },
                                  confirmOnTap: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      causeData = value;
                                      addedDcrGSPList.clear();
                                    });
                                  },
                                );
                              } else {
                                setState(() {
                                  causeData = value;
                                  addedDcrGSPList.clear();
                                });
                              }

                              debugPrint("developer select xxxx $causeData");
                              debugPrint("developer select list ${jobRoleCtrl.text}");
                            },
                          ),
                        ),
                        //     const Positioned(
                        //       top: 8,
                        //       right: 30,
                        //       child: Icon(Icons.star_sharp, color: Colors.red, size: 12),
                        //     ),
                        //   ]
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: [
                        Container(
                          height: screenHeight / 5,
                          // width: screenWidth / 1.8,
                          //height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            //color: Colors.grey,
                            border: Border.all(color: Colors.black),
                          ),
                          child:
                              widget.image1 != ''
                                  ? InkWell(
                                    onDoubleTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomForRxDraftImage(finalImage)));
                                    },
                                    child: Hero(tag: "imageForDraft", child: Image.file(width: double.infinity, fit: BoxFit.cover, File(finalImage))),
                                  )
                                  : file == null
                                  ? Column(children: [Expanded(flex: 4, child: Image.asset('assets/images/default_document.png', fit: BoxFit.cover)), Expanded(child: Container(width: screenWidth / 1.8, color: Colors.white, child: const Center(child: Text("Double tap to zoom", style: TextStyle(fontSize: 18)))))])
                                  : InkWell(
                                    onDoubleTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomForRxImage(imagePath)));
                                    },
                                    child: Hero(tag: "img", child: Image.file(width: double.infinity, fit: BoxFit.cover, imagePath!)),
                                  ),
                        ),
                        const Positioned(top: 16, right: 20, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    //padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Expanded(flex: 3, child: Text("Visited With", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16))),
                        dcr_visitedWithList.isNotEmpty
                            ?
                            // Expanded(
                            //         flex: 5,
                            //         child: FittedBox(
                            //           fit: BoxFit.scaleDown,
                            //           child: SizedBox(
                            //             width: 170,
                            //             child: GFMultiSelect(
                            //               color: Colors.white,
                            //               size: 20,
                            //
                            //               items: dcr_visitedWithList,
                            //               onSelect: (value) {
                            //                 // dcrString = '';
                            //                 if (value.isNotEmpty) {
                            //                   for (var e in value) {
                            //                     if (dcrString == '') {
                            //                       dcrString = dcr_visitedWithList[e];
                            //                     } else {
                            //                       dcrString +=
                            //                           '|${dcr_visitedWithList[e]}';
                            //                     }
                            //                   }
                            //                 }
                            //
                            //                 setState(() {
                            //                   visitedWithString = '';
                            //
                            //                   visitedWithString = dcrString;
                            //                 });
                            //
                            //                 debugPrint('selected $value ');
                            //                 debugPrint(dcrString);
                            //               },
                            //               cancelButton: cancalButton(),
                            //               dropdownTitleTileText: drftVisitShow,
                            //               dropdownTitleTileMargin: EdgeInsets.zero,
                            //               dropdownTitleTilePadding:
                            //                   const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            //               dropdownUnderlineBorder: const BorderSide(
                            //                   color: Colors.transparent, width: 0.5),
                            //               dropdownTitleTileBorder: Border.all(
                            //                   color: Colors.grey, width: 0.5),
                            //               expandedIcon: const Icon(
                            //                 Icons.keyboard_arrow_down,
                            //                 color: Colors.black54,
                            //               ),
                            //               collapsedIcon: const Icon(
                            //                 Icons.keyboard_arrow_up,
                            //                 color: Colors.black54,
                            //               ),
                            //               padding: const EdgeInsets.all(0),
                            //               margin: const EdgeInsets.all(0),
                            //               type: GFCheckboxType.circle,
                            //               activeBgColor: Colors.green.withOpacity(0.5),
                            //               inactiveBorderColor: Colors.grey,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            Expanded(
                              flex: 5,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: 170,
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () async {
                                      List<int> tempSelected = List.from(selectedVisitedIndexes);
                                      final result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setStateDialog) {
                                              return AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children:
                                                        dcr_visitedWithList.asMap().entries.map((entry) {
                                                          final index = entry.key;
                                                          final value = entry.value;
                                                          return CheckboxListTile(
                                                            checkboxShape: const CircleBorder(),
                                                            checkColor: Colors.white,
                                                            activeColor: Colors.green.withOpacity(0.5),

                                                            value: tempSelected.contains(index),
                                                            title: Text(value),
                                                            onChanged: (bool? selected) {
                                                              setStateDialog(() {
                                                                if (selected == true) {
                                                                  tempSelected.add(index);
                                                                } else {
                                                                  tempSelected.remove(index);
                                                                }
                                                              });
                                                            },
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                                actions: [TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(context, tempSelected), child: const Text('OK'))],
                                              );
                                            },
                                          );
                                        },
                                      );

                                      if (result != null) {
                                        setState(() {
                                          selectedVisitedIndexes = result;
                                          dcrString = result
                                              .map((i) {
                                                return dcr_visitedWithList[i];
                                              })
                                              .join(',');
                                          visitedWithString = dcrString;
                                        });
                                        debugPrint('selected $result');
                                        debugPrint("dcr string:$dcrString");
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(4)),
                                      child: Row(children: [Expanded(child: Text(visitedWithString.isEmpty ? drftVisitShow : visitedWithString, overflow: TextOverflow.ellipsis)), const Icon(Icons.keyboard_arrow_down, color: Colors.black54)]),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(4)),
                            child: Stack(
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDeliveryTime,
                                    isExpanded: true,
                                    items:
                                        deliveryTime.map((String item) {
                                          return DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(fontSize: 14)));
                                        }).toList(),
                                    onChanged:
                                        (item) => setState(() {
                                          selectedDeliveryTime = item.toString();
                                          print('selectedDeliveryTime:$selectedDeliveryTime');
                                        }),
                                  ),
                                ),
                                const Positioned(top: 6, right: 20, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    //padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      // height: 55,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.5)),

                        // elevation: 6,
                        child: TextFormField(
                          maxLength: 50,
                          minLines: 1,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'))],
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                          controller: noteController,
                          decoration: const InputDecoration(counterText: "", border: OutlineInputBorder(borderSide: BorderSide.none), labelText: '   Feedback/Note/Place of Work', labelStyle: TextStyle(color: Colors.blueGrey)),
                          onChanged: (value) {
                            setState(() {
                              noteText = noteController.text;
                              print('note::$noteText');
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Text('Visited Person:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)),
                        const SizedBox(width: 5),
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 28,
                              child: TextField(
                                controller: visitedPersonController,
                                onChanged: (value) {
                                  print('visitedPersonController:${visitedPersonController.text}');
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.black)),
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const Positioned(top: 8, right: 5, child: Icon(Icons.star_sharp, color: Colors.red, size: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Doctor Gift section..................................
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addedDcrGSPList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext itemBuilder, index) {
                          return Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white70, width: 1), borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(child: Text(addedDcrGSPList[index].giftName, style: const TextStyle(color: Color.fromARGB(255, 9, 38, 61), fontWeight: FontWeight.w400, fontSize: 16))),
                                                // Text(
                                                //   '(${addedDcrGSPList[index].giftType})',
                                                //   style: const TextStyle(
                                                //       fontSize: 16),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              _showMyDialog(index);
                                            },
                                            icon: const Icon(Icons.clear, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          addedDcrGSPList[index].giftType != "Discussion" ? Row(children: [const Text('Qt:  ', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 9, 38, 61))), Text(addedDcrGSPList[index].quantity.toString(), style: const TextStyle(color: Color.fromARGB(255, 9, 38, 61), fontSize: 16, fontWeight: FontWeight.bold))]) : const Text(""),
                                          const Spacer(),
                                          Row(children: [Text('(${addedDcrGSPList[index].giftType})', style: const TextStyle(color: Color.fromARGB(255, 9, 38, 61), fontSize: 16))]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  causeData.isNotEmpty || jobRoleCtrl.text.isNotEmpty
                      ? const SizedBox()
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              //  getDcrGitData();

                              FocusManager.instance.primaryFocus?.unfocus();
                              if (isGiftLoading) {
                                Fluttertoast.showToast(msg: 'Gift data is still loading...', backgroundColor: Colors.black);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DcrGiftDataPage(
                                        uniqueId: widget.uniqueId,
                                        doctorGiftlist: doctorGiftlist,
                                        tempList: addedDcrGSPList,
                                        tempListFunc: (value) {
                                          setState(() {
                                            addedDcrGSPList = value;
                                            calculatingTotalitemString();
                                          });
                                        },
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 18,
                              width: screenWidth / 4,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.teal),
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // isGiftLoading? const CircularProgressIndicator(
                                      //   color:  Colors.white,
                                      // ):
                                      const Text('Gift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // getDcrSampleData();

                              FocusManager.instance.primaryFocus?.unfocus();
                              if (isSampleLoading) {
                                Fluttertoast.showToast(msg: 'Sample data is still loading...', backgroundColor: Colors.black);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DcrSampleDataPage(
                                        uniqueId: widget.uniqueId,
                                        doctorSamplelist: doctorSamplelist,
                                        tempList: addedDcrGSPList,
                                        tempListFunc: (value) {
                                          setState(() {
                                            addedDcrGSPList = value;
                                            calculatingTotalitemString();
                                          });
                                        },
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 18,
                              width: screenWidth / 4,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.teal),
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // isSampleLoading? const CircularProgressIndicator(
                                      //   color:  Colors.white,
                                      // ):
                                      const Text('Sample', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // ElevatedButton(
                          //   onPressed: () {
                          //     FocusManager.instance.primaryFocus
                          //         ?.unfocus();
                          //     getDcrPpmData();
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     fixedSize: Size(
                          //         screenWidth / 4,
                          //         MediaQuery.of(context).size.height /
                          //             18), backgroundColor: const Color.fromARGB(
                          //         255, 138, 201, 149),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   child: const FittedBox(
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           'PPM',
                          //           style: TextStyle(
                          //               color: Color.fromARGB(255, 9, 19, 11),
                          //               fontWeight: FontWeight.w500,
                          //               fontSize: 16),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              //  getDcrPpmData();

                              FocusManager.instance.primaryFocus?.unfocus();
                              if (isPPMLoading) {
                                Fluttertoast.showToast(msg: 'PPM data is still loading...', backgroundColor: Colors.black);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DcrPpmDataPage(
                                        uniqueId: widget.uniqueId,
                                        doctorPpmlist: doctorPpmlist,
                                        tempList: addedDcrGSPList,
                                        tempListFunc: (value) {
                                          setState(() {
                                            addedDcrGSPList = value;
                                            calculatingTotalitemString();
                                          });
                                        },
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 18,
                              width: screenWidth / 4,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.teal),
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // isPPMLoading? const CircularProgressIndicator(
                                      //   color:  Colors.white,
                                      // ):
                                      const Text('PPM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          dcr_discussion == true
                              ? GestureDetector(
                                onTap: () {
                                  getDcrDiscussionData();
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 18,
                                  width: screenWidth / 4,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.teal),
                                  child: const Center(
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Icon(Icons.add,
                                          //     color: Colors.white),
                                          // SizedBox(width: 5),
                                          Text('Discuss', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            currentIndex: _currentSelected,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey[800],
            selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[BottomNavigationBarItem(label: 'Save Drafts', icon: Icon(Icons.drafts)), BottomNavigationBarItem(label: 'Submit', icon: Icon(Icons.save)), BottomNavigationBarItem(label: 'Camera', icon: Icon(Icons.camera_alt_outlined))],
          ),
        )
        : Container(padding: const EdgeInsets.all(100), color: Colors.white, child: const Center(child: CircularProgressIndicator()));
  }

  // getDcrGitData() async {
  //   // await giftOpenBox();
  //
  //   if (isGiftSync == true) {
  //     var mymap = Hive.box('dcrGiftListData').values.toList();
  //
  //     if (mymap.isEmpty) {
  //       Fluttertoast.showToast(
  //           msg: "No Gift Found", backgroundColor: Colors.red);
  //       doctorGiftlist.add('empty');
  //     } else {
  //       doctorGiftlist = mymap;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DcrGiftDataPage(
  //             uniqueId: widget.uniqueId,
  //             doctorGiftlist: doctorGiftlist,
  //             tempList: addedDcrGSPList,
  //             tempListFunc: (value) {
  //               addedDcrGSPList = value;
  //               calculatingTotalitemString();
  //
  //               setState(() {});
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: 'Please sync gift',
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  Future<void> getDcrGitData() async {
    setState(() {
      isGiftLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword",
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword"
        ),
      );
      print(
        'API URL for getDcrGitData: '
        //'http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword'
        "${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword",
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponseData = jsonDecode(response.body);
        Map<String, dynamic> resData = jsonResponseData['res_data'];

        if (resData['giftList'] != null && resData['giftList'].isNotEmpty) {
          setState(() {
            doctorGiftlist = resData['giftList'];
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => DcrGiftDataPage(
          //       uniqueId:widget.uniqueId,
          //       doctorGiftlist: doctorGiftlist,
          //       tempList: addedDcrGSPList,
          //       tempListFunc: (value) {
          //         setState(() {
          //           addedDcrGSPList = value;
          //           calculatingTotalitemString();
          //         });
          //       },
          //     ),
          //   ),
          // );
        } else {
          Fluttertoast.showToast(msg: "No Gift Found from API", backgroundColor: Colors.red);
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to load gift data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching gift data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      debugPrint("Error in getDcrGitData: $e");
    }
    setState(() {
      isGiftLoading = false;
    });
  }

  // getDcrSampleData() async {
  //   // await sampleOpenBox();
  //
  //   if (isSampleSync == true) {
  //     var mymap = Hive.box('dcrSampleListData').values.toList();
  //
  //     if (mymap.isEmpty) {
  //       debugPrint('empty Sample');
  //       Fluttertoast.showToast(
  //           msg: "No Sample Found", backgroundColor: Colors.red);
  //       doctorSamplelist.add('empty');
  //     } else {
  //       doctorSamplelist = mymap;
  //
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DcrSampleDataPage(
  //             uniqueId: widget.uniqueId,
  //             doctorSamplelist: doctorSamplelist,
  //             tempList: addedDcrGSPList,
  //             tempListFunc: (value) {
  //               addedDcrGSPList = value;
  //               calculatingTotalitemString();
  //
  //               setState(() {});
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: 'Please sync Sample',
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  Future<void> getDcrSampleData() async {
    setState(() {
      isSampleLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword"
          "${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword",
        ),
      );
      print(
        'API URL for getDcrSampleData: '
        //'http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword'
        "${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword",
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponseData = jsonDecode(response.body);
        Map<String, dynamic> resData = jsonResponseData['res_data'];

        if (resData['sampleList'] != null && resData['sampleList'].isNotEmpty) {
          setState(() {
            doctorSamplelist = resData['sampleList'];
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => DcrSampleDataPage(
          //       uniqueId: widget.uniqueId,
          //       doctorSamplelist: doctorSamplelist,
          //       tempList: addedDcrGSPList,
          //       tempListFunc: (value) {
          //         setState(() {
          //           addedDcrGSPList = value;
          //            calculatingTotalitemString();
          //         });
          //       },
          //     ),
          //   ),
          // );
        } else {
          Fluttertoast.showToast(msg: "No Sample Found from API", backgroundColor: Colors.red);
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to load sample data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching sample data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      debugPrint("Error in getDcrSampleData: $e");
    }
    setState(() {
      isSampleLoading = false;
    });
  }

  // getDcrPpmData() async {
  //   // await ppmOpenBox();
  //
  //   if (isPPMSync == true) {
  //     var mymap = Hive.box('dcrPpmListData').values.toList();
  //
  //     if (mymap.isEmpty) {
  //       Fluttertoast.showToast(
  //           msg: "No PPM Found", backgroundColor: Colors.red);
  //       doctorPpmlist.add('empty');
  //     } else {
  //       doctorPpmlist = mymap;
  //
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DcrPpmDataPage(
  //             uniqueId: widget.uniqueId,
  //             doctorPpmlist: doctorPpmlist,
  //             tempList: addedDcrGSPList,
  //             tempListFunc: (value) {
  //               addedDcrGSPList = value;
  //               calculatingTotalitemString();
  //
  //               setState(() {});
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: 'Please sync PPM',
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  Future<void> getDcrPpmData() async {
    setState(() {
      isPPMLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword"
          "${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword",
        ),
      );
      print(
        'API URL for getDcrPpmData: '
        //'http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword'
        "${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword",
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponseData = jsonDecode(response.body);
        Map<String, dynamic> resData = jsonResponseData['res_data'];

        if (resData['ppmList'] != null && resData['ppmList'].isNotEmpty) {
          setState(() {
            doctorPpmlist = resData['ppmList'];
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => DcrPpmDataPage(
          //       uniqueId: widget.uniqueId,
          //       doctorPpmlist: doctorPpmlist,
          //       tempList: addedDcrGSPList,
          //       tempListFunc: (value) {
          //         setState(() {
          //           addedDcrGSPList = value;
          //           calculatingTotalitemString();
          //         });
          //       },
          //     ),
          //   ),
          // );
        } else {
          Fluttertoast.showToast(msg: "No PPM Found from API", backgroundColor: Colors.red);
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to load PPM data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching PPM data.', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      debugPrint("Error in getDcrPpmData: $e");
    }
    setState(() {
      isPPMLoading = false;
    });
  }

  getDcrDiscussionData() async {
    // await discussionOpenBox();

    var mymap = Hive.box('syncItemData').values.toList();

    if (mymap.isEmpty) {
      Fluttertoast.showToast(msg: "No Discussion Found", backgroundColor: Colors.red);
      doctorDiscussionlist.add('empty');
    } else {
      doctorDiscussionlist = mymap;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => DcrDiscussionPage(
                uniqueId: widget.uniqueId,
                doctorDiscussionlist: doctorDiscussionlist,
                tempList: addedDcrGSPList,
                tempListFunc: (value) {
                  addedDcrGSPList = value;
                  calculatingTotalitemString();

                  setState(() {});
                },
              ),
        ),
      );
    }
  }

  calculatingTotalitemString() {
    itemString = '';
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
      itemString = newString;
    });
    print('ItemString updated: $itemString');
  }

  cancalButton() {
    dcrString = "";
  }

  submButton() {
    if (dcrString.contains("|")) {
      newString = dcrString.replaceAll(",", "|");
      debugPrint(newString);
    }
    Navigator.pop(context);
  }

  Future addedSampleOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('addedDcrSampletData');
  }

  Future putAddedDcrGSPData(String visitewith) async {
    List<DcrDataModel> doctorList = [];

    if (widget.ck != '') {
      for (int i = 0; i <= addedDcrGSPList.length; i++) {
        deleteDcrGSPItem(widget.dcrKey);

        setState(() {});
      }

      setState(() {});

      Navigator.pop(context);

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
      for (var dcr in doctorList) {
        final box = Boxes.dcrUsers();
        box.add(dcr);
      }

      final box1 = Boxes.dcrUsers();
      final box = Boxes.dcrUsers().toMap();
      box.forEach((key, value) {
        if (value.uiqueKey == widget.uniqueId) {
          box1.put(
            key,
            DcrDataModel(
              uiqueKey: value.uiqueKey,
              docName: value.docName,
              docId: value.docId,
              areaId: value.areaId,
              areaName: value.areaName,
              address: 'address',
              visitedWith: visitewith,
              note: noteText,
              non_Excution: causeData,
              shift: selectedDeliveryTime,
              image: imagePath.toString(),
              visitedPerson: visitedPersonController.text,
              organizationName: value.organizationName,
              phoneNum: value.phoneNum,
              brandId: value.brandId,
              category: value.category,
            ),
          );
        }
      });
    } else {
      debugPrint("visted with string in dcr $visitewith");
      var doctor = DcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.officeName,
        docId: widget.officeId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: 'address',
        visitedWith: visitewith,
        note: noteText,
        non_Excution: causeData,
        shift: selectedDeliveryTime,
        image: imagePath.toString(),
        visitedPerson: visitedPersonController.text,
        organizationName: widget.orgName,
        phoneNum: widget.phnNum.toInt(),
        brandId: widget.brandId,
        category: widget.category,
      );
      doctorList.add(doctor);

      for (var dcr in doctorList) {
        final box = Boxes.dcrUsers();
        box.add(dcr);
      }

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
    }
  }

  deleteDcrGSPItem(int id) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteDoctor(int id) {
    final box = Hive.box<DcrDataModel>("selectedDcr");

    final Map<dynamic, DcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

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

  Future<dynamic> rxImageUpload() async {
    setState(() {
      _isLoading = false;
    });

    // final compressfileForImage = await compressFile(imagePath!);

    var dt = DateFormat('HH:mm:ss').format(DateTime.now());
    calculatingTotalitemString();

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
        //rxSubmit(fileName);
        orderGSPSubmit(fileName);
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
        //rxSubmit(fileName);
        orderGSPSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image submit Failed'), backgroundColor: Colors.red));
      }
    }
  }

  Future<dynamic> orderGSPSubmit(String fileName) async {
    print('Submitting with itemString: $itemString');
    print('Submitting with jobRoleCtrl.text: ${jobRoleCtrl.text}');
    //print('VisitedWith String: $visitedwith');
    debugPrint('image name from orderGSPSubmit: $fileName');

    String address = '';
    double lat = 0.0;
    double long = 0.0;

    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);

        setState(() {
          address = "${placemarks[0].street!} ${placemarks[0].country!}";
          lat = position.latitude;
          long = position.longitude;
        });
      }
    } on Exception catch (e) {
      debugPrint("Exception geolocator section: $e");
    }

    String a = '${submit_url}api_visit_submit/submit_data';
    debugPrint(a);

    debugPrint(
      "visit submit url: ${submit_url}api_visit_submit/submit_data?"
      "cid=$cid&"
      "user_id=$userId&"
      "user_pass=$userPassword&"
      "device_id=$deviceId&"
      "office_id=${widget.officeId}&"
      "branch_id=${widget.areaId}&"
      "non_execution=$causeData&"
      //"image_name=$imageFileName&"
      "image_name=$fileName&"
      "visit_with=$dcrString&"
      "shift=$selectedDeliveryTime&"
      "feedback=$noteText&"
      "visited_person=${visitedPersonController.text}&"
      "item_list_gsp=${jobRoleCtrl.text.isEmpty ? itemString : ''}&"
      "latitude=${(minLatitude <= lat && lat <= maxLatitude) ? lat : ''}&"
      "longitude=${(minLongitude <= long && long <= maxLongitude) ? long : ''}&"
      //"location_detail=${((minLatitude <= lat && lat <= maxLatitude) && (minLongitude <= long && long <= maxLongitude)) ? address : ''}&"
      "app_version=$appVersion",
    );

    try {
      final Map<String, dynamic> body = {
        'cid': cid,
        'user_id': userId,
        'user_pass': userPassword,
        'device_id': deviceId,
        'office_id': widget.officeId,
        'branch_id': widget.areaId,
        'non_execution': causeData,
        //'image_name':imageFileName,
        'image_name': fileName,
        'visit_with': dcrString,
        "shift": selectedDeliveryTime,
        "feedback": noteText,
        'visited_person': visitedPersonController.text,
        "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
        'longitude': (minLongitude <= long && long <= maxLongitude) ? long : '',
        // 'location_detail': ((minLatitude <= lat && lat <= maxLatitude) &&
        //         (minLongitude <= long && long <= maxLongitude))
        //     ? address
        //     : '',
        "item_list_gsp": jobRoleCtrl.text.isEmpty ? itemString : '',
        //"causeExcucution": jobRoleCtrl.text,
        'app_version': appVersion,
      };
      final http.Response response = await http.post(
        //Uri.parse('http://192.168.100.219:8000/physician_api/api_visit_submit/submit_data'),
        Uri.parse('${submit_url}api_visit_submit/submit_data'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
        // body: jsonEncode(
        //   <String, dynamic>{
        //     'cid': cid,
        //     'user_id': userId,
        //     'user_pass': userPassword,
        //     'device_id': deviceId,
        //     'office_id': widget.officeId,
        //     'branch_id': widget.areaId,
        //     'non_execution':causeData,
        //     //'image_name':imageFileName,
        //     'image_name':fileName,
        //     'visit_with': dcrString,
        //     "shift": selectedDeliveryTime,
        //     "feedback": noteText,
        //     'visited_person':visitedPersonController.text,
        //     "latitude": (minLatitude <= lat && lat <= maxLatitude) ? lat : '',
        //     'longitude':
        //         (minLongitude <= long && long <= maxLongitude) ? long : '',
        //     // 'location_detail': ((minLatitude <= lat && lat <= maxLatitude) &&
        //     //         (minLongitude <= long && long <= maxLongitude))
        //     //     ? address
        //     //     : '',
        //     "item_list_gsp": jobRoleCtrl.text.isEmpty ? itemString : '',
        //     //"causeExcucution": jobRoleCtrl.text,
        //     'app_version': appVersion,
        //   },
        // ),
      );

      var orderInfo = json.decode(response.body);

      print("Submit Body : $body");
      print("--------------------${orderInfo}");
      String status = orderInfo['status'];
      var ret_str = orderInfo['ret_str'];
      print('submit success:$ret_str');

      if (status == "Success") {
        for (int i = 0; i <= addedDcrGSPList.length; i++) {
          deleteDcrGSPItem(widget.dcrKey);

          setState(() {});
        }

        deleteDoctor(widget.dcrKey);

        setState(() {
          _isLoading = true;
        });

        addedDcrGSPList.clear();
        //  _submitToastforOrder(ret_str);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visited Submit Succesfully! $ret_str'), backgroundColor: Colors.green));
        print('Visited Submit Succesfully $ret_str');

        Navigator.of(context).pop();
      } else if (orderInfo['ret_str'].toString().toLowerCase().contains('http') && status == 'Failed') {
        String update_app_url = '';
        String update_app_notification = '';

        if (orderInfo['ret_str'].toString().contains('http')) {
          int index = orderInfo['ret_str'].toString().indexOf("http");

          update_app_notification = orderInfo['ret_str'].toString().substring(0, index).trim() ?? '';
          update_app_url = orderInfo['ret_str'].toString().substring(index).trim() ?? '';
          await databox.put('update_new_app', update_app_notification);
          await databox.put('update_new_app_url', update_app_url);
        }

        AllServices().messageForUser(orderInfo['ret_str']);
        setState(() {
          _isLoading = true;
        });

        if (update_app_url != null || update_app_url != '') {
          AllServices().showMap(update_app_url);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${orderInfo['ret_str']}'), backgroundColor: Colors.red));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
      print('errorrrr:$e');
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(msg: "Visit Submitted\n$ret_str", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, backgroundColor: Colors.green.shade900, textColor: Colors.white, fontSize: 16.0);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
