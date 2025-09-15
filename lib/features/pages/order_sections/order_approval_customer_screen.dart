// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/datasources/local_storage/boxes.dart';

import '../../../data/models/order_approval_model.dart';
import '../../Widgets/new_order_customerwidget.dart';
import 'customer_edit_page.dart';
import 'order_approval_page.dart';

// ignore: must_be_immutable
class OrderApprovalCustomerListScreen extends StatefulWidget {
  AreaList areaList;

  OrderApprovalCustomerListScreen({
    Key? key,
    required this.areaList
  }) : super(key: key) ;

  @override
  State<OrderApprovalCustomerListScreen> createState() => _OrderApprovalCustomerListScreenState();
}

class _OrderApprovalCustomerListScreenState extends State<OrderApprovalCustomerListScreen> {
  Box? box;
  String client_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool client_flag = false;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  List<ClientList> foundUsers = [];
  int _counter = 0;
  final databox = Boxes.allData();
  String client_edit_url = '';
  bool clientEdit = false;
  String? logo_url_1;
  String? logo_url_2;
  AreaList? areaList;


  @override
  void initState() {
    super.initState();



    setState(() {

      cid = databox.get("CID")!;
      areaList = widget.areaList;
      userId = databox.get("user_id")!;
      // client_edit_url = databox.get("client_edit_url")!;
      userPassword = databox.get("PASSWORD")!;
      // clientEdit = databox.get('client_edit_flag') ?? false;
      // client_url = databox.get("client_url") ?? '';
      // client_flag = databox.get("client_flag") ?? false;
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

    foundUsers = widget.areaList.clientList ?? [];
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
    foundUsers = widget.areaList.clientList ?? [];
    List<ClientList> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      var starts = foundUsers
          .where((s) => s.clientName!
          .toLowerCase()
          .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
      s.clientName!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          s.clientId!.toLowerCase().startsWith(enteredKeyword.toLowerCase()) ||
          (s.orders != null && s.orders!.any((order) =>
              order.orderSerial!.toLowerCase().contains(enteredKeyword.toLowerCase()))))
          .toList()
        ..sort((a, b) => a.clientName!
            .toLowerCase()
            .compareTo(b.clientName!.toLowerCase()));


      results = contains;
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
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.areaList.areaName!.toUpperCase()} | ${widget.areaList.areaId!.toUpperCase()} ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 131, 186, 141),
                  ),
                ),
                Divider(
                  thickness: 1.0,
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
              : widget.areaList.clientList?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, index) {
            // Handle client based on searchController
            final client = searchController.text.isNotEmpty
                ? foundUsers[index]
                : widget.areaList.clientList?[index];

            // Safeguard against potential null clients
            if (client == null) {
              return const SizedBox.shrink();
            }

            return Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: ExpansionTile(
                title: NewOrderCustomerListCardWidget(
                  clientName: "${client.clientName ?? ''} (${client.clientName ?? ''})",
                  base: client.categoryName != null && client.categoryName!.isNotEmpty
                      ? '(${client.categoryName ?? ''})'
                      : '',
                  marketName: client.address ?? '',
                  outstanding: client.outstanding ?? '',
                ),
                // Safeguard orders mapping
                children: client.orders?.map((order) {
                  return ListTile(
                    title: Text(
                      "Order Sl : ${order.orderSerial ?? 'N/A'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delivery Date: ${order.deliveryDate ?? 'N/A'}"),
                        Text("Collection Date: ${order.collectionDate ?? 'N/A'}"),
                        Text("Delivery Time: ${order.deliveryTime ?? 'N/A'}"),
                        Text("Payment Mode: ${order.paymentMode ?? 'N/A'}"),
                        // Text("Offer: ${order.offer ?? 'N/A'}"),
                        // Text("Note: ${order.note ?? 'N/A'}"),
                        Text("Submitted By: ${order.submittedBy ?? 'N/A'}"),
                        // Removed duplicate submissions
                      ],
                    ),
                    onTap: () {
                      // Increment counter
                      _incrementCounter();

                      // Navigate to OrderApprovalPage with proper data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderApprovalPage(
                            ckey: 0,
                            uniqueId: _counter,
                            itemList: order.itemList ?? [],
                            deliveryDate: order.deliveryDate ?? '',
                            collectionDate: order.collectionDate ?? '',
                            deliveryTime: order.deliveryTime ?? '',
                            paymentMethod: order.paymentMode ?? '',
                            outStanding: client.outstanding ?? '',
                            clientName: client.clientName ?? "",
                            clientId: client.clientId ?? "",
                            marketName: client.categoryName != null &&
                                client.categoryName!.isNotEmpty
                                ? "(${client.categoryName}) ${client.address ?? ''}"
                                : client.address ?? '',
                            areaId: widget.areaList.areaId ?? "",
                            areaName: widget.areaList.areaName ?? "",
                            note: order.note, order_sl: order.orderSerial ?? "",
                          ),
                        ),
                      );
                    },
                  );
                }).toList() ?? [],
              ),
            );
          },
        )
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
