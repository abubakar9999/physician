// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:physician_latest/features/pages/loginPage.dart';
import 'package:physician_latest/features/pages/splash_screen.dart';

import 'core/themes.dart';
import 'data/datasources/local_storage/hive_data_model.dart';
import 'data/service/hive_adapter.dart';


// String address = "";

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
var SameDeviceId;
// var appVersion = "v-20231207"; // BIOPHARMA
// var appVersion = "v-20240117"; //IBNSINA
// var appVersion = "v-20240929"; //APEX PHARMA
// var appVersion = "v-20250127"; //Hamdard
//var appVersion = "v-20250201"; //Hamdard_new
//var appVersion = "v-20250305"; //Hamdard_new
//var appVersion = "v-20250411";
//var appVersion = "v-20250505";
//var appVersion = "v-20250617";
//var appVersion = "v-20250726";
//var appVersion = "v-20250728";
//var appVersion = "v-20250729";
// var appVersion = "v-20250730";
var appVersion = "v-20250901";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);

  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(AddItemModelAdapter());
  Hive.registerAdapter(CustomerDataModelAdapter());
  Hive.registerAdapter(DcrGSPDataModelAdapter());
  Hive.registerAdapter(RxDcrDataModelAdapter());
  Hive.registerAdapter(MedicineListModelAdapter());
  Hive.registerAdapter(DcrDataModelAdapter());
  Hive.registerAdapter(NoticeListModelAdapter());


  await Hive.openBox('checkData');
  await Hive.openBox('proDxCusBox');
  await HiveAdapter().HiveAdapterbox();

  //await initializeService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'mRep_v03',
        theme: defaultTheme,
        home: SplashScreen(),
      ),
    );
  }
}
