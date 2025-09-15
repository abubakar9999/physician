import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/late_attendance_report_model.dart';
import '../../data/service/apiCall.dart';


class AttendanceApprovalReportScreen extends StatefulWidget {
  const AttendanceApprovalReportScreen({super.key});

  @override
  State<AttendanceApprovalReportScreen> createState() =>
      _AttendanceApprovalReportScreenState();
}

class _AttendanceApprovalReportScreenState
    extends State<AttendanceApprovalReportScreen> {
  List<DataList> dataList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    lateAttendanceReport();
  }

  lateAttendanceReport() async {
    // Simulate API call delay
    print("3");

    setState(() {
      isLoading = true;
    });
    print("4");

    dataList = await lateAttendanceReportApi() ?? [];

    print("5");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Late Attendance Report"),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : dataList.isEmpty
          ? Center(child: Text("No Data Found"))
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            dataRowMaxHeight: double.infinity,
            dataRowColor:
            MaterialStateColor.resolveWith((states) => Colors.amberAccent),
            headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.greenAccent),
            columnSpacing: size.width * .01,
            horizontalMargin: 10,
            columns: <DataColumn>[
              DataColumn(
                label: Container(
                  width: size.width * .20,
                  child: Text(
                    'Date and Time',
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: size.width * .45,
                  child: Text(
                    'Reason',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: size.width * .2,
                  child: Text(
                    'Status',
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              dataList.length, // Change this to the number of rows you have
                  (index) => DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  return index.isEven ? Colors.white : Colors.grey[300]!;
                }),
                cells: <DataCell>[
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: size.width * .20,
                        child: Text(
                          dataList[index].submittedDatetime!,
                          softWrap: true,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: size.width * .45,
                        child: Text(
                          dataList[index].note!,
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 2),
                        child: Container(
                          width: size.width * .2,
                          child: FittedBox(
                            child: Row(
                              children: [
                                Icon(size : 14, dataList[index].status! == "SUBMITTED" ? Icons.circle : dataList[index].status! == "APPROVED" ? Icons.check_circle: Icons.cancel,color: dataList[index].status! == "SUBMITTED" ? Colors.blue : dataList[index].status! == "APPROVED" ? Colors.green : Colors.red,),
                                SizedBox(width: 2,),
                                Text(
                                  dataList[index].status!,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: dataList[index].status! == "SUBMITTED" ? Colors.blue : dataList[index].status! == "APPROVED" ? Colors.green : Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}
