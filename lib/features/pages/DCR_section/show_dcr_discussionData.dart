// ignore_for_file: file_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import '../../../data/datasources/local_storage/hive_data_model.dart';

// ignore: must_be_immutable
class DcrDiscussionPage extends StatefulWidget {
  int uniqueId;
  List doctorDiscussionlist;
  List<DcrGSPDataModel> tempList;
  Function(List<DcrGSPDataModel>) tempListFunc;
  DcrDiscussionPage(
      {Key? key,
      required this.uniqueId,
      required this.doctorDiscussionlist,
      required this.tempList,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<DcrDiscussionPage> createState() => _DcrDiscussionPageState();
}

class _DcrDiscussionPageState extends State<DcrDiscussionPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  // final List<TextEditingController> _itemController = [];
  Map<String, TextEditingController> controllers = {};
  Map<String, bool> pressedActivity = {};
  List foundUsers = [];
  List dcrDiscussion = [];
  var selectedDiscussion;
  final _formkey = GlobalKey<FormState>();
  String? itemId;

  // List<AddItemModel> finalItemDataList = [];

  @override
  void initState() {
    foundUsers = widget.doctorDiscussionlist;
    for (var element in foundUsers) {
      pressedActivity[element['item_id']] = false;
    }
    // foundUsers.forEach((element) {
    //   controllers[element['item_id']] = TextEditingController();
    // });
    for (var element in widget.tempList) {
      itemId = element.giftId;
      // debugPrint('list: ${element.item_id}');
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    // foundUsers.forEach((element) {
    //   controllers[element['ppm_id']]!.dispose();
    // });
    super.dispose();
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.doctorDiscussionlist;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
     debugPrint("$results");
    } else {
      var starts = foundUsers
          .where((s) => s['item_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['item_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['item_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) => a['item_name']
            .toLowerCase()
            .compareTo(b['item_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  // int _currentSelected = 0;
  // _onItemTapped(int index) async {
  //   if (index == 1) {
  //     widget.tempListFunc(widget.tempList);

  //     Navigator.pop(context);
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
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        title: const Text('Discussion'),
        centerTitle: true,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   // type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     _onItemTapped(index);
      //   },
      //   currentIndex: 1,
      //   // showUnselectedLabels: true,
      //   unselectedItemColor: Colors.grey[800],
      //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: '',
      //       icon: Icon(
      //         Icons.save,
      //         color: Colors.white,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       // activeIcon: Icon(Icons.add_shopping_cart_outlined),
      //       label: 'AddtoCart',
      //       icon: Icon(Icons.add_shopping_cart_outlined),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        onChanged: (value) => runFilter(value),
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Item Search',
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Form(
              key: _formkey,
              child: foundUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: foundUsers.length,
                      itemBuilder: (context, index) {
                        final pressAttention =
                            pressedActivity[foundUsers[index]['item_id']];
                        return GestureDetector(
                          onTap: () {
                            setState(() =>
                                pressedActivity[foundUsers[index]['item_id']] =
                                    !pressAttention);

                            selectedDiscussion = foundUsers[index];
                            if (pressedActivity[
                                    selectedDiscussion['item_id']] ==
                                true) {
                              dcrDiscussion.add(selectedDiscussion);
                            } else {
                              dcrDiscussion.remove(selectedDiscussion);
                              // final temp = DcrGSPDataModel(
                              //   uiqueKey: widget.uniqueId,
                              //   quantity: 1,
                              //   giftName: selectedDiscussion['item_name'],
                              //   giftId: selectedDiscussion['item_id'],
                              //   giftType: 'Discussion',
                              // );

                              // String tempItemId = temp.giftId;

                              // widget.tempList.removeWhere(
                              //     (item) => item.giftId == tempItemId);

                              // setState(() {});
                            }
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromARGB(108, 255, 255, 255),
                                  width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: pressAttention!
                                    ? const Color.fromARGB(255, 143, 199, 248)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\n" +
                                                    foundUsers[index]
                                                        ['item_name'],
                                                // maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                foundUsers[index]['item_id'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : const Text(
                      'No data found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                for (var element in dcrDiscussion) {
                  var temp = DcrGSPDataModel(
                      uiqueKey: widget.uniqueId,
                      quantity: 1,
                      giftName: element['item_name'],
                      giftId: element['item_id'],
                      giftType: 'Discussion');

                  String tempItemId = temp.giftId;

                  widget.tempList
                      .removeWhere((item) => item.giftId == tempItemId);

                  widget.tempList.add(temp);
                }
                widget.tempListFunc(widget.tempList);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), backgroundColor: const Color.fromARGB(255, 4, 60, 105),
                maximumSize: const Size(200, 50),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(5))),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ADD",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
