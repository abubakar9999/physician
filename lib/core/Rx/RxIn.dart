// ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';

// class RxDataPage extends StatefulWidget {
//   const RxDataPage({Key? key}) : super(key: key);

//   @override
//   State<RxDataPage> createState() => _RxDataPageState();
// }

// class _RxDataPageState extends State<RxDataPage> {
//   Box? box;
//   List data = [];
//   @override
//   void initState() {
//     getData();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView.builder(
//             itemCount: 6,
//             itemBuilder: (context, index) => ListTile(
//                   title: Text('$data'),
//                 )));
//   }

//   //! Future openBox3() async {
//   //!  var dir = await getApplicationDocumentsDirectory();
//   //!  Hive.init(dir.path);
//   //!  box = await Hive.openBox('rxInfoData');
//   //!}

//    getData() {
//     //! await openBox3();
//     var box=Hive.box('rxInfoData');
//     var rxinfo = box.toMap().values.toList();
//     if (rxinfo == '') {
//       data.add('Empty');
//     } else {
//       data = rxinfo;
//       print(data);
//     }
//   }
// }
