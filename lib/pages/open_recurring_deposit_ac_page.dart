import 'dart:convert';

import 'package:softcoremobilebanking/api/depositapi.dart';
import 'package:softcoremobilebanking/api/fixeddepositapi.dart';
import 'package:softcoremobilebanking/api/recurringdepositapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_bank_view.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/fd_mat_instr.dart';
import 'package:softcoremobilebanking/models/fd_type.dart';
import 'package:softcoremobilebanking/models/rd_type.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_bank_sppiner.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_spinner_item.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';

import '../app_data.dart';
import 'menu_help_page.dart';
import 'otp_verification_page.dart';

class OpenRecurringDepositACPage extends StatefulWidget {
  @override
  _OpenRecurringDepositACState createState() => _OpenRecurringDepositACState();
}

class _OpenRecurringDepositACState extends State<OpenRecurringDepositACPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> scafoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController amountTxtCntl = TextEditingController();
  TextEditingController expDurationTxtCntl = TextEditingController();
  FocusNode amountFcsNode = FocusNode();
  FocusNode expDurationFcsNode = FocusNode();

  Account selectedAc;
  RDType selectedRDType;
  List<Account> accountList = [];
  List<RDType> rdTypes = [];
  double interestRate, interestAmount, maturityAmount;
  String maturityDate;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      accountList = AppData.current.customerLogin.oAccounts
          .where((i) => i.AccountType == AccountTypeConst.TransactionalAccounts)
          .toList();
      if (accountList.length > 0) selectedAc = accountList[0];
    }
    loadRDType();

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
            key: scafoldKey,
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CustomAppbar(
                          backButtonVisibility: true,
                          onBackPressed: () {
                            Navigator.pop(context);
                          },
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
                                            "key_open_rd"),
                                        pdfURL:connectionServerMsg + "/CustCommonAppApi/help/openrd.pdf",
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
                          caption: AppTranslations.of(context).text("key_open_rd"),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 15.0,
                            right: 15.0,
                            bottom: 10.0,
                          ),
                          child: accountList != null && accountList.length > 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    CustomBankView(
                                      onTap: () {
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
                                      accountNo: selectedAc != null
                                          ? selectedAc.AccountNo
                                          : '',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomSpinnerItem(
                                        onPressed: () {
                                          showRDTypes().then((value) {
                                            setState(() {
                                              if (value != null) {
                                                selectedRDType = value;
                                                expDurationTxtCntl.text =
                                                    selectedRDType.rdduration;
                                              }
                                            });
                                          });
                                        },
                                        caption: AppTranslations.of(context)
                                            .text("key_rd_type"),
                                        selectedItem: selectedRDType != null
                                            ? selectedRDType.rdtpname
                                            : AppTranslations.of(context)
                                                .text("key_select_type")),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      autofoucus: false,
                                      isIcon: false,
                                      textEditingController: amountTxtCntl,
                                      focusNode: amountFcsNode,
                                      borderRadius: 10,
                                      onFieldSubmitted: (value) {
                                        this.amountFcsNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(this.expDurationFcsNode);
                                      },
                                      icon: Icons.monetization_on_outlined,
                                      hint: AppTranslations.of(context)
                                          .text("key_installment_amount"),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      autofoucus: false,
                                      isIcon: false,
                                      enable: false,
                                      textEditingController: expDurationTxtCntl,
                                      focusNode: expDurationFcsNode,
                                      borderRadius: 10,
                                      onFieldSubmitted: (value) {
                                        this.expDurationFcsNode.unfocus();
                                      },
                                      icon: Icons.monetization_on_outlined,
                                      hint: AppTranslations.of(context)
                                          .text("key_entr_deposit_prd_month"),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                          AppTranslations.of(context)
                                              .text("key_note"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0, top: 5),
                                        child: Text(
                                          AppTranslations.of(context)
                                              .text("key_note_intrest_principal"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                          textAlign: TextAlign.justify,
                                        ),
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 15),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_submit"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
                            setState(() {
                              _isLoading = true;
                            });
                            DepositAPI(context: context)
                                .getMaturityDetails(
                                    Amount: amountTxtCntl.text,
                                    CustomerID: AppData
                                        .current.customerLogin.user.CustomerID,
                                    DepositCode: selectedRDType.rdtpcode,
                                    DepositType: "R",
                                    Duration: expDurationTxtCntl.text,
                                    DurationType: "M")
                                .then((res) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (res != null &&
                                  HttpStatusCodes.OK == res['Status']) {
                                var data = res["Data"];

                                interestRate = data["InterestRate"];
                                interestAmount = data["InterestAmount"];
                                maturityAmount = data["MaturityAmount"];
                                maturityDate = data["MaturityDate"];

                                showConfirmAlert(context);
                              } else {
                                FlushbarMessage.show(
                                  context,
                                  res["Message"],
                                  MessageTypes.ERROR,
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
    if (selectedRDType == null) {
      return AppTranslations.of(context).text("key_fd_type_mandatory");
    }
    if (amountTxtCntl.text == null || amountTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_deposit_amount_mandatory");
    }
    if (expDurationTxtCntl.text == null ||
        expDurationTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_deposit_period_mandatory");
    }

    return "";
  }

  void loadRDType(){
    setState(() {
      _isLoading = true;
    });
    RecurringDepositAPI(context: context).getRDType().then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          rdTypes = List<RDType>.from(data.map((i) => RDType.fromMap(i)));
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
                accountList.length,
                (index) => CustomBankSpinner(
                  accountNo: accountList[index].AccountNo ?? '',
                  accountName: accountList[index].AccountName ?? '',
                  onPressed: () {
                    Navigator.pop(context, accountList[index]);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> showRDTypes() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_slct_rd_type"),
              ),
              actions: List<Widget>.generate(
                rdTypes.length,
                (i) => CustomCupertinoAction(
                  actionText: rdTypes[i].rdtpname,
                  actionIndex: i,
                  onActionPressed: () {
                    Navigator.pop(context, rdTypes[i]);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showConfirmAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: new Text(
                AppTranslations.of(context).text("key_conf_recr_deposit"),
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
                    padding: const EdgeInsets.only(top: 10.0, left: 10),
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
                              .text("key_debit_ac_details"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context).text("key_ac_type"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              selectedAc.AccountName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context).text("key_ac_no"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              selectedAc.AccountNo ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppTranslations.of(context)
                              .text("key_recr_deposit_dtl"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context).text("key_rd_type"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              selectedRDType.rdtpname,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_deposite_amount"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              amountTxtCntl.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_duration"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              expDurationTxtCntl.text +
                                  " " +
                                  (AppTranslations.of(context)
                                      .text("key_months")),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_maturity_amt"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              maturityAmount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_interest_rate"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              interestRate.toString() + " %",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_intr_amt"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              interestAmount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_maturity"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              DateFormat('dd-MMM-yyyy')
                                  .format(DateTime.parse(maturityDate)),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    SMSAPI(context: context)
                        .GeterateOTP(
                      TransactionType: TransactionType.RDAccountOpening,
                      RegenerateSMS: "false",
                      OldSMSAutoID: "-1",
                      AccountNumber: "xxxx",
                      Amount: "-1",
                      CustomerID: AppData.current.customerLogin.user.CustomerID,
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
                              transactionType: TransactionType.RDAccountOpening,
                              customerID:
                                  AppData.current.customerLogin.user.CustomerID,
                              smsAutoID: data["SMSAutoID"],
                              mobileNo: data["MobileNo"],
                              branchCode: selectedAc.BranchCode,
                              debitAccountNo: selectedAc.AccountNo,
                              depositAmount: amountTxtCntl.text,
                              rdTypeCode: selectedRDType.rdtpcode,
                              duration: expDurationTxtCntl.text,
                              durationType: "M",
                              interestRate: interestRate.toString(),
                              interestAmount: interestAmount.toString(),
                              maturityAmount: maturityAmount.toString(),
                              maturityDate: DateFormat('dd-MMM-yyyy')
                                  .format(DateTime.parse(maturityDate))
                                  .toString(),
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
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_confirm"),
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
}
