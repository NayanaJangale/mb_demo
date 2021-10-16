import 'dart:io';

import 'package:softcoremobilebanking/api/user.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/custom_password_field.dart';
import '../components/custom_progress_handler.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  String transactionType, customerID, smsAutoID, otp;

  ChangePasswordPage({
    this.transactionType,
    this.customerID,
    this.smsAutoID,
    this.otp,
  });

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isLoading;
  String _loadingText;
  String smsAutoId;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode _oldPasswordFocusNode = FocusNode();
  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> _changePassScaffoldKey =
      new GlobalKey<ScaffoldState>();
  File photoImgFile;

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = false;
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
                backgroundColor: Theme.of(context).backgroundColor,
                key: _changePassScaffoldKey,
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomAppbar(
                        backButtonVisibility: true,
                        onBackPressed: () {
                          Navigator.pop(context);
                        },
                        caption:
                            AppTranslations.of(context).text("key_change_pswd"),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            AppTranslations.of(context)
                                .text("key_password_must_be_minimum_and_maximum"),
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 12),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: widget.transactionType !=
                                        TransactionType.ForgotPassword,
                                    child: Column(
                                      children: [
                                        CustomPasswordField(
                                          keyboardType: TextInputType.text,
                                          textEditingController:
                                              oldPasswordController,
                                          obscureText: true,
                                          borderRadius: 10,
                                          icon: Icons.lock_outline_sharp,
                                          hint: AppTranslations.of(context)
                                              .text("key_old_pswd"),
                                          focusNode: _oldPasswordFocusNode,
                                          onFieldSubmitted: (value) {
                                            this._oldPasswordFocusNode.unfocus();
                                            FocusScope.of(context).requestFocus(
                                                this._newPasswordFocusNode);
                                          },
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomPasswordField(
                                    keyboardType: TextInputType.text,
                                    textEditingController: newPasswordController,
                                    obscureText: true,
                                    borderRadius: 10,
                                    icon: Icons.lock_outline_sharp,
                                    hint: AppTranslations.of(context)
                                        .text("key_new_pswd"),
                                    focusNode: _newPasswordFocusNode,
                                    onFieldSubmitted: (value) {
                                      this._newPasswordFocusNode.unfocus();
                                      FocusScope.of(context).requestFocus(
                                          this._confirmPasswordFocusNode);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  CustomPasswordField(
                                    keyboardType: TextInputType.text,
                                    textEditingController:
                                        confirmPasswordController,
                                    obscureText: true,
                                    borderRadius: 10,
                                    icon: Icons.lock_outline_sharp,
                                    hint: AppTranslations.of(context)
                                        .text("key_cnfrm_pswd"),
                                    focusNode: _confirmPasswordFocusNode,
                                    onFieldSubmitted: (value) {
                                      this._confirmPasswordFocusNode.unfocus();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: CustomDarkButton(
                                      caption: AppTranslations.of(context)
                                          .text("key_confirm"),
                                      onPressed: () {
                                        validation().then((valMsg) {
                                          if (valMsg == '') {
                                            if (widget.transactionType ==
                                                TransactionType.ForgotPassword) {
                                              callForgotCustPswd();
                                            } else {
                                              callChangeCustPswd();
                                            }
                                          } else {
                                            FlushbarMessage.show(
                                              context,
                                              valMsg,
                                              MessageTypes.WARNING,
                                            );
                                          }
                                        });
                                      }),
                                )),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: CustomDarkButton(
                                      caption: AppTranslations.of(context)
                                          .text("key_cancel"),
                                      onPressed: () {}),
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  Future<String> validation() async {
    if (widget.transactionType != null &&
        widget.transactionType != TransactionType.ForgotPassword) {
      if (oldPasswordController.text.length == 0) {
        return AppTranslations.of(context).text("key_old_pswd_mandatory");
      }
    }

    if (newPasswordController.text.length == 0) {
      return AppTranslations.of(context).text("key_new_pswd_mandatory");
    }
    if (confirmPasswordController.text.length == 0) {
      return AppTranslations.of(context).text("key_conf_new_pswd_mandatory");
    }

    if (oldPasswordController.text == newPasswordController.text) {
      return AppTranslations.of(context)
          .text("key_conf_old_new_pswd_cannot_same");
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      return AppTranslations.of(context).text("key_new_conf_pswd_must_same");
    }
    return '';
  }

  void callForgotCustPswd() {
    setState(() {
      _isLoading = true;
    });
    UserAPI(context: context)
        .ForgotCustomerPassword(
            SMSAutoID: widget.smsAutoID,
            OTP: widget.otp,
            CustomerID: widget.customerID,
            NewPassword: newPasswordController.text.toString())
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false,
        );
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }

  void callChangeCustPswd() {
    setState(() {
      _isLoading = true;
    });
    UserAPI(context: context)
        .changeCustomerPassword(
            NewPassword: newPasswordController.text.toString(),
            OldPassword: oldPasswordController.text.toString(),
            UserNo: AppData.current.customerLogin.user.UserNo.toString())
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false,
        );
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
