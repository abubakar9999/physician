// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unused_local_variable, duplicate_ignore

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/service/apiCall.dart';
import 'expense_details.dart';


class ExpenseApprovalPage extends StatefulWidget {
  const ExpenseApprovalPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseApprovalPage> createState() => _ExpenseApprovalPageState();
}

class _ExpenseApprovalPageState extends State<ExpenseApprovalPage> {
  TextEditingController initialController = TextEditingController(
      // text: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
      );
  TextEditingController lastController = TextEditingController(
      // text: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
      );
  TextEditingController reasonController = TextEditingController();
  // TextEditingController rejectController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final jobRoleCtrl = TextEditingController();

  List<String> exp_reject_reason = [];

  List newApprovalList = [];
  String role = "";
  String reason = "";
  // initialController = 22 / 12 / 2022;
  var lastDate = 22 / 12 / 2022;
  List<bool> approved = [];

  String exp_approval_url = '';
  String cid = '';
  String user_id = '';
  // String user_id1 = '';
  String user_pass = '';
  String device_id = '';
  var approvalData = [];
  var expString = '';
  var emp_id = '';
  bool isClik = true;
  bool loading = false;
  String datails_loading = '';
  bool is_show = false;

  List<String> user_basis_list = [];
  List<bool> detail_loating = [];
  final databox = Boxes.allData();

  @override
  void initState() {
    setState(() {
      exp_approval_url = databox.get('exp_approval_url')!;
      cid = databox.get('CID')!;
      user_id = databox.get('USER_ID')!;
      user_pass = databox.get('PASSWORD')!;
      device_id = databox.get('deviceId')!;
      exp_reject_reason = databox.get('exp_reject_reason')!;
      user_basis_list = databox.get('user_basis_level_list');

      debugPrint("Result is : $exp_reject_reason");
      debugPrint("user basis lavel  is : $user_basis_list");
      role = user_basis_list[0];
      jobRoleCtrl.text = user_basis_list[0];
    });
    _getApprovalList();
    super.initState();
  }

