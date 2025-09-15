import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/service/apiCall.dart';
import '../loginPage.dart';
import '../order_and_dcr_root_sync.dart';

class VisitedEntityAddScreen extends StatefulWidget {
  // final String officeId;
  // final String officeName;
  final String branchName;
  final String branchId;

  const VisitedEntityAddScreen({Key? key,  required this.branchName, required this.branchId,}) : super(key: key);

  @override
  State<VisitedEntityAddScreen> createState() => _VisitedEntityAddScreenState();
}

class _VisitedEntityAddScreenState extends State<VisitedEntityAddScreen> {
  final dataBox=Boxes.allData();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController officeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController thanaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _districtSearchController = TextEditingController();
  final TextEditingController _thanaSearchController = TextEditingController();



  List<dynamic> districtThanaList = [];
  List<String> districtName = [];
  List<String> thanaNames = [];

  String? selectedDistrict;
  String? selectedThana;


  String cid = '';
  String userId = '';
  String userPassword = '';
  String visit_office_add_url='';

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    //officeController.text = widget.officeName;
    branchController.text = widget.branchName;

    cid = dataBox.get("CID")!;
    userId = dataBox.get("user_id")!;
    userPassword = dataBox.get("PASSWORD")!;
    visit_office_add_url=dataBox.get('visit_office_add_url');


