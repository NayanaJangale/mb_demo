import 'dart:io';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/pages/self_account_trasfer_page.dart';

import '../app_data.dart';
import 'menu_help_page.dart';
import 'otp_verification_page.dart';

class AddInterBankBeneficiaryPage extends StatefulWidget {
  String ifscCode, bankName, city, entNo;

  AddInterBankBeneficiaryPage({
    this.ifscCode,
    this.bankName,
    this.city,
    this.entNo,
  });

  @override
  _AddInterBankBeneficiaryPageState createState() =>
      _AddInterBankBeneficiaryPageState();
}

class _AddInterBankBeneficiaryPageState
    extends State<AddInterBankBeneficiaryPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> scaffoldStateKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController txtBenefiAcCntl = TextEditingController();
  TextEditingController txtConfBenefAcCntl = TextEditingController();
  TextEditingController txtBenefiNameCntl = TextEditingController();
  TextEditingController txtIfscCodeCntl = TextEditingController();
  TextEditingController txtBankNameCntl = TextEditingController();
  TextEditingController txtCityCntl = TextEditingController();
  TextEditingController txtMobileNoCntl = TextEditingController();
  FocusNode fcnBeneficiaryAc = FocusNode();
  FocusNode fcnConfBenefAc = FocusNode();
  FocusNode fcnBenefiName = FocusNode();
  FocusNode fcnIfscCode = FocusNode();
  FocusNode fcnBankName = FocusNode();
  FocusNode fcnCity = FocusNode();
  FocusNode fcnMobileNo = FocusNode();

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    setState(() {
      txtIfscCodeCntl.text = widget.ifscCode ?? '';
      txtBankNameCntl.text = widget.bankName ?? '';
      txtCityCntl.text = widget.city ?? '';
    });
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
            key: scaffoldStateKey,
            body: Column(
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
                  caption: AppTranslations.of(context).text("key_add_beneficiary"),
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
                                    "key_inter_bank_trans"),
                                pdfURL:connectionServerMsg + "/CustCommonAppApi/help/InterBankTransfer.pdf",
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
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtBenefiAcCntl,
                                focusNode: fcnBeneficiaryAc,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnBeneficiaryAc.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(this.fcnConfBenefAc);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_entr_benef_ac_no"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtConfBenefAcCntl,
                                focusNode: fcnConfBenefAc,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnConfBenefAc.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(this.fcnBenefiName);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_conf_benef_ac_no"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtBenefiNameCntl,
                                focusNode: fcnBenefiName,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnBenefiName.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(this.fcnIfscCode);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_benef_name"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                enable: false,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtIfscCodeCntl,
                                focusNode: fcnIfscCode,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnIfscCode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(this.fcnBankName);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_ifsc_code"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                autofoucus: false,
                                isIcon: false,
                                enable: false,
                                textEditingController: txtBankNameCntl,
                                focusNode: fcnBankName,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnBankName.unfocus();
                                  FocusScope.of(context).requestFocus(this.fcnCity);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_bank_name"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtCityCntl,
                                focusNode: fcnCity,
                                borderRadius: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnCity.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(this.fcnMobileNo);
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context).text("key_city"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                autofoucus: false,
                                isIcon: false,
                                textEditingController: txtMobileNoCntl,
                                focusNode: fcnMobileNo,
                                borderRadius: 10,
                                maxLength: 10,
                                onFieldSubmitted: (value) {
                                  this.fcnMobileNo.unfocus();
                                },
                                icon: Icons.monetization_on_outlined,
                                hint: AppTranslations.of(context)
                                    .text("key_mobile_no"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                AppTranslations.of(context).text("key_note"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w500, fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppTranslations.of(context)
                                      .text("key_add_benef_notes"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ), //savta urbn
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
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
                              TransactionType:
                                  TransactionType.AddInterBankBeneficiaryRequest,
                              RegenerateSMS: "false",
                              OldSMSAutoID: "-1",
                              AccountNumber: "xxxx",
                              Amount: "-1",
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
                                      transactionType: TransactionType
                                          .AddInterBankBeneficiaryRequest,
                                      name: txtBenefiNameCntl.text.toString(),
                                      ifscCode: txtIfscCodeCntl.text.toString(),
                                      entNo: widget.entNo,
                                      bankName: widget.bankName,
                                      accountNo: txtBenefiAcCntl.text.toString(),
                                      city: widget.city,
                                      mobileNo: txtMobileNoCntl.text.toString(),
                                      customerID: AppData
                                          .current.customerLogin.user.CustomerID,
                                      smsAutoID: data["SMSAutoID"],
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
    if ((txtBenefiAcCntl.text == null ||
            txtBenefiAcCntl.text.toString() == '') ||
        (txtConfBenefAcCntl.text == null ||
            txtConfBenefAcCntl.text.toString() == '')) {
      return AppTranslations.of(context).text("key_benef_and_cbenef_mandatory");
    }

    if (txtBenefiAcCntl.text.toString() != txtConfBenefAcCntl.text.toString()) {
      return AppTranslations.of(context).text("key_benef_and_cbenef_same");
    }

    if (txtBenefiNameCntl.text == null ||
        txtBenefiNameCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_benef_name_mandatory");
    }

    if (txtIfscCodeCntl.text == null || txtIfscCodeCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_ifsc_code_mand");
    }
    if (txtBankNameCntl.text == null || txtBankNameCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_bank_name_mand");
    }
    if (txtCityCntl.text == null || txtCityCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_city_mand");
    }

    if (txtMobileNoCntl.text == null || txtMobileNoCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_mobile_no_mand");
    }
    return "";
  }
}
