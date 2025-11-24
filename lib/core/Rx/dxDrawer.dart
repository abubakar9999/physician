import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/local_storage/boxes.dart';

Map<String, dynamic> dxDataMap = {};
List<dynamic> systemDiseaseslist = [];
List<String> systemNames = [];
List<String> diseaseOptions = [];
late final bool isMulti;
String? selectedSystem;

String? selectedDisease;
List<String> selectedDiseases = [];
String selectedDiseasesText = '';
List<String> selectedSystems = [];
String selectedSystemsText = '';
List<String> selectedPatientTemperaments = [];
String selectedPatientTemperamentsText = '';

List<String> patientTemperamentlist = [];
String? selectedPatientTemperament;

TextEditingController beforeDiabetesController = TextEditingController();
TextEditingController afterDiabetesController = TextEditingController();
TextEditingController systolicController = TextEditingController();
TextEditingController diastolicController = TextEditingController();
TextEditingController oxygenLevelController = TextEditingController();
TextEditingController bodyTemperatureController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController feetController = TextEditingController();
TextEditingController inchController = TextEditingController();

double? bmi;
String? bmiStatus;
String? bmiDetailedMessage;

class Dxdrawer extends StatefulWidget {
  const Dxdrawer({super.key});

  @override
  State<Dxdrawer> createState() => _DxdrawerState();
}

class _DxdrawerState extends State<Dxdrawer> {
  final dataBox = Boxes.allData();
  Color? textColor;

  void calculateBMI() {
    final weight = double.tryParse(weightController.text);
    final feet = double.tryParse(feetController.text);
    final inch = double.tryParse(inchController.text);

    if (weight != null && feet != null && inch != null && weight > 0 && (feet > 0 || inch > 0)) {
      final heightInMeter = ((feet * 12) + inch) * 0.0254;
      if (heightInMeter == 0) {
        setState(() {
          bmi = null;
          bmiStatus = null;
          bmiDetailedMessage = null;
          dxDataMap['bmi'] = null;
          dxDataMap['bmiStatus'] = null;
        });
        return;
      }
      final bmiVal = weight / (heightInMeter * heightInMeter);

      String status;
      String detailedMessage = '';
      double idealWeightLower = 18.5 * (heightInMeter * heightInMeter);
      double idealWeightUpper = 24.9 * (heightInMeter * heightInMeter);

      if (bmiVal < 18.5) {
        status = 'Underweight';
        final neededWeight = idealWeightLower - weight;
        detailedMessage = 'You need to gain ${neededWeight.toStringAsFixed(1)} KG to reach normal weight.';
        textColor = Colors.red;
      } else if (bmiVal < 25) {
        status = 'Normal';
        detailedMessage = 'Your weight is in a healthy range.';
        textColor = Colors.black54;
      } else if (bmiVal < 30) {
        status = 'Overweight';
        final excessWeight = weight - idealWeightUpper;
        detailedMessage = 'You need to lose ${excessWeight.toStringAsFixed(1)} KG to reach normal weight.';
        textColor = Colors.red;
      } else {
        status = 'Obese';
        final excessWeight = weight - idealWeightUpper;
        detailedMessage = 'You need to lose ${excessWeight.toStringAsFixed(1)} KG to reach normal weight.';
        textColor = Colors.red;
      }

      setState(() {
        bmi = double.parse(bmiVal.toStringAsFixed(2));
        bmiStatus = status;
        bmiDetailedMessage = detailedMessage;

        dxDataMap['bmi'] = bmi;
        dxDataMap['bmiStatus'] = bmiStatus;
      });
    } else {
      setState(() {
        bmi = null;
        bmiStatus = null;
        bmiDetailedMessage = null;
        dxDataMap['bmi'] = null;
        dxDataMap['bmiStatus'] = null;
      });
    }
  }

