import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AllServices {
  // Todo!<<<<<<<<<<<<<<<<<<<<<<       Splash Screen     >>>>>>>>>>>>>>>>>>>>>>>>>>

  //todo Get Position for Track Location

  Future<geo.Position> determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
  }

  //todo   Get Parmission ????????

  // getPermission() async {
  //   bool? serviceEnabled;
  //   PermissionStatus? permissionGranted;

  //   Permission location = Permission();
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }

  Future<void> getPermission() async {
    // Check if permission is already granted
    var location_status = await Permission.location.status;
    if (location_status == PermissionStatus.granted) {
      // Permission is already granted
      print('Location permission is already granted.');
    } else {
      // Request permission
      var result = await Permission.location.request();
      if (result == PermissionStatus.granted) {
        print('Location permission granted.');
        // Perform actions that require location permission here
      } else {
        print('Location permission denied.');
        // Handle the case where the user denies location permission
      }
    }
    var storage_status = await Permission.storage.request();

    if (storage_status.isGranted) {
      // Permission granted, you can now access storage
      print('Storage permission granted');
    } else if (storage_status.isDenied) {
      // Permission denied
      print('Storage permission denied');
    } else if (storage_status.isPermanentlyDenied) {
      // Permission permanently denied, open settings
      print('Storage permission permanently denied');
      openAppSettings();
    }
  }
  // code write by monir for test

//todo!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  HOME PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//todo>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  CustomerList PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//todo    Tost Message  >>>>>>>>>>>>>>>>>>>

  void messageForUser(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  getTodayDate() {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    debugPrint("----------------------$todayDate");
    return todayDate; // prints the current date in the format "yyyy-MM-dd"
  }

  // Future<bool> isLocationEnabled() async {
  //   geo.LocationPermission permission = await geo.Geolocator.checkPermission();
  //   if (permission == geo.LocationPermission.deniedForever) {
  //     // Location permissions are permanently denied, take appropriate action
  //     return false;
  //   }

  //   bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are disabled, take appropriate action
  //     return false;
  //   }

  //   return true;
  // }
  String formatAndRoundNumber(String input) {
    double number = double.tryParse(input) ?? 0;
    int roundedNumber = number.round();
    String formattedNumber = NumberFormat("#,###").format(roundedNumber);
    return formattedNumber;
  }

  Future<void> showMap(String url) async {
    try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch Google Maps URL';
        }

    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
