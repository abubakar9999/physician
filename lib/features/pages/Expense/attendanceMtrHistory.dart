// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, file_names
import 'package:flutter/material.dart';

import '../../../data/service/all_service.dart';
import '../../../data/service/apiCall.dart';
import '../../../data/service/network_connectivity.dart';


// ignore: must_be_immutable
class AttendanceMeterHistory extends StatefulWidget {
  const AttendanceMeterHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<AttendanceMeterHistory> createState() => _AttendanceMeterHistoryState();
}

class _AttendanceMeterHistoryState extends State<AttendanceMeterHistory> {
  TextEditingController dateController = TextEditingController();
  List attenMtrLog = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDatat();
    });
  }

  _getDatat() async {
    bool result = await NetworkConnecticity.checkConnectivity();
    if (result) {
      attenMtrLog = await AttendanceMtrHistory();
      setState(() {
        print(attenMtrLog);
      });
    } else {
      AllServices().messageForUser("Please Check Your Internet connection");
    }
  }

  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance & Meter Reading log"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            color: const Color.fromARGB(255, 3, 129, 98),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Time",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Reading",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: attenMtrLog.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: attenMtrLog.length,
                    itemBuilder: (context, index) {
                      var parts = attenMtrLog[index]["m_check_in"].split(" ");
                      return Card(
                        color: const Color.fromARGB(255, 198, 241, 192),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "${parts[0]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "${parts[1]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "${attenMtrLog[index]["meter_reading_st"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              color: const Color.fromARGB(255, 152, 223, 161),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text("Address:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    Expanded(
                                      child: Text(
                                        " ${attenMtrLog[index]["address"].toString()}",
                                        // " loremkkkkkkdsajlfjdslajflsdajfsdfowejtofsdjaflfjaolgjasodltujweropasjfsdljgalsjfsaouwojfujtowasjfeotw",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
          )

          // Expanded(
          //   child:attenMtrLog.isEmpty?Center(child: CircularProgressIndicator(),):  ListView.builder(
          //       itemCount: attenMtrLog.length,
          //       itemBuilder: (context, i) {
          //         var parts = attenMtrLog[i]["m_check_in"].split(" ");

          //         return Card(
          //           elevation: 5,
          //           color: Color.fromARGB(255, 181, 217, 241),
          //           child: Padding(
          //             padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          //             child: Column(
          //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Text(
          //                           "Date: ",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                         Text(
          //                           "${parts[0]}",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.w500),
          //                         ),
          //                       ],
          //                     ),
          //                     Row(
          //                       children: [
          //                         Text(
          //                           "Time:",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                         Text(
          //                           " ${parts[1]}",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.w500),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     Text(
          //                       "MTR Reading-",
          //                       style: TextStyle(
          //                           color: Colors.black,
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                     Row(
          //                       children: [
          //                         Text(
          //                           "Start: ",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                         Text(
          //                           "${attenMtrLog[i]["meter_reading_st"]}",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.w500),
          //                         ),
          //                       ],
          //                     ),
          //                     Row(
          //                       children: [
          //                         Text(
          //                           "End:",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                         Text(
          //                           " ${attenMtrLog[i]["meter_reading_end"]}",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.w500),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     Text(
          //                       "Address: ",
          //                       style: TextStyle(
          //                           color: Colors.black,
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                     Text(
          //                       " ${attenMtrLog[i]["address"].toString()}",
          //                       style: TextStyle(
          //                           color: Colors.black,
          //                           fontWeight: FontWeight.w500),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       }),
          // ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2060),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                surface: Colors.blue,
              ),
              // dialogBackgroundColor: Colors.white,
            ), // This will change to light theme.
            child: child!,
          );
        },
      );
}
