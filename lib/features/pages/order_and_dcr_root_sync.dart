import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../data/service/apiCall.dart';
import 'loginPage.dart';

class DcrAndOrderHive {
  Box box = Hive.box('mpoForClaient');

  dcrandOrder(contexts) async {
    var data = await getClaintandDoctot();
    print('xxxx$data');
    List client = [];
    List doctor = [];


    print('data status::${data["status"]}');
    if (data["status"] == "Success") {
      await mydatabox.put('isClientForMPOSync', true);
      await mydatabox.put('isDoctorForMPOSync', true);


      final int totalExam =data['total_exam'] ?? 0;
      print('total exam: $totalExam');

      doctor = data["visitOfficeList"];
      print('doctor::$doctor');

      debugPrint("Claint Data $client");
      debugPrint("Doctor data$doctor");
      await putClientForMpo(client);
      await putDcrForMpo(doctor);
      await putExamCount(totalExam);

      Timer(const Duration(seconds: 5), () => Navigator.pop(contexts));

      return buildShowDialog(contexts);
    } else {
      print("Errror");
    }
  }

  putClientForMpo(client) async {
    //Box box= Hive.box('mpoForClaient');
    await box.clear();
    for (var d in client) {
      box.add(d);
    }
    debugPrint("boxCient${box.values}");
  }

  putDcrForMpo(doctor) async {
    print('xxxx');
    Box box = Hive.box('mpoForDoctor');
    await box.clear();
    for (var d in doctor) {
      print('xxxx');
      box.add(d);
      debugPrint("ADDD------------$d");
    }
    debugPrint("boxDoctor${box.values}");
    print("------------------------------------------000000");

    print(box.values.toString());
  }

  // putExamCount(totalExamCount) async {
  //   Box box = Hive.box('exam_count');
  //   await box.clear();
  //   await box.put('total_exam', totalExamCount);
  // }

  Future<void> putExamCount(int totalExamCount) async {
    final box = await Hive.openBox('exam_count');
    await box.put('total_exam', totalExamCount);
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 18),
                child: Text('DCR & Client synchronizing... '),
              )
            ],
          );
        });
  }
}
