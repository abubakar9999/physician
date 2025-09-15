// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:physician_latest/features/pages/DCR_section/visited_entity_add_page.dart';


import '../../../data/datasources/local_storage/boxes.dart';
import '../../Widgets/customerListWidget.dart';
import 'dcr_gift_sample_PPM_page.dart';
import 'doctor_add_page.dart';
import 'doctor_edit_page.dart';
import 'microunion_add_page.dart';
import 'visited_entity_edit_page.dart';

// ignore: must_be_immutable
class DcrListPage extends StatefulWidget {
  List visitOfficeDataList;
  String? branchId;
  String? branchName;

  DcrListPage({
    Key? key,
    required this.visitOfficeDataList,
    this.branchId,
    this.branchName,
  }) : super(key: key);

  @override
  State<DcrListPage> createState() => _DcrListPageState();
}

class _DcrListPageState extends State<DcrListPage> with WidgetsBindingObserver {
  Box? box;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // String doctor_url = '';
  // String microunion_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool docFlag = false;
  // String doctor_url_edit = "";
  bool doctorEdit = false;

  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;
  final mydata = Boxes.allData();
  String? logo_url_1;
  String? logo_url_2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      cid = mydata.get("CID")!;
      userId = mydata.get("USER_ID")!;
      userPassword = mydata.get("PASSWORD")!;
      docFlag = mydata.get("doc_flag") ?? false;
      print('docFlag:$docFlag');
      doctorEdit = mydata.get('doc_edit_flag') ?? false;
      logo_url_1 = mydata.get('logo_url_1') ?? null;
      logo_url_2 = mydata.get('logo_url_2') ?? null;
    });
    if (mydata.get("_dcrcounter") != null) {
      int? a = mydata.get("_dcrcounter");

      setState(() {
        _counter = a!;
      });
    }

    _refreshDataFromHive();

    // foundUsers = widget.visitOfficeDataList;
    // if (foundUsers.isEmpty) {
    //   var doctorData = Hive.box('mpoForDoctor').values.toList();
    //   final branchKey = '${widget.branchName}|${widget.branchId}';
    //   var matched = doctorData.firstWhere(
    //         (e) => e['branch'].toString() == branchKey,
    //     orElse: () => {},
    //   );
    //   foundUsers = matched['office_list'] ?? [];
    // }
  }

  // A method to get the latest data from Hive
  void _refreshDataFromHive() {
    var doctorData = Hive.box('mpoForDoctor').values.toList();
    final branchKey = '${widget.branchName}|${widget.branchId}';
    var matched = doctorData.firstWhere(
          (e) => e['branch'].toString() == branchKey,
      orElse: () => {},
    );
    List newOfficeList = matched['office_list'] ?? [];

    setState(() {
      widget.visitOfficeDataList = newOfficeList;
      foundUsers = widget.visitOfficeDataList;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshDataFromHive();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    mydata.put('_dcrcounter', _counter);

    setState(() {});
  }

  // void runFilter(String enteredKeyword) {
  //   foundUsers = widget.dcrDataList;
  //   List results = [];
  //   if (enteredKeyword.isEmpty) {
  //     results = foundUsers;
  //   } else {
  //     var contains = foundUsers
  //         .where((s) =>
  //             s['doc_name'].toLowerCase().contains(enteredKeyword.toLowerCase())
  //                 || s['doc_name'].toLowerCase().contains(enteredKeyword.toLowerCase())
  //                 || s['doc_id'].toLowerCase().startsWith(enteredKeyword.toLowerCase())
  //                 || s['doc_name'].toLowerCase().startsWith(enteredKeyword.toLowerCase())).
  //     toList()..sort((a, b) => a['doc_name'].toLowerCase().compareTo(b['doc_name'].toLowerCase()));
  //     results = [...contains];
  //   }
  //   setState(() {
  //     foundUsers = results;
  //   });
  // }
  void runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.visitOfficeDataList;
    } else {
      results = widget.visitOfficeDataList.where((s) {
        final name = s['office_name']?.toLowerCase() ?? '';
        final id = s['office_id']?.toString().toLowerCase() ?? '';
        return name.contains(enteredKeyword.toLowerCase()) || id.startsWith(enteredKeyword.toLowerCase());
      }).toList()
        ..sort((a, b) => a['office_name'].toLowerCase().compareTo(b['office_name'].toLowerCase()));
    }

    setState(() {
      foundUsers = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     // LinearGradient
        //     gradient: LinearGradient(
        //       // colors for gradient
        //       colors: [
        //         Color(0xff70BA85),
        //         Color(0xff56CCF2),
        //       ],
        //     ),
        //   ),
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text('Visited Entity list'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 138, 201, 149)),
              child: Column(
                children: [
                  // logo_url_2 != null ?  CachedNetworkImage(
                  //   height: screenHeight*.15,
                  //   imageUrl: logo_url_2!,
                  //   errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                  // )
                  //     : Image.asset("assets/images/mRep7_logo.png"),
                  Image.asset('assets/images/c_logo_1.png',fit: BoxFit.contain,height: screenHeight*.075,),
                  SizedBox(height: 8,),
                  // Image.asset('assets/images/mRep7_logo.png'),
                  // Expanded(
                  //   child: Text(
                  //     '${widget.clientName}',
                  //     // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                  //     style: const TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Expanded(
                  //     child: Text(
                  //   widget.clientId,
                  //   style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold),
                  // ))
                ],
              ),
            ),
            docFlag
                ?
            // ListTile(
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.of(context).push(
            //               MaterialPageRoute(
            //             builder: (context) =>
            //                 //DoctorAddPage(areaId: widget.branchId.toString()),
            //             VisitedEntityAddScreen(
            //               // officeId: "${foundUsers[index]['office_id'] ?? ''}",
            //               // officeName: '${foundUsers[index]['office_name']}',
            //               branchId: '${widget.branchId}',
            //               branchName: '${widget.branchName}',
            //             )
            //           ));
            //         },
            //         leading:
            //             const Icon(Icons.person_add, color: Colors.blueAccent),
            //         title: const Text(
            //           'Visited Entity Add',
            //           style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w500,
            //               color: Color.fromARGB(255, 15, 53, 85)),
            //         ),
            //       )
            ListTile(
              // onTap: () async {
              //   Navigator.pop(context);
              //   final updatedList = await Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           VisitedEntityAddScreen(
              //             branchId: '${widget.branchId}',
              //             branchName: '${widget.branchName}',
              //           ),
              //     ),
              //   );
              //
              //   // If result is returned (updated office list), refresh UI
              //   if (updatedList != null && mounted) {
              //     setState(() {
              //       foundUsers = updatedList;
              //       widget.visitOfficeDataList = updatedList;
              //     });
              //   }
              // },
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VisitedEntityAddScreen(
                      branchId: '${widget.branchId}',
                      branchName: '${widget.branchName}',
                    ),
                  ),
                );
                _refreshDataFromHive();
              },
              leading: const Icon(Icons.person_add, color: Colors.blueAccent),
              title: const Text(
                'Visited Entity Add',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 15, 53, 85),
                ),
              ),
            )

        : Container(),
            // docFlag
            //     ?
            // ListTile(
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) =>
            //                 MicrounionAddPage(areaId: widget.branchId.toString()),
            //           ));
            //         },
            //
            //         leading: const Icon(Icons.medical_information,
            //             color: Colors.blueAccent),
            //         title: const Text(
            //           'Pocket Market',
            //           style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w500,
            //               color: Color.fromARGB(255, 15, 53, 85)),
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => runFilter(value),
                controller: searchController,
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
                            runFilter('');
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                            // size: 28,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                          widget.branchName.toString(),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                    Text(
                      "Total Count : ${foundUsers.length} ",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1.0,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.text.isNotEmpty
                        ? foundUsers.length
                        : widget.visitOfficeDataList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                doctorEdit == true
                                    ? InkWell(
                                        // onTap: () async {
                                        //   final updatedList = await Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           VisitedEntityEditScreen(
                                        //             officeId: "${foundUsers[index]['office_id'] ?? ''}",
                                        //             officeName: '${foundUsers[index]['office_name']}',
                                        //             branchId: '${widget.branchId}',
                                        //             branchName: '${widget.branchName}',
                                        //             district: "${foundUsers[index]['district'] ?? ''}",
                                        //             thana: "${foundUsers[index]['thana'] ?? ''}",
                                        //             phnNumber: foundUsers[index]['mobile_no'] ?? 0,
                                        //             organization: "${foundUsers[index]['org_name'] ?? ''}",
                                        //             designation: "${foundUsers[index]['designation'] ?? ''}",
                                        //             address: "${foundUsers[index]['address'] ?? ''}",
                                        //           ),
                                        //     ),
                                        //   );
                                        //
                                        //   // If result is returned (updated office list), refresh UI
                                        //   if (updatedList != null && mounted) {
                                        //     setState(() {
                                        //       foundUsers = updatedList;
                                        //       widget.visitOfficeDataList = updatedList;
                                        //     });
                                        //   }
                                        //
                                        //
                                        //   // Navigator.of(context).push(
                                        //   //   MaterialPageRoute(
                                        //   //     builder: (context) {
                                        //   //       return VisitedEntityEditScreen(
                                        //   //         officeId: "${foundUsers[index]['office_id'] ?? ''}",
                                        //   //         officeName: '${foundUsers[index]['office_name']}',
                                        //   //         branchId: '${widget.branchId}',
                                        //   //         branchName: '${widget.branchName}',
                                        //   //       );
                                        //   //     },
                                        //   //   ),
                                        //   // );
                                        // },
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VisitedEntityEditScreen(
                                              officeId: "${foundUsers[index]['office_id'] ?? ''}",
                                              officeName: '${foundUsers[index]['office_name']}',
                                              branchId: '${widget.branchId}',
                                              branchName: '${widget.branchName}',
                                              district: "${foundUsers[index]['district'] ?? ''}",
                                              thana: "${foundUsers[index]['thana'] ?? ''}",
                                              phnNumber: foundUsers[index]['mobile_no'] ?? 0,
                                              organization: "${foundUsers[index]['org_name'] ?? ''}",
                                              designation: "${foundUsers[index]['designation'] ?? ''}",
                                              address: "${foundUsers[index]['address'] ?? ''}",
                                            ),
                                      ),
                                    );
                                    _refreshDataFromHive();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(Icons.edit),
                                  ),
                                )
                                    : const SizedBox(),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _incrementCounter();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DcrGiftSamplePpmPage(
                                            ck: '',
                                            dcrKey: 0,
                                            uniqueId: _counter,
                                            draftOrderItem: [],
                                            officeName: foundUsers[index]['office_name']??'',
                                            officeId: foundUsers[index]['office_id']??'',
                                            areaName: widget.branchName??'',
                                            // foundUsers[index]//todo Old
                                            //     ['area_name'],
                                            areaId: widget.branchId??'',
                                            //  foundUsers[index]['area_id'],//todo old
                                            address: "",
                                            //  foundUsers[index]['address'],//todo old
                                            note: '',
                                            dVisitedWith: "",
                                            nonExcution: "",
                                            selectedDeliveryTime: "",
                                            image1: '',
                                            visitedPerson: '',
                                            phnNum: foundUsers[index]['mobile_no']??'',
                                            orgName: foundUsers[index]['org_name']??'',
                                            brandId: foundUsers[index]['category']??'',
                                            category: foundUsers[index]['brand_id']??'',
                                          ),
                                        ),
                                      );
                                    },
                                    child: CustomerListCardWidget(
                                        clientName: foundUsers[index]['office_name']??'',
                                        clientId:foundUsers[index]['office_id']??'',
                                        docDegree:foundUsers[index]['category'].toString().isNotEmpty?'(${foundUsers[index]['category']??''})' : 'None',
                                        address:foundUsers[index]['address'] ?? '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
                : const Center(
                  child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
                ),
          ),
        ],
      ),
    );
  }
}