  @override
  void dispose() {
    initialController.dispose();
    lastController.dispose();
    reasonController.dispose();
    // rejectController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Approval"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: RichText(
                    text: const TextSpan(
                      text: 'Date Range',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        // TextSpan(
                        //     text: ' *',
                        //     style: TextStyle(
                        //         color: Colors.red,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
                // Text(
                //   "From",
                //   style: TextStyle(fontSize: 16),
                // ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.zero,
                    // width: 120,
                    // height: 50,
                    color: const Color.fromARGB(255, 138, 201, 149)
                        .withOpacity(.3),
                    child: TextField(
                      controller: initialController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date = await pickDate();

                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              initialController.text =
                                  DateFormat('yyyy-MM-dd').format(date);
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
                  flex: 2,
                  child: RichText(
                    text: const TextSpan(
                      text: '  To',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        // TextSpan(
                        //     text: ' *',
                        //     style: TextStyle(
                        //         color: Colors.red,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.zero,
                    // width: 120,
                    // height: 45,
                    color: const Color.fromARGB(255, 138, 201, 149)
                        .withOpacity(.3),
                    child: TextField(
                      controller: lastController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date = await pickDate();

                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              lastController.text =
                                  DateFormat('yyyy-MM-dd').format(date);
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
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                // DropdownButtonFormField(items: items, onChanged: (onChanged){
                const Flexible(
                  // flex: 2,
                  child: Text("FF Type:"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  // flex: 3,
                  child: CustomDropdown(
                    // hintText: ff_type[0],
                    hintText: "Select FF",
                    //fillColor: const Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                    items: user_basis_list,

                    //controller: jobRoleCtrl,
                    onChanged: (value) {
                      role = value!;
                      debugPrint("developer select list $role");
                    },
                  ),
                )
                // })
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _getApprovalList();
                  },
                  child: const Text(
                    "Show",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.8),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(1.8),
                3: FlexColumnWidth(2.5)
              },
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 92, 194, 146)),
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 3, bottom: 10, left: 3),
                              child: Text('ID',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 3, left: 3),
                              child: Text('Name',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 10),
                        child: Column(children: const [
                          Text('Amount',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Column(children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 10),
                          child: Text('Status',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ]),
                    ]),
              ],
            ),
          ),

          Expanded(
            child: is_show
                ? loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : approvalData.isNotEmpty
                        ? ListView.builder(
                            itemCount: approvalData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.8),
                                    1: FlexColumnWidth(2.5),
                                    2: FlexColumnWidth(1.8),
                                    3: FlexColumnWidth(2.5)
                                  },
                                  border: const TableBorder(
                                    top: BorderSide.none,
                                    left: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    horizontalInside: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    verticalInside: BorderSide(
                                        width: 1.0, color: Colors.black),
                                  ),
                                  children: [
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: approved[index] == true
                                                ? const Color.fromARGB(
                                                    255, 75, 173, 185)
                                                : Colors.white),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, left: 5),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    approvalData[index]
                                                        ["emp_id"],
                                                    style: TextStyle(
                                                        color:
                                                            approved[index] ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  // Text(approvalData[index]["emp_name"]),
                                                ]),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  approvalData[index]
                                                      ["emp_name"],
                                                  style: TextStyle(
                                                      color: approved[index] ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Column(children:const [
                                          //   Text('FF Name', style: TextStyle(fontSize: 16))
                                          // ]),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, right: 3),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    approvalData[index]
                                                            ["exp_amt_total"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            approved[index] ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                ]),
                                          ),
                                          Column(children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Checkbox(
                                                    value: approved[index],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // e["status"]== true?
                                                        approved[index] =
                                                            value!;
                                                        // debugPrint("approval ashbe $approved");

                                                        if (approved[index] ==
                                                            true) {
                                                          newApprovalList.add(
                                                              approvalData[
                                                                  index]);
                                                        } else {
                                                          newApprovalList
                                                              .remove(
                                                                  approvalData[
                                                                      index]);
                                                        }
                                                        debugPrint(
                                                            "approval ashbe $newApprovalList");

                                                        // if (approved[index] == true) {
                                                        //   newApprovalList.forEach((element) {\\
                                                        //     y=element['emp_id'];

                                                        //   });

                                                        //    if (expString == '') {
                                                        //       expString = y;
                                                        //     } else  {
                                                        //       expString =
                                                        //           expString + "|" + y;

                                                        //     }
                                                        //      debugPrint(expString);
                                                        // }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        datails_loading =
                                                            index.toString();

                                                        print(
                                                            "expensedetails url: $exp_approval_url");

                                                        if (isClik) {
                                                          setState(() {
                                                            isClik = false;
                                                          });
                                                          List
                                                              expEmpListDetails =
                                                              await ExpEmpDetailsList(
                                                            cid: cid,
                                                            ff_type: role,
                                                            user_id: user_id,
                                                            user_pass:
                                                                user_pass,
                                                            device_id:
                                                                device_id,
                                                            exp_date_from:
                                                                initialController
                                                                    .text,
                                                            exp_date_to:
                                                                lastController
                                                                    .text,
                                                            exp_url:
                                                                exp_approval_url,
                                                            emp_id:
                                                                approvalData[
                                                                        index]
                                                                    ["emp_id"],
                                                          );

                                                          print(
                                                              "my detail List is ::$expEmpListDetails");
                                                          // datails_loading = 1
                                                          //         .toString() +
                                                          //     index.toString();
                                                          setState(() {
                                                            datails_loading =
                                                                '';
                                                          });

                                                          Navigator.push(
                                                            context,
                                                            (MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ExpenseDetailsScreen(
                                                                cid: cid,
                                                                device_id:
                                                                    device_id,

                                                                exp_fromDate:
                                                                    initialController
                                                                        .text,
                                                                exp_toDate:
                                                                    lastController
                                                                        .text,
                                                                exp_url:
                                                                    exp_approval_url,
                                                                ff_type: role,
                                                                user_id:
                                                                    user_id,
                                                                user_pass:
                                                                    user_pass,
                                                                emp_id: approvalData[
                                                                        index]
                                                                    ["emp_id"],

                                                                representativeID:
                                                                    approvalData[
                                                                            index]
                                                                        [
                                                                        "emp_id"],
                                                                representativeName:
                                                                    approvalData[
                                                                            index]
                                                                        [
                                                                        "emp_name"],

                                                                expEmpListDetails:
                                                                    expEmpListDetails,
                                                                mycallback:
                                                                    (value) async {
                                                                  setState(
                                                                      () {});

                                                                  if (approvalData
                                                                      .contains(
                                                                          value)) {
                                                                    approvalData =
                                                                        value;
                                                                  } else if (value ==
                                                                      null) {
                                                                    approvalData =
                                                                        value;
                                                                  } else {
                                                                    approvalData = await expensapprovel(
                                                                        cid:
                                                                            cid,
                                                                        device_id:
                                                                            device_id,
                                                                        exp_date_from:
                                                                            initialController
                                                                                .text,
                                                                        exp_date_to:
                                                                            lastController
                                                                                .text,
                                                                        exp_url:
                                                                            exp_approval_url,
                                                                        user_id:
                                                                            user_id,
                                                                        user_pass:
                                                                            user_pass,
                                                                        ff_type:
                                                                            role);
                                                                  }
                                                                },

                                                                // expenseLog: widget.expenseLog,
                                                                // expenseDetails: widget.expenseLog,
                                                                // repId: '2580',
                                                              ),
                                                            )),
                                                          );
                                                          isClik = true;
                                                        }
                                                      },
                                                      child: datails_loading ==
                                                              index.toString()
                                                          ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        231,
                                                                        86,
                                                                        8),
                                                              ),
                                                            )
                                                          : const Text(
                                                              'Details')),
                                                )
                                              ],
                                            )
                                          ]),
                                        ]),
                                  ],
                                ),
                              );
                            })
                        : const Text("No Data Found")
                : const SizedBox.shrink(),
          ),

          // Container(
          //   color: Colors.green[100],
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     // child: Row(
          //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     //   children: const [
          //     //     Text(
          //     //       "Territory",
          //     //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     //     ),
          //     //     Text(
          //     //       "FF       ",
          //     //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     //     ),
          //     //     Text(
          //     //       "      Amount",
          //     //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     //     ),
          //     //     Text(
          //     //       "Status",
          //     //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     //     ),
          //     //   ],
          //     // ),
          //   ),
          // ),
