import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/pages/loginPage.dart';
import '../datasources/local_storage/hive_data_model.dart';

class AuthServices {
  static Future logOut(BuildContext context) async {
    Box myBox = await Hive.box('alldata');
    await myBox.put('PASSWORD', '');

    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
    //await stopBackgroundService();
    Hive.box<NoticeListModel>('noticeList').clear();
    await mydatabox.put('first_notice_api_hit', false);
    debugPrint("after logout button pressed the first_notice_api_hit is ${mydatabox.get('first_notice_api_hit')}");
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      ModalRoute.withName('/'),
    );
  }

  static Future checkExistingUser(String newUserr) async {
    Box myBox = await Hive.box('alldata');
    String existingUser = await myBox.get('USER_ID') ?? '';
    if (existingUser != newUserr) {
      await getTemporaryDirectory().then(
        (value) {
          Directory(value.path).delete(recursive: true);
        },
      );
      await mydatabox.put('isItemSync', false);
      await mydatabox.put('isGiftSync', false);
      await mydatabox.put('isSampleSync', false);
      await mydatabox.put('isPPMSync', false);
      await mydatabox.put('isMedicineSync', false);
      await mydatabox.put('isRxDoctorSync', false);
      await mydatabox.put('isExpenseSync', false);
      await mydatabox.put('isClientForMPOSync', false);
      await mydatabox.put('isDoctorForMPOSync', false);
      await mydatabox.put('first_notice_api_hit', false);
    }
  }
}
