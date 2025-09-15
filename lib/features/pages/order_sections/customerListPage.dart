// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/datasources/local_storage/boxes.dart';
import '../../Widgets/dimensions.dart';
import '../../Widgets/new_order_customerwidget.dart';
import 'customer_add_page.dart';
import 'customer_edit_page.dart';
import 'newOrderPage.dart';


// ignore: must_be_immutable
class CustomerListScreen extends StatefulWidget {
  List data;
  String terrorId;
  String terrorName;

  CustomerListScreen({
    Key? key,
    required this.data,
    required this.terrorId,
    required this.terrorName,
  }) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Box? box;
  String client_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool client_flag = false;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;
  final databox = Boxes.allData();
  String client_edit_url = '';
  bool clientEdit = false;
  String? logo_url_1;
  String? logo_url_2;
  double screenHeight = 0.0;
  double screenWidth = 0.0;


  @override
  void initState() {
    super.initState();

    print("-------------------------------${widget.terrorId}");

    setState(() {
      cid = databox.get("CID")!;

      userId = databox.get("user_id")!;
      client_edit_url = databox.get("client_edit_url")!;
      userPassword = databox.get("PASSWORD")!;
      clientEdit = databox.get('client_edit_flag') ?? false;
      client_url = databox.get("client_url") ?? '';
      client_flag = databox.get("client_flag") ?? false;
      logo_url_1 = databox.get('logo_url_1') ?? null;
      logo_url_2 = databox.get('logo_url_2') ?? null;
    });
    // debugPrint('$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword');
    if (databox.get("_counter") != null) {
      int? a = databox.get("_counter");

      setState(() {
        _counter = a!;
      });
    }

    foundUsers = widget.data;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    databox.put('_counter', _counter);

    setState(() {});
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.data;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      var starts = foundUsers
          .where((s) => s['client_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['client_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              s['client_id']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) => a['client_name']
            .toLowerCase()
            .compareTo(b['client_name'].toLowerCase()));

      results = [...contains];
    }

