import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/datasources/local_storage/boxes.dart';
import '../../../data/datasources/local_storage/hive_data_model.dart';
import 'newOrderPage.dart';


class DraftOrderPage extends StatefulWidget {
  const DraftOrderPage({Key? key}) : super(key: key);

  @override
  State<DraftOrderPage> createState() => _DraftOrderPageState();
}

class _DraftOrderPageState extends State<DraftOrderPage> {
  Box? box;
  double total = 0;
  List itemDraftList = [];
  List<AddItemModel> finalItemDataList = [];
  List<AddItemModel> filteredOrder = [];
  List<CustomerDataModel> customerItemDataList = [];

  @override
  void initState() {
    box = Boxes.getDraftOrderedData();
    finalItemDataList = box!.toMap().values.toList().cast<AddItemModel>();
    // for (var element in finalItemDataList) {
    //     // debugPrint(element.item_name);
    //   }

    box = Boxes.getCustomerUsers();
    customerItemDataList =
        box!.toMap().values.toList().cast<CustomerDataModel>();

    super.initState();
  }

  double totalCount(index) {
    double subtotal = index['tp'] * index['quantity'];
    double newVat = index['vat'] / 100;
    double total1 = subtotal * newVat;
    total = total1 + subtotal;

    return total;
  }

  Future<void> deleteClient(CustomerDataModel customerModel) async {
    customerModel.delete();
  }

  deleteOrderItem(int id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text('Draft Order'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.getCustomerUsers().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers =
                box.values.toList().cast<CustomerDataModel>();

            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }

  Widget genContent(List<CustomerDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].clientName}", //new
                  // "${user[index].clientName} (${user[index].marketName}) ",//todo Old
                  maxLines: 2,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 30, 66, 77), fontSize: 18),
                ),
                subtitle: Text(
                  "${user[index].clientId}  ${user[index].deliveryDate}   ${user[index].deliveryTime} ",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 66, 77),
                  ),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to Delete the Order?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // User clicked No, so close the dialog
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final ckey = user[index].uiqueKey;
                                      deleteClient(user[index]);

                                      deleteOrderItem(ckey);
                                      // User clicked Yes, so close the dialog and return true
                                      Navigator.of(context).pop(true);
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
                        onPressed: () {
                          final ckey = user[index].uiqueKey;
                          filteredOrder = [];
                          finalItemDataList
                              .where((item) => item.uiqueKey1 == ckey)
                              .forEach((item) {
                            final temp = AddItemModel(
                              uiqueKey1: item.uiqueKey1,
                              quantity: item.quantity,
                              item_name: item.item_name,
                              tp: item.tp,
                              item_id: item.item_id,
                              category_id: item.category_id,
                              vat: item.vat,
                              manufacturer: item.manufacturer,
                            );
                            filteredOrder.add(temp);
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewOrderPage(
                                ckey: ckey,
                                uniqueId: ckey,
                                draftOrderItem: filteredOrder,
                                outStanding: user[index].outstanding,
                                deliveryDate: user[index].deliveryDate,
                                collectionDate: user[index].collectionDate,
                                deliveryTime: user[index].deliveryTime,
                                paymentMethod: user[index].paymentMethod,
                                offer: user[index].offer,
                                clientName: user[index].clientName,
                                clientId: user[index].clientId,
                                marketName: user[index].marketName,
                                note: user[index].note,
                                areaId: user[index].areaId,
                                areaName: user[index].areaName ?? '',
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
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