  // void calculateBMI() {
  //   final weight = double.tryParse(weightController.text);
  //   final feet = double.tryParse(feetController.text);
  //   final inch = double.tryParse(inchController.text);
  //
  //   if (weight != null && feet != null && inch != null) {
  //     final heightInMeter = ((feet * 12) + inch) * 0.0254;
  //     final bmiVal = weight / (heightInMeter * heightInMeter);
  //
  //     String status;
  //     if (bmiVal < 18.5) {
  //       status = 'Underweight';
  //     } else if (bmiVal < 25) {
  //       status = 'Normal';
  //     } else if (bmiVal < 30) {
  //       status = 'Overweight';
  //     } else {
  //       status = 'Obese';
  //     }
  //
  //     setState(() {
  //       bmi = double.parse(bmiVal.toStringAsFixed(2));
  //       bmiStatus = status;
  //
  //       dxDataMap['bmi'] = bmi;
  //       dxDataMap['bmiStatus'] = bmiStatus;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    systemDiseaseslist = dataBox.get('system_diseases_list', defaultValue: []);
    print('systemdisease list:$systemDiseaseslist');
    if (systemDiseaseslist.isNotEmpty) {
      systemNames = systemDiseaseslist.map<String>((e) => e['system_name'].toString()).toList();

      final defaultSystem = systemDiseaseslist.firstWhere((element) => element['system_name'] == selectedSystem, orElse: () => {'diseases_name': []});

      final diseases = defaultSystem['diseases_name'];
      if (diseases is List) {
        diseaseOptions = diseases.map((e) => e.toString()).toList();
      } else {
        diseaseOptions = [];
      }
    }

    patientTemperamentlist = dataBox.get('patient_temperament_list', defaultValue: []);
    print('patientTemperament list:$patientTemperamentlist');