    districtThanaList=dataBox.get('district_thana_list', defaultValue: []);
    print('District Thana list:$districtThanaList');
    if (districtThanaList.isNotEmpty) {
      districtName = districtThanaList.map<String>((e) => e['district_name'].toString()).toList();

      final defaultSystem = districtThanaList.firstWhere(
            (element) => element['district_name'] == selectedDistrict,
        orElse: () => {'thana_name': []},
      );

      final thana = defaultSystem['thana_name'];
      if (thana is List) {
        thanaNames = thana.map((e) => e.toString()).toList();
      } else {
        thanaNames = [];
      }
    }

  }

  visitOffice(contexts) async {
    var data = await getClaintandDoctot();

    List office = [];
    print('data status::${data["status"]}');
    if (data["status"] == "Success") {

      await mydatabox.put('isDoctorForMPOSync', true);

      office = data["visitOfficeList"];
      print('office::$office');

      debugPrint("office data$office");
      await putVisitOfficeForMpo(office);

      return const CircularProgressIndicator();
    } else {
      print("Errror");
    }
  }
  putVisitOfficeForMpo(office) async {
    print('xxxx');
    Box box = Hive.box('mpoForDoctor');
    await box.clear();
    for (var d in office) {
      print('xxxx');
      box.add(d);
      debugPrint("ADDD------------$d");
    }
    debugPrint("boxDoctor${box.values}");
    print("------------------------------------------000000");

    print(box.values.toString());
  }


  Future<void> submitVisitedEntityAdd({
    required String cid,
    required String userId,
    required String userPassword,
    required String officeName,
    required String branchId,
    required String officeAddress,
    required String district,
    required String thana,
    required String designation,
    required String companyName,
    required String officePhone,
  }) async {

    setState(() {
      isSubmitting = true;
    });

    final uri = Uri.parse(
      //'http://192.168.100.219:8000/physician_api/api_visit_office_add/office_add'
      '$visit_office_add_url'
          '?cid=$cid'
          '&user_id=$userId'
          '&user_pass=$userPassword'
          '&office_name=$officeName'
          '&branch_id=$branchId'
          '&office_address=$officeAddress'
          '&district=$district'
          '&thana=$thana'
          '&designation=$designation'
          '&company_name=$companyName'
          '&office_phone=$officePhone',
    );

    debugPrint("Visited Entity Add API URL: $uri");

    try {
      final response = await http.get(uri);
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      // if (response.statusCode == 200) {
      //   debugPrint("Visited Entity Added Successfully");
      //   Navigator.pop(context);
      // }
      if (response.statusCode == 200) {
        debugPrint("Visited Entity Added Successfully");

        // Sync again
        await visitOffice(context);

        // Get updated data from Hive
        final updatedList = Hive.box('mpoForDoctor').values
            .toList()
            .where((e) => e['branch'].toString().contains(widget.branchId))
            .map((e) => e['office_list'])
            .expand((e) => e)
            .toList();

        Navigator.pop(context, updatedList); // ✅ Pass updated list back
      }
      else {
        debugPrint("Failed to add visited entity");
      }
    } catch (e) {
      debugPrint("Error submitting visited entity: $e");
    }
    finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visited Entity Add"),
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        actions: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body:isSubmitting
          ? const Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildLabel("Visited Office/ Person"),
              buildTextField(officeController),
              buildLabel("Branch"),
              buildReadOnlyField(branchController),
              buildLabel("District",),
              // Padding(
              //   padding: const EdgeInsets.only(top: 6),
              //   child: DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     contentPadding: const EdgeInsets.symmetric(
              //         horizontal: 12, vertical: 20),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //     hint: const Text('District'),
              //     value: selectedDistrict,
              //     validator: (value) => value == null ? 'Please select a District' : null,
              //     items: districtName.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Center(child: Text(value, style: const TextStyle(fontSize: 14))),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedDistrict = value;
              //         selectedThana = null;
              //
              //         final matched = districtThanaList.firstWhere(
              //               (element) => element['district_name'] == value,
              //           orElse: () => {'thana_name': []},
              //         );
              //
              //         final thana = matched['thana_name'];
              //         if (thana is List) {
              //           thanaNames = thana.map((e) => e.toString()).toList();
              //         } else {
              //           thanaNames = [];
              //         }
              //       });
              //     },
              //   ),
              // ),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                //hint: const Text('District'),
                value: selectedDistrict,
                validator: (value) => value == null ? 'Please select a District' : null,
                items: districtName.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                selectedItemBuilder: (context) {
                  return districtName.map((district) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        district,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList();
                },
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                    selectedThana = null;

                    final matched = districtThanaList.firstWhere(
                          (element) => element['district_name'] == value,
                      orElse: () => {'thana_name': []},
                    );

                    final thana = matched['thana_name'];
                    if (thana is List) {
                      thanaNames = thana.map((e) => e.toString()).toList();
                    } else {
                      thanaNames = [];
                    }
                  });
                  _districtSearchController.clear();
                },
                dropdownSearchData: DropdownSearchData(
                  searchController: _districtSearchController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _districtSearchController,
                      decoration: const InputDecoration(
                        hintText: 'Search district...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                  },
                ),
              ),
              const SizedBox(height: 10),
              buildLabel("Thana",),
              // Padding(
              //   padding: const EdgeInsets.only(top: 6),
              //   child: DropdownButtonFormField(
              //     decoration: InputDecoration(
              //       contentPadding: const EdgeInsets.symmetric(
              //           horizontal: 12, vertical: 20),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     hint: const Text('Thana'),
              //     value: selectedThana,
              //     validator: (value) => value == null ? 'Please select a Thana' : null,
              //     items: thanaNames.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Center(child: Text(value, style: const TextStyle(fontSize: 14))),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedThana=value;
              //       });
              //     },
              //   ),
              // ),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                //hint: const Text('Thana'),
                value: selectedThana,
                validator: (value) => value == null ? 'Please select a Thana' : null,
                items: thanaNames.map((thana) {
                  return DropdownMenuItem<String>(
                    value: thana,
                    child: Text(thana),
                  );
                }).toList(),
                selectedItemBuilder: (context) {
                  return thanaNames.map((thana) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        thana,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList();
                },
                onChanged: (value) {
                  setState(() {
                    selectedThana = value;
                  });
                  _thanaSearchController.clear();
                },
                dropdownSearchData: DropdownSearchData(
                  searchController: _thanaSearchController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _thanaSearchController,
                      decoration: const InputDecoration(
                        hintText: 'Search thana...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                  },
                ),
              ),
              const SizedBox(height: 10),
              buildLabel("Phone", ),
              buildTextField(
                  phoneController,
                  onTap: () {
                    if (phoneController.text.isEmpty) {
                      phoneController.text = '88';
                      phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: phoneController.text.length),
                      );
                    }
                  },
                  onChanged: (value){
                    {
                      if (!value.startsWith('88')) {
                        phoneController.text = '88';
                        phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: phoneController.text.length),
                        );
                      }
                    }
                  }
              ),
              buildLabel("Organization/ Company",),
              buildTextField(organizationController),
              buildLabel("Designation", ),
              buildTextField(designationController),
              buildLabel("Address", ),
              buildTextField(addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitVisitedEntityAdd(
                      cid: cid,
                      userId: userId,
                      userPassword: userPassword,
                      officeName: officeController.text.trim(),
                      branchId: widget.branchId.trim(),
                      officeAddress: addressController.text.trim(),
                      district: selectedDistrict ?? '',
                      thana: selectedThana ?? '',
                      designation: designationController.text.trim(),
                      companyName: organizationController.text.trim(),
                      officePhone: phoneController.text.trim(),
                    );

                  }
                },
                style: ElevatedButton.styleFrom(
                  shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  padding: const EdgeInsets.all(18),
                  backgroundColor: const Color.fromARGB(255, 138, 201, 149),
                ),
                child: const Center(child: Text("Submit",style: TextStyle(fontSize: 16),)),
              ),
              //const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text,) {
    return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: Row(
          children: [
            Text(text),
            const Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        )
    );
  }

  Widget buildTextField(TextEditingController controller,{
    Function(String)? onChanged,VoidCallback? onTap
  }) {
    return TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      validator: (val) => (val == null || val.isEmpty) ? 'Required field' : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
      ),
    );
  }

  Widget buildReadOnlyField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        fillColor: Color(0xFFEDEDED),
        filled: true,
      ),
    );
  }
}
