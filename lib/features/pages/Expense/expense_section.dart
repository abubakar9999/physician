// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../../Widgets/custombutton.dart';
import '../Expense/expense_approval.dart';
import '../Expense/attendanceMtrHistory.dart';

import '../Expense/expense_draft_v2.dart';

import '../Expense/expense_entry_v2.dart';
import '../Expense/expense_log.dart';
import '../Expense/expense_report_page.dart';
import '../Expense/expense_summary.dart';



import '../../../data/datasources/local_storage/boxes.dart';

import '../attendance_page.dart';
import '../homePage.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  String userId = "";
  String userName = "";
  String user_pass = "";
  String expApproval = "";
  // String expense_report = "";
  String startTime = "";
  String cid = "";
  bool exp_approval_flag = false;
  var prefix;
  var prefix2;
  bool isClick = true;
  bool isloading = true;
  final databox = Boxes.allData();
  bool isExpenseSync = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      isExpenseSync = databox.get('isExpenseSync') ?? false;
      userId = databox.get("user_id") ?? "";
      cid = databox.get("CID") ?? "";
      userName = databox.get("userName") ?? "";
      user_pass = databox.get("PASSWORD") ?? "";
      expApproval = databox.get("exp_approval_url") ?? "";
      // expense_report = databox.get("report_exp_url");
      startTime = databox.get("startTime") ?? '';
      exp_approval_flag = databox.get("exp_approval_flag")!;

      debugPrint("Expense Flage:$exp_approval_flag");
      // debugPrint("start time ashbe $startTime");
      var parts = startTime.split(' ');
      prefix = parts[0].trim();
      // debugPrint(prefix);
      String dt = DateTime.now().toString();
      var parts2 = dt.split(' ');
      prefix2 = parts2[0].trim();
      // debugPrint("dateTime ashbe$prefix2");
    });
  }

  // List<ExpenseModel> expenseDraft = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense"),
        leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          userPassword: user_pass,
                          userName: userName,
                          user_id: userId)),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                prefix2 != prefix
                    ?
                    // startTime == ""
                    //     ?
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Please Give Meter Reading First",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    // : Text("ok")
                    : const Text(""),
                Container(
                  height: size.height * 0.16,
                  child: customBuildButton(
                    onClick: () async {
                      // newList = await expenseEntry();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AttendanceScreen(
                              // expenseTypelist: newList,
                              // callback: () {}, tempExpList: [],
                              // expDraftDate: '',
                              // tempExpenseList: [],
                              ),
                        ),
                      );
                    },
                    title: "Attendance & \nMeter Reading",
                    sizeWidth: MediaQuery.of(context).size.width,
                    inputColor: const Color(0xff56CCF2).withOpacity(.3),
                    icon: Icons.chrome_reader_mode_sharp,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: size.height * 0.16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          child: customBuildButton(
                            onClick: () async {
                              //          setState(() {
                              //             isloading=false;
                              //          });

                              //           if(isClick){

                              //         isClick = false;

                              // List<dynamic> expeseListField  = (await expenseEntry()) as List<dynamic>;
                              // print("$expeseListField");

                              //              setState(() {
                              //                   isloading=true;
                              //              });

                              if (isExpenseSync == true) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ExpenseEntry(),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Sync Expense',
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              setState(() {});
                              // isClick = true;
                              // debugPrint("clicked is:$isClick");
                              // }
                            },
                            // color: Colors.green,
                            title: isloading ? "Expense Entry" : "Loading...",
                            sizeWidth: MediaQuery.of(context).size.width,

                            icon: Icons.draw_rounded,
                            inputColor: const Color(0xff56CCF2).withOpacity(.3),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                height: double.infinity,
                                child: customBuildButton(
                                  onClick: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExpenseDraft()));
                                  },
                                  title: "Draft",
                                  sizeWidth: 300,
                                  icon: Icons.pending_actions_sharp,
                                  inputColor:
                                      const Color(0xff56CCF2).withOpacity(.3),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(135, 2, 160, 68),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                          Hive.box("draftForExpense")
                                              .length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                exp_approval_flag == true
                    ? Container(
                        height: size.height * 0.16,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: customBuildButton(
                          onClick: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ExpenseApprovalPage(),
                              ),
                            );
                          },
                          title: "Approval",
                          sizeWidth: MediaQuery.of(context).size.width,
                          icon: Icons.approval,
                          inputColor: const Color(0xff70BA85).withOpacity(.3),
                        ),
                      )
                    : SizedBox(),
                Container(
                    height: size.height * 0.16,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            child: customBuildButton(
                              onClick: () async {
                                // debugPrint(ExpenseLog);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ExpenseLogScreen(),
                                  ),
                                );
                              },
                              title: "Expense Log",
                              sizeWidth: 300,
                              inputColor:
                                  const Color(0xff70BA85).withOpacity(.3),
                              icon: Icons.receipt_long_sharp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            child: customBuildButton(
                              icon: Icons.summarize,
                              inputColor:
                                  const Color(0xff70BA85).withOpacity(.3),
                              onClick: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AttendanceMeterHistory()));
                              },
                              sizeWidth: 300,
                              title: 'Attendance-MTR Reading Log',
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    height: size.height * 0.16,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            child: customBuildButton(
                              icon: Icons.summarize,
                              inputColor:
                                  const Color(0xff70BA85).withOpacity(.3),
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ExpenseSummaryScreen()));
                              },
                              sizeWidth: 300,
                              title: 'Expense Summary',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            child: customBuildButton(
                              onClick: () async {
                                // var url =

                                //     '$expense_report?cid=$cid&rep_id=$userId&rep_pass=$user_pass';
                                // debugPrint(url);
                                // if (await canLaunch(url)) {
                                //   await launch(url);
                                // } else {
                                //   throw 'Could not launch $url';
                                // }
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ExpenseReportPage(),
                                ));
                              },
                              title: "Expense Details",
                              sizeWidth: MediaQuery.of(context).size.width,
                              icon: Icons.document_scanner,
                              inputColor:
                                  const Color(0xff70BA85).withOpacity(.3),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
