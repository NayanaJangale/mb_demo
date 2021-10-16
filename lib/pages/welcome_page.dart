import 'dart:convert';
import 'dart:typed_data';

import 'package:softcoremobilebanking/pages/tips_and_faq_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_lable_button.dart';
import 'package:softcoremobilebanking/components/responsive_ui.dart';
import 'package:softcoremobilebanking/pages/emi_calculator_page.dart';
import 'package:softcoremobilebanking/pages/login_page.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:local_auth/local_auth.dart';
import '../../components/custom_dark_button.dart';
import '../../components/custom_progress_handler.dart';
import '../../localization/app_translations.dart';
import '../api/customerapi.dart';
import '../components/flushbar_message.dart';
import '../constants/SharedPreferencesConst.dart';

import '../constants/http_status_codes.dart';
import '../constants/message_types.dart';
import '../models/customer_login.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoading, _large, _medium, hasFingerprint = false, isAvailable = false;
  String _loadingText;
  double _width, _pixelRatio;
  Size size;

  final GlobalKey<ScaffoldState> _welcomePageGlobalKey =
      new GlobalKey<ScaffoldState>();

  Uint8List bytesLogoImg;
  String logo64Str = '', clientName;

  CustomerLogin customerLogin = new CustomerLogin();

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    checkAvaliablity();

    logo64Str =
        AppData.current.preferences.get(SharedPreferencesConst.ClientLogo);
    clientName =
        AppData.current.preferences.get(SharedPreferencesConst.ClientName);

    if (logo64Str != null && logo64Str != '')
      bytesLogoImg = Base64Decoder().convert(logo64Str);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio);
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          key: _welcomePageGlobalKey,
          body: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    width: scrWidth,
                    height: scrHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: ColorsConst.white,
                          radius: 60,
                          child: bytesLogoImg == null
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                )
                              : Image.memory(
                                  bytesLogoImg,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 30),
                            child: Text(
                              clientName ??
                                  AppTranslations.of(context)
                                      .text("key_clientname")
                                      .toUpperCase(),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: _large ? 16 : (_medium ? 15 : 14)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5),
                            child: Text(
                              AppTranslations.of(context).text("key_banking_anytime_anywhere"),
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: _large ? 14 : (_medium ? 13 : 12)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 20, right: 20),
                          child: Divider(
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                        //Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: ColorsConst.white,
                                    radius: 30,
                                    child: Image.asset(
                                      'assets/images/ta_icon.png',
                                      color: Theme.of(context).primaryColor,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.10,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("key_saving_accounts"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: _large
                                                ? 14
                                                : (_medium ? 13 : 12),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: ColorsConst.white,
                                    radius: 30,
                                    child: Image.asset(
                                      'assets/images/la_icons.png',
                                      color: Theme.of(context).primaryColor,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.10,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("key_loan_services"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: _large
                                                ? 14
                                                : (_medium ? 13 : 12),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: ColorsConst.white,
                                      radius: 30,
                                      child: Image.asset(
                                        'assets/images/da_icon.png',
                                        color: Theme.of(context).primaryColor,
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.10,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.10,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("key_deposite_services"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: _large
                                                ? 14
                                                : (_medium ? 13 : 12),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        CustomDarkButton(
                            caption:
                                AppTranslations.of(context).text("key_login"),
                            onPressed: () async {
                              if (AppData.current.isFngrPrintAvailable()) {
                                final isAvailable =
                                    await LocalAuthApi.hasBiometrics();
                                final biometrics =
                                    await LocalAuthApi.getBiometrics();

                                final hasFingerprint = biometrics
                                    .contains(BiometricType.fingerprint);
                                if (isAvailable == true &&
                                    hasFingerprint == true) {
                                  final isAuthenticated =
                                      await LocalAuthApi.authenticate();
                                  if (isAuthenticated) {
                                    String userNo, clientCode;
                                    userNo = AppData.current.preferences
                                            .getString(SharedPreferencesConst
                                                .FingerPrintUserNo) ??
                                        "0";
                                    clientCode = AppData.current.preferences
                                            .getString(SharedPreferencesConst
                                                .ClientCode) ??
                                        "0";
                                    AppData.current.userNo = userNo;
                                    AppData.current.ClientCode = clientCode;
                                    fetchUserData();
                                  }
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginPage(),
                                  ),
                                );
                              }
                            }),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomLableButton(
                                caption: AppTranslations.of(context)
                                    .text("key_security_tips")
                                    .toUpperCase(),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TipsAndFAQPage(
                                        menuFor: "Tips",
                                      ),
                                      // builder: (_) => SubjectsPage(),
                                    ),
                                  );
                                }),
                            Container(
                              width: 1.0,
                              height: 15.0,
                              color: Colors.grey,
                              margin: EdgeInsets.only(left: 8.0, right: 8.0),
                            ),
                            CustomLableButton(
                                caption: AppTranslations.of(context)
                                    .text("key_faq")
                                    .toUpperCase(),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TipsAndFAQPage(
                                        menuFor: "FAQ",
                                      ),
                                      // builder: (_) => SubjectsPage(),
                                    ),
                                  );
                                }),
                            Container(
                              width: 1.0,
                              height: 15.0,
                              color: Colors.grey,
                              margin: EdgeInsets.only(left: 8.0, right: 8.0),
                            ),
                            CustomLableButton(
                                caption: AppTranslations.of(context)
                                    .text("key_emi_calculator")
                                    .toUpperCase(),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EMICalculatorPage(),
                                      // builder: (_) => SubjectsPage(),
                                    ),
                                  );
                                })
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Visibility(
                          visible:
                              isAvailable == true && hasFingerprint == true,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Login Using Customer ID or PIN ?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: " " + 'Click here',
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => LoginPage(),
                                              ),
                                            );
                                          })
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ClipPath(
                clipper: OuterClippedPart(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).buttonColor,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
              ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                  color: Theme.of(context).primaryColorDark,
                  // color: Color(0xff0c2551),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
            ],
          )),
    );
  }

  void fetchUserData() {
    setState(() {
      _isLoading = true;
    });
    CustomerAPI(context: context)
        .fetchUserData(LoginType: "UserNo")
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.CREATED == res['Status']) {
        AppData.current.clearMenu;
        customerLogin = CustomerLogin.fromMap(res['Data']);
        AppData.current.customerLogin = customerLogin;
        AppData.current.ConnectionString = customerLogin.ConnectionString;
        AppData.current.preferences.setString(
            SharedPreferencesConst.ClientName, customerLogin.ClientName);
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
  }

  Future<void> checkAvaliablity() async {
    final Available = await LocalAuthApi.hasBiometrics();
    final biometrics = await LocalAuthApi.getBiometrics();
    final Fingerprint = biometrics.contains(BiometricType.fingerprint);
    setState(() {
      isAvailable = Available;
      hasFingerprint = Fingerprint;
    });
  }
}

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}

class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
