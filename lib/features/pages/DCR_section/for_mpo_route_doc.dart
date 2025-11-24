import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../loginPage.dart';
import 'dcr_list_page.dart';

class DoctorTerritoryPage extends StatefulWidget {
  const DoctorTerritoryPage({Key? key}) : super(key: key);

  @override
  State<DoctorTerritoryPage> createState() => _DoctorTerritoryPageState();
}

class _DoctorTerritoryPageState extends State<DoctorTerritoryPage> {
  List doctorData = [];
  List doctorList = [];
  bool isDoctorForMPOSync = false;
  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Box box = Hive.box('mpoForDoctor');
      print('5555555555555555555555555');
      print('box:${box.get(0)}');
      // print("Doctor =========${Hive.box("mpoForDoctor").toMap().values.toList()}");
      setState(() {
        doctorData = Hive.box("mpoForDoctor").values.toList();
        foundUsers = doctorData;

        isDoctorForMPOSync = mydatabox.get('isDoctorForMPOSync') ?? false;
        print('is doctor for mpo sync::$isDoctorForMPOSync');

        if (isDoctorForMPOSync == false) {
          Fluttertoast.showToast(msg: 'Please Sync Doctor', backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
        }
      });
      print("*******doctor   $doctorData");
    });
  }

  void runFilter(String enteredKeyword) {
    print("enteredKeyword:$enteredKeyword");
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = doctorData;
    } else {
      results =
          doctorData.where((data) {
            final route = data["branch"]?.toString().toLowerCase() ?? "";
            return route.contains(enteredKeyword.toLowerCase());
          }).toList();
    }

    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: const Text("Branch")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                runFilter(value);
              },
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Search',
                suffixIcon:
                    searchController.text.isEmpty && searchController.text == ''
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
          Padding(padding: const EdgeInsets.only(right: 8), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("Total Branch : ${foundUsers.length}", style: const TextStyle(fontSize: 16, color: Colors.black))])),
          Expanded(
            //flex: 9,
            child:
                foundUsers.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: foundUsers.length,
                      itemBuilder: (context, index) {
                        final raw = foundUsers[index]["branch"].toString();

                        // remove quotes + outer spaces
                        final cleaned = raw.replaceAll("'", "").trim();

                        // split & trim each side
                        final parts = cleaned.split('|').map((e) => e.trim()).toList();

                        // final clean branch name & id
                        final branchName = parts.isNotEmpty ? parts[0] : "";
                        final branchId = parts.length > 1 ? parts[1] : parts[0];

                        print("FD US $foundUsers");
                        print('foundUsers:${foundUsers.length}');
                        print('xx:${foundUsers[index]["branch"]}');
                        final doctorList = foundUsers[index]["office_list"];
                        // final doctor = foundUsers[index]["branch"].toString();
                        return InkWell(
                          onTap: () async {
                            print("Selectd Data : $raw");
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => DcrListPage(visitOfficeDataList: doctorList, branchId: branchId, branchName: branchName, branchKey: raw)));
                            setState(() {});
                          },
                          child: Card(elevation: 10, child: Padding(padding: const EdgeInsets.all(5), child: ListTile(title: Text(raw, style: const TextStyle(color: Colors.black)), trailing: const Icon(Icons.arrow_forward_ios_outlined)))),
                        );
                      },
                    )
                    : const Center(child: Text('No results found', style: TextStyle(fontSize: 24))),
          ),
        ],
      ),
    );
  }
}
