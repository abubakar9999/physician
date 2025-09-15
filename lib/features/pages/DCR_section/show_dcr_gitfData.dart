// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/datasources/local_storage/hive_data_model.dart';

class DcrGiftDataPage extends StatefulWidget {
  int uniqueId;
  List doctorGiftlist;
  List<DcrGSPDataModel> tempList;
  Function(List<DcrGSPDataModel>) tempListFunc;
  DcrGiftDataPage({Key? key, required this.uniqueId, required this.doctorGiftlist, required this.tempList, required this.tempListFunc}) : super(key: key);

  @override
  State<DcrGiftDataPage> createState() => _DcrGiftDataPageState();
}

class _DcrGiftDataPageState extends State<DcrGiftDataPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  final List<TextEditingController> _itemController = [];
  Map<String, TextEditingController> controllers = {};
  List foundUsers = [];

  final _formkey = GlobalKey<FormState>();

  String? itemId;

  @override
  void initState() {
    super.initState();
    foundUsers = widget.doctorGiftlist;
    // for (var element in foundUsers) {
    //   controllers[element['gift_id']] = TextEditingController();
    // }
    //
    // for (var element in widget.tempList) {
    //   controllers.forEach((key, value) {
    //     if (key == element.giftId) {
    //       value.text = element.quantity.toString();
    //     }
    //   });
    // }

    for (var element in foundUsers) {
      final key = element['gift_id'].toString() + element['promo_type'].toString();
      controllers[key] = TextEditingController();
    }
    for (var item in widget.tempList) {
      final key = item.giftId + item.giftType;
      if (controllers.containsKey(key)) {
        controllers[key]!.text = item.quantity.toString();
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();

    // foundUsers.forEach((element) {
    //   controllers[element['gift_id']]!.dispose();
    // });
    super.dispose();
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.doctorGiftlist;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      var starts = foundUsers.where((s) => s['gift_name'].toLowerCase().startsWith(enteredKeyword.toLowerCase())).toList();

      var contains = foundUsers.where((s) => s['gift_name'].toLowerCase().contains(enteredKeyword.toLowerCase()) || s['gift_id'].toLowerCase().contains(enteredKeyword.toLowerCase())).toList()..sort((a, b) => a['gift_name'].toLowerCase().compareTo(b['gift_name'].toLowerCase()));

      results = [...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('Gift'),
        titleTextStyle: const TextStyle(color: Color.fromARGB(255, 27, 56, 34), fontWeight: FontWeight.w500, fontSize: 20),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        onChanged: (value) => runFilter(value),
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Gift Search',
                          suffixIcon: searchController.text.isEmpty && searchController.text == ''
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Form(
              key: _formkey,
              child: foundUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.only(bottom: keyboardHeight + 10.0),
                      itemCount: foundUsers.length,
                      itemBuilder: (context, index) {

                        final gift = foundUsers[index];
                        final key = gift['gift_id'].toString() + gift['promo_type'].toString();
                        final leftQty = gift['gift_left_qty'] ?? 0;
                        final controller = controllers[key]!;

                        debugPrint('qty: ${foundUsers[index]['gift_left_qty']}');

                        _itemController.add(TextEditingController());

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color.fromARGB(108, 255, 255, 255), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  foundUsers[index]['gift_name'],
                                                  style: const TextStyle(color: Color.fromARGB(255, 30, 66, 77), fontSize: 18),
                                                ),
                                                const SizedBox(width: 10,),
                                                foundUsers[index]['gift_left_qty']==0 ? const SizedBox.shrink() : Text(
                                                  //'(${foundUsers[index]['gift_left_qty']}/${foundUsers[index]['gift_total_qty']})',
                                                  '(${foundUsers[index]['gift_left_qty']})',
                                                  style: const TextStyle(color: Colors.red, fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              foundUsers[index]['gift_id'],
                                              style: const TextStyle(color: Color.fromARGB(255, 30, 66, 77), fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Card(
                                              elevation: 1,
                                              child: Container(
                                                height: 40,
                                                color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                                                width: 70,
                                                child: TextFormField(
                                                  onTap: (){
                                                    if(foundUsers[index]['gift_left_qty']==0){
                                                      Fluttertoast.showToast(msg: 'Item is not available',backgroundColor: Colors.red);
                                                    }
                                                  },
                                                  textAlign: TextAlign.center,
                                                  keyboardType: const TextInputType.numberWithOptions(
                                                    decimal: true,
                                                  ),
                                                  maxLength: 4,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.digitsOnly,
                                                  ],
                                                  controller: controller,
                                                  readOnly: foundUsers[index]['gift_left_qty']==0,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
                                                  ),
                                                  // onChanged: (value) {
                                                  //   setState(() {});
                                                  //   if (value != '' && value != "0") {
                                                  //     final temp = DcrGSPDataModel(uiqueKey: widget.uniqueId, quantity: int.parse(controllers[foundUsers[index]['gift_id']]!.text), giftName: foundUsers[index]['gift_name'], giftId: foundUsers[index]['gift_id'], giftType: 'Gift');
                                                  //
                                                  //
                                                  //     String tempItemId = temp.giftId;
                                                  //
                                                  //     widget.tempList.removeWhere((item) => item.giftId == tempItemId);
                                                  //
                                                  //     widget.tempList.add(temp);
                                                  //   } else if (value == '') {
                                                  //     final temp = DcrGSPDataModel(
                                                  //       uiqueKey: widget.uniqueId,
                                                  //       quantity: value == '' ? 0 : int.parse(controllers[foundUsers[index]['gift_id']]!.text),
                                                  //       giftName: foundUsers[index]['gift_name'],
                                                  //       giftId: foundUsers[index]['gift_id'],
                                                  //       giftType: 'Gift',
                                                  //     );
                                                  //
                                                  //     String tempItemId = temp.giftId;
                                                  //
                                                  //     widget.tempList.removeWhere((item) => item.giftId == tempItemId);
                                                  //
                                                  //     setState(() {});
                                                  //   }
                                                  // },
                                                  onChanged: (value) {
                                                    final inputQty = int.tryParse(value) ?? 0;

                                                    if (inputQty > leftQty) {
                                                      Fluttertoast.showToast(
                                                        msg: 'Only $leftQty items available',
                                                        backgroundColor: Colors.red,
                                                      );

                                                      // Reset back to max available
                                                      controllers[key]!.text = leftQty.toString();
                                                      controllers[key]!.selection = TextSelection.fromPosition(
                                                        TextPosition(offset: controllers[key]!.text.length),
                                                      );
                                                      return;
                                                    }

                                                    setState(() {});

                                                    if (inputQty > 0) {
                                                      final model = DcrGSPDataModel(
                                                        uiqueKey: widget.uniqueId,
                                                        quantity: inputQty,
                                                        giftName: gift['gift_name'],
                                                        giftId: gift['gift_id'],
                                                        giftType: gift['promo_type'],
                                                      );

                                                      widget.tempList.removeWhere((item) =>
                                                      item.giftId == model.giftId && item.giftType == model.giftType);
                                                      widget.tempList.add(model);
                                                    } else {
                                                      widget.tempList.removeWhere((item) =>
                                                      item.giftId == gift['gift_id'] && item.giftType == gift['promo_type']);
                                                    }
                                                  },
                                                ),
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
                          ),
                        );
                      })
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                widget.tempListFunc(widget.tempList);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color.fromARGB(255, 4, 60, 105),
                maximumSize: const Size(200, 50),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(5))),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_shopping_cart_outlined, size: 30),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "AddToCart",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
