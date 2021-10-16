import 'dart:io';

import 'package:softcoremobilebanking/api/user.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../components/custom_progress_handler.dart';
import '../components/flushbar_message.dart';
import '../constants/message_types.dart';
import 'login_page.dart';

class ConfirmAccessPINPage extends StatefulWidget {
  String CustomerID, SMSAutoID, OTP;

  ConfirmAccessPINPage({
    this.CustomerID,
    this.SMSAutoID,
    this.OTP,
  });

  @override
  _ConfirmAccessPINPageState createState() => _ConfirmAccessPINPageState();
}

class _ConfirmAccessPINPageState extends State<ConfirmAccessPINPage> {
  bool _isLoading;
  String _loadingText;
  String smsAutoId;
  TextEditingController accessPinCtrl = TextEditingController();
  TextEditingController confAccessPinCtrl = TextEditingController();
  FocusNode accessPinFocusNode = FocusNode();
  FocusNode confAccessPinFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> _confirmAccessPINScaffoldKey =
      new GlobalKey<ScaffoldState>();
  File photoImgFile;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    Size size = MediaQuery.of(context).size;
    return CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Container(
          color: Colors.grey[100],
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                key: _confirmAccessPINScaffoldKey,
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 240,
                        child:  Image.asset(
                          "assets/images/banner.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppTranslations.of(context).text("key_plz_confm_4digit_qpin"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppTranslations.of(context).text("key_entr_4digit_qpin"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w500, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: PinInputTextFormField(
                                pinLength: 4,
                                decoration: BoxLooseDecoration(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(),
                                  strokeColorBuilder: PinListenColorBuilder(
                                      Theme.of(context).primaryColorDark,
                                      Colors.grey[400]),
                                  bgColorBuilder: true
                                      ? PinListenColorBuilder(
                                          Colors.white.withOpacity(0.5),
                                          Colors.white.withOpacity(0.5))
                                      : null,
                                ),
                                controller: accessPinCtrl,
                                textInputAction: TextInputAction.go,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                focusNode: accessPinFocusNode,
                                onSubmit: (pin) {},
                                onChanged: (pin) {
                                },
                                onSaved: (pin) {
                                },
                                validator: (pin) {},
                                cursor: Cursor(
                                  width: 2,
                                  color: Theme.of(context).primaryColorDark,
                                  radius: Radius.circular(1),
                                  enabled: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppTranslations.of(context).text("key_re_entr_4digit_qpin"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w500, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: PinInputTextFormField(
                                pinLength: 4,
                                decoration: BoxLooseDecoration(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(),
                                  strokeColorBuilder: PinListenColorBuilder(
                                      Theme.of(context).primaryColorDark,
                                      Colors.grey[400]),
                                  bgColorBuilder: true
                                      ? PinListenColorBuilder(
                                          Colors.white.withOpacity(0.5),
                                          Colors.white.withOpacity(0.5))
                                      : null,
                                ),
                                controller: confAccessPinCtrl,
                                textInputAction: TextInputAction.go,
                                enabled: true,
                                keyboardType: TextInputType.number,
                                focusNode: confAccessPinFocusNode,
                                onSubmit: (pin) {},
                                onChanged: (pin) {
                                },
                                onSaved: (pin) {
                                },
                                validator: (pin) {},
                                cursor: Cursor(
                                  width: 2,
                                  color: Theme.of(context).primaryColorDark,
                                  radius: Radius.circular(1),
                                  enabled: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: CustomDarkButton(
                                  caption: AppTranslations.of(context).text("key_confirm"),
                                  onPressed: () {
                                    validation().then((valMsg) {
                                      if (valMsg == '') {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        UserAPI(context: context)
                                            .RegisterAccessPIN(
                                                CustomerID: widget.CustomerID,
                                                AccessPIN:
                                                    accessPinCtrl.text.toString(),
                                                OTP: widget.OTP,
                                                SMSAutoID: widget.SMSAutoID)
                                            .then((res) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          if (res != null &&
                                              HttpStatusCodes.CREATED == res['Status']) {
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
                                      } else {
                                        FlushbarMessage.show(
                                          context,
                                          valMsg,
                                          MessageTypes.WARNING,
                                        );
                                      }
                                    });
                                  }),
                            )
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
    if (accessPinCtrl.text == null || accessPinCtrl.text.toString() == '') {
      return AppTranslations.of(context).text("key_entr_4digit_qpin");
    }
    if (confAccessPinCtrl.text == null || confAccessPinCtrl.text == '') {
      return AppTranslations.of(context).text("key_re_entr_4digit_qpin");
    }

    if (accessPinCtrl.text != confAccessPinCtrl.text) {
      return AppTranslations.of(context).text("key_pin_cpin_must_same");
    }

    return "";
  }
}
