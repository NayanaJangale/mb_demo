import 'dart:convert';

import 'package:softcoremobilebanking/api/depositapi.dart';
import 'package:softcoremobilebanking/api/fixeddepositapi.dart';
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

class OpenFixedDepositACPage extends StatefulWidget {
  @override
  _OpenDepositACState createState() => _OpenDepositACState();
}

class _OpenDepositACState extends State<OpenFixedDepositACPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> OpenFixedDepositScafoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController amountTxtCntl = TextEditingController();
  TextEditingController expDurationTxtCntl = TextEditingController();
  TextEditingController maturityAmtTxtCntl = TextEditingController();
  FocusNode amountFcsNode = FocusNode();
  FocusNode expDurationFcsNode = FocusNode();
  FocusNode maturityAmtFcsNode = FocusNode();
  String _rdDurationValue = 'M';

  Account selectedAc;
  FDType selectedFDType;
  FDMatInstr selectedFDMatInstr;
  List<Account> accountList = [];
  List<FDType> fdTypes = [];
  List<FDMatInstr> fdMatInstrs = [];
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
    loadFDType();
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
            key: OpenFixedDepositScafoldKey,
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
                                            "key_open_fd"),
                                        pdfURL:connectionServerMsg + "/CustCommonAppApi/help/openfd.pdf",
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
                          caption: AppTranslations.of(context).text("key_open_fd"),
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
                                          .text("key_select_accountg"),
                                      accountNo: selectedAc != null
                                          ? selectedAc.AccountNo
                                          : '',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomSpinnerItem(
                                        onPressed: () {
                                          showFDTypes().then((value) {
                                            setState(() {
                                              if (value != null)
                                                selectedFDType = value;
                                            });
                                          });
                                        },
                                        caption: AppTranslations.of(context)
                                            .text("key_fd_type"),
                                        selectedItem: selectedFDType != null
                                            ? selectedFDType.fddesc
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
                                          .text("key_deposite_amount"),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ColorsConst.white,
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              AppTranslations.of(context)
                                                  .text("key_deposit_period"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.grey,
                                                    //fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          Theme(
                                            data: ThemeData.dark().copyWith(
                                              brightness: Brightness.dark,
                                              colorScheme: ColorScheme.dark(
                                                primary:
                                                    Theme.of(context).primaryColor,
                                                onPrimary: Colors.deepPurple,
                                              ),
                                              unselectedWidgetColor:
                                                  Theme.of(context)
                                                      .secondaryHeaderColor,
                                            ),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                new Radio(
                                                  value: "M",
                                                  groupValue: _rdDurationValue,
                                                  activeColor: Theme.of(context)
                                                      .primaryColorDark,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _rdDurationValue = value;
                                                    });
                                                  },
                                                ),
                                                new Text(
                                                  AppTranslations.of(context)
                                                      .text("key_months"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(),
                                                ),
                                                Row(
                                                  children: [
                                                    new Radio(
                                                      value: "D",
                                                      groupValue: _rdDurationValue,
                                                      activeColor: Theme.of(context)
                                                          .primaryColorDark,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _rdDurationValue = value;
                                                        });
                                                      },
                                                    ),
                                                    new Text(
                                                      AppTranslations.of(context)
                                                          .text("key_days"),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      autofoucus: false,
                                      isIcon: false,
                                      textEditingController: expDurationTxtCntl,
                                      focusNode: expDurationFcsNode,
                                      borderRadius: 10,
                                      onFieldSubmitted: (value) {
                                        this.expDurationFcsNode.unfocus();
                                      },
                                      icon: Icons.monetization_on_outlined,
                                      hint: _rdDurationValue == "M"
                                          ? AppTranslations.of(context)
                                              .text("key_entr_period_month")
                                          : AppTranslations.of(context)
                                              .text("key_entr_period_day"),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Column(
                                      children: [
                                        CustomSpinnerItem(
                                            onPressed: () {
                                              showMatInstrs().then((value) {
                                                setState(() {
                                                  if (value != null)
                                                    selectedFDMatInstr = value;
                                                });
                                              });
                                            },
                                            caption: AppTranslations.of(context)
                                                .text("key_maturity_instruction"),
                                            selectedItem: selectedFDMatInstr != null
                                                ? selectedFDMatInstr.Descr
                                                : AppTranslations.of(context)
                                                    .text("key_Slct_instr")),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
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
                                    DepositCode: selectedFDType.fdtpcode,
                                    DepositType: "F",
                                    Duration: expDurationTxtCntl.text,
                                    DurationType: _rdDurationValue)
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
    if (selectedFDType == null) {
      return AppTranslations.of(context).text("key_fd_type_mandatory");
    }
    if (amountTxtCntl.text == null || amountTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_deposit_amount_mandatory");
    }
    if (expDurationTxtCntl.text == null ||
        expDurationTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_deposit_period_mandatory");
    }
    if (selectedFDMatInstr == null) {
      return AppTranslations.of(context).text("key_mat_instr_mandatory");
    }

    if (selectedFDType != null &&
        (selectedFDType.dur_unit != _rdDurationValue)) {
      return AppTranslations.of(context).text("key_deposite_type_must_be") +
          (_rdDurationValue == "M"
              ? AppTranslations.of(context).text("key_months")
              : AppTranslations.of(context).text("key_days"));
    }
    if (int.parse(expDurationTxtCntl.text) < selectedFDType.dur_from ||
        int.parse(expDurationTxtCntl.text) > selectedFDType.dur_upto) {
      if (selectedFDType.dur_from == selectedFDType.dur_upto) {
        return selectedFDType.fddesc +
            AppTranslations.of(context).text("key_can_be_opened_for") +
            selectedFDType.dur_from.toString() +
            " " +
            (selectedFDType.dur_unit == "M"
                ? AppTranslations.of(context).text("key_months")
                : AppTranslations.of(context).text("key_days"));
      } else {
        return selectedFDType.fddesc +
            AppTranslations.of(context).text("key_can_be_opened_bet") +
            selectedFDType.dur_from.toString() +
            " & " +
            selectedFDType.dur_upto.toString() +
            " " +
            (selectedFDType.dur_unit == "M"
                ? AppTranslations.of(context).text("key_months")
                : AppTranslations.of(context).text("key_days"));
      }
    }
    return "";
  }

  void loadFDType(){
    setState(() {
      _isLoading = true;
    });
    FixedDepositAPI(context: context).getFDMaster().then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        var fdTypeData = data["FDMMaster"];
        var fdMatInstrData = data["FDMatInstr"];
        setState(() {
          fdTypes = List<FDType>.from(fdTypeData.map((i) => FDType.fromMap(i)));
          fdMatInstrs = List<FDMatInstr>.from(
              fdMatInstrData.map((i) => FDMatInstr.fromMap(i)));
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

  Future<dynamic> showFDTypes() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_slct_fd_type"),
              ),
              actions: List<Widget>.generate(
                fdTypes.length,
                (i) => CustomCupertinoAction(
                  actionText: fdTypes[i].fddesc,
                  actionIndex: i,
                  onActionPressed: () {
                    Navigator.pop(context, fdTypes[i]);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> showMatInstrs() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return CupertinoActionSheet(
              message: CustomCupertinoActionMessage(
                message: AppTranslations.of(context).text("key_Slct_instr"),
              ),
              actions: List<Widget>.generate(
                fdMatInstrs.length,
                (i) => CustomCupertinoAction(
                  actionText: fdMatInstrs[i].Descr,
                  actionIndex: i,
                  onActionPressed: () {
                    Navigator.pop(context, fdMatInstrs[i]);
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
                AppTranslations.of(context).text("key_confirm_fixed_deposit"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
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
                              fontWeight: FontWeight.w500, fontSize: 14),
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
                              .text("key_fixed_deposit_details"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context).text("key_fd_type"),
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
                              selectedFDType.fddesc,
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
                                  (_rdDurationValue == "M"
                                      ? AppTranslations.of(context)
                                          .text("key_months")
                                      : AppTranslations.of(context)
                                          .text("key_days")),
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
                            Container(
                              width: 70,
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_maturity_instr"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                selectedFDMatInstr.Descr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.black),
                                textAlign: TextAlign.right,
                              ),
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
                      TransactionType: TransactionType.FDAccountOpening,
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
                              transactionType: TransactionType.FDAccountOpening,
                              customerID:
                                  AppData.current.customerLogin.user.CustomerID,
                              smsAutoID: data["SMSAutoID"],
                              mobileNo: data["MobileNo"],
                              branchCode: selectedAc.BranchCode,
                              debitAccountNo: selectedAc.AccountNo,
                              depositAmount: amountTxtCntl.text,
                              fdTypeCode: selectedFDType.fdtpcode,
                              intrCode: selectedFDMatInstr.IntrCode,
                              duration: expDurationTxtCntl.text,
                              durationType: _rdDurationValue,
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
