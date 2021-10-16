import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/pages/account_statement_page.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:softcoremobilebanking/utils/clipper.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../components/responsive_ui.dart';
import 'interest_certificate_page.dart';
import 'loan_history_page.dart';
import 'open_fixed_deposit_ac_page.dart';
import 'open_recurring_deposit_ac_page.dart';

class MoreMenuPage extends StatefulWidget {
  @override
  _MoreMenuPageState createState() => _MoreMenuPageState();
}

class _MoreMenuPageState extends State<MoreMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldAccountMenuKey =
      new GlobalKey<ScaffoldState>();
  List<Menu> menuList = [];

  Account selectedAc;
  List<Account> fdAccounts = [];
  bool _isLoading;
  String _loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = false;

      menuList = AppData.current.accontsMenu != null
          ? AppData.current.accontsMenu
          : [];

      if (AppData.current.customerLogin != null &&
          AppData.current.customerLogin.oAccounts != null &&
          AppData.current.customerLogin.oAccounts.length > 0) {
        fdAccounts = AppData.current.customerLogin.oAccounts
            .where((i) => i.AcType == AccountTypeConst.FDAcType)
            .toList();

        if (fdAccounts.length > 0) selectedAc = fdAccounts[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Theme.of(context).accentColor,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldAccountMenuKey,
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).accentColor,
                          Theme.of(context).primaryColor
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NavigationHomeScreen(),
                                // builder: (_) => SubjectsPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: ColorsConst.white,
                          radius: 20,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.of(context).text("key_services"),
                                style: Theme.of(context).textTheme.headline1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                AppData.current.customerLogin.ClientName ?? '',
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: size.width * 0.05,
                  top: size.height * 0.10,
                  right: size.width * 0.05,
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: size.height * 0.85,
                    width: size.width,
                    child: GridView.builder(
                      itemCount: menuList.length,
                      primary: false,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return _customCard(
                          menu: menuList[index],
                          onPressed: () {
                            switch (menuList[index].menuName.toUpperCase()) {
                              case MenuName.ACStatement:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AccountStatementPage(),
                                  ),
                                );
                                break;
                              case MenuName.DownloadFDSlip:
                                _downloadAccountSlip(context);
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
                              case MenuName.LoanRequest:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoanHistoryPage(),
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
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                      getDepositSlipDwnldUrl();
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

  _customCard({Menu menu, Function onPressed}) {
    Size size = MediaQuery.of(context).size;
    double _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    bool large = ResponsiveWidget.isScreenLarge(size.width, _pixelRatio);
    bool medium = ResponsiveWidget.isScreenMedium(size.width, _pixelRatio);
    return SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.4,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onPressed,
          child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        getIcon(menu.menuName),
                        color: Colors.white,
                        size: large
                            ? 40
                            : medium
                                ? 30
                                : 20,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      StringUtils.capitalize(
                          AppData.current.getMenuName(
                              context: context, menuName: menu.menuName),
                          allWords: true),
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(10),
              height: 150.0)),
    );
  }

  IconData getIcon(String menuName) {
    IconData iconData = Icons.arrow_circle_down_outlined;
    switch (menuName) {
      case MenuName.ACStatement:
        iconData = Icons.arrow_circle_down_outlined;
        break;
      case MenuName.OpenFixedDeposit:
        iconData = Icons.shopping_bag_outlined;
        break;
      case MenuName.IntCertRequest:
        iconData = Icons.backpack_outlined;
        break;
      case MenuName.DownloadFDSlip:
        iconData = Icons.download;
        break;
      case MenuName.LoanRequest:
        iconData = Icons.precision_manufacturing_sharp;
        break;
      case MenuName.OpenRecurringDeposit:
        iconData = Icons.precision_manufacturing_sharp;
        break;
    }
    return iconData;
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

  void getDepositSlipDwnldUrl() async {
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
//365