import 'dart:io';
import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/payment_indicator_const.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/customer_beneficiary_details.dart';
import 'package:softcoremobilebanking/models/inter_bank_transfer.dart';
import 'package:softcoremobilebanking/models/slab_charges.dart';
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
import 'otp_verification_page.dart';

class InterBankTransferPage extends StatefulWidget {
  CustomerBeneficiaryDetails customerBenefDetails;

  InterBankTransferPage({
    this.customerBenefDetails,
  });

  @override
  _InterBankTransferPageState createState() => _InterBankTransferPageState();
}

class _InterBankTransferPageState extends State<InterBankTransferPage> {
  bool _isLoading, isSelected = true;
  String _loadingText;

  String _rdCharges = 'N', _PaymentIndicator, chargesType = "";
  final GlobalKey<ScaffoldState> InterBankScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final GlobalKey expansionTileKey = GlobalKey();

  TextEditingController txtAmtCntl = TextEditingController();
  TextEditingController txtRemarkCntl = TextEditingController();
  FocusNode amountFcsNode = FocusNode();
  FocusNode remarkFcsNode = FocusNode();

  List<Slabcharges> slabchargesList = [];
  List<Account> accountList = [];
  Account selectedAc;
  InterBankTransfer interBankTransfer = new InterBankTransfer();

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

