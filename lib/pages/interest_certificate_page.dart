import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:showcaseview/showcaseview.dart';

import '../app_data.dart';

class InterestCertificatePage extends StatefulWidget {
  const InterestCertificatePage({Key key}) : super(key: key);

  @override
  _InterestCertificatePageState createState() =>
      _InterestCertificatePageState();
}

class _InterestCertificatePageState extends State<InterestCertificatePage> {
  final GlobalKey<ScaffoldState> _InterestCertificatePageGlobalKey =
      new GlobalKey<ScaffoldState>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isSelected = false;

  List<Account> accountList = [];
  Account selectedAc;

  bool _isLoading;
  String _loadingText;
  GlobalKey downloadKey = GlobalKey();
  BuildContext myContext;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      accountList = AppData.current.customerLogin.oAccounts
          .where((i) => i.AcType == AccountTypeConst.FDAcType)
          .toList();

      if (accountList != null && accountList.length > 0) {
        selectedAc = accountList[0];
        accountList[0].isSelected = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _isFirstLaunch().then((result) {
            print(result);
            if (result) ShowCaseWidget.of(myContext).startShowCase([downloadKey]);
          });
        });
      }
    }


  }

  Future<Null> _selectDate(BuildContext context, String dateFor) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1980, 8),
      lastDate: DateTime(2025, 8),
    );
    if (picked != null) {
      switch (dateFor) {
        case 'From':
          setState(() {
            startDate = picked;
          });
          break;
        case 'To':
          setState(() {
            endDate = picked;
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorsConst.backgroundColor,
            key: _InterestCertificatePageGlobalKey,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                CustomAppbar(
                  caption:
                      AppTranslations.of(context).text("key_intr_crtf_req"),
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: accountList != null && accountList.length > 0
                      ? Column(
                          children: [
                            getInputWidgets(context),
                            Expanded(
                              child: ListView.builder(
                                itemCount: accountList.length,
                                padding: const EdgeInsets.only(top: 0),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() {
                                        for (int i = 0;
                                            i < accountList.length;
                                            i++) {
                                          accountList[i].isSelected = false;
                                        }
                                        accountList[index].isSelected = true;
                                        selectedAc = accountList[index];
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.account_balance_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      accountList[index]
                                                              .AccountName ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontSize: 14),
                                                      textAlign:
                                                          TextAlign.start),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      accountList[index]
                                                              .AccountNo ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              // color: ColorsConst.grey
                                                              ),
                                                      textAlign:
                                                          TextAlign.start),
                                                ],
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                accountList[index].isSelected
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: this.isSelected
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Theme.of(context)
                                                        .secondaryHeaderColor,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Divider(
                                              height: 1.0,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : CustomNotFoundWidget(
                          description: AppTranslations.of(context)
                              .text("key_account_not_available"),
                        ),
                )
              ],
            ),
            floatingActionButton:accountList != null && accountList.length > 0? ShowCaseWidget(
              builder: Builder(builder: (context) {
                myContext = context;
                return Showcase(
                  key: downloadKey,
                  title: AppTranslations.of(context).text("key_download"),
                  description: AppTranslations.of(context).text("key_clk_to_dwld_intr_crtf"),
                  shapeBorder: CircleBorder(),
                  animationDuration: Duration(milliseconds: 1500),
                  overlayColor: Colors.blueGrey,
                  child: FloatingActionButton(
                    onPressed: () {
                      dwnldFDIntCertificate();
                    },
                    child: const Icon(Icons.download_outlined,
                        color: Colors.white, size: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }),
              autoPlay: false,
              autoPlayDelay: Duration(seconds: 3),
              autoPlayLockEnable: false,
            ):Container(),
          ),
        ),
      ),
    );
  }

  getInputWidgets(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                AppTranslations.of(context).text("key_from"),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsConst.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 0),
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _selectDate(context, 'From');
                },
                child: Row(
                  children: [
                    Text(
                      startDate != null
                          ? DateFormat('dd-MMM-yyyy').format(startDate)
                          : DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.date_range,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                AppTranslations.of(context).text("key_to"),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsConst.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(top: 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _selectDate(context, 'To');
                },
                child: Row(
                  children: [
                    Text(
                      endDate != null
                          ? DateFormat('dd-MMM-yyyy').format(endDate)
                          : DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.date_range,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void dwnldFDIntCertificate() async {
    setState(() {
      _isLoading = true;
    });
    CustomerLogin customerLogin = AppData.current.customerLogin;
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri uri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            "FixedDeposit/GetFDIntCertificate",
      ).replace(queryParameters: {
        "ClientCode": AppData.current.ClientCode,
        "ConnectionString": AppData.current.ConnectionString,
        "BranchCode": selectedAc.BranchCode,
        "AccountNo": selectedAc.AccountNo,
        "FromDate": DateFormat('dd-MMM-yyyy').format(startDate),
        "ToDate": DateFormat('dd-MMM-yyyy').format(endDate),
        "CFLAG": "FALSE",
        "ZFLAG": "N",
        'ApplicationType': 'MobileBanking',
        'SessionAutoID': customerLogin == null
            ? "0"
            : customerLogin.SessionAutoID.toString(),
        'UserNo': customerLogin == null || customerLogin.user == null
            ? "-1"
            : customerLogin.user.UserNo.toString(),
        'ConnectionString': AppData.current.ConnectionString,
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

  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch = AppData.current.preferences
            .getBool(FirstLaunchConst.InterestCertfReq) ??
        true;

    if (isFirstLaunch)
      AppData.current.preferences
          .setBool(FirstLaunchConst.InterestCertfReq, false);

    return isFirstLaunch;
  }
}
