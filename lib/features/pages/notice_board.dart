import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/datasources/local_storage/hive_data_model.dart';
import '../../data/service/apiCall.dart';
import 'notice_details_screen.dart';


class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool isLoading = false;
  List<NoticeListModel> noticeList = [];
  // var box = Hive.box('checkData');
  var notices = Boxes.getNoticeList();
  List noticeIds = [];
  String noticeCount = '0';
  final noticeBox = Hive.box<NoticeListModel>('noticeList');
  final seenNoticeCount = Hive.box('checkData');
  List noticeSeenCount = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      noticeIds = seenNoticeCount.get('notice_Id', defaultValue: []);
      debugPrint("Notice IDs: ${noticeIds.toString()}");
      noticeSeenCount = seenNoticeCount.get('notice_Id', defaultValue: []);
      noticeList = notices.values.toList();
      await getNoticeApi();
      fetchNoticeList();
    });
  }

  void fetchNoticeList() {
    final noticeBox = Boxes.getNoticeList();
    setState(() {
      noticeList = noticeBox.values.toList();
    });
  }

  Future<void> getNoticeApi() async {
    setState(() {
      isLoading = true;
    });
    debugPrint("Hitting API");
    List<NoticeListModel> apiNoticeList = await noticeEvent();

    debugPrint("API hit complete");



    List noticeSeenCount = seenNoticeCount.get('notice_Id', defaultValue: []);
    List<String> currentNoticeIds =
    apiNoticeList.map((notice) => notice.notice_id ?? '').toList();
    noticeSeenCount =
        noticeSeenCount.where((id) => currentNoticeIds.contains(id)).toList();
    seenNoticeCount.put('notice_Id', noticeSeenCount);
    await noticeBox.clear();
    for (var noticeMap in apiNoticeList) {
      NoticeListModel noticeModel = NoticeListModel(
        uiqueKey: noticeMap.uiqueKey ?? 0,
        notice_date: noticeMap.notice_date ?? '',
        notice_title: noticeMap.notice_title ?? '',
        notice_details: noticeMap.notice_details ?? '',
        notice_id: noticeMap.notice_id ?? '',
          status: noticeMap.status ?? ''
      );

      await noticeBox.add(noticeModel);
    }

    setState(() {
      noticeList = noticeBox.values.toList();
      noticeCount = (noticeList.length - noticeSeenCount.length).toString();
      seenNoticeCount.put('noticeCount', noticeCount);
      isLoading = false;
    });

    debugPrint("Notice List Length: ${noticeList.length}");
    debugPrint("Seen Notice Count Length: ${noticeSeenCount.length}");
    debugPrint("Notice Count: $noticeCount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : noticeList.isNotEmpty
          ? RefreshIndicator(
        onRefresh: getNoticeApi,
        child: ListView.builder(
          itemCount: noticeList.length,
          itemBuilder: (context, index) {
            var str = noticeList[index].notice_date;
            var parts = str?.split(' ');
            var prefix = parts?[0].trim();
            var prefixTime = parts?[1].trim();
            var prefixSplit = prefix?.split("-");
            var lastPart = prefixSplit?[2];
            var secPart = prefixSplit?[1];
            var firstPart = prefixSplit?[0];

            return InkWell(
              onTap: () async {
                var currentNoticeId = noticeList[index].notice_id;

                if (!noticeIds.contains(currentNoticeId)) {
                  noticeIds.add(currentNoticeId);
                  seenNoticeCount.put('notice_Id', noticeIds);
                }

                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => NoticePage(
                      notice: noticeList[index],
                    )));
                setState(() {
                  noticeIds = seenNoticeCount.get('notice_Id', defaultValue: []);
                  noticeList = noticeBox.values.toList();
                  noticeCount = (noticeList.length - noticeSeenCount.length).toString();
                  seenNoticeCount.put('noticeCount', noticeCount);
                });
              },
              child: Card(
                elevation: 6,
                child: Container(
                  color:
                  const Color.fromARGB(255, 189, 247, 237),
                  child: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(5, 8, 0, 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromARGB(255, 138, 201, 149),
                                Color.fromARGB(255, 119, 199, 133),
                                Color.fromARGB(255, 62, 201, 91),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 0, 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                      lastPart!,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            secPart!,
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            firstPart!,
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                prefixTime!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Stack(
                                children: [
                                  const Divider(),
                                  noticeIds.contains(
                                      noticeList[index]
                                          .notice_id)
                                      ? const SizedBox.shrink()
                                      : const Positioned(
                                    right: 4,
                                    top: 0,
                                    bottom: 0,
                                    child: Align(
                                      alignment:
                                      Alignment
                                          .centerRight,
                                      child: Icon(
                                        Icons
                                            .notifications_active,
                                        color:
                                        Colors.green,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                noticeList[index].notice_title,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      )
          : const Center(child: Text("No Data Found")),
    );
  }
}
