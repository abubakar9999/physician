import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/datasources/local_storage/hive_data_model.dart';
import '../../Widgets/dimensions.dart';
import 'dcr_gift_sample_PPM_page.dart';

class DraftDCRScreen extends StatefulWidget {
  const DraftDCRScreen({Key? key}) : super(key: key);

  @override
  State<DraftDCRScreen> createState() => _DraftDCRScreenState();
}

class _DraftDCRScreenState extends State<DraftDCRScreen> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;
  var screenHeight;
  var screenWidth;
  List itemDraftList = [];
  List<DcrGSPDataModel> addedDcrGSPList = [];
  List<DcrGSPDataModel> filteredOrder = [];
  List<DcrDataModel> dcrDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = Boxes.selectedDcrGSP();
      addedDcrGSPList = box!.toMap().values.toList().cast<DcrGSPDataModel>();

      box = Boxes.dcrUsers();
      dcrDataList = box!.toMap().values.toList().cast<DcrDataModel>();

      setState(() {});
    });
    super.initState();
  }

  Future<void> deletedoctor(DcrDataModel dcrDataModel) async {
    dcrDataModel.delete();
  }

  deletDcrGSPitem(int id) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Visit'), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.dcrUsers().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers = box.values.toList().cast<DcrDataModel>();

            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }

  Widget genContent(List<DcrDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          // //int space = user[index].image.indexOf(" ");
          // int? space = user[index].image!.indexOf(" ");
          // //String removeSpace = user[index].image.substring(space + 1, user[index].presImage.length);
          // String? removeSpace = user[index].image!.substring(space + 1, user[index].image!.length);
          // //String finalImage = removeSpace.replaceAll("'", '');
          // String? finalImage = removeSpace.replaceAll("'", '');
          String? finalImage;
          if (user[index].image != null && user[index].image!.contains(" ")) {
            int space = user[index].image!.indexOf(" ");
            String removeSpace = user[index].image!.substring(space + 1);
            finalImage = removeSpace.replaceAll("'", '');
          }


          return GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 207, 240, 207),
              child: ExpansionTile(
                childrenPadding: const EdgeInsets.all(0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight / 8,
                        width: screenWidth / 6,
                        // child: Image(
                        //   fit: BoxFit.cover,
                        //   image: FileImage(File(finalImage)),
                        // ),
                        child: finalImage != null && File(finalImage).existsSync()
                            ? Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(finalImage)),
                        )
                            : const Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Text(
                          //   // "${user[index].docName} (${user[index].areaName}) ",//todo old
                          //   "${user[index].docName} (${user[index].areaId}) ",
                          //   maxLines: 2,
                          //   style: const TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 18),
                          // ),
                          Text(
                            "${user[index].docName} (${user[index].docId}) ",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            user[index].areaName,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Text("${user[index].docId}  "),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to Delete the Doctor?"),
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
                                      final ckey = user[index].uiqueKey;
                                      deletedoctor(user[index]);

                                      deletDcrGSPitem(ckey);
                                      // User clicked Yes, so close the dialog and return true
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final vititedwith = user[index].visitedWith;
                          final note = user[index].note;
                          final nonExcution = user[index].non_Excution;
                          final selectedDeliveryTime = user[index].shift;
                          debugPrint("Visited with $vititedwith");
                          debugPrint("Note $note");
                          debugPrint("Note $nonExcution");

                          final dcrKey = user[index].uiqueKey;

                          filteredOrder = [];
                          addedDcrGSPList
                              .where((item) => item.uiqueKey == dcrKey)
                              .forEach(
                            (item) {
                              final temp = DcrGSPDataModel(
                                  uiqueKey: item.uiqueKey,
                                  quantity: item.quantity,
                                  giftName: item.giftName,
                                  giftId: item.giftId,
                                  giftType: item.giftType);
                              filteredOrder.add(temp);
                            },
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DcrGiftSamplePpmPage(
                                ck: 'isCheck',
                                dcrKey: dcrKey,
                                uniqueId: dcrKey,
                                draftOrderItem: filteredOrder,
                                officeName: user[index].docName,
                                officeId: user[index].docId,
                                areaName: user[index].areaName,
                                areaId: user[index].areaId,
                                address: user[index].address,
                                dVisitedWith: vititedwith ?? "",
                                note: note ?? "",
                                nonExcution: nonExcution ?? "",
                                selectedDeliveryTime: selectedDeliveryTime ?? "",
                                image1: user[index].image ?? '',
                                visitedPerson: user[index].visitedPerson ?? '',
                                phnNum: user[index].phoneNum!.toInt(),
                                orgName: user[index].organizationName ?? '',
                                category: user[index].category ?? '',
                                brandId: user[index].brandId ?? '',
                              ),
                            ),
                          );

                          print(selectedDeliveryTime);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          "Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
