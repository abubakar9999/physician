// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/service/all_service.dart';
import '../../../data/service/apiCall.dart';
import '../../../data/service/network_connectivity.dart';


class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  List expSummaryList = [];
  bool isloadding = false;
  bool isFFListLoading = false;
  bool is_show = false;

  final box = Boxes.allData();

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  var total;

  DateTime dateTime = DateTime.now();

  /////////////////////
  ///
  final TextEditingController _searchController = TextEditingController();
  List<String> ff_list = [];
  List<String> user_level_list = [];
  String? ffType;
  String? ffUserId;
  String? _userCID;
  String? _userId;
  String? _userPass;

  @override
  void initState() {
    // TODO: implement initState
    // ff_list = box.get('ff_list') ?? [];
    user_level_list = box.get('user_basis_level_list') ?? [];
    _userCID = box.get('CID');
    _userId = box.get('user_id');
    _userPass = box.get('PASSWORD');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Summary"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: RichText(
                          text: const TextSpan(
                            text: 'Date Range',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.zero,
                          // width: 120,
                          // height: 70,
                          color: const Color.fromARGB(255, 138, 201, 149)
                              .withOpacity(.3),
                          child: TextField(
                            controller: fromDate,
                            decoration: InputDecoration(
                                hintText: toDate.text == ""
                                    ? "Select Date"
                                    : toDate.text,
                                hintStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                border: const OutlineInputBorder()),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final date = await pickDate();

                              if (date == null) {
                                return;
                              } else {
                                setState(
                                  () {
                                    fromDate.text =
                                        DateFormat('yyyy/MM/dd').format(date);
                                    // DateFormat.yMd().format(date);

                                    // debugPrint(dateController.text);
                                    // dateTime = date;
                                    // DateFormat.yMEd().format(dateTime);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: const TextSpan(
                            text: ' To',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                      // Text(
                      //   "To",
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.zero,
                          // width: 120,
                          // height: 45,
                          color: const Color.fromARGB(255, 138, 201, 149)
                              .withOpacity(.3),
                          child: TextField(
                            controller: toDate,
                            decoration: InputDecoration(
                                hintText: toDate.text == ""
                                    ? "Select Date"
                                    : toDate.text,
                                hintStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                border: const OutlineInputBorder()),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final date = await pickDate();

                              if (date == null) {
                                return;
                              } else {
                                setState(
                                  () {
                                    toDate.text =
                                        DateFormat('yyyy/MM/dd').format(date);
                                    // debugPrint(dateController.text);
                                    // dateTime = date;
                                    // DateFormat.yMEd().format(dateTime);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      // ElevatedButton(onPressed: () {}, child: Text("Show")),
                    ],
                  ),
                ),
                user_level_list.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RichText(
                                    text: const TextSpan(
                                      // text: ' To',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select FF Type',
                                        ),
                                        items: user_level_list
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: ffType,
                                        onChanged: (value) async {
                                          setState(() {
                                            ffType = value as String;
                                            isFFListLoading = true;
                                            ff_list.clear();
                                            ffUserId = null;
                                          });
                                          bool result =
                                              await NetworkConnecticity
                                                  .checkConnectivity();
                                          if (result) {
                                            ff_list = await getFFList(
                                              cid: _userCID,
                                              userId: _userId,
                                              userPass: _userPass,
                                              ffType:
                                                  "${value.toString().toUpperCase()}",
                                            );
                                          } else {
                                            AllServices().messageForUser(
                                                'Please Check your Internet connection');
                                          }

                                          await Future.delayed(
                                              Duration(seconds: 5));
                                          setState(() {
                                            isFFListLoading = false;
                                          });
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          height: 40,
                                          // width: 200,
                                        ),
                                        dropdownStyleData:
                                            const DropdownStyleData(
                                          maxHeight: 300,
                                        ),
                                        // menuItemStyleData: const MenuItemStyleData(
                                        //   height: 40,
                                        // ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isFFListLoading == true
                                ? CircularProgressIndicator()
                                : ff_list.isNotEmpty
                                    ? Row(
                                        children: [
                                          Expanded(flex: 1, child: SizedBox()),
                                          Expanded(
                                            flex: 15,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.black38,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select FF ID',
                                                  ),
                                                  items: ff_list
                                                      .map((item) =>
                                                          DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: ffUserId,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      ffUserId =
                                                          value as String;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    height: 40,
                                                    // width: 200,
                                                  ),
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                    maxHeight: 300,
                                                  ),
                                                  // menuItemStyleData: const MenuItemStyleData(
                                                  //   height: 40,
                                                  // ),
                                                  dropdownSearchData:
                                                      DropdownSearchData(
                                                    searchController:
                                                        _searchController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget:
                                                        Container(
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 4,
                                                        right: 8,
                                                        left: 8,
                                                      ),
                                                      child: TextFormField(
                                                        expands: true,
                                                        maxLines: null,
                                                        controller:
                                                            _searchController,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                          hintText:
                                                              'Search ...',
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    searchMatchFn:
                                                        (item, searchValue) {
                                                      print(searchValue);
                                                      return (item.value
                                                          .toString()
                                                          .contains(searchValue
                                                              .toUpperCase()));
                                                    },
                                                  ),
                                                  //This to clear the search value when you close the menu
                                                  onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      _searchController.clear();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                          ],
                        ),
                      )
                    : SizedBox(),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 16, 121, 207),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      bool result =
                          await NetworkConnecticity.checkConnectivity();
                      if (result) {}
                      setState(() {
                        isloadding = true;
                        is_show = true;
                      });
                      total = null;
                      if (fromDate.text != "" && toDate.text != "") {
                        if (result) {
                          expSummaryList = await ExpenseSummary(
                            initialDate: fromDate.text,
                            lastDate: toDate.text,
                            ffType: ffType ?? '',
                            ffuserId: (ffUserId.toString().contains("|")
                                    ? ffUserId.toString().split("|")[1]
                                    : ffUserId) ??
                                '',
                          );
                        } else {
                          AllServices().messageForUser(
                              'Please Check your Internet connection');
                        }
                      } else {
                        AllServices().messageForUser("Date required");
                      }

                      // if (user_level_list.isEmpty) {
                      //   if (fromDate.text != "" && toDate.text != "") {
                      //     if (result) {
                      //       expSummaryList = await ExpenseSummary(
                      //         initialDate: fromDate.text,
                      //         lastDate: toDate.text,
                      //         ffType: "MPO",
                      //         ffuserId: (ffUserId.toString().contains("|")
                      //                 ? ffUserId.toString().split("|")[1]
                      //                 : ffUserId) ??
                      //             '',
                      //       );
                      //     } else {
                      //       AllServices().messageForUser(
                      //           'Please Check your Internet connection');
                      //     }
                      //   } else {
                      //     AllServices()
                      //         .messageForUser("Please Select Date Range");
                      //   }
                      // } else {
                      //   if (fromDate.text != "" &&
                      //       toDate.text != "" &&
                      //       (ffType.toString().isNotEmpty && ffType != null)) {
                      //     if (result) {
                      //       expSummaryList = await ExpenseSummary(
                      //         initialDate: fromDate.text,
                      //         lastDate: toDate.text,
                      //         ffType: ffType ?? '',
                      //         ffuserId: (ffUserId.toString().contains("|")
                      //                 ? ffUserId.toString().split("|")[1]
                      //                 : ffUserId) ??
                      //             '',
                      //       );
                      //     } else {
                      //       AllServices().messageForUser(
                      //           'Please Check your Internet connection');
                      //     }
                      //   } else {
                      //     AllServices()
                      //         .messageForUser("Date and FF type required");
                      //   }
                      // }

                      for (var element in expSummaryList) {
                        if (total == null) {
                          total = element["exp_amt"];
                        } else {
                          total += element["exp_amt"];
                        }
                      }
                      // ignore: avoid_print
                      print(total);

                      debugPrint("list ashbe $expSummaryList");
                      setState(() {
                        isloadding = false;
                      });
                    },
                    child: const Text(
                      "Show",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
            tileColor: Color.fromARGB(255, 169, 219, 202),
            contentPadding: EdgeInsets.fromLTRB(5, -3, 5, -3),
            leading: SizedBox(
              height: 30,
              width: 140,
              // decoration: BoxDecoration(
              //     color: const Color.fromARGB(255, 81, 233, 187),
              //     borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  "Expense Head",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            trailing: SizedBox(
              height: 30,
              width: 110,
              // decoration: BoxDecoration(
              //     color: const Color.fromARGB(255, 81, 233, 187),
              //     borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  "Amount",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          is_show
              ? isloadding
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : expSummaryList.isNotEmpty
                      ? Expanded(
                          child: Container(
                            color: const Color(0xff56CCF2).withOpacity(.3),
                            child: ListView.builder(
                                itemCount: expSummaryList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    leading: Text(
                                      expSummaryList[index]["exp_type"],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(
                                      expSummaryList[index]["exp_amt"]
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : const Text(
                          "No Data Found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
              : const SizedBox.shrink(),
          expSummaryList.isEmpty
              ? const Spacer()
              : ListTile(
                  tileColor: const Color.fromARGB(255, 169, 219, 202),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    total == null ? "0" : total.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015),
        // firstDate: DateTime(dateTime.year, dateTime.month - 2, dateTime.day),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE2EFDA),
                surface: Color.fromARGB(255, 37, 199, 78),
              ),
              dialogBackgroundColor: const Color.fromARGB(255, 38, 187, 233),
            ),
            child: child!,
          );
        },
      );
}
