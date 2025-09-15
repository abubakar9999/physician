// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// import '../../../data/datasources/local_storage/boxes.dart';
//
//
// class DoctorEditPage extends StatefulWidget {
//   const DoctorEditPage({
//     super.key,
//     required this.docId,
//   });
//   final String docId;
//
//   @override
//   State<DoctorEditPage> createState() => _DoctorEditPageState();
// }
//
// class _DoctorEditPageState extends State<DoctorEditPage> {
//   double progress = 0;
//   String doctor_edit_url = '';
//   final databox = Boxes.allData();
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//
//   @override
//   void initState() {
//     cid = databox.get("CID")!;
//     userId = databox.get("user_id")!;
//     doctor_edit_url = databox.get("doctor_edit_url")!;
//     userPassword = databox.get("PASSWORD")!;
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("office edit:$doctor_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&doc_id=${widget.docId}");
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Doctor Edit"),
//       ),
//       body: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
//               child: InAppWebView(
//                 initialUrlRequest: URLRequest(
//                     //url: Uri.parse("$doctor_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&doc_id=${widget.docId}")),
//                     url: WebUri("$doctor_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&doc_id=${widget.docId}")),
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
