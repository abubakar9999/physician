// ignore_for_file: non_constant_identifier_names, avoid_print, file_names, must_be_immutable, deprecated_member_use, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../../core/constant.dart';
import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/datasources/local_storage/hive_data_model.dart';
import '../../../data/service/all_service.dart';
import '../../../data/service/network_connectivity.dart';
import '../../../main.dart';
import '../homePage.dart';
import '../loginPage.dart';
import 'last_invoice_page.dart';
import 'last_order_page.dart';
import 'order_item_list.dart';
import 'outstanding_page.dart';

class NewOrderPage extends StatefulWidget {
  int ckey;
  String clientName;
  String marketName;
  String clientId;
  int uniqueId;
  String deliveryTime;
  String deliveryDate;
  String collectionDate;
  String paymentMethod;
  String? outStanding;
  String? offer;
  String? note;
  String areaId;
  String areaName;

  List<AddItemModel> draftOrderItem;
  NewOrderPage({
    Key? key,
    required this.ckey,
    required this.uniqueId,
    required this.draftOrderItem,
    required this.clientName,
    required this.clientId,
    this.outStanding,
    required this.deliveryDate,
    required this.collectionDate,
    required this.deliveryTime,
    required this.paymentMethod,
    this.offer,
    this.note,
    required this.marketName,
    required this.areaId,
    required this.areaName,
  }) : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final List<TextEditingController> _itemController = [];
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String selectedDeliveryDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedCollectionDate =
  DateFormat('yyyy-MM-dd').format(DateTime.now());

  String userName = '';
  String user_id = '';

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isSaved = false;
  bool isSaved2 = false;

  List<AddItemModel> finalItemDataList = [];
  List<CustomerDataModel> orderCustomerList = [];
  List<CustomerDataModel> customerdatalist = [];
  bool isItemSync = false;

  //! Box? box;

  List syncItemList = [];
  List<String> deliveryTime = ['Morning', 'Evening'];
  String selectedDeliveryTime = 'Morning';
  List<String> payMethod = ['CASH', 'CREDIT'];
  List<String> offer = ['_', 'Priority', 'Flex'];
  String slectedPayMethod = 'CASH';
  String initialOffer = '_';
  DateTime deliveryDate = DateTime.now();
  bool dr = false;
  double orderAmount = 0;
  double totalAmount = 0;
  double unitPrice = 0;
  double vat = 0;
  double total = 0;
  String submit_url = '';
  String client_edit_url = '';
  String client_outst_url = '';
  // String repOutsUrl = '';
  // String repLastOrdUrl = '';
  // String repLastInvUrl = '';
  String noteText = '';
  String? cid;
  String? userId;
  String? userPassword;
  // bool offer_flag = false;
  // bool note_flag = false;
  // bool client_edit_flag = false;
  // bool os_show_flag = false;
  // bool os_details_flag = false;
  // bool ord_history_flag = false;
  // bool inv_histroy_flag = false;
  var body = "";
  var resultofOuts = "";
  String itemString = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  Map<String, TextEditingController> controllers = {};
  // String? logo_url_1;
  String? logo_url_2;

  bool _isLoading = true;
  var formatter = NumberFormat.currency(
    // locale: "",
      decimalDigits: 2,
      symbol: "");
  final databox = Boxes.allData();

