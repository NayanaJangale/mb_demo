import 'package:softcoremobilebanking/api/ledgerapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/components/custom_bank_view.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_spinner_item.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/account_statement.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

import 'menu_help_page.dart';

class AccountStatementPage extends StatefulWidget {
  const AccountStatementPage({Key key}) : super(key: key);

  @override
  _AccountStatementPageState createState() => _AccountStatementPageState();
}

class _AccountStatementPageState extends State<AccountStatementPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _AccountStatementPageGlobalKey =
  new GlobalKey<ScaffoldState>();
  List<String> _transationType = [];
  List<String> _engTransationType = [
    "Current Month",
    "Last Month",
    "Last 3 Months",
    "Last 6 Months",
    "Last Financial Year",
    "Current Financial Year",
    "Select Date Range",
  ];
  List<String> _mrTransationType = [
    "चालू महिना",
    "मागील महिना",
    "मागील 3 महिने",
    "मागील 6 महिने",
    "मागील आर्थिक वर्ष",
    "चालू आर्थिक वर्ष",
    "तारीख निवडा",
  ];

  String selectedTransactionType,
      selectedLocale = 'en';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isSelectDateVisible = false;
  double _filterViewHeight = 180.0;
  AnimationController animationController;
  Account selectedAc;
  List<Account> accountList = [];
  List<AccountStatement> acStatementList = [];
  bool isLoading;
  String loadingText;

  GlobalKey accountsKey = GlobalKey();
  GlobalKey acStatementTypeKey = GlobalKey();
  GlobalKey applyKey = GlobalKey();
  BuildContext myContext;

  @override
  void initState() {
    this.isLoading = false;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      accountList = AppData.current.customerLogin.oAccounts
          .where((i) => i.AccountType == AccountTypeConst.TransactionalAccounts)
          .toList();
      if (accountList.length > 0) selectedAc = accountList[0];
    }

    selectedLocale =
        AppData.current.preferences.getString('localeLang') ?? 'en';
    if (selectedLocale == "en") {
      _transationType.addAll(_engTransationType);
    } else {
      _transationType.addAll(_mrTransationType);
    }

    selectedTransactionType = _transationType[0];

    if (selectedAc != null)
      loadAccountStatement();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          _isFirstLaunch().then((result) {
            if (result)
              ShowCaseWidget.of(myContext).startShowCase(
                  [accountsKey, acStatementTypeKey, applyKey]);
          });
        }
    );
  }

  Future<Null> _selectDate(BuildContext context, String dateFor) async {
    Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.amber,
      ),
      child: new Builder(
        builder: (context) =>
        new FloatingActionButton(
          child: new Icon(Icons.date_range),
          onPressed: () =>
              showDatePicker(
                context: context,
                initialDate: new DateTime.now(),
                firstDate:
                new DateTime.now().subtract(new Duration(days: 30)),
                lastDate: new DateTime.now().add(new Duration(days: 30)),
              ).then((picked) {
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
              }),
        ),
      ),
    );

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
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.loadingText = AppTranslations.of(context).text("key_loading");

    return ShowCaseWidget(
      onStart: (index, key) {

      },
      builder: Builder(builder: (context) {
        myContext = context;
        return CustomProgressHandler(
          isLoading: this.isLoading,
          loadingText: this.loadingText,
          child: Container(
            color: Colors.grey[100],
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: ColorsConst.backgroundColor,
                  key: _AccountStatementPageGlobalKey,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomAppbar(
                        caption:
                        AppTranslations.of(context).text(
                            "key_account_statement"),
                        backButtonVisibility: true,
                        onBackPressed: () {
                          Navigator.pop(context);
                        },
                        onIconPressed: () async {
                          String connectionServerMsg = await NetworkHandler
                              .getServerWorkingUrl();
                          if (connectionServerMsg != "key_check_internet") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MenuHelpPage(
                                      menuName: AppTranslations.of(context).text(
                                          "key_account_statement"),
                                      pdfURL:connectionServerMsg + "/CustCommonAppApi/help/accountstatement.pdf",
                                    ),
                              ),
                            );
                          }else{
                            FlushbarMessage.show(
                              context,
                              connectionServerMsg,
                              MessageTypes.WARNING,
                            );
                          }
                        },
                        icon: Icons.help_outline_outlined,
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() {
                              _filterViewHeight != 0.0
                                  ? _filterViewHeight = 0.0
                                  : selectedTransactionType ==
                                  AppTranslations.of(context)
                                      .text("key_select_date_range")
                                  ? _filterViewHeight = 240
                                  : _filterViewHeight = 180;
                            }),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Theme
                              .of(context)
                              .primaryColor,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context).text(
                                      "key_filter"),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                      color: ColorsConst.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                Icon(
                                  Icons.sort,
                                  color: ColorsConst.white,
                                  //size: 22.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        //color: Colors.grey[200],
                        duration: const Duration(milliseconds: 120),
                        height: _filterViewHeight,
                        child: getFilterView(context),
                      ),
                      Expanded(
                        child: acStatementList != null && acStatementList
                            .length > 0
                            ? ListView.builder(
                          itemCount: acStatementList.length,
                          padding: const EdgeInsets.only(top: 8),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = acStatementList.length;
                            // hotelList.length > 10 ? 10 : hotelList.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController.forward();
                            return AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: Transform(
                                    transform: Matrix4.translationValues(
                                        0.0, 50 * (1.0 - animation.value), 0.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                acStatementList[index]
                                                    .VoucherDate !=
                                                    null
                                                    ? DateFormat('dd-MMM-yyyy')
                                                    .format(DateTime.parse(
                                                    acStatementList[index]
                                                        .VoucherDate))
                                                    : '',
                                                textAlign: TextAlign.center,
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                              Spacer(),
                                              Text(
                                                AppTranslations.of(context)
                                                    .text("key_rs_symbol") +
                                                    getAmunt(index),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor),
                                              ),
                                              Icon(
                                                  isDebit(index)
                                                      ? Icons
                                                      .arrow_circle_up_outlined
                                                      : Icons
                                                      .arrow_circle_down_outlined,
                                                  size: 20,
                                                  color: isDebit(index)
                                                      ? Colors.red
                                                      : Colors.green)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 5.0),
                                              Text(
                                                  acStatementList[index]
                                                      .Narration,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  )),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                  AppTranslations.of(context)
                                                      .text("key_balance"),
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                    // color: Theme.of(context).primaryColor,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  )),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                AppTranslations.of(context)
                                                    .text("key_rs_symbol") +
                                                    acStatementList[index]
                                                        .ClosingBalance,
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                ),
                                                child: Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                    BorderRadius.all(
                                                      Radius.circular(4.0),
                                                    ),
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
                              },
                            );
                          },
                        )
                            : CustomNotFoundWidget(
                          description: AppTranslations.of(context)
                              .text("key_ac_statement_not_available"),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      }),
      autoPlay: false,
      autoPlayDelay: Duration(seconds: 3),
      autoPlayLockEnable: false,
    );
  }

  bool isDebit(int index) {
    if (acStatementList[index].DebitAmount != null &&
        double.parse(acStatementList[index].DebitAmount) > 0) {
      return true;
    } else {
      return false;
    }
  }

  String getAmunt(int index) {
    if (acStatementList[index].DebitAmount != null &&
        double.parse(acStatementList[index].DebitAmount) > 0) {
      return acStatementList[index].DebitAmount;
    } else {
      return acStatementList[index].CreditAmount;
    }
  }

  getFilterView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(
          children: [
            Showcase(
              key: accountsKey,
              title: AppTranslations.of(context).text("key_account"),
              description: AppTranslations.of(context).text(
                  "key_slct_ac_to_view_ac_stmt"),
              shapeBorder: CircleBorder(),
              animationDuration: Duration(milliseconds: 1500),
              overlayColor: Colors.blueGrey,
              child: CustomBankView(
                onTap: () {
                  showBankAccounts();
                },
                accountName: selectedAc != null
                    ? selectedAc.AccountName
                    : AppTranslations.of(context).text("key_select_account"),
                accountNo: selectedAc != null ? selectedAc.AccountNo : '',
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Showcase(
              key: acStatementTypeKey,
              title: AppTranslations.of(context).text("key_stmt_type"),
              description: AppTranslations.of(context).text(
                  "key_slct_ac_stmt_type"),
              shapeBorder: CircleBorder(),
              animationDuration: Duration(milliseconds: 1500),
              overlayColor: Colors.blueGrey,
              child: CustomSpinnerItem(
                onPressed: () {
                  showTransactionType();
                },
                caption: AppTranslations.of(context).text("key_select_type"),
                selectedItem: selectedTransactionType ?? "",
              ),
            ),

            Visibility(
              visible: isSelectDateVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      AppTranslations.of(context).text("key_from"),
                      style: Theme
                          .of(context)
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
                    margin: const EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, 'From');
                      },
                      child: Row(
                        children: [
                          Text(
                            startDate != null
                                ? DateFormat('dd-MMM-yyyy').format(startDate)
                                : DateFormat('dd-MMM-yyyy')
                                .format(DateTime.now()),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.date_range,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      AppTranslations.of(context).text("key_to"),
                      style: Theme
                          .of(context)
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
                    margin: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, 'To');
                      },
                      child: Row(
                        children: [
                          Text(
                            endDate != null
                                ? DateFormat('dd-MMM-yyyy').format(endDate)
                                : DateFormat('dd-MMM-yyyy')
                                .format(DateTime.now()),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.date_range,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Showcase(
                    key: applyKey,
                    title: AppTranslations.of(context).text("key_apply"),
                    description: AppTranslations.of(context).text(
                        "key_clck_to_view_ac_stmt"),
                    shapeBorder: CircleBorder(),
                    animationDuration: Duration(milliseconds: 1500),
                    overlayColor: Colors.blueGrey,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_up),
                      style: ElevatedButton.styleFrom(
                        primary: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      onPressed: () {
                        loadAccountStatement();
                        /*setState(() {
                        _filterViewHeight = 0.0;
                      });*/
                      },
                      label: Text(
                        AppTranslations.of(context).text("key_apply"),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorsConst.white,
                            fontSize: 14),
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showTransactionType() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_select_type"),
              ),
              actions: List<Widget>.generate(
                _transationType.length,
                    (i) =>
                    CustomCupertinoAction(
                      actionText: _transationType[i],
                      actionIndex: i,
                      onActionPressed: () {
                        setState(() {
                          selectedTransactionType = _transationType[i];

                          if (selectedTransactionType ==
                              AppTranslations.of(context)
                                  .text("key_select_date_range")) {
                            isSelectDateVisible = true;
                            _filterViewHeight = 220;
                          } else {
                            isSelectDateVisible = false;
                            _filterViewHeight = 180;
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
              )),
    );
  }

  void showBankAccounts() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_select_account"),
              ),
              actions: List<Widget>.generate(
                accountList.length,
                    (index) =>
                    CustomBankSpinner(
                      accountNo: accountList[index].AccountNo ?? '',
                      accountName: accountList[index].AccountName ?? '',
                      onPressed: () {
                        setState(() {
                          selectedAc = accountList[index];
                        });
                        Navigator.pop(context);
                      },
                    ),
              )),
    );
  }

  loadAccountStatement() {
    setState(() {
      this.isLoading = true;
    });
    var now = new DateTime.now();

    switch (selectedTransactionType) {
      case "Current Month":
      case "चालू महिना":
        setState(() {
          startDate = DateTime.utc(now.year, now.month, 1);
          endDate = DateTime.utc(
            now.year,
            now.month + 1,
          ).subtract(Duration(days: 1));
        });

        break;
      case "Last Month":
      case "मागील महिना":
        setState(() {
          startDate = DateTime.utc(now.year, now.month - 1, 1);
          endDate = DateTime.utc(
            now.year,
            now.month,
          ).subtract(Duration(days: 1));
        });
        break;
      case "Last 3 Months":
      case "मागील 3 महिने":
        setState(() {
          startDate = new DateTime(now.year, now.month - 3, now.day);
          endDate = now;
        });
        break;
      case "Last 6 Months":
      case "मागील 6 महिने":
        setState(() {
          startDate = new DateTime(now.year, now.month - 6, now.day);
          endDate = now;
        });
        break;
      case "Last Financial Year":
      case "मागील आर्थिक वर्ष":
        setState(() {
          if (now.month <= 3) {
            startDate = DateTime.utc(now.year - 2, 3, 1);
            endDate =
                DateTime.utc(now.year - 1, 4, 1).subtract(Duration(days: 1));
          } else {
            startDate = DateTime.utc(now.year - 1, 3, 1);
            endDate = DateTime.utc(now.year, 4, 1).subtract(Duration(days: 1));
          }
        });
        break;
      case "Current Financial Year":
      case "चालू आर्थिक वर्ष":
        setState(() {
          if (now.month <= 3) {
            startDate = DateTime.utc(now.year - 1, 3, 1);
            endDate = DateTime.utc(now.year, 4, 1).subtract(Duration(days: 1));
          } else {
            startDate = DateTime.utc(now.year, 3, 1);
            endDate =
                DateTime.utc(now.year + 1, 4, 1).subtract(Duration(days: 1));
          }
        });
        break;
    }
    LedgerAPI(context: context)
        .getAccountStatement(
        BranchCode: selectedAc.BranchCode,
        AccountNo: selectedAc.AccountNo,
        FromDate: DateFormat('dd-MMM-yyyy').format(startDate),
        ToDate: DateFormat('dd-MMM-yyyy').format(endDate))
        .then((res) {
      setState(() {
        this.isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          acStatementList = List<AccountStatement>.from(
              data.map((i) => AccountStatement.fromJson(i)));
        });
      } else {
        FlushbarMessage.show(
          context,
          res["Message"] ?? '',
          MessageTypes.ERROR,
        );
      }
    });
  }

  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch = AppData.current.preferences.getBool(
        FirstLaunchConst.AccountStatement) ?? true;

    if (isFirstLaunch)
      AppData.current.preferences.setBool(
          FirstLaunchConst.AccountStatement, false);

    return isFirstLaunch;
  }
}
//https://stackoverflow.com/questions/61949626/flutter-filter-list-based-on-last-week-last-month-and-last-year
//https://stackoverflow.com/questions/8878399/how-to-discover-financial-year-based-on-current-datetime
