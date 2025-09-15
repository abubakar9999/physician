// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../../data/datasources/local_storage/boxes.dart';
import '../../data/service/apiCall.dart';


class AreaPage extends StatefulWidget {
  String isdcr;
  bool orderApproval;
  AreaPage({
    Key? key,
    this.isdcr = "",
    this.orderApproval = false
  }) : super(key: key);

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  final TextEditingController searchController = TextEditingController();

  String cid = '';
  String userId = '';
  String userPassword = '';
  String areaPageUrl = '';
  String syncUrl = '';
  bool _isLoading = false;
  String searchArea = '';
  final databox = Boxes.allData();

  @override
  void initState() {
    super.initState();

    setState(() {
      cid = databox.get("CID")!;
      userId = databox.get("USER_ID")!;
      areaPageUrl = databox.get('user_area_url')!;
      userPassword = databox.get("PASSWORD")!;
      syncUrl = databox.get("sync_url")!;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Territory'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // onChanged: (value) => runFilter(value),
                controller: searchController
                  ..addListener(() {
                    setState(() {
                      searchArea = searchController.text;
                    });
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
              child: FutureBuilder(
                future: getAreaPage(areaPageUrl, cid, userId, userPassword),
                builder: ((context, AsyncSnapshot<List> snapshot) {
                  debugPrint("----------------------------------------------area--------------------------------${areaPageUrl.toString()}");
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error} occured');
                    } else if (snapshot.data != null) {
                      var _searchResult = searchArea.isEmpty
                          ? snapshot.data
                          : snapshot.data
                              ?.where((element) => element
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchArea.toLowerCase()))
                              .toList();
                      return _searchResult!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data found",
                                style: TextStyle(fontSize: 24),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResult.length,
                              itemBuilder: (context, index) {
                                var area = _searchResult[index];
                                return StatefulBuilder(
                                    builder: (BuildContext context, setState1) {
                                  return InkWell(
                                    onTap: () async {
                                      if (widget.isdcr == "dcr") {
                                        setState1(() {
                                          _isLoading = true;
                                        });
                                        bool response = await getAreaBaseDoctor(
                                            context,
                                            syncUrl,
                                            cid,
                                            userId,
                                            userPassword,
                                            area['area_id'],
                                            area['area_name']);

                                        setState(() {
                                          _isLoading = response;
                                        });
                                      } else {
                                        setState1(() {
                                          _isLoading = true;
                                        });
                                        bool response = await getAreaBaseClient(
                                          context,
                                          syncUrl,
                                          cid,
                                          userId,
                                          userPassword,
                                          area['area_id'],
                                          area['area_name'],
                                        );

                                        setState(() {
                                          _isLoading = response;
                                        });
                                      }
                                    },
                                    child: Card(
                                      // color: Colors.blue.withOpacity(.03),
                                      margin: EdgeInsets.fromLTRB(
                                          08.0, 0.0, 8.0, 10),
                                      elevation: 2,
                                      child: SizedBox(
                                          //height: 40,
                                          child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${area['area_name']} | ${area['area_id']}",
                                              ),
                                            ),
                                          ),
                                          _isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () async {
                                                    if (widget.isdcr == "dcr") {
                                                      setState1(() {
                                                        _isLoading = true;
                                                      });
                                                      bool response =
                                                          await getAreaBaseDoctor(
                                                              context,
                                                              syncUrl,
                                                              cid,
                                                              userId,
                                                              userPassword,
                                                              area['area_id'],
                                                              area[
                                                                  'area_name']);

                                                      setState(() {
                                                        _isLoading = response;
                                                      });
                                                    } else {
                                                      setState1(() {
                                                        _isLoading = true;
                                                      });
                                                      bool response =
                                                          await getAreaBaseClient(
                                                              context,
                                                              syncUrl,
                                                              cid,
                                                              userId,
                                                              userPassword,
                                                              area['area_id'],
                                                              area[
                                                                  'area_name']);

                                                      setState(() {
                                                        _isLoading = response;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(Icons
                                                      .arrow_forward_ios_sharp),
                                                ),
                                        ],
                                      )),
                                    ),
                                  );
                                });
                              });
                    }
                  } else {}
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
