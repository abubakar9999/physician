// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../features/pages/loginPage.dart';

class SyncItemstoHive {
  Box? box;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('syncItemData');// medicine
  }

  Future<dynamic> syncItemsToHive(String syncUrl, String cid, String userId,
      String userPassward, BuildContext context) async {
    await openBox();
    debugPrint(
        '${syncUrl}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userPassward');
    try {
      var response = await http.get(Uri.parse(
          '${syncUrl}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userPassward'));
          // 'http://192.168.100.246:8000/hamdard_api/api_item/item_list?cid=HAMDARD&user_id=5968&user_pass=1906'));
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      var status = jsonResponseDcrData['status'];
      var itemList = jsonResponseDcrData['itemList'];

      if (status == 'Success') {
       await mydatabox.put('isItemSync',true );
        await putData(itemList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Inavalid User Id & Password\n Please Login again!')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putData(itemData) async {
    await box!.clear();

    for (var d in itemData) {
      box!.add(d);
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
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
                child: Text('Item data synchronizing... '),
              )
            ],
          );
        });
  }
}
