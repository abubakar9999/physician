import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:physician_latest/features/pages/loginPage.dart';
import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';

class PromotionalDrawer extends StatefulWidget {
  final int uniqueId;
  //final List doctorGiftlist;
  final List<DcrGSPDataModel> tempList;
  final Function(List<DcrGSPDataModel>) tempListFunc;

  //final List doctorSamplelist;
  final List<DcrGSPDataModel> tempList1;

  //final List doctorPpmlist;
  final List<DcrGSPDataModel> tempList2;

  const PromotionalDrawer({super.key, required this.uniqueId, required this.tempList, required this.tempListFunc, required this.tempList1, required this.tempList2});

  @override
  State<PromotionalDrawer> createState() => _PromotionalDrawerState();
}

class _PromotionalDrawerState extends State<PromotionalDrawer> {
  String syncUrl = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  final myDataBox = Boxes.allData();

  bool isGiftExpanded = false;
  bool isSampleExpanded = false;
  bool isPPMExpanded = false;

  final Map<String, TextEditingController> giftControllersMap = {};
  final Map<String, TextEditingController> sampleControllersMap = {};
  final Map<String, TextEditingController> ppmControllersMap = {};

  List doctorGiftList = [];
  List doctorSampleList = [];
  List doctorPPMList = [];

  String? itemId;

  bool isGiftLoading = false;
  bool isSampleLoading = false;
  bool isPPMLoading = false;

