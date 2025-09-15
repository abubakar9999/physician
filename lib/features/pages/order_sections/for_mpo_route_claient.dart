import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/datasources/local_storage/hive_data_model.dart';
import 'customerListPage.dart';


class ClaientRoutePage extends StatefulWidget {
  const ClaientRoutePage({Key? key}) : super(key: key);

  @override
  State<ClaientRoutePage> createState() => _ClaientRoutePageState();
}

class _ClaientRoutePageState extends State<ClaientRoutePage> {
  List clientdata = [];
  List clientlist = [];
  bool isClientForMPOSync = false;

  List<NoticeListModel> noticeList = [];
  final mydatabox = Boxes.allData();
  final seenNoticeCount = Hive.box('checkData');
  final noticeBox = Hive.box<NoticeListModel>('noticeList');


  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("*******client ${Hive.box("mpoForClaient").values.toList()}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        clientdata = Hive.box("mpoForClaient").values.toList();
        isClientForMPOSync = mydatabox.get('isClientForMPOSync') ?? false;

        if (isClientForMPOSync == false) {
          Fluttertoast.showToast(
              msg: 'Please Sync Customer',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
      searchAreaList('');
    });
  }

  List filterAreaList = [];
  searchAreaList(String search) async {
    if (search.isEmpty) {
      filterAreaList = clientdata;
    } else {
      filterAreaList = clientdata
          .where((element) =>
              element['route'].toString().toLowerCase().contains(search))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  // Future<void> getNotice() async {
  //   debugPrint("hitting api from homeeeeeeeeeeeeeessssssssssssssscccccccccccccrrrrrrrrrrrrreeeeeeeeeeeeeeeeennnnnnnnnnnnnnnnnnnnn");
  //   List<NoticeListModel> apiNoticeList = await noticeEvent();
  //
  //   debugPrint("api hitted");
  //
  //
  //   List noticeSeenCount = seenNoticeCount.get('notice_Id', defaultValue: []);
  //   List<String> currentNoticeIds = apiNoticeList.map((notice) => notice.notice_id ?? '').toList();
  //   noticeSeenCount = noticeSeenCount.where((id) => currentNoticeIds.contains(id)).toList();
  //   seenNoticeCount.put('notice_Id', noticeSeenCount);
  //   await noticeBox.clear();
  //   for (var noticeMap in apiNoticeList) {
  //     NoticeListModel noticeModel = NoticeListModel(
  //         uiqueKey: noticeMap.uiqueKey ?? 0,
  //         notice_date: noticeMap.notice_date ?? '',
  //         notice_title: noticeMap.notice_title ?? '',
  //         notice_details: noticeMap.notice_details ?? '',
  //         notice_id: noticeMap.notice_id ?? '',
  //         status: noticeMap.status ?? ''
  //     );
  //
  //     // Add the NoticeModel object to the Hive box
  //     await noticeBox.add(noticeModel);
  //   }
  //
  //   // Update the noticeCount
  //
  //   String noticeCount = (apiNoticeList.length - noticeSeenCount.length).toString();
  //   seenNoticeCount.put('noticeCount', noticeCount);
  //   mydatabox.put('first_notice_api_hit', true);
  //
  //
  //   debugPrint("Notice List Length: ${apiNoticeList.length}");
  //   debugPrint("Seen Notice Count Length: ${noticeSeenCount.length}");
  //   debugPrint("Notice Count: $noticeCount");
  // }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {

    //await   mydatabox.put('first_notice_api_hit', false);

      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Territory"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // onChanged: (value) => runFilter(value),
                  controller: searchController
                    ..addListener(() {
                      searchAreaList(searchController.text.toLowerCase());
                      setState(() {});
                    }),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: ' Search',
                    suffixIcon: searchController.text.isEmpty &&
                            searchController.text == ''
                        ? const Icon(Icons.search)
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              // runFilter('');
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear)),

                    //  suffixIcon: searchController.text.isEmpty &&
                    //             searchController.text == ''
                    //         ? const Icon(Icons.search)
                    //         : IconButton(
                    //             onPressed: () {
                    //               searchController.clear();
                    //               runFilter('');
                    //               setState(() {});
                    //             },
                    //             icon: const Icon(
                    //               Icons.clear,
                    //               color: Colors.black,
                    //               // size: 28,
                    //             ),
                    //           ),
                  ),
                ),
              ),
              Expanded(
                  child: filterAreaList.isEmpty
                      ? Center(
                          child: Text(
                            "No Data found",
                            style: TextStyle(fontSize: 24),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filterAreaList.length,
                          itemBuilder: (context, index) {
                            print("HHHHHHHLIst$clientlist");
                            var area = filterAreaList[index];
                            return InkWell(
                              onTap: () async {
                                clientlist = area["clientlist"];
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerListScreen(
                                      data: clientlist,
                                      // terrorId: area["route"],
                                      terrorId: area["route"]
                                              .toString()
                                              .contains('|')
                                          ? area["route"].toString().split('|')[1]
                                          : area["route"],
                                      terrorName: area["route"]
                                              .toString()
                                              .contains('|')
                                          ? area["route"].toString().split('|')[0]
                                          : area["route"],
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Card(
                                elevation: 10,
                                margin: EdgeInsets.fromLTRB(08.0, 0.0, 8.0, 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      area["route"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            );
                          }))
            ],
          ),
        ),
      ),
    );
  }
}
