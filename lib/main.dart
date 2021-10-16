import 'dart:io';

import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_fund_tran_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:softcoremobilebanking/localization/app_translations_delegate.dart';
import 'package:softcoremobilebanking/localization/application.dart';
import 'package:softcoremobilebanking/themes/app_settings_change_notifier.dart';
import 'package:softcoremobilebanking/themes/theme_constants.dart';
import 'package:softcoremobilebanking/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((preferences) {
    AppData.current.preferences = preferences;
    HttpOverrides.global = new MyHttpOverrides();
    runApp(PulseIndia(preferences: preferences));
  });
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class PulseIndia extends StatefulWidget {
  final SharedPreferences preferences;
  PulseIndia({
    this.preferences,
  });
  @override
  _PulseIndiaState createState() => _PulseIndiaState();
}

class _PulseIndiaState extends State<PulseIndia> {

  @override
  Widget build(BuildContext context) {

    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Purple);

    Locale locale =
        new Locale((widget.preferences.getString('localeLang') ?? 'en'));

    return ChangeNotifierProvider<AppSettingsChangeNotifier>(
      create: (_) => AppSettingsChangeNotifier(
          _handleThemeConfiguration(), themeName, locale),
      child: AppWithCustomTheme(
        preferences: widget.preferences,
      ),
    );
  }

  ThemeData _handleThemeConfiguration() {
    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Purple);

    switch (themeName) {
      case ThemeNames.Purple:
        return ThemeConfig.purpleThemeData(context);
      case ThemeNames.Blue:
        return ThemeConfig.blueThemeData(context);
      case ThemeNames.Teal:
        return ThemeConfig.tealThemeData(context);
      case ThemeNames.Orange:
        return ThemeConfig.OrangeThemeData(context);
      case ThemeNames.Red:
        return ThemeConfig.redThemeData(context);
      case ThemeNames.Grey:
        return ThemeConfig.greyThemeData(context);
    }
  }
}

class AppWithCustomTheme extends StatefulWidget {
  final SharedPreferences preferences;
  AppWithCustomTheme({@required this.preferences});

  @override
  _AppWithCustomThemeState createState() => _AppWithCustomThemeState();
}

class _AppWithCustomThemeState extends State<AppWithCustomTheme> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppSettingsChangeNotifier>(context);
    onLocaleChange(theme.getLocale());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      color: Colors.white,
      title: 'SoftCore Mobile Banking',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      darkTheme: theme.getTheme(),
      themeMode: ThemeMode.light,
      home: WelcomePage(
 //       preferences: widget.preferences,
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("mr", ""),
      ],
    );
  }
}
