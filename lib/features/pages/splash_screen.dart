// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:physician_latest/features/pages/syncDataTabPaga.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/service/all_service.dart';
import 'homePage.dart';
import 'loginPage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool? areaPage;
  String? user_id;
  String? logo_url_1;
  String? logo_url_2;
  String? userName;
  List itemToken = [];
  List clientToken = [];
  List dcrtToken = [];
  List gifttToken = [];
  var buttonNames;

  double latitude = 0.0;
  double longitude = 0.0;
  final myallData = Boxes.allData();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getLatLong();

      // !Hive.openBox('data').then(
      //! (value) {

      //! clientToken = value.toMap().values.toList();

      //! setState(() {});

      clientToken = Hive.box('dcrListData').values.toList();
      cid = myallData.get("CID") ?? '';
      userId = myallData.get("USER_ID") ?? '';
      userPassword = myallData.get("PASSWORD") ?? '';
      // areaPage = myallData.get("areaPage");
      userName = myallData.get("userName");
      user_id = myallData.get("user_id");
      logo_url_1 = myallData.get("logo_url_1");
      logo_url_2 = myallData.get("logo_url_2");
      // getButtonNames();
      // debugPrint(areaPage);

      if (cid != '' && userId != '' && userPassword != '') {
         debugPrint("client toke:$clientToken");
        if (clientToken.isNotEmpty) {
          Timer(
            const Duration(milliseconds: 1600),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MyHomePage(
                  // userName: userName!,
                  // user_id: userId,
                  // userPassword:userPassword,
                  userName: "",
                  user_id: "",
                  userPassword: "",
                ),
              ),
            ),
          );
        } else {
          Timer(
            const Duration(milliseconds: 1600),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SyncDataTabScreen(
                  cid: cid,
                  userId: userId,
                  userPassword: userPassword,
                ),
              ),
            ),
          );
        }
      } else {
        Timer(
          const Duration(milliseconds: 1600),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          ),
        );
      }
      //   },
      // );
      // !  },
      // !);
    }
  }

  // Future<void> getButtonNames() async {
  //   try {
  //     Box box = await Hive.openBox('buttonNames');
  //     dynamic buttonNames = box.get('buttonNames');
  //     debugPrint("Retrieved buttonNames: $buttonNames");
  //   } catch (e) {
  //     debugPrint("Error retrieving buttonNames: $e");
  //   }
  // }

  getLatLong() {
    Future<Position> data = AllServices().determinePosition();
    data.then((value) {
      // debugPrint("value $value");
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;

        // debugPrint(
        //     "Splass Screen Lat Long :::::::::::::  $latitude : $longitude");

        myallData.put("latitude", latitude);
        myallData.put("longitude", longitude);
      });
    }).catchError((error) {
      // debugPrint("Error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/mRep7_wLogo.png",
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
