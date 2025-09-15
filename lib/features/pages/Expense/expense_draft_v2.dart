// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'expense_entry_v2.dart';
import 'expense_section.dart';

// ignore: must_be_immutable
class ExpenseDraft extends StatefulWidget {
  const ExpenseDraft({Key? key}) : super(key: key);

  @override
  State<ExpenseDraft> createState() => _ExpenseDraftState();
}

class _ExpenseDraftState extends State<ExpenseDraft> {
  Box box = Hive.box("draftForExpense");

  @override
  Widget build(BuildContext context) {
    debugPrint(box.keys.toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Draft"),
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExpensePage()),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back_sharp)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: box.isNotEmpty
                  ? ListView.builder(
                      itemCount: box.keys.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ExpansionTile(
                              title: Text(box.keys.toList()[index].toString()),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm"),
                                              content: const Text(
                                                  "Are you sure you want to Delete Expanse?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    // User clicked No, so close the dialog
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    box.delete(box.keys
                                                        .toList()[index]);
                                                    setState(() {});
                                                    // User clicked Yes, so close the dialog and return true
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        // newList = await expenseEntry();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ExpenseEntry(
                                              draftDate: box.keys
                                                  .toList()[index]
                                                  .toString()
                                                  .split(' ')[0],
                                              draftExpenseCategory: box.keys
                                                  .toList()[index]
                                                  .toString()
                                                  .split(' ')[1],
                                              // draftDate: box.keys
                                              //     .toList()[index]
                                              //     .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_outlined,
                                        color: Colors.blue,
                                      ),
                                      label: const Text(
                                        "Details",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        );
                      })
                  : const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            )
          ],
        ));
  }
}
