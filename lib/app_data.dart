import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/SharedPreferencesConst.dart';
import 'constants/menuname.dart';
import 'localization/app_translations.dart';
import 'models/customer_login.dart';
import 'models/menu.dart';

class AppData {
  String ClientCode, ConnectionString = "", MacAddress = "999",userNo="-1";

  List<Menu> accontsMenu = [];
  List<Menu> fundsTransferMenu = [];
  List<Menu> rechargeMenu = [];
  List<Menu> utilityMenu = [];

  CustomerLogin customerLogin;
  Uint8List bytesLogoImg;

  void get clearMenu {
    accontsMenu = [];
    fundsTransferMenu = [];
    rechargeMenu = [];
    utilityMenu = [];
  }

  SharedPreferences preferences;

  static AppData _current;

  static AppData get current {
    if (_current == null) {
      _current = AppData();
    }
    return _current;
  }

  static void get clearData {
    _current = null;
  }

  String getMenuName({BuildContext context, String menuName}) {
    switch (menuName) {
      case MenuName.SelfAccountTransfer:
        menuName = AppTranslations.of(context).text("key_self_ac_trans");
        break;
      case MenuName.IntraBankTransfer:
        menuName = AppTranslations.of(context).text("key_intra_bank_trans");
        break;
      case MenuName.InterBankTransfer:
        menuName = AppTranslations.of(context).text("key_inter_bank_trans");
        break;
      case MenuName.MobileRecharge:
        menuName = AppTranslations.of(context).text("key_mobile_recharge");
        break;
      case MenuName.PostpaidMobileBills:
        menuName =
            AppTranslations.of(context).text("key_postpaid_mobile_bills");
        break;
      case MenuName.DataCardRecharge:
        menuName = AppTranslations.of(context).text("key_dataCard_recharge");
        break;
      case MenuName.DTHRecharge:
        menuName = AppTranslations.of(context).text("key_dth_recharge");
        break;
      case MenuName.LandlinePhoneBills:
        menuName = AppTranslations.of(context).text("key_landline_phone_bills");
        break;
      case MenuName.ElectricityBills:
        menuName = AppTranslations.of(context).text("key_electricity_bills");
        break;
      case MenuName.RecentBills:
        menuName = AppTranslations.of(context).text("key_recent_bills");
        break;
      case MenuName.ACStatement:
        menuName = AppTranslations.of(context).text("key_ac_statement");
        break;
      case MenuName.OpenFixedDeposit:
        menuName = AppTranslations.of(context).text("key_open_fd");
        break;
      case MenuName.OpenRecurringDeposit:
        menuName = AppTranslations.of(context).text("key_open_rd");
        break;
      case MenuName.IntCertRequest:
        menuName = AppTranslations.of(context).text("key_intr_cert");
        break;
        break;
      case MenuName.DownloadFDSlip:
        menuName = AppTranslations.of(context).text("key_deposit_slip");
        break;
      case MenuName.LoanRequest:
        menuName = AppTranslations.of(context).text("key_loan_req");
        break;
      case MenuName.Gallery:
        menuName = AppTranslations.of(context).text("key_gallery");
        break;
      case MenuName.Circular:
        menuName = AppTranslations.of(context).text("key_circular");
        break;
      case MenuName.ChangePassword:
        menuName = AppTranslations.of(context).text("key_change_pswd");
        break;
      case MenuName.AddFingerprint:
        menuName = AppTranslations.of(context).text("key_add_fingr");
        break;
      case MenuName.MyProfile:
        menuName = AppTranslations.of(context).text("key_my_profile");
        break;
        case MenuName.Setting:
        menuName = AppTranslations.of(context).text("key_setting");
        break;
    }
    return menuName;
  }

  IconData getMenuIcon({BuildContext context, String menuName}) {
    IconData iconData = Icons.phone_android;
    switch (menuName) {
      /* case MenuName.SelfAccountTransfer:
        menuName = AppTranslations.of(context).text("key_self_ac_trans");
        break;
      case MenuName.IntraBankTransfer:
        menuName = AppTranslations.of(context).text("key_intra_bank_trans");
        break;
      case MenuName.InterBankTransfer:
        menuName = AppTranslations.of(context).text("key_inter_bank_trans");
        break;*/
      case MenuName.MobileRecharge:
        iconData = Icons.phone_android;
        break;
      case MenuName.PostpaidMobileBills:
        iconData = Icons.phone_android;
        break;
      case MenuName.DataCardRecharge:
        iconData = Icons.vpn_lock_outlined;
        break;
      case MenuName.DTHRecharge:
        iconData = Icons.live_tv_rounded;
        break;
      case MenuName.LandlinePhoneBills:
        iconData = Icons.phone;
        break;
      case MenuName.ElectricityBills:
        iconData = Icons.lightbulb_outline_rounded;
        break;
      case MenuName.RecentBills:
        iconData = Icons.article_rounded;
        break;
    }
    return iconData;
  }

  bool isFngrPrintAvailable() {
    if (AppData.current.preferences != null &&
        AppData.current.preferences
            .getString(SharedPreferencesConst.FingerPrintUserNo) !=
            null &&
        AppData.current.preferences
            .getString(SharedPreferencesConst.FingerPrintUserNo) !=
            "0") {
      return true;
    } else {
      return false;
    }
  }
}
