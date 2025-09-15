// ignore_for_file: file_names, camel_case_types




import '../datasources/local_storage/boxes.dart';

class All_SharePreference {
  Future<void> setLoginDataHiave(
    
      String cid, String userid, String password) async {
        final mydataBox=Boxes.allData();
    // final prefs = await SharedPreferences.getInstance();
    await mydataBox.put('CID', cid);
    await mydataBox.put('USER_ID', userid);
    await mydataBox.put('PASSWORD', password);
  }

  void setloginData() {}
  void setDmpathData() {}

//    sharedPreferencesGetDAta() async{
//  final prefs = await SharedPreferences.getInstance();
//  prefs.offer_flag =
//    }

//todo!           Device InFo

  // setDeviceInfo(String deviceId, deviceBrand, deviceModel) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('deviceId', deviceId);
  //   await prefs.setString('deviceBrand', deviceBrand!);
  //   await prefs.setString('deviceModel', deviceModel!);
  // }

  //todo!           DM Path

  setDMPathData(
      String syncUrl,
      reportSalesUrl,
      reportDcrUrl,
      reportRxUrl,
      photoSubmitUrl,
      activityLogUrl,
      clientOutstUrl,
      userAreaUrl,
      photoUrl,
      leaveRequestUrl,
      leaveReportUrl,
      pluginUrl,
      tourPlanUrl,
      tourComplianceUrl,
      clientUrl,
      doctorUrl,
      userSalesCollAchUrl,
      osDetailsUrl,
      ordHistoryUrl,
      invHistoryUrl,
      clientEditUrl,
      timerTrackUrl,
      expTypeUrl,
      expSubmitUrl,
      reportExpUrl,
      reportOutstUrl,
      reportLastOrdUrl,
      reportLastInvUrl,
      expApprovalUrl,
      syncNoticeUrl,
      reportAttenUrl) async {
    // final prefs = await SharedPreferences.getInstance();
    final boxdata=Boxes.allData();
    await boxdata.put('sync_url', syncUrl);
    // await boxdata.put('submit_url', submit_url);
    await boxdata.put('report_sales_url', reportSalesUrl);
    await boxdata.put('report_dcr_url', reportDcrUrl);
    await boxdata.put('report_rx_url', reportRxUrl);
    await boxdata.put('photo_submit_url', photoSubmitUrl);
    await boxdata.put('activity_log_url', activityLogUrl);
    await boxdata.put('client_outst_url', clientOutstUrl);
    await boxdata.put('user_area_url', userAreaUrl);
    await boxdata.put('photo_url', photoUrl);
    await boxdata.put('leave_request_url', leaveRequestUrl);
    await boxdata.put('leave_report_url', leaveReportUrl);
    await boxdata.put('plugin_url', pluginUrl);
    await boxdata.put('tour_plan_url', tourPlanUrl);
    await boxdata.put('tour_compliance_url', tourComplianceUrl);
    await boxdata.put('client_url', clientUrl);
    await boxdata.put('doctor_url', doctorUrl);
    await boxdata.put('user_sales_coll_ach_url', userSalesCollAchUrl);
    await boxdata.put('os_details_url', osDetailsUrl);
    await boxdata.put('ord_history_url', ordHistoryUrl);
    await boxdata.put('inv_history_url', invHistoryUrl);
    await boxdata.put('client_edit_url', clientEditUrl);
    await boxdata.put('timer_track_url', timerTrackUrl);
    await boxdata.put('exp_type_url', expTypeUrl);
    await boxdata.put('exp_submit_url', expSubmitUrl);
    await boxdata.put('report_exp_url', reportExpUrl);
    // await boxdata.put('report_exp_url', report_exp_url);
    await boxdata.put('report_outst_url', reportOutstUrl);
    await boxdata.put('report_last_ord_url', reportLastOrdUrl);
    await boxdata.put('report_last_inv_url', reportLastInvUrl);
    await boxdata.put('exp_approval_url', expApprovalUrl);
    await boxdata.put('sync_notice_url', syncNoticeUrl);
    await boxdata.put('report_atten_url', reportAttenUrl);
  }



 //todo!              Set LogIn DATA        >>>>>>>>>>>>>>>>    
 
  
setLogInData(bool userInfo,String userName,userId,password,mobileNo,bool offerFlag,noteFlag,clientEditFlag,osShowFlag,osDetailsFlag,ordHistoryFlag,invHistroyFlag,clientFlag,rxDocMust,rxTypeMust,rxGalleryAllow,orderFlag,dcrFlag,timerFlag,rxFlag,othersFlag,visitPlanFlag,plaginFlag,dcrDiscussion,promoFlag,leaveFlag,noticeFlag,docFlag,docEditFlag, List<String> dcrVisitedWithList, String meterReadingLast,rxTypeList)async{
  final boxdata=Boxes.allData();
        // await prefs.clear();
        await boxdata.put('areaPage', userInfo);
        await boxdata.put('userName', userName);
        await boxdata.put('user_id', userId);
        await boxdata.put('PASSWORD', password);
        await boxdata.put('mobile_no', mobileNo);
        await boxdata.put('offer_flag', offerFlag);
        await boxdata.put('note_flag', noteFlag!);
        await boxdata.put('client_edit_flag', clientEditFlag!);
        await boxdata.put('os_show_flag', osShowFlag!);
        await boxdata.put('os_details_flag', osDetailsFlag!);
        await boxdata.put('ord_history_flag', ordHistoryFlag!);
        await boxdata.put('inv_histroy_flag', invHistroyFlag!);
        await boxdata.put('client_flag', clientFlag);
        await boxdata.put('rx_doc_must', rxDocMust!);
        await boxdata.put('rx_type_must', rxTypeMust!);
        await boxdata.put('rx_gallery_allow', rxGalleryAllow!);
        await boxdata.put('order_flag', orderFlag);
        await boxdata.put('dcr_flag', dcrFlag);
        await boxdata.put('timer_flag', timerFlag!);
        await boxdata.put('rx_flag', rxFlag);
        await boxdata.put('others_flag', othersFlag);
        await boxdata.put('visit_plan_flag', visitPlanFlag);
        await boxdata.put('plagin_flag', plaginFlag);
        await boxdata.put('dcr_discussion', dcrDiscussion);
        await boxdata.put('promo_flag', promoFlag);
        await boxdata.put('leave_flag', leaveFlag);
        await boxdata.put('notice_flag', noticeFlag);
        await boxdata.put('doc_flag', docFlag);
        await boxdata.put('doc_edit_flag', docEditFlag);

        await boxdata.put('dcr_visit_with_list', dcrVisitedWithList);
        await boxdata.put('meter_reading_last', meterReadingLast);

        await boxdata.put('rx_type_list', rxTypeList);

}


}