//todo new
          // SizedBox(
          //   height: 38,
          //   child: Table(

          //     border: TableBorder.all(), columnWidths: const {
          //     0: FlexColumnWidth(1.4),
          //     1: FlexColumnWidth(1.2),
          //     2: FlexColumnWidth(1),
          //     3: FlexColumnWidth(1),
          //   },
          //       // ignore: prefer_const_literals_to_create_immutables
          //       children: [
          //         const TableRow(
          //             decoration: BoxDecoration(
          //               color: Color.fromARGB(255, 121, 238, 125),
          //             ),
          //             children: [
          //               Center(
          //                 child: Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: TableCell(
          //                     child: Text(
          //                       "Territory",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 16),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Center(
          //                 child: Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: TableCell(
          //                     child: Text(
          //                       "FF",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 16),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Center(
          //                 child: Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: TableCell(
          //                     child: Text(
          //                       "Amount",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 16),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Center(
          //                 child: Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: TableCell(
          //                     child: Text(
          //                       "Status",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 16),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ]),
          //       ]),
          // ),

          // Expanded(
          //   child: is_show
          //       ? loading
          //           ? const Center(
          //               child: CircularProgressIndicator(),
          //             )
          //           : approvalData.isNotEmpty
          //               ? ListView.builder(
          //                   itemCount: approvalData.length,
          //                   itemBuilder: (context, index) {
          //                     return Card(
          //                       elevation: 5,
          //                       child: Padding(
          //                         padding:
          //                             const EdgeInsets.fromLTRB(16, 0, 4, 0),
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Text(approvalData[index]["emp_name"]),
          //                             Row(
          //                               children: [
          //                                 Text(
          //                                   approvalData[index]["emp_id"],
          //                                 ),
          //                                 IconButton(
          //                                     onPressed: () async {
          //                                       datails_loading =
          //                                           index.toString();

          //                                       print(
          //                                           "expensedetails url: $exp_approval_url");

          //                                       if (isClik) {
          //                                         setState(() {
          //                                           isClik = false;
          //                                         });
          //                                         List expEmpListDetails =
          //                                             await ExpEmpDetailsList(
          //                                           cid: cid,
          //                                           ff_type: role,
          //                                           user_id: user_id,
          //                                           user_pass: user_pass,
          //                                           device_id: device_id,
          //                                           exp_date_from:
          //                                               initialController.text,
          //                                           exp_date_to:
          //                                               lastController.text,
          //                                           exp_url: exp_approval_url,
          //                                           emp_id: approvalData[index]
          //                                               ["emp_id"],
          //                                         );

          //                                         print(
          //                                             "my detail List is ::$expEmpListDetails");
          //                                         datails_loading =
          //                                             1.toString() +
          //                                                 index.toString();

          //                                         Navigator.push(
          //                                           context,
          //                                           (MaterialPageRoute(
          //                                             builder: (context) =>
          //                                                 ExpenseDetailsScreen(
          //                                               cid: cid,
          //                                               device_id: device_id,

          //                                               exp_fromDate:
          //                                                   initialController
          //                                                       .text,
          //                                               exp_toDate:
          //                                                   lastController.text,
          //                                               exp_url:
          //                                                   exp_approval_url,
          //                                               ff_type: role,
          //                                               user_id: user_id,
          //                                               user_pass: user_pass,
          //                                               emp_id:
          //                                                   approvalData[index]
          //                                                       ["emp_id"],

          //                                               representativeID:
          //                                                   approvalData[index]
          //                                                       ["emp_id"],
          //                                               representativeName:
          //                                                   approvalData[index]
          //                                                       ["emp_name"],

          //                                               expEmpListDetails:
          //                                                   expEmpListDetails,
          //                                               mycallback:
          //                                                   (value) async {
          //                                                 setState(() {});

          //                                                 if (approvalData
          //                                                     .contains(
          //                                                         value)) {
          //                                                   approvalData =
          //                                                       value;
          //                                                 } else if (value ==
          //                                                     null) {
          //                                                   approvalData =
          //                                                       value;
          //                                                 } else {
          //                                                   approvalData = await expensapprovel(
          //                                                       cid: cid,
          //                                                       device_id:
          //                                                           device_id,
          //                                                       exp_date_from:
          //                                                           initialController
          //                                                               .text,
          //                                                       exp_date_to:
          //                                                           lastController
          //                                                               .text,
          //                                                       exp_url:
          //                                                           exp_approval_url,
          //                                                       user_id:
          //                                                           user_id,
          //                                                       user_pass:
          //                                                           user_pass,
          //                                                       ff_type: role);
          //                                                 }
          //                                               },

          //                                               // expenseLog: widget.expenseLog,
          //                                               // expenseDetails: widget.expenseLog,
          //                                               // repId: '2580',
          //                                             ),
          //                                           )),
          //                                         );
          //                                         isClik = true;
          //                                       }
          //                                     },
          //                                     icon: const Icon(
          //                                         Icons.double_arrow_sharp))
          //                               ],
          //                             ),

          //                             Text(
          //                               approvalData[index]["exp_amt_total"]
          //                                   .toString(),
          //                             ),
          //                             datails_loading == index.toString()
          //                                 ? const SizedBox(
          //                                     height: 20,
          //                                     width: 20,
          //                                     child: CircularProgressIndicator(
          //                                       color: Color.fromARGB(
          //                                           255, 231, 86, 8),
          //                                     ))
          //                                 : Checkbox(
          //                                     value: approved[index],
          //                                     onChanged: (value) {
          //                                       setState(() {
          //                                         // e["status"]== true?
          //                                         approved[index] = value!;
          //                                         // debugPrint("approval ashbe $approved");

          //                                         if (approved[index] == true) {
          //                                           newApprovalList.add(
          //                                               approvalData[index]);
          //                                         } else {
          //                                           newApprovalList.remove(
          //                                               approvalData[index]);
          //                                         }
          //                                         debugPrint(
          //                                             "approval ashbe $newApprovalList");

          //                                         // if (approved[index] == true) {
          //                                         //   newApprovalList.forEach((element) {\\
          //                                         //     y=element['emp_id'];

          //                                         //   });

          //                                         //    if (expString == '') {
          //                                         //       expString = y;
          //                                         //     } else  {
          //                                         //       expString =
          //                                         //           expString + "|" + y;

          //                                         //     }
          //                                         //      debugPrint(expString);
          //                                         // }
          //                                       });
          //                                     },
          //                                   ),

          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 )
          //               : const Text("No Data Found")
          //       : const SizedBox.shrink(),
          // ),

          //todo new

          // Container(
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         // "No Data Found",
          //         "",
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     ),
          //   ),
          approvalData.isEmpty
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          newApprovalList.isNotEmpty
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      content: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(
                                            //   children: [
                                            //     Expanded(child: Text("Rejected By")),
                                            //     Expanded(
                                            //         child: TextField(
                                            //             controller: rejectController)),
                                            //   ],
                                            // ),
                                            const Text(
                                              "Reason",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            // CustomDropdown(
                                            //   // hintText: ff_type[0],
                                            //   hintText: "Select Job Role",
                                            //   fillColor: const Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                                            //   items: exp_reject_reason,

                                            //   controller: reasonController,
                                            //   onChanged: (p0) {
                                            //     reason = p0;
                                            //     debugPrint("select Reson debugPrint: $reason");
                                            //   },
                                            // ),

                                            Container(
                                              padding: EdgeInsets.zero,
                                              child: TextField(
                                                controller: reasonController
                                                  ..addListener(() {
                                                    reason = reasonController
                                                        .text
                                                        .trim();
                                                  }),
                                                minLines: 2,
                                                maxLines: 2,
                                                maxLength: 50,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                          255, 138, 201, 149)
                                                      .withOpacity(.3),
                                                  border: OutlineInputBorder(),
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'[a-zA-Z0-9\s]'))
                                                ],
                                              ),
                                            ),

                                            Spacer(),
                                            Center(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                  onPressed: () async {
                                                    var y;

                                                    var stutus = "REJECT";
                                                    if (newApprovalList
                                                        .isNotEmpty) {
                                                      for (var element
                                                          in newApprovalList) {
                                                        y = element['emp_id'];
                                                        if (expString == '') {
                                                          expString = y;
                                                        } else {
                                                          expString =
                                                              "$expString|" + y;
                                                        }
                                                      }

                                                      debugPrint(expString);
                                                    }

                                                    if (expString != '') {
                                                      if (reasonController
                                                              .text !=
                                                          '') {
                                                        var res = await expenseApproveAndReject(
                                                            cid: cid,
                                                            device_id:
                                                                device_id,
                                                            exp_date_from:
                                                                initialController
                                                                    .text,
                                                            exp_date_to:
                                                                lastController
                                                                    .text,
                                                            exp_string:
                                                                expString,
                                                            exp_url:
                                                                exp_approval_url,
                                                            ff_type: role,
                                                            status: stutus,
                                                            user_id: user_id,
                                                            user_pass:
                                                                user_pass,
                                                            reasonController:
                                                                reason
                                                                    .toString());

                                                        debugPrint(
                                                            res['ret_str']);

                                                        if (res['status'] ==
                                                            'Success') {
                                                          print(approvalData);
                                                          approvalData
                                                              .removeWhere((e) =>
                                                                  newApprovalList
                                                                      .contains(
                                                                          e));
                                                          newApprovalList = [];
                                                          // rejectController
                                                          //     .clear();
                                                          approved.clear();

                                                          Fluttertoast.showToast(
                                                              msg: res[
                                                                  'ret_str'],
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      121,
                                                                      192,
                                                                      153));
                                                          for (var element
                                                              in approvalData) {
                                                            approved.add(false);
                                                          }
                                                        }

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Please Give Your Reject Reason',
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    236,
                                                                    81,
                                                                    60));
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Please Select Item',
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  236,
                                                                  81,
                                                                  60));
                                                    }
                                                  },
                                                  child: const Text("Reject")),
                                            )
                                          ],
                                        ),

                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(50)),
                                      ),
                                    );
                                  })
                              : Fluttertoast.showToast(
                                  msg: 'Please Select Item',
                                  backgroundColor:
                                      const Color.fromARGB(255, 236, 81, 60));
                        },
                        child: const Text("Reject")),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        var stutus = "APPROVED";
                        var y;
                        if (newApprovalList.isNotEmpty) {
                          for (var element in newApprovalList) {
                            y = element['emp_id'];
                            if (expString == '') {
                              expString = y;
                            } else {
                              expString = "$expString|" + y;
                            }
                          }
                          if (expString != '') {
                            var res = await expenseApproveAndReject(
                                cid: cid,
                                device_id: device_id,
                                exp_date_from: initialController.text,
                                exp_date_to: lastController.text,
                                exp_string: expString,
                                exp_url: exp_approval_url,
                                ff_type: role,
                                status: stutus,
                                user_id: user_id,
                                user_pass: user_pass,
                                reasonController: '');
                            debugPrint("${res['ret_str']}");

                            setState(() {
                              if (res['status'] == 'Success') {
                                approvalData.removeWhere(
                                    (e) => newApprovalList.contains(e));
                                Fluttertoast.showToast(
                                    msg: res['ret_str'],
                                    fontSize: 16,
                                    backgroundColor: const Color.fromARGB(
                                        255, 121, 192, 153));
                                newApprovalList = [];
                                approved.clear();
                                for (var element in approvalData) {
                                  approved.add(false);
                                }
                              }
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                              fontSize: 16,
                              msg: 'Please Select Item',
                              backgroundColor:
                                  const Color.fromARGB(255, 236, 81, 60));
                        }
                      },
                      child: const Text("Approve"),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                )
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

  Future _getApprovalList() async {
    setState(() {
      loading = true;
      is_show = true;
    });
    if (role != '') {
      if (lastController.text != '' || initialController.text != '') {
        if (lastController.text != '' && initialController.text != '') {
          approvalData = await expensapprovel(
              cid: cid,
              device_id: device_id,
              exp_date_from: initialController.text,
              exp_date_to: lastController.text,
              exp_url: exp_approval_url,
              user_id: user_id,
              user_pass: user_pass,
              ff_type: role);

          for (var element in approvalData) {
            approved.add(false);
          }
        } else {
          Fluttertoast.showToast(
              msg: 'Please Select Valid Date Range',
              backgroundColor: const Color.fromARGB(255, 236, 81, 60));
        }
      } else {
        approvalData = await expensapprovel(
            cid: cid,
            device_id: device_id,
            exp_date_from: initialController.text,
            exp_date_to: lastController.text,
            exp_url: exp_approval_url,
            user_id: user_id,
            user_pass: user_pass,
            ff_type: role);

        for (var element in approvalData) {
          approved.add(false);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Please Select FF Type',
          backgroundColor: const Color.fromARGB(255, 236, 81, 60));
    }
    // if (role != '' &&
    //     initialController.text != '' &&
    //     lastController.text != "") {
    //   approvalData = await expensapprovel(
    //       cid: cid,
    //       device_id: device_id,
    //       exp_date_from: initialController.text,
    //       exp_date_to: lastController.text,
    //       exp_url: exp_approval_url,
    //       user_id: user_id,
    //       user_pass: user_pass,
    //       ff_type: role);

    //   for (var element in approvalData) {
    //     approved.add(false);
    //   }
    // } else {
    //   Fluttertoast.showToast(
    //       msg: 'Please Select Date Range and FF Type',
    //       backgroundColor: const Color.fromARGB(255, 236, 81, 60));
    // }
    setState(() {});
    loading = false;
  }
}
