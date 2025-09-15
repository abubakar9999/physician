// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// import '../../../data/datasources/local_storage/boxes.dart';
//
//
// class Gift extends StatefulWidget {
//   Gift({
//     super.key,
//     required this.docId,
//   });
//   final String docId;
//
//   @override
//   State<Gift> createState() => _GiftState();
// }
//
// class _GiftState extends State<Gift> {
//   double progress = 0;
//   final databox = Boxes.allData();
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//   String giftUrl = '';
//
//   @override
//   void initState() {
//     cid = databox.get("CID")!;
//     userId = databox.get("user_id")!;
//     userPassword = databox.get("PASSWORD")!;
//     giftUrl = databox.get("gift_url") ?? "";
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     debugPrint(
//       //"$repLastOrdUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.docId}"
//       //"https://w05.yeapps.com/hamdard_report/last_doctor_visit/last_doctor_visit?cid=HAMDARD&rep_id=9010&password=1234&doc_id=5087426"
//       //"https://w05.yeapps.com/hamdard_report/last_doctor_visit/last_doctor_visit?cid=$cid&rep_id=$userId&password=$userPassword&doc_id=${widget.docId}");
//         "gift__$giftUrl?cid=$cid&rep_id=$userId&password=$userPassword&doc_id=${widget.docId}"
//     );
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Gift"),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
//               child: InAppWebView(
//                 initialUrlRequest: URLRequest(
//                     url: WebUri(
//                       //"$repLastOrdUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.docId}"
//                       //"https://w05.yeapps.com/hamdard_report/last_doctor_visit/last_doctor_visit?cid=HAMDARD&rep_id=9010&password=1234&doc_id=5087426"
//                       //"https://w05.yeapps.com/hamdard_report/last_doctor_visit/last_doctor_visit?cid=$cid&rep_id=$userId&password=$userPassword&doc_id=${widget.docId}"
//                       // "https://w05.yeapps.com/hamdard_report/last_doctor_visit/last_doctor_visit?cid=$cid&rep_id=$userId&password=$userPassword&doc_id=${widget.docId}"
//                         "$giftUrl?cid=$cid&rep_id=$userId&password=$userPassword&doc_id=${widget.docId}"
//
//                     )),
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