  @override
  void initState() {
    super.initState();   // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugPrint("Rebuilding...3");
    //
    //   final RenderBox renderBox =
    //   _bottomNavBarKey.currentContext!.findRenderObject() as RenderBox;
    //   setState(() {
    //     bottomNavbarHeight = renderBox.size.height;
    //   });
    // });

    if (mounted) {
      getLatLong();
      setState(() {
        isItemSync = mydatabox.get('isItemSync') ?? false;
        client_outst_url = databox.get("client_outst_url") ?? "";
        submit_url = databox.get("submit_url");
        client_edit_url = databox.get("client_edit_url")!;

        cid = databox.get("CID");
        userId = databox.get("USER_ID");
        userPassword = databox.get("PASSWORD");
        userName = databox.get("userName")!;
        user_id = databox.get("user_id")!;
        offer_flag = databox.get("offer_flag")!;
        note_flag = databox.get("note_flag")!;
        client_edit_flag = databox.get("client_edit_flag")!;
        os_show_flag = databox.get("os_show_flag")!;
        os_details_flag = databox.get("os_details_flag")!;
        ord_history_flag = databox.get("ord_history_flag")!;
        inv_histroy_flag = databox.get("inv_histroy_flag")!;
        latitude = databox.get("latitude");
        longitude = databox.get("longitude")!;
        deviceId = databox.get("deviceId");
        deviceBrand = databox.get("deviceBrand");
        deviceModel = databox.get("deviceModel");
        // logo_url_1 = databox.get('logo_url_1') ?? null;
        logo_url_2 = databox.get('logo_url_2') ?? null;
        // logo_url_2 = "";
        // repOutsUrl = databox.get("report_outst_url") ?? "";
        // repLastOrdUrl = databox.get("report_last_ord_url") ?? "";
        // repLastInvUrl = databox.get("report_last_inv_url") ?? "";
        print(latitude);
        print(longitude);
      });

      tempCount = widget.draftOrderItem.length;
      finalItemDataList = widget.draftOrderItem;

      if (widget.draftOrderItem.isNotEmpty) {
        for (var element in finalItemDataList) {
          controllers[element.item_id] = TextEditingController();
          controllers[element.item_id]?.text = element.quantity.toString();
        }
      }

      var box = Boxes.getCustomerUsers();
      orderCustomerList = box.toMap().values.toList().cast<CustomerDataModel>();

      if (widget.deliveryDate != '' && widget.deliveryTime != '') {
        selectedDeliveryTime = widget.deliveryTime;
        selectedDeliveryDate = widget.deliveryDate;
        selectedCollectionDate = widget.collectionDate;
        slectedPayMethod = widget.paymentMethod;
        noteController.text = widget.note ?? '';
        initialOffer = widget.offer ?? 'Offer';
        ordertotalAmount();
      } else {
        return;
      }
      setState(() {});
    }

    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    noteController.dispose();
    _itemController.map((element) {
      element.dispose();
    });

    super.dispose();
  }

  getLatLong() {
    Future<Position> data = AllServices().determinePosition();
    data.then((value) {
      // debugPrint("value $value");
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;

        databox.put("latitude", latitude);
        databox.put("longitude", longitude);
      });
    }).catchError((error) {
      // debugPrint("Error $error");
    });
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  double totalCount(AddItemModel model) {
    double total = (model.tp + model.vat) * model.quantity;
    return total;
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure to remove the Item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (widget.deliveryDate != '') {
                  final uniqueKey = widget.ckey;
                  deleteSingleOrderItem(uniqueKey, index);
                  ordertotalAmount();

                  setState(() {});
                } else {
                  finalItemDataList.removeAt(index);
                  ordertotalAmount();
                  setState(() {});
                }

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteSingleOrderItem(int dcrUniqueKey, int index) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == dcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    finalItemDataList.removeAt(index);

    setState(() {});
  }

  int _currentSelected = 2;
  final GlobalKey _bottomNavBarKey = GlobalKey();
  double bottomNavbarHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuilding...1");
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    debugPrint("Rebuilding...2");
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugPrint("Rebuilding...3");
    //
    //   final RenderBox renderBox =
    //       _bottomNavBarKey.currentContext!.findRenderObject() as RenderBox;
    //   setState(() {
    //     bottomNavbarHeight = renderBox.size.height;
    //   });
    // });
    // debugPrint("Rebuilding...4");
