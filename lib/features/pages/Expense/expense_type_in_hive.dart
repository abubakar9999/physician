// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../data/service/apiCall.dart';

class ExpenseTypeData {
   Box box = Hive.box('expenseData');
  
 
var expenseType = databox.get("exp_type_url");
 
 
 
 
var cid = databox.get("CID");
var user_id = databox.get("USER_ID");
var user_pass = databox.get("PASSWORD");
 
List expense_data=[];



  expenseEntry(contexts) async {
  
  debugPrint("$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass");
  // debugPrint("http://192.168.0.247:8000/ipi_combined_api/api_expense_dmm_check/exp_type_list?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            '$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass'),
        // "http://192.168.0.247:8000/ipi_combined_api/api_expense_dmm_check/exp_type_list?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var orderHistoryInfo = json.decode(response.body);

    String status = orderHistoryInfo['status'];
    List<dynamic> expTypeList = orderHistoryInfo['expTypeList'];
    debugPrint('All expanse$orderHistoryInfo');

    if (status == 'Success') {
    await  databox.put('isExpenseSync', true);
     debugPrint("My Expanse Data is $expTypeList");
      put_expase_in_hive(expTypeList);
      Timer(const Duration(seconds: 3), () => Navigator.pop(contexts));

      return buildShowDialog(contexts);
    }
  } catch (e) {
    debugPrint('Order History error message: $e');
  }
  return "error";
}


put_expase_in_hive(expenselist)async{
 // Box box = Hive.box('expenseData');
 await box.clear();

 for (var d in expenselist) {
  box.add(d);
   
 }

  debugPrint("Addd Box ${box.values}");


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
                child: Text('Expanse data synchronizing... '),
              )
            ],
          );
        });
  }





  
}