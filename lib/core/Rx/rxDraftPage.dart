// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:physician_latest/core/Rx/rxPage.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';

class RxDraftPage extends StatefulWidget {
  const RxDraftPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RxDraftPage> createState() => _RxDraftPageState();
}

class _RxDraftPageState extends State<RxDraftPage> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;
  var screenHeight;
  var screenWidth;
  List itemDraftList = [];
  List<MedicineListModel> addedRxMedicinList = [];
  List<MedicineListModel> filteredMedicin = [];
  List<RxDcrDataModel> dcrDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = Boxes.getMedicine();
      addedRxMedicinList = box!.toMap().values.toList().cast<MedicineListModel>();

      box = Boxes.dcrUsers();
      dcrDataList = box!.toMap().values.toList().cast<RxDcrDataModel>();

      setState(() {});
    });
    super.initState();
  }

  int currentSelected = 0;

  void onItemTapped(int index) async {
    if (index == 1) {
      // await putData();
      setState(() {
        currentSelected = index;
      });
      // debugPrint('order List seved to hive');
    } else {
      // debugPrint('ohe eta hbe na');
    }
    if (index == 0) {
      await Boxes.dcrUsers().clear();

      await Boxes.getMedicine().clear();

      setState(() {
        currentSelected = index;
      });
    }
  }

  Future<void> deleteRxDoctor(RxDcrDataModel rxDcrDataModel) async {
    rxDcrDataModel.delete();
  }

  deletRxMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
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
      appBar: AppBar(title: const Text('Draft Prescription'), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.rxdDoctor().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final rxDoctor = box.values.toList().cast<RxDcrDataModel>();

            return genContent(rxDoctor);
          },
        ),
      ),
    );
  }

  Widget genContent(List<RxDcrDataModel> user) {
    if (user.isEmpty) {
      deleteChace();

      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          int space = user[index].presImage.indexOf(" ");
          String removeSpace = user[index].presImage.substring(space + 1, user[index].presImage.length);
          String finalImage = removeSpace.replaceAll("'", '');

          return GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 207, 240, 207),
              child: ExpansionTile(
                childrenPadding: const EdgeInsets.all(0),
                // tilePadding: EdgeInsets.all(0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight / 8,
                        width: screenWidth / 6,
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(finalImage)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        // onPressed: () => deleteUser(user[index]),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to Delete The RX?"),
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
                                      final rxDoctorkey = user[index].uiqueKey;
                                      deleteRxDoctor(user[index]);
                                      // deleteItem(user[index]);

                                      deletRxMedicinItem(rxDoctorkey);
                                      setState(() {});
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
                          final dcrKey = user[index].uiqueKey;
                          // debugPrint('dcr:$dcrKey');
                          filteredMedicin = [];
                          addedRxMedicinList.where((item) => item.uiqueKey == dcrKey).forEach(
                            (item) {debugPrint('gsp: ${item.uiqueKey}');
                              final temp = MedicineListModel(
                                  uiqueKey: item.uiqueKey,
                                  strength: item.strength,
                                  brand: item.brand,
                                  company: item.company,
                                  formation: item.formation,
                                  name: item.name,
                                  generic: item.generic,
                                  itemId: item.itemId,
                                  quantity: item.quantity);

                              filteredMedicin.add(temp);
                            },
                          );

                          if ((user[index].presImage != "") && filteredMedicin.isEmpty) {
                            print('image: ${user[index].presImage}');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RxPage(
                                  ck: 'isCheckedByImage',
                                  dcrKey: dcrKey,
                                  uniqueId: user[index].uiqueKey,
                                  draftRxMedicinItem: filteredMedicin,
                                  docName: user[index].docName,
                                  docId: user[index].docId,
                                  areaName: user[index].areaName,
                                  areaId: user[index].areaId,
                                  address: user[index].address,
                                  image1: user[index].presImage,
                                  dcrGrad: user[index].dcrGrad,

                                  phnNum: user[index].phnNum.toString(),
                                  patientName: user[index].patientName.toString(),
                                  gender: user[index].gender.toString(),
                                  dob: user[index].dob.toString(),
                                  stripWastage: user[index].stripWastage.toString(),

                                  systemName: user[index].systemName.toString(),
                                  disease: user[index].disease.toString(),
                                  patientTemperament: user[index].patientTemperament.toString(),
                                  beforeDiabetes: user[index].diabetesBefore.toString(),
                                  afterDiabetes: user[index].diabetesAfter.toString(),
                                  bloodSystolic: user[index].bloodSystolic.toString(),
                                  bloodDiastolic: user[index].bloodDiastolic.toString(),
                                  oxygenLevel: user[index].oxygenLevel.toString(),
                                  bodyTemperature: user[index].bodyTemperature.toString(),
                                  weight: user[index].weight.toString(),
                                  heightFeet: user[index].heightFeet.toString(),
                                  heightInch: user[index].heightInch.toString(),

                                ),
                              ),
                            );
                          }
                          else {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RxPage(
                                  ck: 'isCheck',
                                  dcrKey: dcrKey,
                                  uniqueId: user[index].uiqueKey,
                                  draftRxMedicinItem: filteredMedicin,
                                  docName: user[index].docName,
                                  docId: user[index].docId,
                                  areaName: user[index].areaName,
                                  areaId: user[index].areaId,
                                  address: user[index].address,
                                  image1: user[index].presImage,
                                  dcrGrad: user[index].dcrGrad,

                                  phnNum: user[index].phnNum.toString(),
                                  patientName: user[index].patientName.toString(),
                                  gender: user[index].gender.toString(),
                                  dob: user[index].dob.toString(),
                                  stripWastage: user[index].stripWastage.toString(),

                                  systemName: user[index].systemName.toString(),
                                  disease: user[index].disease.toString(),
                                  patientTemperament: user[index].patientTemperament.toString(),
                                  beforeDiabetes: user[index].diabetesBefore.toString(),
                                  afterDiabetes: user[index].diabetesAfter.toString(),
                                  bloodSystolic: user[index].bloodSystolic.toString(),
                                  bloodDiastolic: user[index].bloodDiastolic.toString(),
                                  oxygenLevel: user[index].oxygenLevel.toString(),
                                  bodyTemperature: user[index].bodyTemperature.toString(),
                                  weight: user[index].weight.toString(),
                                  heightFeet: user[index].heightFeet.toString(),
                                  heightInch: user[index].heightInch.toString(),
                                ),
                              ),
                            );
                          }

                        },

                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
                          // size: 30,
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

  Future deleteChace() async {
    await getTemporaryDirectory().then(
      (value) {
        Directory(value.path).delete(recursive: true);
      },
    );
  }
}
