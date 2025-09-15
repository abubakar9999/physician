//  box = Hive.box("draftForExpense");

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/service/apiCall.dart';
import '../../Widgets/custom_dialog.dart';
import 'expense_section.dart';


// ignore: must_be_immutable
class ExpenseEntry extends StatefulWidget {
  final String? draftDate;
  final String? draftExpenseCategory;
  const ExpenseEntry({
    Key? key,
    this.draftDate,
    this.draftExpenseCategory,
  }) : super(key: key);
  @override
  State<ExpenseEntry> createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
  //DateFormat.yMd().format(DateTime.now());;
  DateTime selectDate = DateTime.now();
  TextEditingController dateController =
      TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  bool isclickd = true;
  final mydata = Boxes.allData();
  // bool isOutStation = false;
  Map<String, Map<String, dynamic>> map = {};

  List<String> expenseCategoryList = [];
  String? expenseCategory;
  bool isLoading = false;

  saveExpense() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (expenseCategory != null) {
      Box box = Hive.box("draftForExpense");
      box.put("${dateController.text.toString()} ${expenseCategory}", map);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ExpensePage()),
          (route) => route.isFirst);
    } else {
      Fluttertoast.showToast(
          msg: "Select Working Place",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _onItemTapped(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == 0) {
      saveExpense();
    } else if (index == 1) {}

    if (index == 2) {
      bool hasdata = false;
      debugPrint(Hive.box("draftForExpense").values.toString());

      Box box = Hive.box("draftForExpense");
      String submitDate = dateController.text;
      String itemString = '${expenseCategory.toString()}|1';
      if (submitDate != "") {
        debugPrint("My map $map");

        map.forEach((key, value) {
          if (double.parse(value['amount'].toString()) > 0) {
            hasdata = true;

            debugPrint(key);
            debugPrint(value['amount']);
            if (itemString == '') {
              // if (isOutStation == true) {
              //   itemString = 'outstation|1||$key|${value['amount']}';
              // } else {
              //   itemString = '$key|${value['amount']}';
              // }
              itemString = '$key|${value['amount']}';
            } else {
              itemString += '||$key|${value['amount']}';
            }
          }
        });

        var dcrkey;
        // if (hasdata && isclickd) {
        if (hasdata || itemString.isNotEmpty) {
          if (expenseCategory != null) {
            await getboxData();
            customDialog(
              title: "Confirm",
              content: "Are you sure want to submit Expense?",
              cancelOnTap: () {
                print("object");
                Get.back(canPop: false);
              },
              confirmOnTap: () async {
                try {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back(canPop: true);
                  // isclickd = false;

                  print("issssssssssfalsess444ssssssssumbmit $isclickd");
                  setState(() {
                    isLoading = true;
                  });
                  var expSubmission =
                      await SubmitToExpense(submitDate, itemString);
                  setState(() {
                    isLoading = false;
                  });

                  var retString = expSubmission["ret_str"];
                  if (expSubmission["status"] == "Success") {
                    for (var element in box.keys) {
                      if (element == "${submitDate} ${expenseCategory}") {
                        dcrkey = element;
                        debugPrint("All keys :$dcrkey   $submitDate");
                      } else {
                        debugPrint("All no match :");
                      }
                    }

                    box.delete(dcrkey);
                    Fluttertoast.showToast(
                        msg: "Expense Submitted",
                        // msg: "Order Submitted\n$ret_str",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // isclickd = true;
                    print("issssssssssssssssssumbmit $isclickd");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpensePage()),
                        (route) => route.isFirst);
                  } else {
                    Fluttertoast.showToast(
                        msg: retString,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } catch (e) {
                  print("------------------- ${e.toString()}");
                }
              },
            );
          } else {
            Fluttertoast.showToast(
                msg: "Select Working Place",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please add Your Expense",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    List<dynamic> dynamicList = mydata.get("expense_category_list");
    expenseCategoryList = dynamicList.cast<String>();

    if (expenseCategoryList.isNotEmpty) {
      expenseCategory = widget.draftExpenseCategory != null
          ? widget.draftExpenseCategory
          : expenseCategoryList[0];
    }

    //    expenseData api
    //    draftForExpense save

    print('00000000000000000$expenseCategoryList');
    print(widget.draftDate);
    print("++++++++++++++++++++++ ${Hive.box("draftForExpense").toMap()}");

    if (widget.draftDate == null) {
      for (Map e in Hive.box("expenseData").values) {
        Map<String, dynamic> m = {'exp_type': e['exp_type'], 'amount': 0.0};
        map[e['cat_type_id']] = m;
      }
      updateIfExistValue();
    } else {
      dateController.text = widget.draftDate.toString();
      // selectDate=DateTime.parse(); 2023-03-27 11:27:23.112995 3/25/2023
      // selectDate=DateTime.parse('3/25/2023');

      String date = (int.parse(widget.draftDate!.split('/')[1]) < 10)
          ? '0${widget.draftDate!.split('/')[1]}'
          : widget.draftDate!.split('/')[1];
      String month = (int.parse(widget.draftDate!.split('/')[0]) < 10)
          ? '0${widget.draftDate!.split('/')[0]}'
          : widget.draftDate!.split('/')[0];
      String year = widget.draftDate!.split('/')[2];
      selectDate = DateTime.parse('$year-$month-$date 00:00:00.00');

      for (Map e in Hive.box("expenseData").values) {
        Map<String, dynamic> m = {'exp_type': e['exp_type'], 'amount': 0.0};
        map[e['cat_type_id']] = m;
      }
      updateIfExistValue();
    }
  }

  void updateIfExistValue() {
    if (Hive.box("draftForExpense")
        .keys
        .toString()
        .contains("${dateController.text.toString()} ${expenseCategory}")) {
      Map mp = Hive.box("draftForExpense")
              .get("${dateController.text.toString()} ${expenseCategory}") ??
          {};

      for (String id in map.keys.toList()) {
        if (mp.containsKey(id)) {
          map[id]!['amount'] = mp[id]['amount'];
        }
      }
    } else {
      for (String id in map.keys.toList()) {
        map[id]!['amount'] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Expense Entry"),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   child: Row(
                //     children: [
                //       TextField(
                //         controller: dateController,
                //         onTap: () async {
                //           await pickDate();
                //         },
                //         style: const TextStyle(color: Colors.black, fontSize: 18),
                //         readOnly: true,
                //         decoration: InputDecoration(
                //           hintText: dateController.text,
                //           hintStyle:
                //               const TextStyle(color: Colors.black, fontSize: 18),
                //           border: const OutlineInputBorder(),
                //           suffixIcon:
                //               const Icon(Icons.calendar_today, color: Colors.teal),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            controller: dateController,
                            onTap: () async {
                              await pickDate();
                            },
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            readOnly: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: dateController.text,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, -20.0, 10.0),
                              hintStyle: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.teal,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      // Expanded(
                      //   child: Container(
                      //     height: 40.0,
                      //     padding: EdgeInsets.only(left: 10.0),
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           width: 1.0,
                      //           color: Colors.black38,
                      //         ),
                      //         borderRadius: BorderRadius.circular(5.0)),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "Outstation",
                      //           style: TextStyle(fontSize: 16.0),
                      //         ),
                      //         Checkbox(
                      //           value: isOutStation,
                      //           activeColor: Colors.green,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               isOutStation = value!;
                      //             });
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.black38,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            value: expenseCategory,
                            isExpanded: true,
                            hint: Text(
                              "Select Working Place",
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: expenseCategoryList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                expenseCategory = value!;
                                updateIfExistValue();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.black12,
                ),
                //--------------------------------------listview
                Expanded(
                  child: ListView.builder(
                    itemCount: map.values.length,
                    itemBuilder: (context, index) {
                      TextEditingController amountController =
                          TextEditingController(
                        text: map.values.toList()[index]['amount'] == 0
                            ? ""
                            : map.values.toList()[index]['amount'].toString(),
                      );
                      return Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  map.values
                                      .toList()[index]['exp_type']
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3),
                                  width: 80,
                                  height: 60,
                                  child: Center(
                                    child: TextField(
                                      controller: amountController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        map[map.keys.toList()[index]]![
                                            'amount'] = value;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: BottomAppBar(
            height: 50.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  saveExpense();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: const Color.fromARGB(255, 4, 60, 105),
                  maximumSize: const Size(200, 50),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(5))),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save, size: 30),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Save Expense",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   type: BottomNavigationBarType.fixed,
          //   onTap: _onItemTapped,
          //   //currentIndex: _currentSelected,
          //   showUnselectedLabels: true,
          //   unselectedItemColor: Colors.grey[800],
          //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       label: 'Save Drafts',
          //       icon: Icon(Icons.drafts),
          //     ),

          //     BottomNavigationBarItem(
          //       label: '',
          //       backgroundColor: Colors.white,
          //       icon: Icon(
          //         Icons.add,
          //         color: Colors.white,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Submit',
          //       icon: Icon(Icons.save),
          //     ),
          //     // BottomNavigationBarItem(
          //     //   label: 'Drawer',
          //     //   icon: Icon(Icons.menu),
          //     // )
          //   ],
          // ),
        ),
        isLoading == true
            ? Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
                child: CircularProgressIndicator(),
              )
            : SizedBox(),
      ],
    );
  }

  Future<void> pickDate() async {
    await showDatePicker(
      context: context,
      initialDate: selectDate,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month - 2, DateTime.now().day),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          selectDate = value;
          dateController.text = DateFormat.yMd().format(value);
          updateIfExistValue();
        });
      }
    });
  }
}