print('is loading:$_isLoading');

    return _isLoading
        ? Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Order Cart',
        ),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 138, 201, 149),
              ),
              child: Column(
                children: [

                  // logo_url_2 != null ?  CachedNetworkImage(
                  //   height: screenHeight*.11,
                  //   imageUrl: logo_url_2!,
                  //   errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                  // )
                  //     : Image.asset("assets/images/mRep7_logo.png"),
                  // Image.asset('assets/images/mRep7_logo.png'),
                  Image.asset('assets/images/c_logo_1.png',fit: BoxFit.contain,height: screenHeight*.075,),
                  SizedBox(height: 8,),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        widget.clientName,
                        // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 11, 22, 13),
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(widget.clientId,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 11, 22, 13),
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                  )
                ],
              ),
            ),
            // ListTile(
            //   leading:
            //       const Icon(Icons.sync_outlined, color: Colors.black),
            //   title: const Text('Outstanding'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.document_scanner_outlined,
            //       color: Colors.black),
            //   title: const Text('Report'),
            //   onTap: () {
            //     // Update the state of the app.
            //   },
            // ),
            // const Center(child: Text("SHOW OUTSTANDING")),
            // const SizedBox(
            //   height: 200,
            // ),

            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  resultofOuts,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            os_show_flag == true
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () async {
                  var body = await outstanding(widget.clientId);
                  if (body["outstanding"] == "") {
                    resultofOuts = "No Outstanding";
                  } else {
                    if (body["outstanding"] != 0) {
                      resultofOuts = body["outstanding"]
                          .replaceAll(", ", "\n")
                          .toString();
                    } else {
                      resultofOuts = body["outstanding"].toString();
                    }
                  }

                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Show Outstanding",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () async {
                  //  var url ='https://ww11.yeapps.com/ipi_report/api_client_outstanding_report/client_outstanding_report?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                  // var url =
                  //     '$repOutsUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';

                  // if (await canLaunch(url)) {
                  //   await launch(url);
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                  // setState(() {});

                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OutstandingPage(
                      clientId: widget.clientId,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Outstanding",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () async {
                  // var url =
                  //     '$repLastInvUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                  // //  var url= 'http://w05.yeapps.com/ipi_report/api_client_invoice_report/client_invoice_report?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                  // if (await canLaunch(url)) {
                  //   await launch(url);
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                  // setState(() {});

                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LastInvoicePage(
                      clientId: widget.clientId,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Last Invoice",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () async {
                  //  var url ='http://w05.yeapps.com/ipi_report/api_client_order_report/client_order_report?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';

                  // var url =
                  //     '$repLastOrdUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                  // if (await canLaunch(url)) {
                  //   await launch(url);
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                  // setState(() {});
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LastOrderPage(
                      clientId: widget.clientId,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 27, 43, 23), backgroundColor: const Color.fromARGB(223, 146, 212, 157), fixedSize: const Size(20, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Last Order",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // widget.os_details_flag == true
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: ElevatedButton(
            //           onPressed: () {
            //             setState(() {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) =>
            //                           const OutStandingHistory()));
            //             });
            //           },
            //           child: const Text("Show Outstanding Details"),
            //           style: ElevatedButton.styleFrom(
            //             fixedSize: const Size(20, 50),
            //             primary: Color.fromARGB(255, 55, 129, 167),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(15),
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(children: [
            //     widget.ord_history_flag == true
            //         ? Expanded(
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 setState(() {
            //                   Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) =>
            //                               const OrderHistory()));
            //                 });
            //               },
            //               child: const Text("Order History"),
            //               style: ElevatedButton.styleFrom(
            //                 fixedSize: const Size(20, 50),
            //                 primary: Color.fromARGB(255, 55, 129, 167),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                 ),
            //               ),
            //             ),
            //           )
            //         : Container(),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     widget.inv_histroy_flag == true
            //         ? Expanded(
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 setState(() {
            //                   Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) =>
            //                               const InvoiceHistory()));
            //                 });
            //               },
            //               child: const Text("Invoice History"),
            //               style: ElevatedButton.styleFrom(
            //                 fixedSize: const Size(20, 50),
            //                 primary: Color.fromARGB(255, 55, 129, 167),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                 ),
            //               ),
            //             ),
            //           )
            //         : Container(),
            //   ]),
            // )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight / 10,
              color: const Color.fromARGB(223, 171, 241, 153),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.clientName}(${widget.clientId})',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 23, 41, 23),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.marketName,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 26, 66, 28),
                            fontSize: 16),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        '${widget.areaName} | ${widget.areaId}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 23, 41, 23),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: const Color(0xFFDDEBF7),
              elevation: 5,
              child: SizedBox(
                // height: screenHeight / 9,
                height: 100,

                width: screenWidth,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Count:  ${finalItemDataList.length} ',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Order value: ${formatter.format(totalAmount)}',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                            offer_flag == true
                                ? Expanded(
                              flex: 2,
                              child: SizedBox(
                                // width: 220,
                                child: Center(
                                  child: DropdownButton<String>(
                                    value: initialOffer,
                                    items: offer
                                        .map(
                                          (String item) =>
                                          DropdownMenuItem<
                                              String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style:
                                              const TextStyle(
                                                  fontSize:
                                                  15),
                                            ),
                                          ),
                                    )
                                        .toList(),
                                    onChanged: (item) => setState(
                                          () {
                                        initialOffer =
                                            item.toString();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 06.0),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                child: TextField(
                                  autofocus: false,
                                  controller: initialValue(
                                      selectedDeliveryDate),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  style: const TextStyle(
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Start Date',
                                    contentPadding:
                                    const EdgeInsets.all(2.0),
                                    labelText: "Delivery",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        overflow:
                                        TextOverflow.ellipsis),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {});
                                    selectedDeliveryDate = value;
                                    //dateSelected;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.parse(
                                          DateFormat('yyyy-MM-dd')
                                              .parse(
                                              selectedDeliveryDate)
                                              .toString()),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(
                                          DateTime.now().year + 1),
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        selectedDeliveryDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                // width: 220,
                                child: Center(
                                  child: DropdownButton<String>(
                                    value: selectedDeliveryTime,
                                    items: deliveryTime
                                        .map(
                                          (String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                          ),
                                    )
                                        .toList(),
                                    onChanged: (item) => setState(
                                          () {
                                        selectedDeliveryTime =
                                            item.toString();

                                        print(
                                            "-----------------$selectedDeliveryTime");
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                // width: 220,
                                child: Center(
                                  child: DropdownButton<String>(
                                    value: slectedPayMethod,
                                    items: payMethod
                                        .map(
                                          (String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                          ),
                                    )
                                        .toList(),
                                    onChanged: (item) => setState(
                                          () {
                                        slectedPayMethod =
                                            item.toString();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (cid.toString().toUpperCase() ==
                                'BIOPHARMA')
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  child: TextField(
                                    autofocus: false,
                                    controller: initialValue(
                                        selectedCollectionDate),
                                    focusNode:
                                    AlwaysDisabledFocusNode(),
                                    style: const TextStyle(
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Start Date',
                                      contentPadding:
                                      const EdgeInsets.all(2.0),
                                      labelText: "Collection",
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          overflow:
                                          TextOverflow.ellipsis),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {});
                                      selectedCollectionDate = value;
                                      //dateSelected;
                                    },
                                    onTap: () async {
                                      DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(
                                            DateFormat('yyyy-MM-dd')
                                                .parse(
                                                selectedCollectionDate)
                                                .toString()),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(
                                            DateTime.now().year + 1),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          selectedCollectionDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 06.0),
                    ],
                  ),
                ),
              ),
            ),

            ///*************************************** Note ***********************************************/
            note_flag == true
                ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SizedBox(
                // height: 55,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                    const Color.fromARGB(255, 138, 201, 149)
                        .withOpacity(.5),
                  ),
                  // elevation: 6,

                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9 ]')),
                    ],
                    style: const TextStyle(
                        fontSize: 18, color: Colors.black),
                    controller: noteController
                      ..addListener(() {
                        setState(() {
                          noteText = noteController.text;
                        });
                      }),
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none),
                        labelText: '  Notes...',
                        labelStyle:
                        TextStyle(color: Colors.blueGrey)),
                    onChanged: (value) {
                      // noteText = (noteController.text).replaceAll(
                      //     RegExp('[^A-Za-z0-9]'), " ");
                      noteText = value.toString();
                    },
                  ),
                ),
              ),
            )
                : Container(),
            Expanded(
              child: SizedBox(
                // height: screenHeight / 1.7,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: finalItemDataList.length,
                  physics: const BouncingScrollPhysics(),
                  // padding:
                  // EdgeInsets.only(bottom: 1 + 20),
                  itemBuilder: (BuildContext itemBuilder, index) {
                    // _itemController.add(TextEditingController());

                    // _itemController[index].text =
                    //     finalItemDataList[index].quantity.toString();
                    return Card(
                      elevation: 15,
                      color: const Color.fromARGB(255, 222, 233, 243),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      finalItemDataList[index].item_name,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showMyDialog(index);
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                flex: 3,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  color: const Color.fromARGB(
                                      255, 200, 250, 207),
                                  elevation: 2,
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'QTY',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'TP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Vat',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Total',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                      // flex: 2,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: Container(
                                          color: const Color.fromARGB(
                                              255, 138, 201, 149)
                                              .withOpacity(.3),
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: controllers[
                                            finalItemDataList[index]
                                                .item_id],

                                            keyboardType:
                                            TextInputType.number,
                                            // focusNode: FocusNode(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            decoration:
                                            const InputDecoration(
                                              border:
                                              OutlineInputBorder(),
                                            ),

                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(7),
                                            ],


                                            onChanged: (value) {
                                              // _itemController[index].clear();
                                              finalItemDataList[index]
                                                  .quantity = controllers[
                                              finalItemDataList[
                                              index]
                                                  .item_id]
                                                  ?.text !=
                                                  ''
                                                  ? int.parse(controllers[
                                              finalItemDataList[
                                              index]
                                                  .item_id]!
                                                  .text)
                                                  : 0;

                                              ordertotalAmount();
                                              // setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          '${finalItemDataList[index].tp}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          '${finalItemDataList[index].vat}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          formatter.format(totalCount(
                                              finalItemDataList[index])),
                                          // totalCount(finalItemDataList[
                                          //         index])
                                          //     .toStringAsFixed(2),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: _bottomNavBarKey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _currentSelected,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Save Drafts',
            icon: Icon(Icons.drafts),
          ),
          BottomNavigationBarItem(
            label: 'Submit',
            icon: Icon(Icons.save),
          ),
          BottomNavigationBarItem(
            label: 'Add Item',
            icon: Icon(Icons.add),
          ),
          // BottomNavigationBarItem(
          //   label: 'Drawer',
          //   icon: Icon(Icons.menu),
          // )
        ],
      ),
    )
        : Container(
      padding: const EdgeInsets.all(50),
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _onItemTapped(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) {
      if (index == 0) {
        await orderPutData();
        // Navigator.pop(context);
        setState(() {
          _currentSelected = index;
        });
      } else {}

      if (index == 1) {
        // if (finalItemDataList.isEmpty && noteController.text.isEmpty) {
        //   return Fluttertoast.showToast(
        //       msg: 'Please enter visit notes',
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.SNACKBAR,
        //       backgroundColor: Colors.red,
        //       textColor: Colors.white,
        //       fontSize: 16.0);
        // }

        bool result = await NetworkConnecticity.checkConnectivity();
        if (result == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Confirm"),
              content: Text(
                  "Are you sure want to submit ${finalItemDataList.isEmpty ? 'Visit' : 'Order'}?"),
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
                    setState(() {
                      _isLoading = false;
                    });
                    orderSubmit();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
          );
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // debugPrint(InternetConnectionChecker().lastTryResults);
        }

        setState(() {
          _currentSelected = index;
        });
      }
      if (index == 2) {
        if (isItemSync == true) {
          getData();

          setState(() {
            _currentSelected = index;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Please sync item',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
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

// Delete data from Hive by id...................................
  deleteOrderItem(int id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == widget.ckey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteOrderCustomer(int id) {
    final box = Hive.box<CustomerDataModel>("customerHive");

    final Map<dynamic, CustomerDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.ckey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

//outstanding Api///////////////////////////////////////////////////////////////////////
  Future outstanding(String id) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(
            '$client_outst_url?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // var a = data["outstanding"];

        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Order Failed'), backgroundColor: Colors.red));
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check connection or data!'),
          backgroundColor: Colors.red));
      setState(() {
        _isLoading = true;
      });
      throw Exception("Error on server");
    }

    // return status;
  }

  // Submit order..............................
  Future orderSubmit() async {
    String address = '';
    double lat = 0.0;
    double long = 0.0;

    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        List<geocoding.Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(position.latitude, position.longitude);
        setState(() {
          lat = position.latitude;
          long = position.longitude;

          address = "${placemarks[0].street!} ${placemarks[0].country!}";
        });
      }
    } on Exception catch (e) {
      debugPrint("Exception geolocator section: $e");
    }

    if (itemString != '' || itemString == '') {
      String status;
      try {
        String url =
            "${submit_url}api_order_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=${widget.clientId}&delivery_date=$selectedDeliveryDate&collection_date=$selectedCollectionDate&delivery_time=$selectedDeliveryTime&payment_mode=$slectedPayMethod&offer=$initialOffer&note=$noteText&item_list=$itemString&app_version=v-$appVersion&latitude=${(minLatitude <= lat && lat <= maxLatitude) ? lat : ''}&longitude=${(minLongitude <= long && long <= maxLongitude) ? long : ''}&location_detail=${((minLatitude <= lat && lat <= maxLatitude) && (minLongitude <= long && long <= maxLongitude)) ? address : ''}"; /// main url
        // "https://ww11.yeapps.com/hamdard_api/api_order_submit_test/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=${widget.clientId}&delivery_date=$selectedDeliveryDate&collection_date=$selectedCollectionDate&delivery_time=$selectedDeliveryTime&payment_mode=$slectedPayMethod&offer=$initialOffer&note=$noteText&item_list=$itemString&app_version=$appVersion&latitude=${(minLatitude <= lat && lat <= maxLatitude) ? lat : ''}&longitude=${(minLongitude <= long && long <= maxLongitude) ? long : ''}&location_detail=${((minLatitude <= lat && lat <= maxLatitude) && (minLongitude <= long && long <= maxLongitude)) ? address : ''}"; /// test url
        // "http://192.168.100.235:8000/apex_pharma_api/api_order_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=${widget.clientId}&delivery_date=$selectedDeliveryDate&collection_date=$selectedCollectionDate&delivery_time=$selectedDeliveryTime&payment_mode=$slectedPayMethod&offer=$initialOffer&note=$noteText&item_list=$itemString&latitude=${(minLatitude <= lat && lat <= maxLatitude) ? lat : ''}&longitude=${(minLongitude <= long && long <= maxLongitude) ? long : ''}&location_detail=${((minLatitude <= lat && lat <= maxLatitude) && (minLongitude <= long && long <= maxLongitude)) ? address : ''}&app_version=$appVersion";
        // "http://192.168.100.241:8000/hamdard_api/api_order_submit/submit_data?cid=HAMDARD&user_id=9010&user_pass=1234&device_id=dc4b24f052443aaa&client_id=10001918&delivery_date=2024-01-15&collection_date=2024-01-15&delivery_time=Morning&payment_mode=CASH&offer=_&note=&item_list=P723|10||U008|5||P216|8||U124|12||U031|1&latitude=23.7613035&longitude=90.3717694&location_detail=1%20Asad%20Ave%20Bangladesh&app_version=v-20250200";

        debugPrint(url);
        http.Response response = await http.get(Uri.parse(url));

        var orderInfo = json.decode(response.body);
        status = orderInfo['status'];

        String ret_str = orderInfo['ret_str'];

        if (status == "Success") {
          setState(() {
            _isLoading = true;
          });
          for (int i = 0; i <= finalItemDataList.length; i++) {
            deleteOrderItem(widget.ckey);

            setState(() {});
          }

          deleteOrderCustomer(widget.ckey);

          setState(() {});

          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (context) => MyHomePage(
          //               userName: userName,
          //               user_id: user_id,
          //               userPassword: userPassword ?? '',
          //             )),
          //     (Route<dynamic> route) => false);

          finalItemDataList.clear();
          ordertotalAmount();

          _submitToastforOrder(ret_str);
          Navigator.of(context).pop();
        }
        else if (orderInfo['ret_str'].toString().toLowerCase().contains('http') && status == 'Failed' )
        {
          String update_app_url = '';
          String update_app_notification = '';
          if(orderInfo['ret_str'].toString().contains('http')){
            int index = orderInfo['ret_str'].toString().indexOf("http");
            //
            // String update_app_notification = orderInfo['ret_str'].toString().substring(0, index).trim();
            // debugPrint(update_app_notification);
            update_app_notification = orderInfo['ret_str'].toString().substring(0, index).trim() ?? '';

            update_app_url =
                orderInfo['ret_str'].toString().substring(index).trim() ?? '';
            await databox.put('update_new_app',update_app_notification);
            await databox.put('update_new_app_url',update_app_url);
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
          if(update_app_url != null || update_app_url != '') {
            AllServices().showMap(update_app_url);
          }


        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${orderInfo['ret_str']}'),
              backgroundColor: Colors.red));
          setState(() {
            _isLoading = true;
          });
        }
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please check connection or data!'),
            backgroundColor: Colors.red));
        setState(() {
          _isLoading = true;
        });
        throw Exception("Error on server");
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please Order something',
          ),
          backgroundColor: Colors.red));
    }
    // return status;
  }

  getData() async {
    var mymap = Hive.box('syncItemData').values.toList();

    if (mymap.isEmpty) {
      syncItemList.add('empty');
    } else {
      syncItemList = mymap;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShowSyncItemData(
            uniqueId: widget.uniqueId,
            syncItemList: syncItemList,
            tempList: finalItemDataList,
            tempListFunc: (value) {
              finalItemDataList = value;

              for (var element in finalItemDataList) {
                controllers[element.item_id] = TextEditingController();
                controllers[element.item_id]?.text =
                    element.quantity.toString();
              }
              // finalItemDataList.forEach((element) {

              // });

              ordertotalAmount();
              setState(() {});
            },
          ),
        ),
      );
    }
  }

  // order Amount calculation....................................................

  ordertotalAmount() {
    itemString = '';
    orderAmount = 0.0;
    if (finalItemDataList.isNotEmpty) {
      for (var element in finalItemDataList) {
        total = (element.tp + element.vat) * element.quantity;
        // debugPrint(total);

        if (itemString == '' && element.quantity != 0) {
          itemString = '${element.item_id}|${element.quantity}';
        } else if (element.quantity != 0) {
          itemString += '||${element.item_id}|${element.quantity}';
        }

        orderAmount = orderAmount + total;

        totalAmount = orderAmount;
        // formatter.format(totalAmount);

        // debugPrint(itemString);

        setState(() {});
      }
      // debugPrint(itemString);
    } else {
      setState(() {
        totalAmount = 0;
      });
    }
  }

  // formatAmount(String data){
  //   var formatter = NumberFormat('#,##0.' + "#" * 5);

  //    return formatter.format(double.parse(data));
  // }

