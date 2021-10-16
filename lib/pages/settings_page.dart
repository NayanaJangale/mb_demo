import 'dart:convert';

import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_icon_action.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/themes/app_settings_change_notifier.dart';
import 'package:softcoremobilebanking/themes/theme_constants.dart';
import 'package:softcoremobilebanking/constants/project_lang.dart';
import 'package:provider/provider.dart';
import 'navigation_home_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading;
  String _loadingText;

  String selectedThemeName, selectedLocale = 'en';

  AppSettingsChangeNotifier _appSettingsChangeNotifier;

  @override
  void initState() {
    _isLoading = false;

    if (AppData.current.preferences != null) {
      selectedThemeName =
          AppData.current.preferences.getString('theme') ?? ThemeNames.Purple;
      selectedLocale =
          AppData.current.preferences.getString('localeLang') ?? 'en';
    } else {
      selectedThemeName = ThemeNames.Purple;
      selectedLocale = 'en';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_applying_changes");
    _appSettingsChangeNotifier =
        Provider.of<AppSettingsChangeNotifier>(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationHomeScreen(),
          ),
        );
      },
      child: CustomProgressHandler(
        isLoading: _isLoading,
        loadingText: _loadingText,
        child: Container(
          color: Colors.grey[100],
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(AppTranslations.of(context).text("key_setting")),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppTranslations.of(context).text("key_theme"),
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0, right: 20.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            themeColors.length,
                            (index) => getThemeColor(
                              themeColors[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Divider(
                        height: 0.0,
                        color: Colors.black12,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showLocaleList();
                      },
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, bottom: 10.0, top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  AppTranslations.of(context).text("key_language"),
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  selectedLocale == 'en' ? 'English' : 'मराठी',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getThemeColor(ThemeColor themeColor) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectedThemeName = themeColor.caption;

          ThemeData themeData;
          switch (selectedThemeName) {
            case ThemeNames.Purple:
              themeData = ThemeConfig.purpleThemeData(context);
              break;
            case ThemeNames.Blue:
              themeData = ThemeConfig.blueThemeData(context);
              break;
            case ThemeNames.Teal:
              themeData = ThemeConfig.tealThemeData(context);
              break;
            case ThemeNames.Orange:
              themeData = ThemeConfig.OrangeThemeData(context);
              break;
            case ThemeNames.Red:
              themeData = ThemeConfig.redThemeData(context);
              break;
            case ThemeNames.Grey:
              themeData = ThemeConfig.greyThemeData(context);
              break;
          }
          _appSettingsChangeNotifier.setTheme(selectedThemeName, themeData);

          AppData.current.preferences.setString('theme', selectedThemeName);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: themeColor.color,
                radius: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  themeColor.caption == selectedThemeName
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: themeColor.caption == selectedThemeName
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLocaleList() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_app_language"),
        ),
        actions: List<Widget>.generate(
          projectLang.length,
          (index) => CustomCupertinoIconAction(
            isImage: true,
            imagePath: projectLang[index].image,
            actionText: projectLang[index].title,
            actionIndex: index,
            onActionPressed: () {
              setState(() {
                _isLoading = true;
                _loadingText =
                    AppTranslations.of(context).text("key_applying_changes");

                selectedLocale = projectLang[index].lanaguageCode;
                _appSettingsChangeNotifier
                    .setLocale(new Locale(projectLang[index].lanaguageCode));

                AppData.current.preferences
                    .setString('localeLang', selectedLocale)
                    .then((result) {
                  _isLoading = false;
                });
              });

              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }
}
