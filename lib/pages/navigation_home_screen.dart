import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/drawer_user_controller.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/beneficiary_type.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/menuname_marathi.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/constants/service_type_constant.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/pages/accounts_page.dart';
import 'package:softcoremobilebanking/pages/home_page.dart';
import 'package:softcoremobilebanking/pages/login_page.dart';
import 'package:softcoremobilebanking/pages/profile_page.dart';
import 'package:softcoremobilebanking/pages/recent_bill_page.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_fund_tran_page.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_self_transfer_page.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:showcaseview/showcaseview.dart';

import '../models/menu.dart';
import 'account_statement_page.dart';
import 'album_page.dart';
import 'change_pswd_page.dart';
import 'circular_page.dart';
import 'finerprint_reg_page.dart';
import 'interest_certificate_page.dart';
import 'loan_history_page.dart';
import 'open_fixed_deposit_ac_page.dart';
import 'open_recurring_deposit_ac_page.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  int menuLen = 0;
  bool _isLoading;
  String _loadingText;
  Account selectedAc;
  List<Account> fdAccounts = [];

  @override
  void initState() {
    screenView = ShowCaseWidget(
      onStart: (index, key) {},
      onComplete: (index, key) {
        if (index == 4)
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
              .copyWith(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white));
      },
      builder: Builder(builder: (context) => HomePage()),
      autoPlay: false,
      autoPlayDelay: Duration(seconds: 3),
      autoPlayLockEnable: false,
    );
    //screenView = HomePage();
    _isLoading = false;
    setState(() {
      if (AppData.current.accontsMenu.length > 0) menuLen++;
      if (AppData.current.fundsTransferMenu.length > 0) menuLen++;
      if (AppData.current.rechargeMenu.length > 0) menuLen++;
      if (AppData.current.utilityMenu.length > 0) menuLen++;

      if (AppData.current.customerLogin != null &&
          AppData.current.customerLogin.oAccounts != null &&
          AppData.current.customerLogin.oAccounts.length > 0) {
        fdAccounts = AppData.current.customerLogin.oAccounts
            .where((i) => i.AcType == AccountTypeConst.FDAcType)
            .toList();

        if (fdAccounts.length > 0) selectedAc = fdAccounts[0];
      }
    });

    if (AppData.current.accontsMenu.length == 0 &&
        AppData.current.fundsTransferMenu.length == 0 &&
        AppData.current.rechargeMenu.length == 0 &&
        AppData.current.utilityMenu.length == 0) {
      setState(() {
        _isLoading = true;
      });
      CustomerAPI(context: context).getMenus().then((res) {
        setState(() {
          _isLoading = false;
        });
        if (res != null && HttpStatusCodes.OK == res['Status']) {
          var accountsData = res['Data'];
          List<Menu> Menus =
              List<Menu>.from(accountsData.map((i) => Menu.fromMap(i)));
          setState(() {
            if (Menus != null && Menus.length > 0) {
              AppData.current.customerLogin.Menus = Menus;
            }
          });
        } else {
          FlushbarMessage.show(
            context,
            res["Message"],
            MessageTypes.WARNING,
          );
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return Container(
      color: ColorsConst.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: ColorsConst.nearlyWhite,
          body: WillPopScope(
            onWillPop: () {
              onBackPressed();
            },
            child: DrawerUserController(
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              menuLen: menuLen,
              onDrawerCall: (Menu menu) {
                changeIndex(menu);
              },
              screenView: screenView,
              //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            ),
          ),
        ),
      ),
    );
  }

  void changeIndex(Menu menu) {
    String serviceType;
    switch (menu.menuName.toUpperCase()) {
      case MenuName.ACStatement:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountStatementPage(),
          ),
        );
        break;
      case MenuName.OpenFixedDeposit:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OpenFixedDepositACPage(),
          ),
        );
        break;
      case MenuName.OpenRecurringDeposit:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OpenRecurringDepositACPage(),
          ),
        );
        break;
      case MenuName.SelfAccountTransfer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectAccountForSelfTransferPage(),
          ),
        );
        break;
      case MenuName.IntCertRequest:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InterestCertificatePage(),
          ),
        );
        break;
      case MenuName.DownloadFDSlip:
        _downloadAccountSlip(context);
        break;
      case MenuName.LoanRequest:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoanHistoryPage(),
          ),
        );
        break;
      case MenuName.IntraBankTransfer:
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectAccountForFundTransferPage(
                beneficiaryType: BeneficiaryTypeConst.IntraBankBeneficiary,
              ),
            ),
          );
        });
        break;
      case MenuName.InterBankTransfer:
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectAccountForFundTransferPage(
                beneficiaryType: BeneficiaryTypeConst.InterBankBeneficiary,
              ),
            ),
          );
        });
        break;
      case MenuName.RecentBills:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: "%",
                paymentStatus: "%",
                menuType: menu.MenuType,
                menuFor: MenuName.RecentBills,
                serviceName: "%"),
          ),
        );
        break;
      case MenuName.MobileRecharge:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PrepaidRecharge;
        } else {
          serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.MobileRecharge,
                serviceName: ServiceNameConst.Mobile),
          ),
        );
        break;
      case MenuName.DataCardRecharge:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PrepaidRecharge;
        } else {
          serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.DataCardRecharge,
                serviceName: ServiceNameConst.DataCard),
          ),
        );
        break;
      case MenuName.DTHRecharge:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PrepaidRecharge;
        } else {
          serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.DTHRecharge,
                serviceName: ServiceNameConst.DTH),
          ),
        );
        break;
      case MenuName.PostpaidMobileBills:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PostpaidBills;
        } else {
          serviceType = ServiceTypeConst.Pay2NewPostpaidBills;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.PostpaidMobileBills,
                serviceName: ServiceNameConst.Mobile),
          ),
        );
        break;
      case MenuName.LandlinePhoneBills:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PostpaidBills;
        } else {
          // serviceType = ServiceNameConst.Landline;
          serviceType = ServiceTypeConst.Pay2NewPostpaidBills;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.LandlinePhoneBills,
                serviceName: ServiceNameConst.Landline),
          ),
        );
        break;
      case MenuName.ElectricityBills:
        if (menu.MenuType == MenuTypeConst.Cyberplat) {
          serviceType = ServiceTypeConst.PostpaidBills;
        } else {
          serviceType = ServiceTypeConst.Electricity;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecentBillsPage(
                serviceType: serviceType,
                paymentStatus: "SUCCESS",
                menuType: menu.MenuType,
                menuFor: MenuName.ElectricityBills,
                serviceName: ServiceNameConst.Electricity),
          ),
        );
        break;
      case MenuName.Gallery:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlbumsPage(),
          ),
        );
        break;
      case MenuName.Circular:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CircularPage(),
          ),
        );
        break;
      case MenuName.ChangePassword:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePasswordPage(
              transactionType: TransactionType.ChangeCustomerPassword,
            ),
          ),
        );
        break;
      case MenuName.MyProfile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(),
          ),
        );

        break;
      case MenuName.AddFingerprint:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FingerprintRegistrationPage(),
          ),
        );
        break;
      case MenuName.Setting:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsPage(),
          ),
        );
        break;
    }
  }

  void _downloadAccountSlip(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: new Text(
                AppTranslations.of(context).text("key_downld_deposit_slip"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.of(context)
                              .text("key_select_account"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: CustomBankSpinner(
                            onPressed: () {
                              showBankAccounts().then((value) {
                                setState(() {
                                  if (value != null) selectedAc = value;
                                });
                              });
                            },
                            accountName: selectedAc != null
                                ? selectedAc.AccountName
                                : AppTranslations.of(context)
                                    .text("key_select_account"),
                            accountNo:
                                selectedAc != null ? selectedAc.AccountNo : '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (selectedAc != null) {
                      depositSlipDwnld();
                      Navigator.of(context).pop();
                    } else {
                      FlushbarMessage.show(
                        context,
                        AppTranslations.of(context).text("key_select_account"),
                        MessageTypes.WARNING,
                      );
                    }
                    //Navigator.of(context).pop();
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_download"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_cancel"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              //height: MediaQuery.of(context).size.height * 3 / 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppTranslations.of(context)
                          .text("key_do_you_want_to_logout"),
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[500],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              AppTranslations.of(context).text("key_no"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              CustomerAPI(context: context)
                                  .CustomerLogout()
                                  .then((res) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (res != null &&
                                    HttpStatusCodes.ACCEPTED == res['Status']) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  FlushbarMessage.show(
                                    context,
                                    res["Message"],
                                    MessageTypes.WARNING,
                                  );
                                  Navigator.pop(context);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[500],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              AppTranslations.of(context).text("key_yes"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> showBankAccounts() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_select_account"),
              ),
              actions: List<Widget>.generate(
                fdAccounts.length,
                (index) => CustomBankSpinner(
                  accountNo: fdAccounts[index].AccountNo ?? '',
                  accountName: fdAccounts[index].AccountName ?? '',
                  onPressed: () {
                    Navigator.pop(context, fdAccounts[index]);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void depositSlipDwnld() async {
    setState(() {
      _isLoading = true;
    });
    CustomerLogin customerLogin = AppData.current.customerLogin;
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri uri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            "FixedDeposit/GetDepositSlip",
      ).replace(queryParameters: {
        "ClientCode": AppData.current.ClientCode,
        "ConnectionString": AppData.current.ConnectionString,
        "AccountNo": selectedAc.AccountNo,
        "BranchCode": selectedAc.BranchCode,
        'ApplicationType': 'MobileBanking',
        'SessionAutoID': customerLogin == null
            ? "0"
            : customerLogin.SessionAutoID.toString(),
        'UserNo': customerLogin == null || customerLogin.user == null
            ? "-1"
            : customerLogin.user.UserNo.toString(),
        'ConnectionString': AppData.current.ConnectionString,
        "ClientCode": AppData.current.ClientCode,
        "MacAddress": AppData.current.MacAddress,
      });
      Response response = await get(
        uri,
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode != HttpStatusCodes.OK) {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_some_error_cont_bank"),
          MessageTypes.WARNING,
        );
      } else {
        var pdfData = response.bodyBytes;
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdfData);
      }
    }
  }
}
////imps 2lakh neft rtgs 5lakh gold current account // 2lkh imps 3 lkh neft/ rtgs gold sav a/c   //
