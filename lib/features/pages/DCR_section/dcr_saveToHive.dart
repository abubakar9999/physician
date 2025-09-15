// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../loginPage.dart';
import 'dcr_list_page.dart';

class SyncDcrtoHive {
  Box? box;
  List dcrDataList = [];

  //! Future openBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('dcrListData');
  //! }

  Future<dynamic> syncDcrToHive(String syncUrl, String cid, String userId,
      String userPassward, BuildContext context) async {
        //debugPrint('docto_url: ${syncUrl}api_doctor/get_doctor?cid=$cid&user_id=$userId&user_pass=$userPassward');
        debugPrint('visit_url: ${syncUrl}api_visit_office_list/get_visit_office?cid=$cid&user_id=$userId&user_pass=$userPassward');
    //! await openBox();
    try {
      var response = await http.get(Uri.parse(
          '${syncUrl}api_visit_office_list/get_visit_office?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);

      // Map<String, dynamic> resData = jsonResponseDcrData['res_data'];
      // var status = resData['status'];
      // var doctorList = resData['doctorList'];
      //
      // if (status == 'Success') {
      // await  mydatabox.put('isRxDoctorSync', true);
      //   await putData(doctorList);
      //   Timer(const Duration(seconds: 3), () => Navigator.pop(context));
      //
      //   // ScaffoldMessenger.of(context)
      //   //     .showSnackBar(const SnackBar(content: Text('Sync success')));
      //   return buildShowDialog(context);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Did not sync Doctor list')));
      // }




      if (jsonResponseDcrData['res_data'] != null){
        Map<String, dynamic> resData = jsonResponseDcrData['res_data'];
        var status = resData['status'];
        var doctorList = resData['visitOfficeList'];

        if (status == 'Success') {
          await  mydatabox.put('isRxDoctorSync', true);
          await putData(doctorList);
          Timer(const Duration(seconds: 3), () => Navigator.pop(context));

          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('Sync success')));
          return buildShowDialog(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Did not sync Visit Office list')));
        }
      }



    } on Exception catch (_) {
      // debugPrint(e);
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putData(dcrData) async {
    var dcrdata=Hive.box('dcrListData');
    await dcrdata.clear();

    for (var d in dcrData) {
      dcrdata.add(d);
    }
  }

 
  getData(BuildContext context) async {
    //! await openBox();

    var mymap = Hive.box('dcrListData').values.toList();

    if (mymap.isEmpty) {
      dcrDataList.add('empty');
    } else  {
      dcrDataList = mymap;
    await  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrListPage(visitOfficeDataList: dcrDataList, ),
        ),
      );
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: Colors.black,
        barrierDismissible: false,
        // barrierDismissible: false,
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
                child: Text('Office Visit synchronizing... '),
              )
            ],
          );
        });
  }
}