    weightController.addListener(calculateBMI);
    feetController.addListener(calculateBMI);
    inchController.addListener(calculateBMI);
  }

  @override
  void dispose() {
    weightController.removeListener(calculateBMI);
    feetController.removeListener(calculateBMI);
    inchController.removeListener(calculateBMI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.grey.withOpacity(0.7),
          child: Column(
            children: [
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14), decoration: const BoxDecoration(color: Color.fromARGB(255, 138, 201, 149)), child: Center(child: Text('Diagnosis', style: TextStyle(fontSize: 22, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500)))),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: DiagnosisDropdown(
                                  label: 'System Name',
                                  value: null,
                                  items: systemNames,
                                  isMulti: true,
                                  multiValues: selectedSystems,
                                  onChanged: (joined) {
                                    setState(() {
                                      final j = (joined as String?) ?? '';
                                      selectedSystemsText = j;
                                      selectedSystems = j.isEmpty ? [] : j.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                                      dxDataMap['system_name'] = selectedSystemsText;
                                      dxDataMap['system_name_list'] = selectedSystems;

                                      final List<String> combined = [];
                                      for (final sys in selectedSystems) {
                                        final matched = systemDiseaseslist.firstWhere((element) => element['system_name'] == sys, orElse: () => {'diseases_name': []});
                                        final ds = matched['diseases_name'];
                                        if (ds is List) combined.addAll(ds.map((e) => e.toString()));
                                      }

                                      diseaseOptions = combined.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              DiagnosisDropdown(
                                label: 'Diseases',
                                value: null,
                                items: diseaseOptions,
                                isMulti: true,
                                multiValues: selectedDiseases,
                                onChanged: (joinedString) {
                                  setState(() {
                                    selectedDiseasesText = joinedString ?? '';
                                    selectedDiseases = selectedDiseasesText.isEmpty ? [] : selectedDiseasesText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                                    dxDataMap['diseases'] = selectedDiseasesText;
                                    dxDataMap['diseases_list'] = selectedDiseases;
                                  });
                                  print('selectedDiseases: $selectedDiseases');
                                  print('selectedDiseasesText: $selectedDiseasesText');
                                },
                              ),
                              const SizedBox(height: 10),

                              DiagnosisDropdown(
                                label: 'Patient Temperament',
                                value: null, // not used in multi mode
                                items: patientTemperamentlist,
                                isMulti: true,
                                multiValues: selectedPatientTemperaments,
                                onChanged: (joinedString) {
                                  setState(() {
                                    final j = (joinedString as String?) ?? '';
                                    selectedPatientTemperamentsText = j;
                                    selectedPatientTemperaments = j.isEmpty ? [] : j.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                                    // save to dxDataMap as text and as list
                                    dxDataMap['temperament'] = selectedPatientTemperamentsText;
                                    dxDataMap['temperament_list'] = selectedPatientTemperaments;
                                  });

                                  // debug
                                  print('selectedPatientTemperaments: $selectedPatientTemperaments');
                                  print('selectedPatientTemperamentsText: $selectedPatientTemperamentsText');
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text('Diabetes'),
                              Row(
                                children: [
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: beforeDiabetesController,
                                      hint: 'Before',
                                      onchange: (v) {
                                        dxDataMap["beforeDiabetes"] = v;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: afterDiabetesController,
                                      hint: 'After',
                                      onchange: (v) {
                                        dxDataMap["afterDiabetes"] = v;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (beforeDiabetesController.text.trim().isNotEmpty && afterDiabetesController.text.trim().isNotEmpty && double.tryParse(beforeDiabetesController.text.trim()) != null && double.tryParse(afterDiabetesController.text.trim()) != null) _buildSugarResultWidget(),
                              const SizedBox(height: 10),
                              const Text('Blood Pressure'),
                              Row(
                                children: [
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: systolicController,
                                      keyboardType: TextInputType.number,
                                      hint: 'Systolic',
                                      onchange: (v) {
                                        dxDataMap["blood_systolic"] = v;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: diastolicController,
                                      keyboardType: TextInputType.number,
                                      hint: 'Diastolic',
                                      onchange: (v) {
                                        dxDataMap["blood_diastolic"] = v;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (systolicController.text.trim().isNotEmpty && diastolicController.text.trim().isNotEmpty && double.tryParse(systolicController.text.trim()) != null && double.tryParse(diastolicController.text.trim()) != null) _buildBloodPressureResult(),
                              const Text('Oxygen Level'),
                              DiagnosisInputField(
                                controller: oxygenLevelController,
                                keyboardType: TextInputType.number,
                                hint: '',
                                onchange: (v) {
                                  dxDataMap["oxygenLevel"] = v;
                                },
                              ),

                              if (oxygenLevelController.text.trim().isNotEmpty && double.tryParse(oxygenLevelController.text.trim()) != null) _buildOxygenResult(),
                              const SizedBox(height: 10),
                              const Text('Body Temperature'),
                              DiagnosisInputField(
                                controller: bodyTemperatureController,
                                keyboardType: TextInputType.number,
                                hint: '',
                                onchange: (v) {
                                  dxDataMap["bodyTemperature"] = v;
                                },
                              ),
                              const SizedBox(height: 10),
                              if (bodyTemperatureController.text.trim().isNotEmpty && double.tryParse(bodyTemperatureController.text.trim()) != null) _buildTemperatureResult(),
                              const SizedBox(height: 10),
                              const Text('Weight'),
                              DiagnosisInputField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                hint: 'KG',
                                onchange: (v) {
                                  dxDataMap["weight"] = v;
                                  calculateBMI();
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text('Height'),
                              Row(
                                children: [
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: feetController,
                                      keyboardType: TextInputType.number,
                                      hint: 'Feet',
                                      onchange: (v) {
                                        dxDataMap["height_feet"] = v;
                                        calculateBMI();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DiagnosisInputField(
                                      controller: inchController,
                                      keyboardType: TextInputType.number,
                                      hint: 'Inches',
                                      onchange: (v) {
                                        dxDataMap["height_inch"] = v;
                                        calculateBMI();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (bmi != null && bmiStatus != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [const Text('BMI point: ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)), Text("${bmi!.toStringAsFixed(2)}  |  $bmiStatus", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                                    if (bmiDetailedMessage != null && bmiDetailedMessage!.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(bmiDetailedMessage!, style: TextStyle(fontSize: 14, color: textColor))),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class DiagnosisDropdown extends StatelessWidget {
//   final String? value;
//   final List<String> items;
//   final bool isMulti;
//   final List<String>? multiValues;
//   final ValueChanged<dynamic> onChanged; // single: String? ; multi: joined String
//   final String label;

//   const DiagnosisDropdown({super.key, required this.value, required this.items, required this.onChanged, required this.label, this.isMulti = true, this.multiValues});

//   Future<void> _openSingleSelect(BuildContext context) async {
//     final filtered = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//     if (filtered.isEmpty) {
//       await showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(label), content: const Text('No options available'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));
//       return;
//     }

//     String? temp = value?.trim();
//     final result = await showDialog<String?>(
//       context: context,
//       builder:
//           (ctx) => StatefulBuilder(
//             builder: (context, setStateDialog) {
//               return AlertDialog(
//                 title: Text(label),
//                 content: SizedBox(
//                   width: double.maxFinite,
//                   child: ListView(
//                     shrinkWrap: true,
//                     children:
//                         filtered.map((it) {
//                           return RadioListTile<String>(value: it, groupValue: temp, title: Text(it), onChanged: (v) => setStateDialog(() => temp = v));
//                         }).toList(),
//                   ),
//                 ),
//                 actions: [TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, temp), child: const Text('OK'))],
//               );
//             },
//           ),
//     );

//     onChanged(result); // can be null
//   }

//   Future<void> _openMultiSelect(BuildContext context) async {
//     final filtered = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//     if (filtered.isEmpty) {
//       await showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(label), content: const Text('No options available'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));
//       return;
//     }

//     final temp = List<String>.from((multiValues ?? []).map((e) => e.trim()).where((e) => e.isNotEmpty));
//     final result = await showDialog<List<String>>(
//       context: context,
//       builder:
//           (ctx) => StatefulBuilder(
//             builder: (context, setStateDialog) {
//               return AlertDialog(
//                 title: Text(label),
//                 content: SizedBox(
//                   width: double.maxFinite,
//                   child: ListView(
//                     shrinkWrap: true,
//                     children:
//                         filtered.map((it) {
//                           final checked = temp.contains(it);
//                           return CheckboxListTile(
//                             value: checked,
//                             title: Text(it),
//                             controlAffinity: ListTileControlAffinity.leading,
//                             onChanged: (c) {
//                               setStateDialog(() {
//                                 if (c == true) {
//                                   if (!temp.contains(it)) temp.add(it);
//                                 } else {
//                                   temp.remove(it);
//                                 }
//                               });
//                             },
//                           );
//                         }).toList(),
//                   ),
//                 ),
//                 actions: [TextButton(onPressed: () => Navigator.pop(ctx, multiValues ?? []), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, temp), child: const Text('OK'))],
//               );
//             },
//           ),
//     );

//     if (result != null) {
//       final joined = result.map((e) => e.trim()).where((e) => e.isNotEmpty).join(', ');
//       onChanged(joined); // send joined string
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredItems = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();

//     Widget displayChild;
//     if (isMulti) {
//       final sel = (multiValues ?? []).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//       displayChild = sel.isEmpty ? Text('Tap to select', style: TextStyle(color: Colors.grey[600])) : Wrap(spacing: 6, runSpacing: 6, children: sel.map((e) => Chip(label: Text(e))).toList());
//     } else {
//       final safeValue = (value != null && filteredItems.contains(value!.trim())) ? value!.trim() : null;
//       displayChild = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(safeValue ?? 'Tap to select', style: TextStyle(color: safeValue == null ? Colors.grey[600] : Colors.black), overflow: TextOverflow.ellipsis)), const Icon(Icons.arrow_drop_down)]);
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: () {
//             if (isMulti) {
//               _openMultiSelect(context);
//             } else {
//               _openSingleSelect(context);
//             }
//           },
//           child: Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 1.5)), child: displayChild),
//         ),
//       ],
//     );
//   }
// }

class DiagnosisDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final bool isMulti;
  final List<String>? multiValues;
  final void Function(String?) onChanged;
  final String label;

  const DiagnosisDropdown({super.key, required this.value, required this.items, required this.onChanged, required this.label, this.isMulti = true, this.multiValues});

  Future<void> _openSingleSelect(BuildContext context) async {
    final filtered = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (filtered.isEmpty) {
      await showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(label), content: const Text('No options available'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));
      return;
    }

    String? temp = value?.trim();
    final result = await showDialog<String?>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text(label),
                content: SizedBox(
                  width: double.infinity,
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        filtered.map((it) {
                          return RadioListTile<String>(value: it, groupValue: temp, title: Text(it), onChanged: (v) => setStateDialog(() => temp = v));
                        }).toList(),
                  ),
                ),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, temp), child: const Text('OK'))],
              );
            },
          ),
    );

    onChanged(result); // can be null
  }

  Future<void> _openMultiSelect(BuildContext context) async {
    final filtered = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (filtered.isEmpty) {
      await showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(label), content: const Text('No options available'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));
      return;
    }

    final temp = List<String>.from((multiValues ?? []).map((e) => e.trim()).where((e) => e.isNotEmpty));
    final result = await showDialog<List<String>>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text(label),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        filtered.map((it) {
                          final checked = temp.contains(it);
                          return CheckboxListTile(
                            value: checked,
                            title: Text(it),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (c) {
                              setStateDialog(() {
                                if (c == true) {
                                  if (!temp.contains(it)) temp.add(it);
                                } else {
                                  temp.remove(it);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx, multiValues ?? []), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, temp), child: const Text('OK'))],
              );
            },
          ),
    );

    if (result != null) {
      final joined = result.map((e) => e.trim()).where((e) => e.isNotEmpty).join(', ');
      onChanged(joined); // send joined string
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    Widget displayChild;

    if (isMulti) {
      final sel = multiValues ?? [];

      final text = sel.isEmpty ? 'Tap to select' : sel.join(', '); // <-- এক লাইনের টেক্সট

      displayChild = Text(
        text,
        style: TextStyle(color: sel.isEmpty ? Colors.grey[600] : Colors.black, fontSize: 14),
        maxLines: 2, // max 2 lines
        overflow: TextOverflow.ellipsis, // long হলে ... দেখাবে
      );
    } else {
      final safeValue = (value != null && filteredItems.contains(value)) ? value : null;

      displayChild = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(safeValue ?? 'Tap to select', style: TextStyle(color: safeValue == null ? Colors.grey[600] : Colors.black), overflow: TextOverflow.ellipsis)), const Icon(Icons.arrow_drop_down)]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            if (isMulti) {
              _openMultiSelect(context);
            } else {
              _openSingleSelect(context);
            }
          },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 1.5)), child: displayChild),
        ),
      ],
    );
  }
}

class DiagnosisInputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  void Function(String) onchange;
  final TextInputType? keyboardType;

  DiagnosisInputField({super.key, required this.hint, required this.controller, required this.onchange, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onchange,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }
}

Widget _buildSugarResultWidget() {
  final before = double.parse(beforeDiabetesController.text.trim());
  final after = double.parse(afterDiabetesController.text.trim());

  String status = "";
  Color color = Colors.black;

  double avg = (before + after) / 2;

  if (avg >= 3.9 && avg <= 5.5) {
    status = "Normal";
    color = Colors.green;
  } else if (avg >= 5.6 && avg <= 6.9) {
    status = "Pre Diabetes";
    color = Colors.orange;
  } else if (avg >= 7.0) {
    status = "High Sugar";
    color = Colors.red;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      Row(children: [const Text("Diabetes Result: ", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)), Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color))]),
    ],
  );
}

Widget _buildBloodPressureResult() {
  final sys = double.parse(systolicController.text.trim());
  final dia = double.parse(diastolicController.text.trim());

  String status = "";
  Color color = Colors.black;

  if (sys <= 120 && dia <= 80) {
    status = "Normal Blood Pressure";
    color = Colors.green;
  } else if (sys >= 120 && dia >= 50) {
    status = "High Blood Pressure (Hypertension)";
    color = Colors.red;
  } else {
    status = "Prehypertension / Elevated";
    color = Colors.orange;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("BP Result: ", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),

          Expanded(
            // <-- Prevent overflow
            child: Text(
              status,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
              softWrap: true,
              maxLines: null, // <-- allow next line
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildTemperatureResult() {
  final tempText = bodyTemperatureController.text.trim();
  final temp = double.tryParse(tempText);

  if (temp == null) return const SizedBox();

  String status = "";
  Color color = Colors.black;

  /// Normal range = 36.5°C → 37.5°C
  if (temp >= 36.5 && temp <= 37.5) {
    status = "Normal Body Temperature";
    color = Colors.green;
  } else if (temp < 36.5) {
    status = "Low Body Temperature";
    color = Colors.orange;
  } else if (temp > 37.5) {
    status = "High Body Temperature (Fever)";
    color = Colors.red;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      Row(children: [const Text("Result: ", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)), Expanded(child: Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)))]),
    ],
  );
}

Widget _buildOxygenResult() {
  final raw = oxygenLevelController.text.trim();
  if (raw.isEmpty) return const SizedBox();

  final val = double.tryParse(raw.replaceAll('%', '').replaceAll('mmhg', '').replaceAll(RegExp(r'[^\d\.\-]'), ''));
  if (val == null) return const SizedBox();

  String title = "Oxygen Result: ";
  String status = "";
  Color color = Colors.black;
  String note = "";

  if (val >= 80 && val <= 100) {
    status = "Normal arterial oxygen tension.";
    color = Colors.green;
    note = "Normal arterial oxygen tension.";
  } else if (val < 80) {
    status = "Low arterial oxygen tension.";
    color = Colors.red;
    note = "Low arterial oxygen tension ";
  } else if (val > 100) {
    status = "Higher arterial oxygen tension.";
    color = Colors.red;
    note = "Higher arterial oxygen tension ";
  } else {
    status = "Above-normal PaO₂ (> 100 mmHg)";
    color = Colors.orange;
    note = "Higher than usual PaO₂ (may be supplemental O₂ or measurement).";
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Oxygen Result: ", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)), Expanded(child: Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color), softWrap: true, maxLines: null))]),
      const SizedBox(height: 4),
    ],
  );
}
