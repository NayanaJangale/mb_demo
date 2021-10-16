import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/SharedPreferencesConst.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/sign_up_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../components/custom_password_field.dart';
import '../components/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  double bottom1;
  bool _isLoading;
  String _loadingText;
  String smsAutoId;

  TextEditingController custIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController pinEditingController = TextEditingController();
  FocusNode _custIDFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _bankCodeFocusNode = FocusNode();
  FocusNode _pinEditingFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _loginPageGlobalKey =
  new GlobalKey<ScaffoldState>();
  bool isLoginByCustID = false;

  String loginType = '';
  CustomerLogin customerLogin = new CustomerLogin();

  Uint8List bytesBannerImg;
  String banner64Str = '';

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    NetworkHandler.getId().then((res) {
      setState(() {
        AppData.current.MacAddress = res.toString();
      });
    });

    banner64Str =
        AppData.current.preferences.get(SharedPreferencesConst.ClientBanner);
    if (banner64Str != null && banner64Str != '')
      bytesBannerImg = Base64Decoder().convert(banner64Str);
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          key: _loginPageGlobalKey,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: bytesBannerImg == null
                      ?  Image.asset(
                    "assets/images/banner.png",
                    fit: BoxFit.fitWidth,
                  )
                      : Image.memory(bytesBannerImg, fit: BoxFit.fill),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                top: MediaQuery.of(context).size.height * 0.25,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.bounceInOut,
                  height: isLoginByCustID ? 330 : 320,
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: ColorsConst.notWhite,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5),
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginByCustID = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                      AppTranslations.of(context)
                                          .text("key_pin"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                          color: !isLoginByCustID
                                              ? Theme.of(context)
                                              .primaryColorDark
                                              : Theme.of(context)
                                              .primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  if (!isLoginByCustID)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginByCustID = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    AppTranslations.of(context)
                                        .text("key_customer_id"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                        color: isLoginByCustID
                                            ? Theme.of(context)
                                            .primaryColorDark
                                            : Theme.of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  if (isLoginByCustID)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        if (isLoginByCustID) buildCustIDSection(),
                        if (!isLoginByCustID) buildQuickAccessPINSection()
                      ],
                    ),
                  ),
                ),
              ),
              buildBottomHalfContainer(false),
            ],
          )),
    );
  }

  Container buildQuickAccessPINSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppTranslations.of(context).text("key_enter_ur_q_access_pin"),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          PinInputTextFormField(
            pinLength: 4,
            decoration: BoxLooseDecoration(
              textStyle: Theme.of(context).textTheme.bodyText2.copyWith(),
              strokeColorBuilder: PinListenColorBuilder(
                  Theme.of(context).primaryColorDark, Colors.grey[400]),
              bgColorBuilder: true
                  ? PinListenColorBuilder(Colors.white, Colors.white)
                  : null,
            ),
            controller: pinEditingController,
            textInputAction: TextInputAction.go,
            enabled: true,
            keyboardType: TextInputType.number,
            focusNode: _pinEditingFocusNode,
            onSubmit: (pin) {},
            onChanged: (pin) {
              debugPrint('onChanged execute. pin:$pin');
            },
            onSaved: (pin) {
              debugPrint('onSaved pin:$pin');
            },
            validator: (pin) {},
            cursor: Cursor(
              width: 2,
              color: Theme.of(context).primaryColorDark,
              radius: Radius.circular(1),
              enabled: true,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          CustomTextField(
            keyboardType: TextInputType.number,
            autofoucus: false,
            textEditingController: bankCodeController,
            focusNode: _bankCodeFocusNode,
            borderRadius: 14,
            onFieldSubmitted: (value) {
              this._bankCodeFocusNode.unfocus();
            },
            isIcon: true,
            icon: Icons.account_balance_outlined,
            hint: AppTranslations.of(context).text("key_bank_reg_code"),
          ),
          SizedBox(
            height: 20,
          ),
          QuickAccessPINTextRow(),
        ],
      ),
    );
  }

  Container buildCustIDSection() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            keyboardType: TextInputType.number,
            autofoucus: false,
            textEditingController: custIDController,
            focusNode: _custIDFocusNode,
            borderRadius: 14,
            maxLength: 10,
            onFieldSubmitted: (value) {
              this._custIDFocusNode.unfocus();
              FocusScope.of(context).requestFocus(this._passwordFocusNode);
            },
            isIcon: true,
            icon: Icons.person_outline_outlined,
            hint: AppTranslations.of(context).text("key_customer_id"),
          ),
          CustomPasswordField(
            keyboardType: TextInputType.text,
            textEditingController: passwordController,
            obscureText: true,
            borderRadius: 14,
            icon: Icons.lock_outline_sharp,
            hint: AppTranslations.of(context).text("key_password"),
            focusNode: _passwordFocusNode,
            onFieldSubmitted: (value) {
              this._passwordFocusNode.unfocus();
              FocusScope.of(context).requestFocus(this._bankCodeFocusNode);
            },
          ),
          CustomTextField(
            keyboardType: TextInputType.number,
            autofoucus: false,
            textEditingController: bankCodeController,
            focusNode: _bankCodeFocusNode,
            borderRadius: 14,
            onFieldSubmitted: (value) {
              this._bankCodeFocusNode.unfocus();
            },
            isIcon: true,
            icon: Icons.account_balance_outlined,
            hint: AppTranslations.of(context).text("key_bank_reg_code"),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                    text:
                    AppTranslations.of(context).text("key_forgot_password"),
                    style: Theme.of(context).textTheme.overline.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignUpPage(
                              transactionType: TransactionType.ForgotPassword,
                            ),
                          ),
                        );
                      }),
              )),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: 330,
      right: 0,
      left: 0,
      child: InkWell(
        onTap: () {
          validation().then((valMsg) {
            if (valMsg == '') {
              setState(() {
                _isLoading = true;
              });
              AppData.current.ClientCode = bankCodeController.text ?? '';

              CustomerAPI(context: context)
                  .fetchUserData(
                  CustomerID: custIDController.text ?? '',
                  LoginPassword: passwordController.text ?? '',
                  AccessPIN: pinEditingController.text ?? '',
                  LoginType: loginType)
                  .then((res) {
                setState(() {
                  _isLoading = false;
                });
                if (res != null && HttpStatusCodes.CREATED == res['Status']) {
                  AppData.current.clearMenu;
                  customerLogin = CustomerLogin.fromMap(res['Data']);
                  AppData.current.customerLogin = customerLogin;
                  AppData.current.ConnectionString =
                      customerLogin.ConnectionString;
                  AppData.current.preferences.setString(
                      SharedPreferencesConst.ClientName,
                      customerLogin.ClientName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationHomeScreen(),
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
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 90,
            width: 90,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: ColorsConst.notWhite,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (showShadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1.5,
                      blurRadius: 10,
                    )
                ]),
            child: !showShadow
                ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).buttonColor,
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            )
                : Center(),
          ),
        ),
      ),
    );
  }

  Future<String> validation() async {
    if (!isLoginByCustID) {
      if (pinEditingController.text.length == 0) {
        return AppTranslations.of(context).text("key_quick_pin_mandatory");
      }
      loginType = "AccessPIN";
    } else {
      loginType = "UserID";
      if (custIDController.text.length == 0) {
        return AppTranslations.of(context).text("key_plz_entr10_digit_custid");
      }
      if (passwordController.text.length == 0) {
        return AppTranslations.of(context).text("key_password_mandatory");
      }
    }

    if (bankCodeController.text.length == 0) {
      return AppTranslations.of(context).text("key_bank_reg_mand");
    }
    return '';
  }

  Future<CustomerLogin> fetchUserData(String loginType) async {
    CustomerLogin customerLogin;
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> params = {
        "UserID": custIDController.text ?? '',
        "LoginPassword": passwordController.text ?? '',
        "AccessPIN": pinEditingController.text ?? '',
        "LoginType": loginType,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET,
          CustomerLoginUrls.GET_CustomerLogin,
          params,
          '');

      if (apiResponse.Status != HttpStatusCodes.OK) {
        FlushbarMessage.show(
          context,
          apiResponse.Message,
          MessageTypes.WARNING,
        );
      } else {
        var data = json.decode(apiResponse.Data);
        if (HttpStatusCodes.CREATED == data['Status']) {
        } else {
          FlushbarMessage.show(
            context,
            data["Message"],
            MessageTypes.WARNING,
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      FlushbarMessage.show(
        context,
        e.toString(),
        MessageTypes.WARNING,
      );
    }

    return customerLogin;
  }

  Widget QuickAccessPINTextRow() {
    return Center(
      child: RichText(
        text: TextSpan(
            text: AppTranslations.of(context).text("key_dont_login_pin"),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                  " " + AppTranslations.of(context).text("key_click_here"),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignUpPage(
                            transactionType:
                            TransactionType.AccessPINRegistration,
                          ),
                        ),
                      );
                    })
            ]),
      ),
    );
  }
}
