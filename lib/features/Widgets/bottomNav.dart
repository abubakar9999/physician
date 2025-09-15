// ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:hamdard_mrep_v03/Pages/syncDataTabPaga.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import '../Pages/homePage.dart';
// import '../models/bottomMenue.dart';

// class BottomNavbar extends StatefulWidget {
//   const BottomNavbar({Key? key}) : super(key: key);

//   @override
//   _BottomNavbarState createState() => _BottomNavbarState();
// }

// String userName = '';
// String user_id = '';

// class _BottomNavbarState extends State<BottomNavbar> {
//   PageController _pageController = PageController();
//   int _selectIndex = 0;

//   @override
//   void initState() {
//     SharedPreferences.getInstance().then((prefs) {
//       userName = prefs.getString("userName")!;
//       user_id = prefs.getString("user_id")!;
//       // debugPrint(areaPage);
//     });

//     setState(() {});
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         itemCount: child.length,
//         controller: _pageController,
//         onPageChanged: (value) => setState(() => _selectIndex = value),
//         itemBuilder: (itemBuilder, index) {
//           return Container(
//             child: child[index],
//           );
//         },
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0,
//         child: SizedBox(
//           height: 60,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 for (var i = 0; i < bottomMenu.length; i++)
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _pageController.jumpToPage(i);
//                         _selectIndex = i;
//                       });
//                     },
//                     child: Icon(
//                       bottomMenu[i].icocandata,
//                       color: _selectIndex == i
//                           ? Colors.green
//                           : Colors.grey.withOpacity(1),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List child = [
//     // MyHomePage(userName: userName, user_id: user_id),
//     Container(color: Colors.blue),
//     // Container(color: Colors.teal),
//     // const SyncDataTabScreen(),
//   ];
// }