// Save OrderCustomer and ordered item to Hive..................................
  Future<dynamic> orderPutData() async {
    if (widget.deliveryDate != '' && finalItemDataList.isNotEmpty) {
      for (int i = 0; i <= finalItemDataList.length; i++) {
        deleteOrderItem(widget.ckey);
        deleteOrderCustomer(widget.uniqueId);
        setState(() {});
      }

      setState(() {});

      // debugPrint('object');

      for (var d in finalItemDataList) {
        final box = Boxes.getDraftOrderedData();

        box.add(d);
      }

      var customer = CustomerDataModel(
        uiqueKey: widget.uniqueId,
        clientName: widget.clientName,
        marketName: widget.marketName,
        areaId: widget.areaId.toString(),
        areaName: widget.areaName.toString(),
        clientId: widget.clientId,
        outstanding: widget.outStanding ?? "",
        thana: 'thana',
        address: 'address',
        deliveryDate: selectedDeliveryDate,
        collectionDate: selectedCollectionDate,
        deliveryTime: selectedDeliveryTime,
        offer: initialOffer,
        paymentMethod: slectedPayMethod,
        note: noteController.text,
        shift: selectedDeliveryTime,
      );

      customerdatalist.add(customer);
      final box = Boxes.getCustomerUsers();
      for (var c in customerdatalist) {
        box.add(c);
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              userName: userName,
              user_id: user_id,
              userPassword: userPassword ?? '',
              data: finalItemDataList.length,
            ),
          ),
              (route) => false);
    } else if (widget.deliveryDate != '' && finalItemDataList.isEmpty) {
      deleteOrderItem(widget.ckey);
      deleteOrderCustomer(widget.uniqueId);
      setState(() {});

      var customer = CustomerDataModel(
        uiqueKey: widget.uniqueId,
        clientName: widget.clientName,
        marketName: widget.marketName,
        areaId: widget.areaId.toString(),
        areaName: widget.areaName.toString(),
        clientId: widget.clientId,
        outstanding: widget.outStanding ?? "",
        thana: 'thana',
        address: 'address',
        deliveryDate: selectedDeliveryDate,
        collectionDate: selectedCollectionDate,
        deliveryTime: selectedDeliveryTime,
        offer: initialOffer,
        paymentMethod: slectedPayMethod,
        note: noteController.text,
        shift: selectedDeliveryTime,
      );

      customerdatalist.add(customer);
      final box = Boxes.getCustomerUsers();
      for (var c in customerdatalist) {
        box.add(c);
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              userName: userName,
              user_id: user_id,
              userPassword: userPassword ?? '',
              data: finalItemDataList.length,
            ),
          ),
              (route) => false);
    }

    /// this code hide to save customer when order item is empty
    // else if (finalItemDataList.isEmpty) {
    //   for (int i = 0; i <= tempCount; i++) {
    //     deleteOrderItem(widget.ckey);

    //     setState(() {});
    //   }

    //   setState(() {});

    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => MyHomePage(
    //           userName: userName,
    //           user_id: user_id,
    //           userPassword: userPassword ?? '',
    //         ),
    //       ),
    //       (route) => false);
    // }

    else {
      var customer = CustomerDataModel(
        uiqueKey: widget.uniqueId,
        clientName: widget.clientName,
        marketName: widget.marketName,
        areaId: widget.areaId.toString(),
        areaName: widget.areaName.toString(),
        clientId: widget.clientId,
        outstanding: widget.outStanding ?? "",
        thana: 'thana',
        address: 'address',
        deliveryDate: selectedDeliveryDate,
        collectionDate: selectedCollectionDate,
        deliveryTime: selectedDeliveryTime,
        offer: initialOffer,
        paymentMethod: slectedPayMethod,
        note: noteController.text,
        shift: selectedDeliveryTime,
      );

      customerdatalist.add(customer);

      for (var c in customerdatalist) {
        final box = Boxes.getCustomerUsers();
        box.add(c);
      }

      for (var d in finalItemDataList) {
        final box = Boxes.getDraftOrderedData();

        box.add(d);
      }

      Navigator.pop(context);
    }
  }

// Date pick function.................................................................
  pickDate(String initialDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    print("*********************************** ${pickedDate}");
    return pickedDate;
  }

  // Status Message...................................................................
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "Order Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
