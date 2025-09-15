// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// import '../../../data/datasources/local_storage/boxes.dart';
//
//
// class DoctorAddPage extends StatefulWidget {
//   DoctorAddPage({
//     super.key,
//     required this.areaId,
//   });
//   final String areaId;
//
//   @override
//   State<DoctorAddPage> createState() => _DoctorAddPageState();
// }
//
// class _DoctorAddPageState extends State<DoctorAddPage> {
//   double progress = 0;
//   String doctor_add_url = '';
//   final databox = Boxes.allData();
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//
//   @override
//   void initState() {
//     cid = databox.get("CID")!;
//     userId = databox.get("user_id")!;
//     doctor_add_url = databox.get("doctor_url")!;
//     userPassword = databox.get("PASSWORD")!;
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("$doctor_add_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&terri_id=${widget.areaId}");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Doctor Add"),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
//               child: InAppWebView(
//                 initialUrlRequest: URLRequest(
//                     //url: Uri.parse("$doctor_add_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&terri_id=${widget.areaId}")),
//                     url: WebUri("$doctor_add_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&terri_id=${widget.areaId}")),
//                 onReceivedServerTrustAuthRequest:
//                     (controller, challenge) async {
//                   // debugPrint(challenge);
//                   return ServerTrustAuthResponse(
//                       action: ServerTrustAuthResponseAction.PROCEED);
//                 },
//                 onProgressChanged:
//                     (InAppWebViewController controller, int progress) {
//                   setState(() {
//                     this.progress = progress / 100;
//                   });
//                 },
//               ),
//             ),
//             Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressBar() {
//     if (progress != 1.0) {
//       // return const CircularProgressIndicator();
// // You can use LinearProgressIndicator also
//       return LinearProgressIndicator(
//         value: progress,
//         valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
//         backgroundColor: Colors.blue,
//         minHeight: 7,
//       );
//     }
//     return Container();
//   }
// }
