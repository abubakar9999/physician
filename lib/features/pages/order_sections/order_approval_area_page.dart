// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:physician_latest/data/service/apiCall.dart';

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/models/order_approval_model.dart';
import 'order_approval_customer_screen.dart';


class OrderApprovalAreaScreen extends StatefulWidget {
  OrderApprovalAreaScreen({Key? key,}) : super(key: key);

  @override
  State<OrderApprovalAreaScreen> createState() => _OrderApprovalAreaScreenState();
}

class _OrderApprovalAreaScreenState extends State<OrderApprovalAreaScreen> {
  final TextEditingController searchController = TextEditingController();

  String cid = '';
  String userId = '';
  String userPassword = '';
  String areaPageUrl = '';
  bool _isLoading = false;
  String searchArea = '';
  String order_list_url = '';
  final databox = Boxes.allData();

  @override
  void initState() {
    super.initState();

    setState(() {
      cid = databox.get("CID")!;
      userId = databox.get("USER_ID")!;
      areaPageUrl = databox.get('user_area_url')!;
      userPassword = databox.get("PASSWORD")!;
      order_list_url = databox.get("order_list_url") ?? '';
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
                future: getOrderApprovalData(order_list_url, cid, userId, userPassword),
                builder: ((context, AsyncSnapshot<List<AreaList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error} occured');
                    } else if (snapshot.data != null) {
                      var _searchResult = searchArea.isEmpty
                          ? snapshot.data
                          : snapshot.data
                          ?.where((element) => element.areaId
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
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> OrderApprovalCustomerListScreen(areaList: area)));
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
                                                    "${area.areaName} | ${area.areaId}",
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
                                                onPressed: () async {},
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
