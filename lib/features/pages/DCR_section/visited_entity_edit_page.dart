import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/service/apiCall.dart';
import '../loginPage.dart';

class VisitedEntityEditScreen extends StatefulWidget {
  final String officeId;
  final String officeName;
  final String branchName;
  final String branchId;
  final int phnNumber;
  final String district;
  final String thana;
  final String selectedCat;
  final String selectdSubCat;
  final String organization;
  final String designation;
  final String address;

  const VisitedEntityEditScreen({Key? key, required this.officeId, required this.branchName, required this.branchId, required this.officeName, required this.phnNumber, required this.district, required this.thana, required this.selectdSubCat, required this.selectedCat, required this.organization, required this.designation, required this.address}) : super(key: key);

  @override
  State<VisitedEntityEditScreen> createState() => _VisitedEntityEditScreenState();
}

class _VisitedEntityEditScreenState extends State<VisitedEntityEditScreen> {
  final dataBox = Boxes.allData();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController officeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _districtSearchController = TextEditingController();
  final TextEditingController _thanaSearchController = TextEditingController();
  final TextEditingController _categorySearchController = TextEditingController();
  final TextEditingController _subCategorySearchController = TextEditingController();

  List<dynamic> districtThanaList = [];
  List<String> districtName = [];
  List<String> thanaNames = [];
  List<dynamic> categorySubCategoryList = [];
  List<String> categoryNames = [];
  List<String> subCategoryList = [];
  String? selectedDistrict;
  String? selectedThana;
  String? selectedCatogry;
  String? selectedSubCategory;

  String cid = '';
  String userId = '';
  String userPassword = '';
  String visit_office_edit_url = '';

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    officeController.text = widget.officeName;
    branchController.text = widget.branchName;
    phoneController.text = widget.phnNumber.toString();
    organizationController.text = widget.organization;
    designationController.text = widget.designation;
    addressController.text = widget.address;

    cid = dataBox.get("CID")!;
    userId = dataBox.get("user_id")!;
    userPassword = dataBox.get("PASSWORD")!;
    visit_office_edit_url = dataBox.get('visit_office_edit_url');

    districtThanaList = dataBox.get('district_thana_list', defaultValue: []);
    if (districtThanaList.isNotEmpty) {
      districtName = districtThanaList.map<String>((e) => e['district_name'].toString()).toList();

      selectedDistrict = null;
      selectedThana = null;

      if (widget.district.isNotEmpty) {
        try {
          selectedDistrict = districtName.firstWhere((element) => element.toLowerCase().trim() == widget.district.toLowerCase().trim());
        } catch (e) {
          debugPrint('No matching district found for: ${widget.district}');
        }
      }

      if (selectedDistrict != null) {
        final defaultDistrictData = districtThanaList.firstWhere((element) => element['district_name'] == selectedDistrict, orElse: () => {'thana_name': []});
        final thana = defaultDistrictData['thana_name'];
        if (thana is List) {
          thanaNames = thana.map((e) => e.toString()).toList();

          if (widget.thana.isNotEmpty) {
            try {
              selectedThana = thanaNames.firstWhere((element) => element.toLowerCase().trim() == widget.thana.toLowerCase().trim());
            } catch (e) {
              debugPrint('No matching thana found for: ${widget.thana}');
            }
          }
        } else {
          thanaNames = [];
        }
      } else {
        thanaNames = [];
      }
    }

    // for cat sub cat

