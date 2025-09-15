// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';

import '../datasources/local_storage/hive_data_model.dart';

class HiveAdapter {
  Future HiveAdapterbox() async {
    await Hive.openBox<AddItemModel>('orderedItem');
    await Hive.openBox<CustomerDataModel>('customerHive');
    await Hive.openBox<DcrDataModel>('selectedDcr');
    await Hive.openBox<DcrGSPDataModel>('selectedDcrGSP');
    await Hive.openBox<RxDcrDataModel>('RxdDoctor');
    await Hive.openBox<MedicineListModel>('draftMdicinList');
    await Hive.openBox<NoticeListModel>('noticeList');
    await Hive.openBox('dcrListData'); //todo old  //open for rx doctor
    await Hive.openBox('mpoForDoctor'); // New
    await Hive.openBox('medicineList');
    await Hive.openBox('expenseData');
    await Hive.openBox('rxInfoData');
    // await Hive.openBox('data');//todo old
    await Hive.openBox('mpoForClaient'); // New
    await Hive.openBox('syncItemData');
    await Hive.openBox('dcrGiftListData');
    await Hive.openBox('dcrSampleListData');
    await Hive.openBox('dcrPpmListData');
    await Hive.openBox('dcrDiscussionListData');
    await Hive.openBox('addedDcrSampletData');
    await Hive.openBox("draftForExpense");
    await Hive.openBox('alldata');
    await Hive.openBox('VisitedWithNotes');
    await Hive.openBox('buttonNames');

  }
}
