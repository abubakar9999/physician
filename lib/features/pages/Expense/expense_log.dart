// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../data/service/apiCall.dart';
import '../../Widgets/custom_dialog.dart';


// ignore: must_be_immutable
class ExpenseLogScreen extends StatefulWidget {
  const ExpenseLogScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseLogScreen> createState() => _ExpenseLogScreenState();
}

class _ExpenseLogScreenState extends State<ExpenseLogScreen> {
  TextEditingController dateExp = TextEditingController();
  List ExpenseLog = [];
  bool isloading = false;
  var isExpenseReSubmitLoading = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getdata();
    });
  }

  getdata() async {
    setState(() {
      isloading = true;
    });
    debugPrint("isloading is $isloading");
    var expReport = await ExpenseReport();
    setState(() {
      ExpenseLog = expReport["expList"];
    });
    isloading = false;
    debugPrint("is loading is $isloading");
  }

  IconAprrovalColor(x) {
    if (x == "Submitted") {
      return const Color.fromARGB(255, 6, 46, 155);
    } else if (x == "APPROVED") {
      return const Color.fromARGB(255, 216, 3, 92);
    } else {
      return const Color.fromARGB(255, 243, 234, 234);
    }
  }

  bgAprrovalColor(x) {
    if (x == "Submitted") {
      return Colors.lightBlue[100];
    } else if (x == "APPROVED") {
      return Color.fromARGB(255, 162, 227, 166);
    } else {
      return Color.fromARGB(255, 237, 156, 156);
    }
  }

  @override
  void dispose() {
    dateExp.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Expense Log"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              child: isloading == true
                  ? const Center(child: CircularProgressIndicator())
                  : ExpenseLog.isNotEmpty
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: ExpenseLog.length,
                                  itemBuilder: (_, index) {
                                    List ExpenseDetail =
                                        ExpenseLog[index]["expDetList"];
                                    String _expenseStatus =
                                        ExpenseLog[index]["status"];

                                    bool _isExpenseApproved = false;
                                    List<TextEditingController>
                                        amountController = [];
                                    if (ExpenseLog[index]["status"] ==
                                        "APPROVED") {
                                      _isExpenseApproved = true;
                                    } else {
                                      _isExpenseApproved = false;
                                    }

                                    // debugPrint(ExpenseDetail);
                                    return
                                        // Text(ExpenseLog["expList"][index]["exp_date"])
                                        Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Card(
                                        elevation: 2,
                                        color: bgAprrovalColor(
                                            ExpenseLog[index]["status"]),
                                        // color: Colors.lightBlue[100],
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          childrenPadding: EdgeInsets.zero,
                                          title: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 0, 0, 0),
                                              child: Container(
                                                height: 40,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    color: Colors
                                                        .greenAccent[100]),
                                                child: Center(
                                                  child: FittedBox(
                                                    child: Text(
                                                      "Date: ${ExpenseLog[index]["exp_date"]}",
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            trailing: Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.green),
                                                  color:
                                                      Colors.greenAccent[100]),
                                              child: Center(
                                                child: FittedBox(
                                                  child: Text(
                                                    "Total: ${ExpenseLog[index]["exp_amt_total"]}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: IconAprrovalColor(
                                                      ExpenseLog[index]
                                                          ["status"]),
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${ExpenseLog[index]["status"]}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: IconAprrovalColor(
                                                          ExpenseLog[index]
                                                              ["status"])),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 6, 12, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    "DESCRIPTION",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 150, 55, 42),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    "AMOUNT",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 150, 55, 42),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: ExpenseDetail.length,
                                                itemBuilder: (__, index) {
                                                  // debugPrint(ExpenseDetail.length);
                                                  amountController.add(
                                                      TextEditingController(
                                                          text:
                                                              "${ExpenseDetail[index]["exp_amt"]}"));
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 6, 12, 6),
                                                    child: Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              "${ExpenseDetail[index]["exp_type"]}"),
                                                        ),
                                                        _isExpenseApproved
                                                            ? SizedBox(
                                                                width: 80.0,
                                                                child:
                                                                    TextFormField(
                                                                  // maxLength: 6,
                                                                  readOnly: ExpenseDetail[index]["exp_type"] == "HQ" ||
                                                                          ExpenseDetail[index]["exp_type"] ==
                                                                              "EXHQ" ||
                                                                          ExpenseDetail[index]["exp_type"] ==
                                                                              "Outstation"
                                                                      ? true
                                                                      : false,
                                                                  controller:
                                                                      amountController[
                                                                          index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .numberWithOptions(
                                                                    decimal:
                                                                        true,
                                                                  ),
                                                                  inputFormatters: <
                                                                      TextInputFormatter>[
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly,
                                                                  ],
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                              )
                                                            : Text(
                                                                "${ExpenseDetail[index]["exp_amt"]}"),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 6, 12, 10),
                                              child: ExpenseLog[index]["reason"]
                                                      .toString()
                                                      .isNotEmpty
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "REASON: ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      150,
                                                                      55,
                                                                      42),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          "${ExpenseLog[index]["reason"]}",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ),
                                            Container(
                                              child: _isExpenseApproved
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();

                                                        reSubmit(
                                                            context,
                                                            amountController,
                                                            ExpenseDetail,
                                                            index);
                                                      },
                                                      child: Text("Re-Submit"),
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )
                      : const Center(
                          child: Text("No Data Found"),
                        ),
            ),
            Obx(
              () => isExpenseReSubmitLoading.value == true
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.2),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(),
            )
          ],
        ));
  }

  Future<dynamic> reSubmit(
      BuildContext context,
      List<TextEditingController> amountController,
      List<dynamic> ExpenseDetail,
      int index) {
    return customDialog(
      title: "Confirmation",
      content: "Do you want to resubmit the Expense?",
      cancelOnTap: () => Navigator.of(context).pop(),
      confirmOnTap: () async {
        Navigator.of(context).pop();
        try {
          isExpenseReSubmitLoading.value = true;
          await Future.delayed(Duration(seconds: 2));
          var expense_string = '';
          for (int i = 0; i < amountController.length; i++) {
            var expense_type = ExpenseDetail[i]["exp_type"];
            var expense_amount = double.tryParse(amountController[i].text) ?? 0;
            if (expense_amount > 0) {
              if (expense_string.isEmpty) {
                expense_string = "$expense_type|$expense_amount";
              } else {
                expense_string =
                    expense_string + "||" + "$expense_type|$expense_amount";
              }
            }
          }

          await expenseReSubmit(
            date: "${ExpenseLog[index]["exp_date"]}",
            expenseData: "$expense_string",
            refSL: "${ExpenseLog[index]["ref"]}",
          ).then(
            (_response) {
              if (_response.statusCode == 200) {
                var _data = jsonDecode(_response.body);
                if (_data['status'] == 'Success') {
                  Fluttertoast.showToast(
                      msg: "${_data['ret_str']}",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  getdata();
                } else {
                  Fluttertoast.showToast(
                      msg: "${_data['ret_str']}",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              } else {
                print("errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
                Fluttertoast.showToast(
                    msg: "Connection Error",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          );
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Connection Error",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } finally {
          isExpenseReSubmitLoading.value = false;
        }
        // setState(() {});
      },
    );
  }
}

// http://ww11.yeapps.com/ipi_api/api_expense_submit/submit_data_exp?cid=IBNSINA&user_id=itk&user_pass=1234&device_id=0fe01e0579c64417&exp_date=7/16/2023&exp_data=HQ|1||527|96||529|25
