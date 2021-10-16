import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/SharedPreferencesConst.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:local_auth/local_auth.dart';

import '../app_data.dart';
import 'welcome_page.dart';
import 'navigation_home_screen.dart';

class FingerprintRegistrationPage extends StatefulWidget {
  @override
  _FingerprintRegistrationPageState createState() =>
      _FingerprintRegistrationPageState();
}

class _FingerprintRegistrationPageState
    extends State<FingerprintRegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isReset = false, isAuthenticated = false;

  @override
  Future<void> initState() {
    super.initState();
    regFingerprint();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  CustomAppbar(
                    backButtonVisibility: true,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                    caption: AppTranslations.of(context).text("key_fingr_reg"),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Visibility(
                    visible: isReset,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        resetAlert(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            AppTranslations.of(context).text("key_reset"),
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppTranslations.of(context)
                          .text("key_plc_fingr_snr_vrfy_idty"),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            child: Image.asset(
                              isReset
                                  ? 'assets/images/access.png'
                                  : isAuthenticated
                                      ? 'assets/images/access.png'
                                      : 'assets/images/fingerprint.png',
                              height: 140,
                              width: 140,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Visibility(
                              visible: !AppData.current.isFngrPrintAvailable(),
                              child: Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: CustomDarkButton(
                                    caption: "Add",
                                    onPressed: () {
                                      regFingerprint();
                                    }),
                              )),
                            ),
                            Visibility(
                              visible: !AppData.current.isFngrPrintAvailable(),
                              child: SizedBox(
                                width: 20,
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomDarkButton(
                                  caption: isReset
                                      ? AppTranslations.of(context).text("key_ok")
                                      : AppTranslations.of(context)
                                          .text("key_cancel"),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => NavigationHomeScreen(),
                                      ),
                                    );
                                  }),
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
    );
  }

  Future<void> regFingerprint() async {
    if (AppData.current.isFngrPrintAvailable()) {
      setState(() {
        isReset = true;
      });
    } else {
      final isAvailable = await LocalAuthApi.hasBiometrics();
      final biometrics = await LocalAuthApi.getBiometrics();

      final hasFingerprint = biometrics.contains(BiometricType.fingerprint);
      if (isAvailable == true && hasFingerprint == true) {
        final isAuthenticated = await LocalAuthApi.authenticate();
        if (isAuthenticated) {
          setState(() {
            this.isAuthenticated = isAuthenticated;
            onFingerPrintRegAlert(context);
          });
        }
      }
    }
  }

  void onFingerPrintRegAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: new Text(
                AppTranslations.of(context).text("key_successfully"),
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
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    AppTranslations.of(context).text("key_bio_success_msg"),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (AppData.current.preferences != null) {
                      AppData.current.preferences.setString(
                          SharedPreferencesConst.FingerPrintUserNo,
                          AppData.current.customerLogin.user.UserNo.toString());
                      AppData.current.preferences.setString(
                          SharedPreferencesConst.ClientCode,
                          AppData.current.ClientCode);
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_ok"),
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

  void resetAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: new Text(
                AppTranslations.of(context).text("key_reset"),
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
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    AppTranslations.of(context).text("key_do_you_reset"),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (AppData.current.preferences != null) {
                      AppData.current.preferences.setString(
                          SharedPreferencesConst.FingerPrintUserNo, "0");
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_yes"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_no"),
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
