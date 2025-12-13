// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, prefer_typing_uninitialized_variables, unused_field
// ignore_for_file: avoid_function_literals_in_foreach_calls, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:photo_view/photo_view.dart';

import '../../data/datasources/local_storage/hive_data_model.dart';

String searchControlled = "";
final GlobalKey<ScaffoldState> medkey = GlobalKey();

class MedicinListScreen extends StatefulWidget {
  List medicineData;
  List<MedicineListModel> tempList;
  int counter;
  File? img;
  String img1;
  Function(List<MedicineListModel>) tempListFunc;

  MedicinListScreen({Key? key, required this.medicineData, required this.tempList, required this.counter, required this.tempListFunc, required this.img, required this.img1}) : super(key: key);

  @override
  State<MedicinListScreen> createState() => _MedicinListScreenState();
}

class _MedicinListScreenState extends State<MedicinListScreen> {
  Box? box;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  List<MedicineListModel> newItem = [];
  List finalAdd = [];
  List foundUsers = [];
  bool ok = true;
  bool value = false;
  String? tempId;
  var selectedMed;
  Map pressedActivity = {};
  bool medAdd = false;
  int _currentSelected = 2;
  int items = 0;
  var data = 0;

  @override
  void initState() {
    debugPrint("kkkkkkkkkkkkkkk:$finalAdd");
    if (widget.tempList.isNotEmpty) {
      items = widget.tempList.length;
    }
    foundUsers = widget.medicineData;

    foundUsers.forEach((element) {
      pressedActivity[element["item_id"]] = false;
    });
    if (searchControlled != "") {
      setState(() {
        searchController.text = searchControlled;
        runFilter(searchController.text);
      });
    }
    debugPrint(searchControlled);

    super.initState();
  }

  @override
  void dispose() {
    medicineController.dispose();
    super.dispose();
  }

  // numberOfFinalMed() {
  //   var number = 0;
  //   List idFAList = [];
  //   List idWTList = [];
  //   String newId;
  //   widget.tempList.forEach((element) {
  //     idWTList.add(element.itemId);
  //   });
  //   finalAdd.forEach((item) {
  //     idFAList.add(item["item_id"]);
  //   });
  //   for (int l = 0; l < idFAList.length; l++) {
  //     newId = idFAList[l];
  //     if (idWTList.contains(newId)) {
  //       number = idWTList.length;
  //     } else {
  //       idWTList.add(newId);

  //       number = idWTList.length;
  //     }
  //   }
  //   number = idWTList.length;
  //   return number;
  // }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.medicineData;
    searchControlled = enteredKeyword;
    debugPrint(searchControlled);
    // debugPrint("medicine list ${widget.medicineData.length}");
    List results = [];
    // if (enteredKeyword.isEmpty) {
    //   // if the search field is empty or only contains white-space, we'll display all users
    //   foundUsers;
    //   // results = foundUsers;
    // } else {
    var starts = foundUsers.where((s) => s['name'].toLowerCase().startsWith(enteredKeyword.toLowerCase())).toList();

    var contains = foundUsers.where((s) => s['name'].toLowerCase().contains(enteredKeyword.toLowerCase()) && !s['name'].toLowerCase().startsWith(enteredKeyword.toLowerCase())).toList()..sort((a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));

    results = [...starts, ...contains];
    // }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  // late List<bool> pressedAttentions = foundUsers.map((e) => false).toList();

