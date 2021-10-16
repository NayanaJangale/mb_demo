import 'dart:io';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import '../app_data.dart';
import 'menu_help_page.dart';
import 'otp_verification_page.dart';

class SelfAccountTransferPage extends StatefulWidget {
  Account creditAccount;

  SelfAccountTransferPage({
    this.creditAccount,
  });

  @override
  _SelfAccountTransferPageState createState() =>
      _SelfAccountTransferPageState();
}

class _SelfAccountTransferPageState extends State<SelfAccountTransferPage> {
  bool _isLoading, isSelected = true;
  String _loadingText;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController txtAmtCntl = TextEditingController();
  TextEditingController txtRemarkCntl = TextEditingController();
  FocusNode amountFcsNode = FocusNode();
  FocusNode remarkFcsNode = FocusNode();

  List<Account> accountList = [];
  Account selectedAc;

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = false;

    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      accountList = AppData.current.customerLogin.oAccounts
          .where((i) => i.AccountType == AccountTypeConst.TransactionalAccounts)
          .toList();

      if (accountList != null && accountList.length > 0) {
        selectedAc = accountList[0];
        for (int i = 0; i < accountList.length; i++) {
          accountList[i].isSelected = false;
        }
        accountList[0].isSelected = true;
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
            key: scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: [
                CustomAppbar(
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  caption: AppTranslations.of(context).text("key_self_ac_transfer"),
                  icon: Icons.help_outline_outlined,
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
                                    "key_self_ac_transfer"),
                                pdfURL:connectionServerMsg + "/CustCommonAppApi/help/selfactransfer.pdf",
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 25,
                            child: Text(
                              widget.creditAccount.AccountName[0] ?? '',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConst.white,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.creditAccount.AccountName ?? '',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.creditAccount.AccountNo,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: ColorsConst.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                AppTranslations.of(context).text("key_rs_symbol"),
                                style:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Colors.grey,
                                          fontSize: 40,
                                        ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 48),
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      controller: txtAmtCntl,
                                      focusNode: amountFcsNode,
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Colors.grey,
                                              fontSize: 40,
                                            ),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize: 40,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10) ?? 10,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 60.0),
                            child: TextField(
                              controller: txtRemarkCntl,
                              focusNode: remarkFcsNode,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppTranslations.of(context).text("key_add_note"),
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Colors.grey,
                                        ),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(),
                              ),
                              style:
                                  Theme.of(context).textTheme.bodyText1.copyWith(),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.3), //Colors.grey[200],
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(AppTranslations.of(context).text("key_debit_from"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context).primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ListView.builder(
                            itemCount: accountList.length,
                            padding: const EdgeInsets.only(top: 0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < accountList.length; i++) {
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.account_balance_outlined,
                                            color: Theme.of(context).primaryColor,
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
                                                  accountList[index].AccountName ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 14),
                                                  textAlign: TextAlign.start),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  accountList[index].AccountNo ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          // color: ColorsConst.grey
                                                          ),
                                                  textAlign: TextAlign.start),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            accountList[index].isSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: this.isSelected
                                                ? Theme.of(context).accentColor
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
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_continue"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
                            setState(() {
                              _isLoading = true;
                            });

                            SMSAPI(context: context)
                                .GeterateOTP(
                              TransactionType: TransactionType.SelfAccountTransfer,
                              RegenerateSMS: "false",
                              OldSMSAutoID: "-1",
                              AccountNumber: selectedAc != null
                                  ? selectedAc.AccountNo
                                  : "XXXX",
                              Amount: txtAmtCntl.text.toString(),
                              CustomerID:
                                  AppData.current.customerLogin.user.CustomerID,
                              brcode: AppData.current.customerLogin.user.BranchCode,
                              PaymentIndicator: "",
                            )
                                .then((res) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (res != null &&
                                  HttpStatusCodes.CREATED == res['Status']) {

                                var data = res["Data"];
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OTPVerificationPage(
                                      transactionType:
                                          TransactionType.SelfAccountTransfer,
                                      smsAutoID: data["SMSAutoID"],
                                      mobileNo: data["MobileNo"],
                                      debitAccountNo: selectedAc.AccountNo,
                                      creditAccountNo: widget.creditAccount.AccountNo,
                                      depositAmount: txtAmtCntl.text.toString(),
                                      creditBranchCode: widget.creditAccount.BranchCode,
                                      debitBranchCode: selectedAc.BranchCode,
                                      remark: txtRemarkCntl!=null?txtRemarkCntl.text.toString():'',
                                    ),
                                  ),
                                );
                              } else {
                                FlushbarMessage.show(
                                  context,
                                  res["Message"],
                                  MessageTypes.WARNING,
                                );
                              }
                            });
                          } else {
                            FlushbarMessage.show(
                              context,
                              valMsg,
                              MessageTypes.WARNING,
                            );
                          }
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> validation() async {
    if (selectedAc == null) {
      return AppTranslations.of(context).text("key_select_account");
    }
    if (widget.creditAccount == selectedAc) {
      return AppTranslations.of(context).text("key_dr_cr_amt_cant_not_same");
    }
    if (txtAmtCntl == null || txtAmtCntl.text.toString() == "") {
      return AppTranslations.of(context).text("key_transfer_amt_mand");
    }
    if (txtAmtCntl != null && int.parse(txtAmtCntl.text.toString()) <= 0) {
      return AppTranslations.of(context)
          .text("key_transfer_amt_must_greater_than0");
    }

    if (txtAmtCntl != null &&
        int.parse(txtAmtCntl.text.toString()) > selectedAc.Balance) {
      return AppTranslations.of(context)
          .text("key_transfer_amt_greater_balance");
    }
    return "";
  }
}
