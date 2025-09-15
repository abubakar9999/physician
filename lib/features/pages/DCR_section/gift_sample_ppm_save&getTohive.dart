// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../loginPage.dart';

class SyncDcrGSPtoHive {
  Box? box;
  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];

 
  //! Future giftOpenBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('dcrGiftListData');
  //! }

  //! Future sampleOpenBox() async {
  //!   var dir = await getApplicationDocumentsDirectory();
  //!   Hive.init(dir.path);
  //!   box = await Hive.openBox('dcrSampleListData');
  //! }

  // Future ppmOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('dcrPpmListData');
  // }

  Future discussionOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrDiscussionListData');
  }

// Dcr Gift section.................................

  Future<dynamic> syncDcrGiftToHive(String syncUrl, String cid, String userId,
      String userPassward, BuildContext context) async {
    debugPrint(
        //"${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward");
        "${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassward");

    try {
      var response = await http.get(Uri.parse(
          //'${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));
          '${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      var status = resData['status'];
      var giftList = resData['giftList'];

      if (status == 'Success') {
       await  mydatabox.put('isGiftSync',true );
        await putData(giftList);

        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Gift list')));
      }
    } on Exception catch (e) {
      // throw Exception("Error on server");
      debugPrint("$e");
    }
    // return Future.value(true);
  }

  Future putData(dcrData) async {
    
   var  dcrgiftlist = Hive.box('dcrGiftListData');
    await dcrgiftlist.clear();

    for (var d in dcrData) {
      dcrgiftlist.add(d);
    }
  }

  //  Dcr Sample section............................................

  Future<dynamic> syncDcrSampleToHive(String syncUrl, String cid,
      String userId, String userPassward, BuildContext context) async {
    // await sampleOpenBox();

    try {
      debugPrint(
          //'${syncUrl}api_doctor/get_doctor_sample?cid=$cid&user_id=$userId&user_pass=$userPassward');
          '${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassward');
      var response = await http.get(Uri.parse(
          //'${syncUrl}api_doctor/get_doctor_sample?cid=$cid&user_id=$userId&user_pass=$userPassward'));
          '${syncUrl}api_gift_sample_ppm/get_phy_sample?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      var status = resData['status'];
      var sampleList = resData['sampleList'];

      if (status == 'Success') {
      await mydatabox.put('isSampleSync', true);
        await putSampleData(sampleList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));
        // String msg = 'DCR Gift/Sample/PPM  Synchronizing..';

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Sample list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putSampleData(dcrData) async {
   var dcrsampleList = Hive.box('dcrSampleListData');
    await dcrsampleList.clear();

    for (var d in dcrData) {
      dcrsampleList.add(d);
    }
  }

  // / Dcr PPM section.........................................................

  Future<dynamic> syncDcrPpmToHive(String syncUrl, String cid, String userId,
      String userPassward, BuildContext context) async {
    debugPrint(
        //'${syncUrl}api_doctor/get_doctor_ppm?cid=$cid&user_id=$userId&user_pass=$userPassward');
        '${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassward');
    // await ppmOpenBox();
    try {
      var response = await http.get(Uri.parse(
          //'${syncUrl}api_doctor/get_doctor_ppm?cid=$cid&user_id=$userId&user_pass=$userPassward'));
          '${syncUrl}api_gift_sample_ppm/get_phy_ppm?cid=$cid&user_id=$userId&user_pass=$userPassward'));
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      var status = resData['status'];
      var ppmList = resData['ppmList'];

      if (status == 'Success') {
         await  mydatabox.put('isPPMSync', true);
        await putPpmData(ppmList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));
        // String msg = 'DCR Gift/Sample/PPM  Synchronizing..';

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync PPM list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putPpmData(dcrData) async {
    var drcppm=Hive.box('dcrPpmListData');
    await drcppm.clear();

    for (var d in dcrData) {
      drcppm.add(d);
    }
  }

  //=======================================================================================
  //==============================DCR Discussion======================================
  //=======================================================================================

  Future<dynamic> syncDcrDiscussiontToHive(String syncUrl, String cid,
      String userId, String userPassward, BuildContext context) async {
    debugPrint(
        //'${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward');
        '${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassward');

    try {
      var response = await http.get(Uri.parse(
          //'${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));
          '${syncUrl}api_gift_sample_ppm/get_phy_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      var status = resData['status'];
      var giftList = resData['giftList'];

      if (status == 'Success') {
        await putDiscussionData(giftList);

        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Gift list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putDiscussionData(dcrData) async {
     var dcrgift=Hive.box('dcrGiftListData');
    await dcrgift.clear();

    for (var d in dcrData) {
      dcrgift.add(d);
    }
  }

//============================================================================================================

  buildShowDialog(BuildContext context) {
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
                child: Text('DCR Gift/Sample/PPM  Synchronizing..'),
              )
            ],
          );
        });
  }
}