  List<dynamic> apiGiftList = [];
  List<dynamic> apiSampleList = [];
  List<dynamic> apiPPMList = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        cid = myDataBox.get("CID");
        userId = myDataBox.get("USER_ID");
        userPassword = myDataBox.get("PASSWORD");
        syncUrl = myDataBox.get('sync_url');
      });

      fetchGiftData();
      fetchSampleData();
      fetchPPMData();

      debugPrint("cid: $cid");
      debugPrint("user id: $userId");
      debugPrint("user pass: $userPassword");
      debugPrint("sync url: $syncUrl");
    }

    // ////////////gift////////////
    // doctorGiftList = widget.doctorGiftlist;
    //
    // for (var item in doctorGiftList) {
    //   controllers[item['gift_id']] = TextEditingController();
    // }
    //
    // for (var item in widget.tempList) {
    //   if (controllers.containsKey(item.giftId)) {
    //     controllers[item.giftId]!.text = item.quantity.toString();
    //   }
    // }
    //
    //
    // ////////////sample////////////
    // doctorSampleList = widget.doctorSamplelist;
    // for (var element in doctorSampleList) {
    //   controllers[element['sample_id']] = TextEditingController();
    // }
    //
    // for (var element in widget.tempList1) {
    //   controllers.forEach((key, value) {
    //     if (key == element.giftId) {
    //       value.text = element.quantity.toString();
    //     }
    //   });
    // }
    //
    // ////////////ppm////////////
    // doctorPPMList = widget.doctorPpmlist;
    // for (var element in doctorPPMList) {
    //   controllers[element['ppm_id']] = TextEditingController();
    // }
    //
    // for (var element in widget.tempList2) {
    //   itemId = element.giftId;
    // }
    //
    // for (var element in widget.tempList2) {
    //   controllers.forEach((key, value) {
    //     if (key == element.giftId) {
    //       value.text = element.quantity.toString();
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    for (var controller in giftControllersMap.values) {
      controller.dispose();
    }
    for (var controller in sampleControllersMap.values) {
      controller.dispose();
    }
    for (var controller in ppmControllersMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Future<void> fetchGiftData()async {
  //   setState(() {
  //     isGiftLoading=true;
  //   });
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //         //"${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //     ));
  //     print('urlll: http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword');
  //     if(response.statusCode==200){
  //       Map<String, dynamic> jsonResponseData=jsonDecode(response.body);
  //       Map<String, dynamic> resData=jsonResponseData['res_data'];
  //       apiGiftList=resData['giftList'];
  //
  //       for (var item in apiGiftList) {
  //         final giftId=item['gift_id'];
  //         final promoType=item['promo_type'];
  //         giftControllersMap[giftId+promoType] = TextEditingController();
  //       }
  //       for (var item in widget.tempList) {
  //         if (giftControllersMap.containsKey(item.giftId+item.giftId)) {
  //           giftControllersMap[item.giftId]!.text = item.quantity.toString();
  //         }
  //       }
  //     }
  //     else{
  //       debugPrint('Failed to load gift list');
  //     }
  //   }
  //   catch(e){
  //     debugPrint("$e");
  //   }
  //   setState(() {
  //     isGiftLoading = false;
  //   });
  // }
  Future<void> fetchGiftData() async {
    setState(() {
      isGiftLoading = true;
    });

    try {
      final url =
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword";
          "${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassword";
      print('URL: $url');

      final response = await http.get(Uri.parse(url));
      var jsonResponseData = jsonDecode(response.body);
      String status = jsonResponseData['res_data']['status'];

      if (status == "Success") {
        //final jsonResponseData = jsonDecode(response.body);
        final resData = jsonResponseData['res_data'];
        apiGiftList = resData['giftList'];

        for (var item in apiGiftList) {
          final key = item['gift_id'].toString() + item['promo_type'].toString();
          giftControllersMap[key] = TextEditingController();
        }

        for (var item in widget.tempList) {
          final key = item.giftId + item.giftType;
          if (giftControllersMap.containsKey(key)) {
            giftControllersMap[key]!.text = item.quantity.toString();
          }
        }
      } else {
        debugPrint('Failed to load gift list');
      }
    } catch (e) {
      debugPrint("Gift Fetch Error: $e");
    }

    setState(() {
      isGiftLoading = false;
    });
  }

  // Future<void> fetchSampleData()async {
  //   setState(() {
  //     isSampleLoading=true;
  //   });
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //         //"${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //     ));
  //     print('urlll: http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword');
  //     if(response.statusCode==200){
  //       Map<String, dynamic> jsonResponseData=jsonDecode(response.body);
  //       Map<String, dynamic> resData=jsonResponseData['res_data'];
  //       apiSampleList=resData['sampleList'];
  //
  //       for (var element in apiSampleList) {
  //         sampleControllersMap[element['sample_id']] = TextEditingController();
  //       }
  //
  //       for (var element in widget.tempList1) {
  //         sampleControllersMap.forEach((key, value) {
  //           if (key == element.giftId) {
  //             value.text = element.quantity.toString();
  //           }
  //         });
  //       }
  //     }
  //     else{
  //       debugPrint('Failed to load gift list');
  //     }
  //   }
  //   catch(e){
  //     debugPrint("$e");
  //   }
  //   setState(() {
  //     isSampleLoading = false;
  //   });
  // }
  Future<void> fetchSampleData() async {
    setState(() {
      isSampleLoading = true;
    });

    try {
      final url =
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword";
          "${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassword";
      print('URL: $url');

      final response = await http.get(Uri.parse(url));
      var jsonResponseData = jsonDecode(response.body);
      String status = jsonResponseData['res_data']['status'];

      if (status == "Success") {
        //Map<String, dynamic> jsonResponseData = jsonDecode(response.body);
        Map<String, dynamic> resData = jsonResponseData['res_data'];
        apiSampleList = resData['sampleList'];

        for (var element in apiSampleList) {
          final key = element['sample_id'].toString() + element['promo_type'].toString();
          sampleControllersMap[key] = TextEditingController();
        }

        for (var element in widget.tempList1) {
          final key = element.giftId + element.giftType;
          if (sampleControllersMap.containsKey(key)) {
            sampleControllersMap[key]!.text = element.quantity.toString();
          }
        }
      } else {
        debugPrint('Failed to load sample list');
      }
    } catch (e) {
      debugPrint("Sample Fetch Error: $e");
    }

    setState(() {
      isSampleLoading = false;
    });
  }

  // Future<void> fetchPPMData()async {
  //   setState(() {
  //     isPPMLoading=true;
  //   });
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //         //"${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword"
  //     ));
  //     print('urlll: http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword');
  //     if(response.statusCode==200){
  //       Map<String, dynamic> jsonResponseData=jsonDecode(response.body);
  //       Map<String, dynamic> resData=jsonResponseData['res_data'];
  //       apiPPMList=resData['ppmList'];
  //
  //       for (var element in apiPPMList) {
  //         final ppmId=element['ppm_id'];
  //         final promoType=element['promo_type'];
  //         ppmControllersMap[element[ppmId+promoType]] = TextEditingController();
  //       }
  //       for (var element in widget.tempList2) {
  //         itemId = element.giftId;
  //       }
  //
  //       for (var element in widget.tempList2) {
  //         ppmControllersMap.forEach((key, value) {
  //           if (key == element.giftId) {
  //             value.text = element.quantity.toString();
  //           }
  //         });
  //       }
  //       // for (var element in widget.tempList2) {
  //       //   if (ppmControllersMap.containsKey(element.giftId)) {
  //       //     ppmControllersMap[element.giftId]!.text = element.quantity.toString();
  //       //   }
  //       // }
  //     }
  //     else{
  //       debugPrint('Failed to load gift list');
  //     }
  //   }
  //   catch(e){
  //     debugPrint("$e");
  //   }
  //   setState(() {
  //     isPPMLoading = false;
  //   });
  // }
  Future<void> fetchPPMData() async {
    setState(() {
      isPPMLoading = true;
    });

    try {
      final url =
          //"http://192.168.100.219:8000/physician_api/api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword";
          "${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassword";
      print('URL: $url');

      final response = await http.get(Uri.parse(url));
      var jsonResponseData = jsonDecode(response.body);
      String status = jsonResponseData['res_data']['status'];

      if (status == "Success") {
        final resData = jsonResponseData['res_data'];
        apiPPMList = resData['ppmList'];

        for (var item in apiPPMList) {
          final key = item['ppm_id'].toString() + item['promo_type'].toString();
          ppmControllersMap[key] = TextEditingController();
        }

        for (var item in widget.tempList2) {
          final key = item.giftId + item.giftType;
          if (ppmControllersMap.containsKey(key)) {
            ppmControllersMap[key]!.text = item.quantity.toString();
          }
        }
      } else {
        debugPrint('Failed to load PPM list');
      }
    } catch (e) {
      debugPrint("PPM Fetch Error: $e");
    }

    setState(() {
      isPPMLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14), decoration: const BoxDecoration(color: Colors.blue), child: const Center(child: Text('Promotional Item', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500)))),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ExpansionTile(
                          trailing: Icon(isGiftExpanded ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined, color: Colors.white),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isGiftExpanded = expanded;
                            });
                            // if (expanded && apiGiftList.isEmpty) {
                            //   fetchGiftData();
                            // }
                          },
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          collapsedBackgroundColor: Colors.black,
                          backgroundColor: Colors.black,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: const Center(child: Text('Gift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          children:
                              isGiftLoading
                                  ? [const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator(color: Colors.white)))]
                                  : apiGiftList.isNotEmpty
                                  ? apiGiftList.map((gift) {
                                    final key = gift['gift_id'] + gift['promo_type'];
                                    final controller = giftControllersMap[key]!;
                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(gift['gift_name'], style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      gift['gift_left_qty'] == 0
                                                          ? const SizedBox.shrink()
                                                          : Text(
                                                            //'(${gift['gift_left_qty']}/${gift['gift_total_qty']})',
                                                            '(${gift['gift_left_qty']})',
                                                            style: const TextStyle(color: Colors.red),
                                                          ),
                                                    ],
                                                  ),
                                                  Text('${gift['gift_id']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                controller: controller,
                                                readOnly: gift['gift_left_qty'] == 0,
                                                onTap: () {
                                                  if (gift['gift_left_qty'] == 0) {
                                                    Fluttertoast.showToast(msg: 'Item is not available', backgroundColor: Colors.red);
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                maxLength: 4,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)), isDense: true, contentPadding: const EdgeInsets.all(10)),
                                                onChanged: (value) {
                                                  setState(() {});
                                                  final quantity = int.tryParse(value) ?? 0;
                                                  final leftQty = gift['gift_left_qty'] ?? 0;

                                                  if (quantity > leftQty) {
                                                    Fluttertoast.showToast(msg: 'Only $leftQty items are available', backgroundColor: Colors.red);
                                                    controller.text = leftQty.toString();
                                                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                                    return;
                                                  }

                                                  final model = DcrGSPDataModel(
                                                    uiqueKey: widget.uniqueId,
                                                    quantity: quantity,
                                                    giftName: gift['gift_name'],
                                                    giftId: gift['gift_id'],
                                                    giftType: gift['promo_type'], // e.g., 'Gift'
                                                  );

                                                  widget.tempList.removeWhere((item) => item.giftId == model.giftId && item.giftType == model.giftType);
                                                  if (quantity > 0) {
                                                    widget.tempList.add(model);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [const Padding(padding: EdgeInsets.all(8), child: Text('No results found'))],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ExpansionTile(
                          trailing: Icon(isSampleExpanded ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined, color: Colors.white),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isSampleExpanded = expanded;
                            });
                            // if (expanded && apiSampleList.isEmpty) {
                            //   fetchSampleData();
                            // }
                          },
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          collapsedBackgroundColor: Colors.black,
                          backgroundColor: Colors.black,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: const Center(child: Text('Sample', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          children:
                              isSampleLoading
                                  ? [const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator(color: Colors.white)))]
                                  : apiSampleList.isNotEmpty
                                  ? apiSampleList.map((sample) {
                                    final key = sample['sample_id'] + sample['promo_type'];
                                    final controller = sampleControllersMap[key]!;

                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(sample['sample_name'], style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      sample['sample_left_qty'] == 0
                                                          ? const SizedBox.shrink()
                                                          : Text(
                                                            //'(${sample['sample_left_qty']}/${sample['sample_total_qty']})',
                                                            '(${sample['sample_left_qty']})',
                                                            style: const TextStyle(color: Colors.red),
                                                          ),
                                                    ],
                                                  ),
                                                  Text(sample['sample_id'], style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                controller: controller,
                                                readOnly: sample['sample_left_qty'] == 0,
                                                onTap: () {
                                                  if (sample['sample_left_qty'] == 0) {
                                                    Fluttertoast.showToast(msg: 'Item is not available', backgroundColor: Colors.red);
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                maxLength: 4,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)), isDense: true, contentPadding: const EdgeInsets.all(10)),
                                                onChanged: (value) {
                                                  setState(() {});
                                                  final quantity = int.tryParse(value) ?? 0;
                                                  final leftQty = sample['sample_left_qty'] ?? 0;

                                                  if (quantity > leftQty) {
                                                    Fluttertoast.showToast(msg: 'Only $leftQty items are available', backgroundColor: Colors.red);
                                                    controller.text = leftQty.toString();
                                                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                                    return;
                                                  }

                                                  final model = DcrGSPDataModel(
                                                    uiqueKey: widget.uniqueId,
                                                    quantity: quantity,
                                                    giftName: sample['sample_name'],
                                                    giftId: sample['sample_id'],
                                                    //giftType: 'SAMPLE',
                                                    giftType: sample['promo_type'],
                                                  );

                                                  widget.tempList1.removeWhere((item) => item.giftId == model.giftId && item.giftType == model.giftType);

                                                  if (quantity > 0) {
                                                    widget.tempList1.add(model);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [const Padding(padding: EdgeInsets.all(8), child: Text('No results found'))],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ExpansionTile(
                          trailing: Icon(isPPMExpanded ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined, color: Colors.white),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isPPMExpanded = expanded;
                            });
                            // if (expanded && apiPPMList.isEmpty) {
                            //   fetchPPMData();
                            // }
                          },
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          collapsedBackgroundColor: Colors.black,
                          backgroundColor: Colors.black,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: const Center(child: Text('PPM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          children:
                              isPPMLoading
                                  ? [const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator(color: Colors.white)))]
                                  : apiPPMList.isNotEmpty
                                  ? apiPPMList.map((ppm) {
                                    final key = ppm['ppm_id'] + ppm['promo_type'];
                                    final controller = ppmControllersMap[key]!;

                                    return Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(ppm['ppm_name'], style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      ppm['ppm_left_qty'] == 0
                                                          ? const SizedBox.shrink()
                                                          : Text(
                                                            //'(${ppm['ppm_left_qty']}/${ppm['ppm_total_qty']})',
                                                            '(${ppm['ppm_left_qty']})',
                                                            style: const TextStyle(color: Colors.red),
                                                          ),
                                                    ],
                                                  ),
                                                  Text(ppm['ppm_id'], style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                controller: controller,
                                                readOnly: ppm['ppm_left_qty'] == 0,
                                                onTap: () {
                                                  if (ppm['ppm_left_qty'] == 0) {
                                                    Fluttertoast.showToast(msg: 'Item is not available', backgroundColor: Colors.red);
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                maxLength: 4,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)), isDense: true, contentPadding: const EdgeInsets.all(10)),
                                                onChanged: (value) {
                                                  setState(() {});
                                                  final quantity = int.tryParse(value) ?? 0;
                                                  final leftQty = ppm['ppm_left_qty'] ?? 0;

                                                  if (quantity > leftQty) {
                                                    Fluttertoast.showToast(msg: 'Only $leftQty items are available', backgroundColor: Colors.red);
                                                    controller.text = leftQty.toString();
                                                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                                    return;
                                                  }

                                                  final model = DcrGSPDataModel(
                                                    uiqueKey: widget.uniqueId,
                                                    quantity: quantity,
                                                    giftName: ppm['ppm_name'],
                                                    giftId: ppm['ppm_id'],
                                                    // giftType: 'PPM',
                                                    giftType: ppm['promo_type'],
                                                  );

                                                  widget.tempList2.removeWhere((item) => item.giftId == model.giftId && item.giftType == model.giftType);

                                                  if (quantity > 0) {
                                                    widget.tempList2.add(model);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [const Padding(padding: EdgeInsets.all(8), child: Text('No results found'))],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
