// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:http/http.dart' as http;

import '../../../features/pages/loginPage.dart';

class SyncMedicinetoHive {
 Box box=Hive.box('medicineList');
  List medicineList = [];

  //! Future openBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('medicineList');
  //! }

  Future<dynamic> medicinetoHive(String syncUrl, String cid, String userId,
      String userPassward,  context) async {
    //debugPrint('medicine list::${syncUrl}api_medicine/get_rx_medicine?cid=$cid&user_id=$userId&user_pass=$userPassward');
    debugPrint('medicine list::${syncUrl}api_medicine/medicine_list?cid=$cid&user_id=$userId&user_pass=$userPassward');
    // !await openBox();
    try {
      //var response = await http.get(Uri.parse('${syncUrl}api_medicine/get_rx_medicine?cid=$cid&user_id=$userId&user_pass=$userPassward'));
      var response = await http.get(Uri.parse('${syncUrl}api_medicine/medicine_list?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> medicineData = jsonResponse['res_data'];
      var rxItemList = medicineData['rxItemList'];
      var status = medicineData['status'];
      if (status == 'Success') {
    
       await mydatabox.put('isMedicineSync', true);
        await putData(rxItemList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Medicine list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putData(medicinData) async {
    await box.clear();

    for (var m in medicinData) {
      box.add(m);
    }
  }

  buildShowDialog( context) {
    return showDialog(
        context: context,
        barrierColor: Colors.black,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 18),
                child: Text('Medicine Synchronizing....'),
              )
              // Text(
              //   'Medicine Synchronizing......',
              //   style: TextStyle(
              //       color: Color.fromARGB(255, 237, 243, 237), fontSize: 21),
              // )
            ],
          );
        });
  }
}
