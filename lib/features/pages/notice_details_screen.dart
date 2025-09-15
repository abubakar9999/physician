import 'package:flutter/material.dart';

import '../../data/datasources/local_storage/hive_data_model.dart';
import '../Widgets/dimensions.dart';

class NoticePage extends StatefulWidget {
  final NoticeListModel notice;

  const NoticePage({super.key, required this.notice});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 138, 201, 149),
            appBar: AppBar(
              elevation: 0.5,
              title: const Text("Notice Details"),
              centerTitle: true,
              leading: IconButton(icon:  const Icon(Icons.arrow_back),onPressed: () { Navigator.pop(context, true); // Return true when exiting the page
              },),
            ),

            //  "notice_date_time": "2024-07-29 14:36:42",
            //     "notice": "Api notice list",
            //     "note": "holiday"

            body: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3, color: Color.fromARGB(255, 138, 201, 149),)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      shape: const OutlineInputBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)), borderSide: BorderSide.none),
                      color:  Color.fromARGB(255, 189, 247, 237),
                      child: Padding(
                        padding: EdgeInsets.all(
                          // screenHeight(16, context),
                          // screenHeight(12, context),
                          // screenHeight(12, context),
                            screenHeight(12, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.notice.notice_title.toString(),
                              // style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            heightSpace(5),
                            Text(
                              widget.notice.notice_date!,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment: Alignment.topLeft,child: Text(widget.notice.notice_details ?? "", style: TextStyle(fontSize: 18),textAlign: TextAlign.left,)),
                    )
                  ],
                ),
              ),
            )));
  }
}