    categorySubCategoryList = dataBox.get('cat_subcategory_list', defaultValue: []);
    print("Category Sub Category List :: $categorySubCategoryList");
    if (categorySubCategoryList.isNotEmpty) {
      categoryNames = categorySubCategoryList.map<String>((e) => e['category_name'].toString()).toList();

      selectedCatogry = null;
      selectedSubCategory = null;

      if (widget.selectedCat.isNotEmpty) {
        try {
          selectedCatogry = categoryNames.firstWhere((element) => element.toLowerCase().trim() == widget.selectedCat.toLowerCase().trim());
        } catch (e) {
          debugPrint('No matching category found for: ${widget.selectedCat}');
        }
      }

      if (selectedCatogry != null) {
        final defaultSystem = categorySubCategoryList.firstWhere((element) => element['category_name'] == selectedCatogry, orElse: () => {'sub_category_list': []});
        final subcat = defaultSystem['sub_category_list'];
        if (subcat is List) {
          subCategoryList = subcat.map((e) => e.toString()).toList();
          if (widget.selectdSubCat.isNotEmpty) {
            try {
              selectedSubCategory = subCategoryList.firstWhere((element) => element.toLowerCase().trim() == widget.selectdSubCat.toLowerCase().trim());
            } catch (e) {
              debugPrint('No matching subcategory found for: ${widget.selectdSubCat}');
            }
          }
        } else {
          subCategoryList = [];
        }
      } else {
        subCategoryList = [];
      }
    }
    print("Sub Cat List $subCategoryList");
  }

  Future<void> visitOffice(BuildContext contexts) async {
    var data = await getClaintandDoctot();

    List office = [];
    if (data["status"] == "Success") {
      await mydatabox.put('isDoctorForMPOSync', true);
      office = data["visitOfficeList"];
      await putVisitOfficeForMpo(office);
      return;
    } else {
      debugPrint("Error fetching visited office data during sync.");
    }
  }

  Future<void> putVisitOfficeForMpo(List office) async {
    Box box = Hive.box('mpoForDoctor');
    await box.clear();
    for (var d in office) {
      box.add(d);
    }
  }

  Future<void> submitEditedOffice() async {
    if (_formKey.currentState!.validate() && selectedDistrict != null && selectedThana != null) {
      final uri = Uri.parse(
        '$visit_office_edit_url'
        '?cid=$cid'
        '&user_id=$userId'
        '&user_pass=$userPassword'
        '&office_id=${widget.officeId.trim()}'
        '&office_name=${officeController.text.trim()}'
        '&office_phone=${phoneController.text.trim()}'
        '&company_name=${organizationController.text.trim()}'
        '&designation=${designationController.text.trim()}'
        '&district=${selectedDistrict!.trim()}'
        '&thana=${selectedThana!.trim()}'
        '&category=${selectedCatogry!.trim()}'
        '&sub_category=${selectedSubCategory!.trim()}'
        '&office_address=${addressController.text.trim()}',
      );

      debugPrint('url:$uri');

      setState(() {
        isSubmitting = true;
      });

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entity updated successfully")));

          await visitOffice(context);

          final updatedList = Hive.box('mpoForDoctor').values.toList().where((e) => e['branch'].toString().contains(widget.branchId)).map((e) => e['office_list']).expand((e) => e).toList();

          Navigator.pop(context, updatedList);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.reasonPhrase}")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection error: $e")));
      } finally {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Visited Entity Edit"), backgroundColor: Colors.blue, actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})]),
      body:
          isSubmitting
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      buildLabel("Visited Office/ Person"),
                      buildReadOnlyField(officeController),
                      buildLabel("Branch"),
                      buildReadOnlyField(branchController),
                      buildLabel("District"),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        value: selectedDistrict,
                        validator: (value) => value == null ? 'Please select a District' : null,
                        items:
                            districtName.map((district) {
                              return DropdownMenuItem<String>(value: district, child: Text(district));
                            }).toList(),
                        selectedItemBuilder: (context) {
                          return districtName.map((district) {
                            return Align(alignment: Alignment.centerLeft, child: Text(district, overflow: TextOverflow.ellipsis, maxLines: 1));
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                            selectedThana = null;

                            final matched = districtThanaList.firstWhere((element) => element['district_name'] == value, orElse: () => {'thana_name': []});

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
                          searchInnerWidget: Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _districtSearchController, decoration: const InputDecoration(hintText: 'Search district...', border: OutlineInputBorder()))),
                          searchMatchFn: (item, searchValue) {
                            return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildLabel("Thana"),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        value: selectedThana,
                        validator: (value) => value == null ? 'Please select a Thana' : null,
                        items:
                            thanaNames.map((thana) {
                              return DropdownMenuItem<String>(value: thana, child: Text(thana));
                            }).toList(),
                        selectedItemBuilder: (context) {
                          return thanaNames.map((thana) {
                            return Align(alignment: Alignment.centerLeft, child: Text(thana, overflow: TextOverflow.ellipsis, maxLines: 1));
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
                          searchInnerWidget: Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _thanaSearchController, decoration: const InputDecoration(hintText: 'Search thana...', border: OutlineInputBorder()))),
                          searchMatchFn: (item, searchValue) {
                            return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildLabel("Category"),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        //hint: const Text('District'),
                        value: selectedCatogry,
                        validator: (value) => value == null ? 'Please select a Catagory' : null,
                        items:
                            categoryNames.map((category) {
                              return DropdownMenuItem<String>(value: category, child: Text(category));
                            }).toList(),
                        selectedItemBuilder: (context) {
                          return categoryNames.map((category) {
                            return Align(alignment: Alignment.centerLeft, child: Text(category, overflow: TextOverflow.ellipsis, maxLines: 1));
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedCatogry = value;
                            selectedSubCategory = null;

                            final matched = categorySubCategoryList.firstWhere((element) => element['category_name'] == value, orElse: () => {'sub_category_list': []});

                            final thana = matched['sub_category_list'];
                            if (thana is List) {
                              subCategoryList = thana.map((e) => e.toString()).toList();
                            } else {
                              subCategoryList = [];
                            }
                            print('Selected Category $selectedCatogry');
                          });
                          _categorySearchController.clear();
                        },
                        dropdownSearchData: DropdownSearchData(
                          searchController: _categorySearchController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _categorySearchController, decoration: const InputDecoration(hintText: 'Search category...', border: OutlineInputBorder()))),
                          searchMatchFn: (item, searchValue) {
                            return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildLabel("Sub Category "),

                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        //hint: const Text('Thana'),
                        value: selectedSubCategory,
                        validator: (value) => value == null ? 'Please select Sub Category' : null,
                        items:
                            subCategoryList.map((subCategory) {
                              return DropdownMenuItem<String>(value: subCategory, child: Text(subCategory));
                            }).toList(),
                        selectedItemBuilder: (context) {
                          return subCategoryList.map((subCategory) {
                            return Align(alignment: Alignment.centerLeft, child: Text(subCategory, overflow: TextOverflow.ellipsis, maxLines: 1));
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedSubCategory = value;
                          });
                          _subCategorySearchController.clear();
                          print("Selected Sub Category :: $selectedSubCategory");
                        },
                        dropdownSearchData: DropdownSearchData(
                          searchController: _subCategorySearchController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _subCategorySearchController, decoration: const InputDecoration(hintText: 'Search sub category...', border: OutlineInputBorder()))),
                          searchMatchFn: (item, searchValue) {
                            return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildLabel("Phone"),
                      buildTextField(
                        phoneController,
                        onTap: () {
                          if (phoneController.text.isEmpty) {
                            phoneController.text = '88';
                            phoneController.selection = TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
                          }
                        },
                        onChanged: (value) {
                          if (!value.startsWith('88')) {
                            phoneController.text = '88';
                            phoneController.selection = TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
                          }
                        },
                      ),
                      buildLabel("Organization/ Company"),
                      buildTextField(organizationController),
                      buildLabel("Designation"),
                      buildTextField(designationController),
                      buildLabel("Address"),
                      buildTextField(addressController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          submitEditedOffice();
                        },
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))), padding: const EdgeInsets.all(18), backgroundColor: const Color.fromARGB(255, 138, 201, 149)),
                        child: const Center(child: Text("Submit", style: TextStyle(fontSize: 16))),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(top: 6, bottom: 2), child: Row(children: [Text(text), const Text(' *', style: TextStyle(color: Colors.red))]));
  }

  Widget buildTextField(TextEditingController controller, {Function(String)? onChanged, VoidCallback? onTap}) {
    return TextFormField(onTap: onTap, onChanged: onChanged, controller: controller, validator: (val) => (val == null || val.isEmpty) ? 'Required field' : null, decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))));
  }

  Widget buildReadOnlyField(TextEditingController controller) {
    return TextFormField(controller: controller, readOnly: true, decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))), fillColor: Color(0xFFEDEDED), filled: true));
  }
}

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/datasources/local_storage/boxes.dart';
// import '../../../data/service/apiCall.dart';
// import '../loginPage.dart';
//
// class VisitedEntityEditScreen extends StatefulWidget {
//   final String officeId;
//   final String officeName;
//   final String branchName;
//   final String branchId;
//   final int phnNumber;
//   final String district;
//   final String thana;
//   final String organization;
//   final String designation;
//   final String address;
//
//   const VisitedEntityEditScreen({Key? key, required this.officeId, required this.branchName, required this.branchId, required this.officeName, required this.phnNumber, required this.district, required this.thana, required this.organization, required this.designation, required this.address}) : super(key: key);
//
//   @override
//   State<VisitedEntityEditScreen> createState() => _VisitedEntityEditScreenState();
// }
//
// class _VisitedEntityEditScreenState extends State<VisitedEntityEditScreen> {
//   final dataBox=Boxes.allData();
//
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController officeController = TextEditingController();
//   final TextEditingController branchController = TextEditingController();
//   final TextEditingController districtController = TextEditingController();
//   final TextEditingController thanaController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController organizationController = TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//
//   String? selectedDistrict;
//   String? selectedThana;
//
//   final List<String> districts = ['Dhaka', 'Chittagong', 'Rajshahi'];
//   final List<String> thanas = ['Banani', 'Gulshan', 'Dhanmondi'];
//
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//   String visit_office_edit_url='';
//
//   bool isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     officeController.text = widget.officeName;
//     branchController.text = widget.branchName;
//     districtController.text=widget.district;
//     thanaController.text=widget.thana;
//     phoneController.text=widget.phnNumber.toString();
//     organizationController.text=widget.organization;
//     designationController.text=widget.designation;
//     addressController.text=widget.address;
//
//     cid = dataBox.get("CID")!;
//     userId = dataBox.get("user_id")!;
//     userPassword = dataBox.get("PASSWORD")!;
//     visit_office_edit_url=dataBox.get('visit_office_edit_url');
//
//   }
//
//
//   visitOffice(contexts) async {
//     var data = await getClaintandDoctot();
//
//     List office = [];
//     print('data status::${data["status"]}');
//     if (data["status"] == "Success") {
//
//       await mydatabox.put('isDoctorForMPOSync', true);
//
//       office = data["visitOfficeList"];
//       print('office::$office');
//
//       debugPrint("office data$office");
//       await putVisitOfficeForMpo(office);
//
//       return const CircularProgressIndicator();
//     } else {
//       print("Errror");
//     }
//   }
//   putVisitOfficeForMpo(office) async {
//     print('xxxx');
//     Box box = Hive.box('mpoForDoctor');
//     await box.clear();
//     for (var d in office) {
//       print('xxxx');
//       box.add(d);
//       debugPrint("ADDD------------$d");
//     }
//     debugPrint("boxDoctor${box.values}");
//     print("------------------------------------------000000");
//
//     print(box.values.toString());
//   }
//
//
//   Future<void> submitEditedOffice() async {
//
//     debugPrint(
//         'visited entity edit:: $visit_office_edit_url'
//             '?cid=$cid'
//             '&user_id=$userId'
//             '&user_pass=$userPassword'
//             '&office_id=${widget.officeId.trim()}'
//             '&office_name=${widget.officeName.trim()}'
//             '&office_phone=${phoneController.text.trim()}'
//             '&company_name=${organizationController.text.trim()}'
//             '&designation=${designationController.text.trim()}'
//             '&district=${districtController.text.trim()}'
//             '&thana=${thanaController.text.trim()}'
//             '&office_address=${addressController.text.trim()}'
//     );
//
//
//     final uri = Uri.parse(
//         '$visit_office_edit_url'
//             '?cid=$cid'
//             '&user_id=$userId'
//             '&user_pass=$userPassword'
//             '&office_id=${widget.officeId.trim()}'
//             '&office_name=${widget.officeName.trim()}'
//             //'&office_name=${officeController.text}'
//             '&office_phone=${phoneController.text.trim()}'
//             '&company_name=${organizationController.text.trim()}'
//             '&designation=${designationController.text.trim()}'
//             '&district=${districtController.text.trim()}'
//             '&thana=${thanaController.text.trim()}'
//             '&office_address=${addressController.text.trim()}'
//     );
//     setState(() {
//       isSubmitting = true;
//     });
//
//     try {
//       final response = await http.get(uri);
//
//       if (response.statusCode == 200) {
//
//         // Sync again
//         await visitOffice(context);
//         // Get updated data from Hive
//         final updatedList = Hive.box('mpoForDoctor').values
//             .toList()
//             .where((e) => e['branch'].toString().contains(widget.branchId))
//             .map((e) => e['office_list'])
//             .expand((e) => e)
//             .toList();
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Entity updated successfully")),
//         );
//         Navigator.pop(context, updatedList); // ✅ Pass updated list back
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${response.reasonPhrase}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Connection error: $e")),
//       );
//     }
//     finally {
//       setState(() {
//         isSubmitting = false;
//       });
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Visited Entity Edit"),
//         backgroundColor: const Color.fromARGB(255, 138, 201, 149),
//         actions: [
//           IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
//         ],
//       ),
//       body: isSubmitting
//           ? const Center(child: CircularProgressIndicator())
//           :Padding(
//         padding: const EdgeInsets.all(14),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               buildLabel("Visited Office/ Person"),
//               buildReadOnlyField(officeController),
//               buildLabel("Branch"),
//               buildReadOnlyField(branchController),
//               buildLabel("District",),
//               buildTextField(districtController),
//               const SizedBox(height: 10),
//               buildLabel("Thana",),
//               buildTextField(thanaController),
//               const SizedBox(height: 10),
//               buildLabel("Phone", ),
//               buildTextField(
//                   phoneController,
//                   onTap: () {
//                     if (phoneController.text.isEmpty) {
//                       phoneController.text = '88';
//                       phoneController.selection = TextSelection.fromPosition(
//                         TextPosition(offset: phoneController.text.length),
//                       );
//                     }
//                   },
//                   onChanged: (value){
//                     {
//                       if (!value.startsWith('88')) {
//                         phoneController.text = '88';
//                         phoneController.selection = TextSelection.fromPosition(
//                           TextPosition(offset: phoneController.text.length),
//                         );
//                       }
//                     }
//                   }
//               ),
//               buildLabel("Organization/ Company",),
//               buildTextField(organizationController),
//               buildLabel("Designation", ),
//               buildTextField(designationController),
//               buildLabel("Address", ),
//               buildTextField(addressController),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     submitEditedOffice();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape:const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))
//                   ),
//                   padding: const EdgeInsets.all(18),
//                   backgroundColor: const Color.fromARGB(255, 138, 201, 149),
//                 ),
//                 child: const Center(child: Text("Submit",style: TextStyle(fontSize: 16),)),
//               ),
//               //const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//       // bottomNavigationBar: BottomAppBar(
//       //   child: IconButton(
//       //     icon: const Icon(Icons.home),
//       //     onPressed: () {
//       //       Navigator.pop(context);
//       //     },
//       //   ),
//       // ),
//     );
//   }
//
//   Widget buildLabel(String text,) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 6, bottom: 2),
//       child: Row(
//         children: [
//           Text(text),
//           const Text(
//              ' *',
//             style: TextStyle(color: Colors.red),
//           ),
//         ],
//       )
//     );
//   }
//
//   Widget  buildTextField(TextEditingController controller,{
//     Function(String)? onChanged,VoidCallback? onTap
//   } ) {
//     return TextFormField(
//       onTap: onTap,
//       onChanged: onChanged,
//       controller: controller,
//       validator: (val) => (val == null || val.isEmpty) ? 'Required field' : null,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))
//         ),
//       ),
//     );
//   }
//
//   Widget buildReadOnlyField(TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       readOnly: true,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.all(Radius.circular(10))
//         ),
//         fillColor: Color(0xFFEDEDED),
//         filled: true,
//       ),
//     );
//   }
// }
