import 'package:softcoremobilebanking/api/branchapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/branch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
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

class AddBeneficiaryPage extends StatefulWidget {
  @override
  _AddBeneficiaryPageState createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController txtBenefAcCntl = TextEditingController();
  TextEditingController txtConfBenefAcCntl = TextEditingController();
  TextEditingController txtNickNameCntl = TextEditingController();
  FocusNode benefAcFcsNode = FocusNode();
  FocusNode confBenefAcFcsNode = FocusNode();
  FocusNode nickNameFcsNode = FocusNode();
  List<Branch> branchList = [];
  Branch selectedBranch;

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = false;

    loadBranchList();
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
                                    "key_intra_bank_trans"),
                                pdfURL:connectionServerMsg + "/CustCommonAppApi/help/InterBranchTransfer.pdf",
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
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                CustomSpinnerItem(
                                    onPressed: () {
                                      showBranch();
                                    },
                                    caption: AppTranslations.of(context)
                                        .text("key_branch"),
                                    selectedItem: selectedBranch != null
                                        ? selectedBranch.Brname
                                        : AppTranslations.of(context)
                                            .text("key_select_branch")),
                                SizedBox(
                                  height: 10.0,
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.number,
                                  autofoucus: false,
                                  isIcon: false,
                                  textEditingController: txtBenefAcCntl,
                                  focusNode: benefAcFcsNode,
                                  borderRadius: 10,
                                  onFieldSubmitted: (value) {
                                    this.benefAcFcsNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(this.confBenefAcFcsNode);
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
                                  focusNode: confBenefAcFcsNode,
                                  borderRadius: 10,
                                  onFieldSubmitted: (value) {
                                    this.confBenefAcFcsNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(this.nickNameFcsNode);
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
                                  textEditingController: txtNickNameCntl,
                                  focusNode: nickNameFcsNode,
                                  borderRadius: 10,
                                  onFieldSubmitted: (value) {
                                    this.nickNameFcsNode.unfocus();
                                  },
                                  icon: Icons.monetization_on_outlined,
                                  hint: AppTranslations.of(context)
                                      .text("key_nick_name"),
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
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
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
                        ),
                      ],
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
                              TransactionType:
                                  TransactionType.AddIntraBankBeneficiaryRequest,
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
                                      customerID: AppData
                                          .current.customerLogin.user.CustomerID,
                                      branchCode: selectedBranch.Brcode,
                                      accountNo: txtBenefAcCntl.text.toString(),
                                      name: txtNickNameCntl.text.toString(),
                                      transactionType: TransactionType
                                          .AddIntraBankBeneficiaryRequest,
                                      smsAutoID: data["SMSAutoID"],
                                      mobileNo: data["MobileNo"],
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

  Future<void> showBranch() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_branch"),
        ),
        actions: List<Widget>.generate(
          branchList.length,
          (i) => CustomCupertinoAction(
            actionText: branchList[i].Brname,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedBranch = branchList[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void loadBranchList() {
    setState(() {
      _isLoading = true;
    });
    BranchAPI(context: context).getAllBranch().then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var accountsData = res['Data'];
        branchList =
            List<Branch>.from(accountsData.map((i) => Branch.fromMap(i)));
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }

  Future<String> validation() async {
    if (selectedBranch == null) {
      return AppTranslations.of(context).text("key_branch_selec_mand");
    }

    if ((txtBenefAcCntl.text == null || txtBenefAcCntl.text.toString() == '') ||
        (txtConfBenefAcCntl.text == null ||
            txtConfBenefAcCntl.text.toString() == '')) {
      return AppTranslations.of(context).text("key_benef_and_cbenef_mandatory");
    }

    if (txtBenefAcCntl.text.toString() != txtConfBenefAcCntl.text.toString()) {
      return AppTranslations.of(context).text("key_benef_and_cbenef_same");
    }

    if (txtNickNameCntl.text == null || txtNickNameCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_nick_name_mandatory");
    }
    return "";
  }
}
