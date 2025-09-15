// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import '../../data/datasources/local_storage/boxes.dart';
//
// Map<String,dynamic> dxDataMap={};
// List<dynamic> systemDiseaseslist = [];
// List<String> systemNames = [];
// List<String> diseaseOptions = [];
//
// String? selectedSystem;
// String? selectedDisease;
//
// List<String> patientTemperamentlist=[];
// String? selectedPatientTemperament;
//
// TextEditingController beforeDiabetesController = TextEditingController();
// TextEditingController afterDiabetesController = TextEditingController();
// TextEditingController systolicController = TextEditingController();
// TextEditingController diastolicController = TextEditingController();
// TextEditingController oxygenLevelController = TextEditingController();
// TextEditingController bodyTemperatureController = TextEditingController();
// TextEditingController weightController = TextEditingController();
// TextEditingController feetController = TextEditingController();
// TextEditingController inchController = TextEditingController();
//
//
// class Dxdrawer extends StatefulWidget {
//
//    const Dxdrawer({
//     super.key});
//
//   @override
//   State<Dxdrawer> createState() => _DxdrawerState();
// }
//
// class _DxdrawerState extends State<Dxdrawer> {
//
//   final databox = Boxes.allData();
//   double? bmi;
//   String? bmiStatus;
//
//   void calculateBMI() {
//     final weight = double.tryParse(weightController.text);
//     final feet = double.tryParse(feetController.text);
//     final inch = double.tryParse(inchController.text);
//
//     if (weight != null && feet != null && inch != null) {
//       final heightInMeter = ((feet * 12) + inch) * 0.0254;
//       final bmiVal = weight / (heightInMeter * heightInMeter);
//
//       String status;
//       if (bmiVal < 18.5) {
//         status = 'Underweight';
//       } else if (bmiVal < 25) {
//         status = 'Normal';
//       } else if (bmiVal < 30) {
//         status = 'Overweight';
//       } else {
//         status = 'Obese';
//       }
//
//       setState(() {
//         bmi = double.parse(bmiVal.toStringAsFixed(2));
//         bmiStatus = status;
//
//         dxDataMap['bmi'] = bmi;
//         dxDataMap['bmiStatus'] = bmiStatus;
//       });
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     systemDiseaseslist=databox.get('system_diseases_list', defaultValue: []);
//     print('systemdisease list:$systemDiseaseslist');
//     if (systemDiseaseslist.isNotEmpty) {
//       systemNames = systemDiseaseslist.map<String>((e) => e['system_name'].toString()).toList();
//
//       final defaultSystem = systemDiseaseslist.firstWhere(
//             (element) => element['system_name'] == selectedSystem,
//         orElse: () => {'diseases_name': []},
//       );
//
//       final diseases = defaultSystem['diseases_name'];
//       if (diseases is List) {
//         diseaseOptions = diseases.map((e) => e.toString()).toList();
//       } else {
//         diseaseOptions = [];
//       }
//     }
//
//     patientTemperamentlist=databox.get('patient_temperament_list', defaultValue: []);
//     print('patientTemperament list:$patientTemperamentlist');
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  SafeArea(
//       child: Drawer(
//         child: Container(
//           color: Colors.grey.withOpacity(0.7),
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 138, 201, 149),
//                 ),
//                 child:  Center(
//                   child: Text(
//                     'Diagnosis',
//                     style: TextStyle(
//                       fontSize: 22,
//                       color: Colors.white.withOpacity(0.7),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return SingleChildScrollView(
//                       padding: EdgeInsets.only(
//                         left: 16,
//                         right: 16,
//                         bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//                       ),
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                         child: IntrinsicHeight(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 10),
//                               DiagnosisDropdown(
//                                 label: 'System Name',
//                                 value: selectedSystem,
//                                 items: systemNames,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedSystem = value;
//                                     selectedDisease = null;
//
//                                     dxDataMap["system_name"]=selectedSystem;
//                                     final matched = systemDiseaseslist.firstWhere(
//                                           (element) => element['system_name'] == value,
//                                       orElse: () => {'diseases_name': []},
//                                     );
//
//                                     final diseases = matched['diseases_name'];
//                                     if (diseases is List) {
//                                       diseaseOptions = diseases.map((e) => e.toString()).toList();
//                                     } else {
//                                       diseaseOptions = [];
//                                     }
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                               DiagnosisDropdown(
//                                 label: 'Diseases',
//                                 value: selectedDisease,
//                                 items: diseaseOptions,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedDisease = value;
//                                     dxDataMap["diseases"]=selectedDisease;
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                               DiagnosisDropdown(
//                                 label: 'Patient Temperament',
//                                 value: selectedPatientTemperament,
//                                 items: patientTemperamentlist,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedPatientTemperament = value;
//                                     dxDataMap["temperament"]=selectedPatientTemperament;
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                               const Text('Diabetes'),
//                               Row(
//                                 children: [
//                                   Expanded(child: DiagnosisInputField(controller: beforeDiabetesController, hint: 'Before',onchang: (v){
//                                     dxDataMap["beforeDiabetes"]=v;
//                                   },)),
//                                   const SizedBox(width: 8),
//                                   Expanded(child: DiagnosisInputField(controller: afterDiabetesController, hint: 'After',onchang: (v){
//                                   dxDataMap["afterDiabetes"]=v;
//                                   },)),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               const Text('Blood Pressure'),
//                               Row(
//                                 children: [
//                                   Expanded(child: DiagnosisInputField(controller: systolicController, hint: 'Systolic',onchang: (v){
//                                     dxDataMap["blood_systolic"]=v;
//                                   },)),
//                                   const SizedBox(width: 8),
//                                   Expanded(child: DiagnosisInputField(controller: diastolicController, hint: 'Diastolic',onchang: (v){
//                                     dxDataMap["blood_diastolic"]=v;
//                                   },)),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               const Text('Oxygen Level'),
//                               DiagnosisInputField(controller: oxygenLevelController, hint: '',onchang: (v){
//                                 dxDataMap["oxygenLevel"]=v;
//                               },),
//                               const SizedBox(height: 10),
//                               const Text('Body Temperature'),
//                               DiagnosisInputField(controller: bodyTemperatureController, hint: '',onchang: (v){
//                                 dxDataMap["bodyTemperature"]=v;
//                               },),
//                               const SizedBox(height: 10),
//                               const Text('Weight'),
//                               DiagnosisInputField(controller: weightController, hint: 'KG',onchang: (v){
//                                 dxDataMap["weight"]=v;
//                                 calculateBMI();
//                               },),
//                               const SizedBox(height: 10),
//                               const Text('Height'),
//                               Row(
//                                 children: [
//                                   Expanded(child: DiagnosisInputField(controller: feetController, hint: 'Feet',onchang: (v){
//                                     dxDataMap["height_feet"]=v;
//                                     calculateBMI();
//                                   },)),
//                                   const SizedBox(width: 8),
//                                   Expanded(child: DiagnosisInputField(controller: inchController, hint: 'Inches',onchang: (v){
//                                     dxDataMap["height_inch"]=v;
//                                     calculateBMI();
//                                   },)),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               if (bmi != null && bmiStatus != null)
//                                 Row(
//                                   children: [
//                                     const Text('BMI point:'),
//                                     Text(
//                                       "${bmi!.toStringAsFixed(2)}  |  $bmiStatus",
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class DiagnosisDropdown extends StatelessWidget {
//   final String? value;
//   final List<String> items;
//   final Function(String?) onChanged;
//   final String label;
//
//   const DiagnosisDropdown({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(
//           height: 48,
//           width: 270,
//           child: Stack(
//             children: [
//               DropdownButtonFormField2<String>(
//                 //dropdownColor: Colors.grey,
//                 value: value,
//
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: Colors.grey, width: 1.5),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: Colors.grey, width: 1.5),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white.withOpacity(0.4),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                 ),
//                 items: items.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Center(child: Text(value, style: const TextStyle(fontSize: 14))),
//                   );
//                 }).toList(),
//                 onChanged: onChanged,
//               ),
//               const Positioned(
//                 top: 18,
//                 right: 32,
//                 child: Icon(Icons.star_sharp, color: Colors.red, size: 12),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
// class DiagnosisInputField extends StatelessWidget {
//   final String hint;
//   final TextEditingController controller;
//   void Function(String) onchang;
//
//    DiagnosisInputField({super.key, required this.hint, required this.controller , required this.onchang});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       onChanged: onchang,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.grey, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.grey, width: 1.5),
//         ),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.4),
//         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       ),
//     );
//   }
// }