  void onItemTapped(int index) async {
    if (index == 0) {
      // setState(() {
      //   _isLoading = false;
      // });
      // orderSubmit();

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 1) {
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await addMedicine(context);
        return false;
      },
      child: Scaffold(
        key: medkey,
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: true,
        // endDrawerEnableOpenDragGesture: true,
        appBar: AppBar(leading: const BackButton(color: Colors.white), backgroundColor: Colors.blue, title: const Text('Prescription Medicine-List '), titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), centerTitle: true),

        drawer: buildDrawerWidget(context),

        body: Column(
          children: [
            widget.img == null
                ? SizedBox(height: MediaQuery.of(context).size.height / 2, width: MediaQuery.of(context).size.width, child: PhotoView(imageProvider: FileImage(File(widget.img1)), enableRotation: true, filterQuality: FilterQuality.high, enablePanAlways: false, maxScale: 4.0))
                : SizedBox(height: MediaQuery.of(context).size.height / 2, width: MediaQuery.of(context).size.width / 1, child: PhotoView(imageProvider: FileImage(widget.img!), enableRotation: true, filterQuality: FilterQuality.high, enablePanAlways: false, maxScale: 4.0)),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // medAdd = true;

        //     // debugPrint("med add hbe ${medAdd}");
        //   },
        //   child: const Text('Add'),
        // ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      debugPrint("drawer");
                      // Scaffold.of(context).openEndDrawer;
                      medkey.currentState!.openDrawer();
                      // medkey.currentState!.openEndDrawer();

                      // buildDrawerWidget(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 18, 16),
                      child: Column(
                        children: [
                          // const SizedBox(
                          //   height: 13,
                          // ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              "assets/images/cap.png",
                              height: 45,
                              width: 40,
                              fit: BoxFit.cover,
                              // color: Colors.blue,
                            ),
                          ),
                          const Text("Medicine"),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      addMedicine(context);
                    },
                    child: Column(
                      children: [
                        const Text(""),
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            SizedBox(height: 50, width: 50, child: Image.asset("assets/images/done.png", height: 60, width: 60, fit: BoxFit.cover)),
                            Positioned(
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    // numberOfFinalMed().toString(),
                                    finalAdd.isNotEmpty ? data.toString() : items.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text('Done'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await addMedicine(context);
        return false;
      },
      child: SafeArea(
        child: Drawer(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      // if (searchControlled != "") {
                      //   runFilter(searchControlled);
                      // } else {
                      runFilter(value);
                      // }
                    },
                    autofocus: searchControlled != "" ? true : false,
                    controller: searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Search Medicine',
                      suffixIcon:
                          searchController.text.isEmpty && searchController.text == ''
                              ? const Icon(Icons.search)
                              : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  runFilter('');
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                  // size: 28,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              foundUsers.isNotEmpty
                  ? Expanded(
                    flex: 9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: foundUsers.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final pressAttention = pressedActivity[foundUsers[index]['item_id']];
                        bool isSelectedItem = false;
                        for (int i = 0; i < widget.tempList.length; i++) {
                          if (widget.tempList[i].itemId == foundUsers[index]['item_id']) {
                            isSelectedItem = true;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            // PressAttention = bool? where its selected == true, unselected == false, according to  item id of the list

                            setState(() => pressedActivity[foundUsers[index]['item_id']] = !pressAttention!);

                            selectedMed = foundUsers[index];
                            if (pressedActivity[selectedMed['item_id']] == true) {
                              finalAdd.add(selectedMed);
                            } else {
                              finalAdd.remove(selectedMed);
                            }
                            mycount();
                            // debugPrint(selectedMed);
                            // debugPrint(finalAdd);
                            // mycount(finalAdd);
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white70, width: 1), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  // flex: 9,
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(color: pressAttention! || isSelectedItem ? const Color.fromARGB(255, 85, 148, 243).withOpacity(.7) : Colors.white, borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${foundUsers[index]['name']} ',
                                                // '(${foundUsers[index]['item_id']})',
                                                style: const TextStyle(color: Color.fromARGB(255, 30, 66, 77), fontWeight: FontWeight.bold, fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  : const Text('No data found', style: TextStyle(fontSize: 24)),
              // DrawerHeader(
              //   decoration: const BoxDecoration(
              //     color: Color.fromARGB(255, 138, 201, 149),
              //   ),
              //   child: Image.asset('assets/images/mRep7_logo.png'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  addMedicine(context) {
    // debugPrint(finalAdd);
    // setState(() =>
    //                   pressedActivity[foundUsers[index]['item_id']] =
    //                       !pressAttention!);
    // if (pressedActivity[selectedMed['item_id']] == true) {
    finalAdd.forEach((element) {
      final temp = MedicineListModel(strength: element['strength'], name: element['name'], generic: element['generic'], brand: element['brand'], company: element['company'], formation: element['formation'], uiqueKey: widget.counter, itemId: element['item_id'], quantity: 1);
      final tempItemId = temp.itemId;
      print(temp);

      widget.tempList.removeWhere((item) => item.itemId == tempItemId);

      widget.tempList.add(temp);
    });

    // }
    //  else {
    //   finalAdd.forEach((element) {
    //     final temp = MedicineListModel(
    //         strength: element['strength'],
    //         name: element['name'],
    //         generic: element['generic'],
    //         brand: element['brand'],
    //         company: element['company'],
    //         formation: element['formation'],
    //         uiqueKey: widget.counter,
    //         itemId: element['item_id'],
    //         quantity: 1);
    //     final tempItemId = temp.itemId;
    //     widget.tempList.removeWhere((item) => item.itemId == tempItemId);
    //   });
    // }
    widget.tempListFunc(widget.tempList);

    Navigator.pop(context);
  }

  mycount() {
    finalAdd.forEach((element) {
      final temp = MedicineListModel(strength: element['strength'], name: element['name'], generic: element['generic'], brand: element['brand'], company: element['company'], formation: element['formation'], uiqueKey: widget.counter, itemId: element['item_id'], quantity: 1);
      setState(() {
        final tempItemId = temp.itemId;

        widget.tempList.removeWhere((item) => item.itemId == tempItemId);
        widget.tempList.add(temp);
      });
      data = widget.tempList.length;
      //  widget.tempListFunc(widget.tempList);
    });

    setState(() {
      items = data;
    });
  }

  addOrphanMedicine() {
    final newitem = MedicineListModel(strength: "", name: medicineController.text, generic: "", brand: "", company: "", formation: "", uiqueKey: widget.counter, itemId: "0", quantity: 1);
    // final tempItemId = newitem.itemId;

    // widget.tempList
    //     .removeWhere((item) => item.itemId == tempItemId);

    widget.tempList.add(newitem);
    // debugPrint(widget.tempList);

    widget.tempListFunc(widget.tempList);

    medicineController.text = "";
    Navigator.pop(context);
  }
}

class CustomDrawer {
  final Function updateMainScreen;
  CustomDrawer(this.updateMainScreen);
}

class ZoomForRxImage extends StatelessWidget {
  File? img;
  ZoomForRxImage(this.img, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(child: Hero(tag: 'imageHero', child: PhotoView(imageProvider: FileImage(img!)))),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class ZoomForRxDraftImage extends StatelessWidget {
  String? draftFinalImage;
  ZoomForRxDraftImage(this.draftFinalImage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(imageProvider: FileImage(File(draftFinalImage!))),
      // child:Hero (
      //   tag: 'imageForDraft',
      //   child: PhotoView(
      //     imageProvider: FileImage(File(draftFinalImage!)),
      //   ),
      // ),
    );
  }
}
