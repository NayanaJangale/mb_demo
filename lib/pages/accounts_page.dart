import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/account_summary.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GlobalKey<ScaffoldState> _accountPageGlobalKey =
      new GlobalKey<ScaffoldState>();
  List<Account> accountList = [];

  bool _isLoading;
  String _loadingText;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null) {
      accountList = AppData.current.customerLogin.oAccounts;
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
              key: _accountPageGlobalKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  CustomAppbar(
                    backButtonVisibility: true,
                    onBackPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NavigationHomeScreen(),
                        ),
                      );
                    },
                    caption: AppTranslations.of(context).text("key_accounts"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: accountList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.6),
                                          blurRadius: 24),
                                    ],
                                  ),
                                  //color: Theme.of(context).accentColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        getAcName(accountList[index].AcType),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30.0),
                                        topLeft: Radius.circular(3.0),
                                        bottomRight: Radius.circular(3.0),
                                        bottomLeft: Radius.circular(3.0),
                                      ),
                                    ),
                                    color: ColorsConst.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  getAcode(accountList[index]),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (accountList[index]
                                                        .isACVisible)
                                                      accountList[index]
                                                          .isACVisible = false;
                                                    else
                                                      accountList[index]
                                                          .isACVisible = true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(
                                                    accountList[index]
                                                            .isACVisible
                                                        ? Icons.remove_red_eye
                                                        : Icons
                                                            .remove_red_eye_outlined,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Container(
                                              height: 1,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      AppTranslations.of(
                                                              context)
                                                          .text("key_balance"),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    AppTranslations.of(context)
                                                            .text(
                                                                "key_rs_symbol") +
                                                        (accountList != null
                                                            ? accountList[index]
                                                                .Balance
                                                                .toString()
                                                            : ''),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTapDown:
                                                    (TapDownDetails details) =>
                                                        _showPopupMenu(details,
                                                            accountList[index]),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
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
              )),
        ),
      ),
    );
  }

  String getAcName(String acType) {
    String acTypeName = '';

    switch (acType) {
      case "CUR":
        acTypeName = "Current";
        break;
      case "DRD":
        acTypeName = "Pigmy";
        break;
      case "RDD":
        acTypeName = "Recurring Deposit";
        break;
      case "FDR":
        acTypeName = "Fixed Deposit";
        break;
      case "GEN":
        acTypeName = "General";
        break;
      case "LAC":
        acTypeName = "Loan";
        break;
      case "SAV":
        acTypeName = "Saving";
        break;
      case "SHR":
        acTypeName = "Shares";
        break;
    }
    return acTypeName;
  }

  String getAcode(Account account) {
    String acode = '';
    if (account.isACVisible) {
      acode = account.AccountNo;
    } else {
      acode = 'X' *
              (account.AccountNo.length > 6
                  ? account.AccountNo.length - 6
                  : 1) +
          (account.AccountNo.length > 6
              ? account.AccountNo.substring(account.AccountNo.length - 6)
              : account.AccountNo);
    }

    return acode;
  }

  Future<void> _showPopupMenu(TapDownDetails details, Account account) async {
    Offset _tapPosition;
    final RenderBox referenceBox = context.findRenderObject();
    _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    var x = _tapPosition.dx;
    var y = _tapPosition.dy;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(x, y, x + 1, y + 1),
      items: [
        if (account.AccountType != AccountType.TransactionalAccounts)
          PopupMenuItem<String>(
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppTranslations.of(context).text("key_account_details"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
              value: '1'),
        if (account.NomineeDetails.length > 0)
          PopupMenuItem<String>(
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppTranslations.of(context).text("key_nominee_dtls"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
              value: '2'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(
                  Icons.share_sharp,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  AppTranslations.of(context).text("key_share"),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                )
              ],
            ),
            value: '3'),
      ],
      elevation: 8.0,
    ).then<void>((String itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .GetAccountSummary(
                AccountNo: account.AccountNo, BranchCode: account.BranchCode)
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.OK == res['Status']) {
            var data = res["Data"];
            AccountSummary accountSummary = AccountSummary.fromMap(res['Data']);
            if (account.AccountType == AccountType.DepositAccounts) {
              _showDepositAccountDetails(context, accountSummary);
            }

            if (account.AccountType == AccountType.LoanAccounts &&
                account.LoanType == LoanType.DateType) {
              _showDateTypeLoanSummary(context, accountSummary);
            } else if (account.AccountType == AccountType.LoanAccounts) {
              _showInstallmentLoanSummary(context, accountSummary);
            }
          } else {
            FlushbarMessage.show(
              context,
              res["Message"],
              MessageTypes.WARNING,
            );
          }
        });
      } else if (itemSelected == "2") {
        _showNomineeDetails(context, account);
      } else if (itemSelected == "3") {
        _showAccountInfo(context, account);
      }
    });
  }

  void _showDepositAccountDetails(
      BuildContext context, AccountSummary accountSummary) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_account_summery"),
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
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_opening_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.OpeningDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.OpeningDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_installment"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(getInstallmentAmount(accountSummary),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_interest_rate"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.InterestRate,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_maturity_amount"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(getMaturityAmount(accountSummary),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_maturity_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.ClosingDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.ClosingDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showInstallmentLoanSummary(
      BuildContext context, AccountSummary accountSummary) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_account_summery"),
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
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_loan_amt"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.LoanAmount,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_loan_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.OpeningDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.OpeningDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_loan_duration"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.NoOfLoanInstallments,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_due_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.ClosingDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.ClosingDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_interest_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.InterestRate,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_emi_amount"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.LoanInstallmentAmount,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showDateTypeLoanSummary(
      BuildContext context, AccountSummary accountSummary) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_account_summery"),
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
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_loan_limit"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.LoanLimit,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_loan_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.OpeningDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.OpeningDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_interest_rate"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.InterestRate,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_wd_limit"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(accountSummary.WithdrawalLimit,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_due_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                    accountSummary.ClosingDate != StringHandlers.NotAvailable
                        ? DateFormat('dd-MMM-yyyy')
                            .format(DateTime.parse(accountSummary.ClosingDate))
                        : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  String getInstallmentAmount(AccountSummary accountSummary) {
    String amount = '';
    if (accountSummary.AccountName == AccountType.FixedDepositAccount) {
      amount = accountSummary.FixedDepositAmount;
    }
    if (accountSummary.AccountName == AccountType.RecurringDepositAccount) {
      amount = accountSummary.RDInstallmentAmount;
    }

    return amount;
  }

  String getMaturityAmount(AccountSummary accountSummary) {
    String amount = '';
    if (accountSummary.AccountName == AccountType.FixedDepositAccount) {
      amount = accountSummary.FDMaturityAmount;
    }
    if (accountSummary.AccountName == AccountType.RecurringDepositAccount) {
      amount = accountSummary.RDMaturityAmount;
    }

    return amount;
  }

  void _showNomineeDetails(BuildContext context, Account account) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_nominee_dtls"),
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
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_name"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].NNAME,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_age"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].AGE,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_relation"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].RELATION,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_dob"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].BDATE,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_email_id"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].EMAILID,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_adhar_card_no"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].ADHARID,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_pan_card_no"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].PAN_NO,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_contact_no"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(account.NomineeDetails[0].CONTACT,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_address"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(
                  account.NomineeDetails[0].addres,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showAccountInfo(BuildContext context, Account account) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_account_info"),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(AppTranslations.of(context).text("key_account_name"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.start),
                      Text(account != null ? account.AccountName : '',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.right),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                          AppTranslations.of(context)
                              .text("key_account_number"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.start),
                      Text(account != null ? account.AccountNo : '',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.right),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ),
                      Visibility(
                        visible: account != null &&
                            account.vacode != null &&
                            account.vacode != StringHandlers.NotAvailable,
                        child: Column(
                          children: [
                            Text(
                                AppTranslations.of(context)
                                    .text("key_payment_account"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                textAlign: TextAlign.start),
                            Text(account != null ? account.vacode : '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.right),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 10),
                              child: Divider(
                                height: 1.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(AppTranslations.of(context).text("key_ifsc_code"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.start),
                      Text(account != null ? account.IFSCCode : '',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.right),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  String shareText = AppTranslations.of(context)
                          .text("key_account_name") +
                      " :- " +
                      account.AccountName +
                      "\n" +
                      AppTranslations.of(context).text("key_account_number") +
                      " :- " +
                      account.AccountNo +
                      "\n" +
                      (account.vacode != StringHandlers.NotAvailable
                          ? (AppTranslations.of(context)
                                      .text("key_payment_account") +
                                  " :- " +
                                  account.vacode) +
                              "\n"
                          : "") +
                      AppTranslations.of(context).text("key_ifsc_code") +
                      " :- ";
                  /*FlutterShare.share(
                      title: AppTranslations.of(context).text("key_account_info"),
                      text: shareText,
                      chooserTitle: AppTranslations.of(context).text("key_share_account_info"));*/
                  Share.share(shareText,
                      subject: AppTranslations.of(context)
                          .text("key_share_account_info"));
                },
                child: Text(
                  AppTranslations.of(context).text("key_share"),
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
        });
  }
}