    // Refresh the UI....................
    setState(() {
      foundUsers = results;
    });
  }

  // int _currentSelected = 0;

  // _onItemTapped(int index) async {
  //   if (index == 0) {
  //     Navigator.pop(context);
  //     setState(() {
  //       _currentSelected = index;
  //     });
  //   }
  //   if (index == 1) {
  //     getDrawer();
  //     setState(() {
  //       _currentSelected = index;
  //     });
  //   }
  // }

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
        title: const Text('Customer List'),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                // logo_url_2 != null ?  CachedNetworkImage(
                //   imageUrl: logo_url_2!,
                //   errorWidget: (context, url, error) => Image.asset("assets/images/mRep7_logo.png"),
                // )
                //     : Image.asset("assets/images/mRep7_logo.png"),
                Image.asset('assets/images/c_logo_1.png',fit: BoxFit.contain,height: screenHeight*.075,),
              ),
            ),
            // DrawerHeader(
            //   decoration: const BoxDecoration(
            //       color: Color.fromARGB(255, 138, 201, 149)),
            //   child: Column(
            //     children: [
            //       Image.asset('assets/images/mRep7_logo.png'),
            //       // Expanded(
            //       //   child: Text(
            //       //     '${widget.clientName}',
            //       //     // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
            //       //     style: const TextStyle(
            //       //         color: Colors.white,
            //       //         fontSize: 18,
            //       //         fontWeight: FontWeight.bold),
            //       //   ),
            //       // ),
            //       // Expanded(
            //       //     child: Text(
            //       //   widget.clientId,
            //       //   style: const TextStyle(
            //       //       color: Colors.white,
            //       //       fontSize: 15,
            //       //       fontWeight: FontWeight.bold),
            //       // ))
            //     ],
            //   ),
            // ),
            client_flag
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CustomerAddPage(terriId: widget.terrorId),
                      ));
                    },
                    leading:
                        const Icon(Icons.person_add, color: Colors.blueAccent),
                    title: const Text(
                      'Customer',
                      style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 15, 53, 85)),
                    ),
                  )
                : Container()
            // ListTile(
            //   leading: const Icon(Icons.document_scanner_outlined,
            //       color: Colors.black),
            //   title: const Text('Report'),
            //   onTap: () {
            //     // Update the state of the app.
            //   },
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   onTap: _onItemTapped,
      //   currentIndex: _currentSelected,
      //   showUnselectedLabels: true,
      //   unselectedItemColor: Colors.grey[800],
      //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Drawer',
      //       icon: Icon(Icons.menu),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
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
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "${widget.terrorName}",
          //                 softWrap: false,
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: TextStyle(
          //                   fontSize: 16.0,
          //                   fontWeight: FontWeight.w800,
          //                   color: Color.fromARGB(255, 131, 186, 141),
          //                 ),
          //               ),
          //               Text(
          //                 "${widget.terrorId.toUpperCase()} ",
          //                 style: TextStyle(
          //                   fontSize: 16.0,
          //                   fontWeight: FontWeight.w800,
          //                   color: Color.fromARGB(255, 131, 186, 141),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Text(
          //             "Total Count : ${widget.data?.length.toString() ?? "0"} ",
          //             style: TextStyle(
          //               fontSize: 16.0,
          //               fontWeight: FontWeight.bold,
          //               color: Color.fromARGB(255, 131, 186, 141),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Divider(
          //         thickness: 1.0,
          //       ),
          //     ],
          //   ),
          // ),


          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child:
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex:5,
                  child: Text(
                    "${widget.terrorName}",
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 131, 186, 141),
                    ),
                  ),
                ),
                // Text(
                //   "${widget.terrorId.toUpperCase()} ",
                //   style: TextStyle(
                //     fontSize: 16.0,
                //     fontWeight: FontWeight.w800,
                //     color: Color.fromARGB(255, 131, 186, 141),
                //   ),
                // ),
                Flexible(
                  flex: 3,
                  child: Text(
                    "Total Count : ${widget.data?.length.toString() ?? "0"} ",
                    //"Total Count :  545 ",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 131, 186, 141),
                    ),
                  ),
                ),
              ],
            ),


          ),


          Expanded(
            flex: 7,
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.text.isNotEmpty
                        ? foundUsers.length
                        : widget.data.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: Row(
                          children: [
                            clientEdit == true
                                ? InkWell(
                                    onTap: () async {
                                      // var url =
                                      //     //  'https://ww11.yeapps.com/ipi_report/client_update/client_edit?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                                      //     '$client_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${foundUsers[index]['client_id']}';
                                      // if (await canLaunch(url)) {
                                      //   await launch(url);
                                      // } else {
                                      //   throw 'Could not launch $url';
                                      // }
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerEditPage(
                                            clientId:
                                                "${foundUsers[index]['client_id']}",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.edit),
                                    ),
                                  )
                                : SizedBox(),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _incrementCounter();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewOrderPage(
                                        ckey: 0,
                                        uniqueId: _counter,
                                        draftOrderItem: [],
                                        deliveryDate: '',
                                        collectionDate: '',
                                        deliveryTime: '',
                                        paymentMethod: '',
                                        outStanding:
                                            // foundUsers[index]
                                            //         ['outstanding']//todo old
                                            //     .toString(),
                                            "",
                                        clientName: foundUsers[index]
                                            ['client_name'],
                                        clientId: foundUsers[index]
                                            ['client_id'],
                                        marketName:
                                            '${foundUsers[index]['category_name'].toString().isNotEmpty ? "(${foundUsers[index]['category_name'].toString()}) " : ' '}' +
                                                foundUsers[index]['address']
                                                    .toString(),
                                        areaId: widget.terrorId,
                                        areaName: widget.terrorName,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: NewOrderCustomerListCardWidget(
                                  clientName:
                                      "${foundUsers[index]['client_name'] ?? ''} (${foundUsers[index]['client_id'] ?? ''})",
                                  base: foundUsers[index]['category_name']
                                          .toString()
                                          .isNotEmpty
                                      ? '(${foundUsers[index]['category_name'] ?? ''})'
                                      : '',
                                  marketName:
                                      foundUsers[index]['address'] ?? '',
                                  outstanding:
                                      foundUsers[index]['outstanding'] ?? '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : const Text(
                    'No Data found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