    loadSlabwiseCharges(paymentIndicator: _rdCharges);
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
            key: InterBankScaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: [
                SizedBox(height: 10),
                CustomAppbar(
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  onIconPressed: () {},
                  caption: AppTranslations.of(context).text("key_inter_bank_trans"),
                  icon: Icons.history,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 15),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 25,
                                child: Text(
                                  widget
                                      .customerBenefDetails.BeneficiaryNickName[0],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: ColorsConst.white,
                                          fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(widget.customerBenefDetails.BeneficiaryNickName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                  textAlign: TextAlign.start),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  AppTranslations.of(context)
                                          .text("key_ifsc_code") +
                                      " - " +
                                      widget.customerBenefDetails.IFSCCode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: ColorsConst.grey),
                                  textAlign: TextAlign.start),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  AppTranslations.of(context).text("key_ac_no") +
                                      " - " +
                                      widget.customerBenefDetails
                                          .BeneficiaryAccountNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: ColorsConst.grey),
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppTranslations.of(context).text("key_rs_symbol"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: ColorsConst.grey, fontSize: 40),
                                textAlign: TextAlign.start),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller: txtAmtCntl,
                                  focusNode: amountFcsNode,
                                  autofocus: false,
                                  textAlign: TextAlign.center,
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
                              hintText:
                                  AppTranslations.of(context).text("key_add_note"),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: Colors.grey,
                                      ),
                              labelStyle:
                                  Theme.of(context).textTheme.bodyText1.copyWith(),
                            ),
                            style: Theme.of(context).textTheme.bodyText1.copyWith(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Divider(
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      AppTranslations.of(context)
                                          .text("key_trans_type"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              //   color: Theme.of(context).primaryColorDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _showNEFTCharges(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                          chargesType +
                                              " " +
                                              AppTranslations.of(context)
                                                  .text("key_charges"),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(
                                                  // color: Theme.of(context).primaryColorDark,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Theme(
                                data: ThemeData.dark().copyWith(
                                  brightness: Brightness.dark,
                                  colorScheme: ColorScheme.dark(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.deepPurple,
                                  ),
                                  unselectedWidgetColor:
                                      Theme.of(context).secondaryHeaderColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new Radio(
                                      value: "N",
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _rdCharges,
                                      activeColor:
                                          Theme.of(context).primaryColorDark,
                                      onChanged: (value) {
                                        setState(() {
                                          _rdCharges = value;
                                          chargesType = AppTranslations.of(context)
                                              .text("key_neft");
                                          slabchargesList = [];
                                          loadSlabwiseCharges(
                                              paymentIndicator: _rdCharges);
                                        });
                                      },
                                    ),
                                    new Text(
                                      AppTranslations.of(context).text("key_neft"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                    ),
                                    new Radio(
                                      value: "I",
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _rdCharges,
                                      activeColor:
                                          Theme.of(context).primaryColorDark,
                                      onChanged: (value) {
                                        setState(() {
                                          _rdCharges = value;
                                          chargesType = AppTranslations.of(context)
                                              .text("key_imps");
                                          slabchargesList = [];
                                          loadSlabwiseCharges(
                                              paymentIndicator: _rdCharges);
                                        });
                                      },
                                    ),
                                    new Text(
                                      AppTranslations.of(context).text("key_imps"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                    ),
                                    new Radio(
                                      value: "R",
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _rdCharges,
                                      activeColor:
                                          Theme.of(context).primaryColorDark,
                                      onChanged: (value) {
                                        setState(() {
                                          _rdCharges = value;
                                          chargesType = AppTranslations.of(context)
                                              .text("key_rtgs");
                                          slabchargesList = [];
                                          loadSlabwiseCharges(
                                              paymentIndicator: _rdCharges);
                                        });
                                      },
                                    ),
                                    new Text(
                                      AppTranslations.of(context).text("key_rtgs"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Divider(
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                    AppTranslations.of(context)
                                        .text("key_debit_from"),
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        //   color: Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
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
                                                color:
                                                    Theme.of(context).primaryColor,
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
                                                          .copyWith(fontSize: 14),
                                                      textAlign: TextAlign.start),
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
                              ExpansionTile(
                                key: expansionTileKey,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    _scrollToSelectedContent(
                                        expansionTileKey: expansionTileKey);
                                  }
                                },
                                collapsedBackgroundColor: Theme.of(context)
                                    .secondaryHeaderColor
                                    .withOpacity(0.3),
                                title: new Text(
                                  AppTranslations.of(context).text("key_note"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                ),
                                children: <Widget>[
                                  new Column(
                                    children: [
                                      ListTile(
                                        title: new Text(
                                          AppTranslations.of(context)
                                              .text("key_inter_bank_note1"),
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  // color: Theme.of(context).primaryColorDark,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                        ),
                                        // leading: new Icon(Icons.ac_unit),
                                      ),
                                      ListTile(
                                        title: new Text(
                                          AppTranslations.of(context)
                                              .text("key_inter_bank_note2"),
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  // color: Theme.of(context).primaryColorDark,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                        ),
                                        // leading: new Icon(Icons.ac_unit),
                                      ),
                                      ListTile(
                                        title: new Text(
                                          AppTranslations.of(context)
                                              .text("key_inter_bank_note3"),
                                          textAlign: TextAlign.justify,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  // color: Theme.of(context).primaryColorDark,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                        ),
                                        // leading: new Icon(Icons.ac_unit),
                                      ),
                                      ListTile(
                                        title: Table(
                                          border: TableBorder.all(
                                              color: Colors.grey[600],
                                              style: BorderStyle.solid,
                                              width: 1),
                                          children: [
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_transaction"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context).text(
                                                      "key_mon_to_working_sat"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_rtgs"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_8AM_to_4_pm"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_neft"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_8AM_to_6_pm"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        // leading: new Icon(Icons.ac_unit),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_payment"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
                            setState(() {
                              _isLoading = true;
                            });

                            SMSAPI(context: context)
                                .GeterateOTP(
                              TransactionType: TransactionType.InterBankTransfer,
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
                                if (_rdCharges == "N") {
                                  _PaymentIndicator = PaymentIndicatorConst.NEFT;
                                } else if (_rdCharges == "R") {
                                  _PaymentIndicator = PaymentIndicatorConst.RTGS;
                                } else {
                                  _PaymentIndicator = PaymentIndicatorConst.IMPS;
                                }

                                interBankTransfer.PaymentIndicator =
                                    _PaymentIndicator;
                                interBankTransfer.CustName =
                                    AppData.current.customerLogin.user.DisplayName;
                                interBankTransfer.CustBrCode =
                                    AppData.current.customerLogin.user.BranchCode;
                                interBankTransfer.CustAcNo = selectedAc.AccountNo;
                                interBankTransfer.BenefAcNo = widget
                                    .customerBenefDetails.BeneficiaryAccountNo;
                                interBankTransfer.BenefName =
                                    widget.customerBenefDetails.BeneficiaryNickName;
                                interBankTransfer.IFSCCode =
                                    widget.customerBenefDetails.IFSCCode;
                                interBankTransfer.BenefBankNo =
                                    widget.customerBenefDetails.BeneficiaryBankNo;
                                interBankTransfer.BeneAddr1 =
                                    widget.customerBenefDetails.BeneficiaryCity;
                                interBankTransfer.Amount =
                                    double.parse(txtAmtCntl.text.toString());
                                interBankTransfer.Charge = calculateCharge();
                                interBankTransfer.Narration =
                                    txtRemarkCntl.text.toString();
                                interBankTransfer.benfBankName =
                                    widget.customerBenefDetails.BeneficiaryBankName;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OTPVerificationPage(
                                      transactionType:
                                          TransactionType.InterBankTransfer,
                                      smsAutoID: data["SMSAutoID"],
                                      mobileNo: data["MobileNo"],
                                      paymentIndicator: _PaymentIndicator,
                                      interBankTransfer: interBankTransfer,
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

  void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  void _showNEFTCharges(BuildContext context) {
    int count = 0;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  chargesType +
                      " " +
                      AppTranslations.of(context).text("key_charges"),
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowHeight: 40,
                      dataRowHeight: 40,
                      horizontalMargin: 0,
                      columns: [
                        DataColumn(
                          label: Text(
                            AppTranslations.of(context).text("key_slab"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppTranslations.of(context).text("key_charges"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                      rows: new List<DataRow>.generate(
                        slabchargesList.length,
                        (int index) {
                          count++;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  slabchargesList[index].startamt.toString() +
                                      " - " +
                                      slabchargesList[index].endamt.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  AppTranslations.of(context)
                                          .text("key_rs_symbol") +
                                      slabchargesList[index].commamt.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<String> validation() async {
    if (selectedAc == null) {
      return AppTranslations.of(context).text("key_select_account");
    }

    if (widget.customerBenefDetails == null) {
      return AppTranslations.of(context).text("key_benef_selec_mand");
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
    if (int.parse(txtAmtCntl.text.toString()) < getMinAmount()) {
      if (_rdCharges == 'R') {
        return AppTranslations.of(context).text("key_note_min_amt_for_rtgs");
      } else {
        return AppTranslations.of(context)
                .text("key_trans_amt_must_grater_or_equal") +
            getMinAmount().toString();
      }
    }

    if (txtRemarkCntl == null || txtRemarkCntl.text.toString() == "") {
      return AppTranslations.of(context).text("key_add_note");
    }
    return "";
  }

  double getMinAmount() {
    double minAmount = 0;
    if (_rdCharges == 'R') {
      minAmount = 200000;
    } else {
      minAmount = 1;
    }
    return minAmount;
  }

  double calculateCharge() {
    double charge = 0;
    double transferAmount = double.parse(txtAmtCntl.text.toString());
    if (slabchargesList == null) return charge;
    for (int i = 0; i < slabchargesList.length; i++) {
      if (transferAmount >= slabchargesList[i].startamt &&
          transferAmount <= slabchargesList[i].endamt) {
        if (slabchargesList[i].comm_tp == "P") {
          charge = (transferAmount / 100.0) * slabchargesList[i].commamt;
        } else {
          charge = slabchargesList[i].commamt;
        }
        break;
      }
    }
    return charge;
  }

  void loadSlabwiseCharges({String paymentIndicator}) {
    setState(() {
      _isLoading = true;
    });
    CustomerAPI(context: context)
        .getSlabwiseCharges(PaymentIndicator: paymentIndicator)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var accountsData = res['Data'];
        setState(() {
          slabchargesList = List<Slabcharges>.from(
              accountsData.map((i) => Slabcharges.fromMap(i)));
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
}
