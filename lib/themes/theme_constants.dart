import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:softcoremobilebanking/themes/text_styles.dart';

class ThemeColor {
  Color color;
  String caption;

  ThemeColor({
    this.color,
    this.caption,
  });
}

List<ThemeColor> themeColors = [
  ThemeColor(
    color: Colors.deepPurple,
    caption: ThemeNames.Purple,
  ),
  ThemeColor(
    color: Colors.blue,
    caption: ThemeNames.Blue,
  ),
  ThemeColor(
    color: Colors.teal,
    caption: ThemeNames.Teal,
  ),
  ThemeColor(
    color: Colors.deepOrange,
    caption: ThemeNames.Orange,
  ),
  ThemeColor(
    color: Color(0xff78002e),
    caption: ThemeNames.Red,
  ),
  ThemeColor(
    color: Colors.grey,
    caption: ThemeNames.Grey,
  ),
];

class ThemeConfig {
  static purpleThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: PurpleTheme.primary,
      primaryColorDark: PurpleTheme.primaryDark,
      accentColor: PurpleTheme.primaryLight,
      primaryColorLight: PurpleTheme.primaryExtraLight1,
      scaffoldBackgroundColor: PurpleTheme.spacer,
      secondaryHeaderColor: PurpleTheme.primaryExtraLight2,
      backgroundColor: Color(0xFFF2F3F8),// HexColor('#E2EDF8'),
      bottomAppBarColor: PurpleTheme.primary,
      buttonColor: PurpleTheme.decorationHexColor,
      textTheme: TextTheme(
          caption: TextStyles.caption,
          headline1: TextStyles.headline1,
          headline2: TextStyles.headline2,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0,
            color: PurpleTheme.primary,
            textTheme: TextTheme(
                caption: TextStyles.caption,
                headline1: TextStyles.headline1,
                headline2: TextStyles.headline2,
                bodyText1: TextStyles.bodyText1,
                bodyText2: TextStyles.bodyText2,
                button: TextStyles.button,
                overline: TextStyles.overline
            ),
          ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption

          ),
       cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),
    );
  }

  static blueThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: BlueTheme.primary,
      primaryColorDark: BlueTheme.primaryDark,
      accentColor: BlueTheme.primaryLight,
      primaryColorLight: BlueTheme.primaryExtraLight1,
      scaffoldBackgroundColor: BlueTheme.spacer,
      secondaryHeaderColor: BlueTheme.primaryExtraLight2,
      backgroundColor:   Color(0xFFF2F3F8),
      buttonColor: BlueTheme.decorationHexColor,//HexColor('#E2EDF8'),
      textTheme: TextTheme(
          caption: TextStyles.caption,
          headline1: TextStyles.headline1,
          headline2: TextStyles.headline2,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0,
            color: BlueTheme.primary,
            textTheme: TextTheme(
                caption: TextStyles.caption,
                headline1: TextStyles.headline1,
                headline2: TextStyles.headline2,
                bodyText1: TextStyles.bodyText1,
                bodyText2: TextStyles.bodyText2,
                button: TextStyles.button,
                overline: TextStyles.overline
            ),
          ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption

      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),

      focusColor: BlueTheme.primary,
      dividerColor: BlueTheme.spacer,
    );
  }

  static tealThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: TealTheme.primary,
      primaryColorDark: TealTheme.primaryDark,
      accentColor: TealTheme.primaryLight,
      primaryColorLight: TealTheme.primaryExtraLight1,
      scaffoldBackgroundColor: TealTheme.spacer,
      secondaryHeaderColor: TealTheme.primaryExtraLight2,
      backgroundColor:  Color(0xFFF2F3F8),
      buttonColor: TealTheme.decorationHexColor,//HexColor('#E2EDF8'),
      textTheme: TextTheme(
          caption: TextStyles.caption,
          headline1: TextStyles.headline1,
          headline2: TextStyles.headline2,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0,
            color: TealTheme.primary,
            textTheme: TextTheme(
                caption: TextStyles.caption,
                headline1: TextStyles.headline1,
                headline2: TextStyles.headline2,
                bodyText1: TextStyles.bodyText1,
                bodyText2: TextStyles.bodyText2,
                button: TextStyles.button,
                overline: TextStyles.overline

            ),
          ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption
          ),
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),
      focusColor: TealTheme.primary,
      dividerColor: TealTheme.spacer,
    );
  }

  static OrangeThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: OrangeTheme.primary,
      primaryColorDark: OrangeTheme.primaryDark,
      accentColor: OrangeTheme.primaryLight,
      primaryColorLight: OrangeTheme.primaryExtraLight1,
      scaffoldBackgroundColor: OrangeTheme.spacer,
      secondaryHeaderColor: OrangeTheme.primaryExtraLight2,
      backgroundColor:  Color(0xFFF2F3F8) ,//HexColor('#E2EDF8'),
      focusColor: OrangeTheme.primary,
      dividerColor: OrangeTheme.spacer,
      buttonColor: OrangeTheme.decorationHexColor,

      textTheme: TextTheme(
          caption: TextStyles.caption,
          headline1: TextStyles.headline1,
          headline2: TextStyles.headline2,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0,
            color: OrangeTheme.primary,
            textTheme: TextTheme(
                caption: TextStyles.caption,
                headline1: TextStyles.headline1,
                headline2: TextStyles.headline2,
                bodyText1: TextStyles.bodyText1,
                bodyText2: TextStyles.bodyText2,
                button: TextStyles.button,
                overline: TextStyles.overline
            ),
          ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption
          ),
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),
    );
  }

  static redThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: RedTheme.primary,
      primaryColorDark: RedTheme.primaryDark,
      accentColor: RedTheme.primaryLight,
      primaryColorLight: RedTheme.primaryExtraLight1,
      scaffoldBackgroundColor: RedTheme.spacer,
      secondaryHeaderColor: RedTheme.primaryExtraLight2,
      backgroundColor:  Color(0xFFF2F3F8),// HexColor('#E2EDF8'),
      focusColor: RedTheme.primary,
      dividerColor: RedTheme.spacer,
      buttonColor: RedTheme.decorationHexColor,
      textTheme: TextTheme(
        caption: TextStyles.caption,
        headline1: TextStyles.headline1,
        headline2: TextStyles.headline2,
        bodyText1: TextStyles.bodyText1,
        bodyText2: TextStyles.bodyText2,
        button: TextStyles.button,
        overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0,
            color: RedTheme.primary,
            textTheme: TextTheme(
                caption: TextStyles.caption,
                headline1: TextStyles.headline1,
                headline2: TextStyles.headline2,
                bodyText1: TextStyles.bodyText1,
                bodyText2: TextStyles.bodyText2,
                button: TextStyles.button,
                overline: TextStyles.overline
            ),
          ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption
          ),
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),
    );
  }

  static greyThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: GreyTheme.primary,
      primaryColorDark: GreyTheme.primaryDark,
      accentColor: GreyTheme.primaryLight,
      primaryColorLight: GreyTheme.primaryExtraLight1,
      scaffoldBackgroundColor: GreyTheme.spacer,
      secondaryHeaderColor: GreyTheme.primaryExtraLight2,
      backgroundColor:  Color(0xFFF2F3F8),//HexColor('#E2EDF8'),
      focusColor: GreyTheme.primary,
      dividerColor: GreyTheme.spacer,
      buttonColor: GreyTheme.decorationHexColor,
      textTheme: TextTheme(
          caption: TextStyles.caption,
          headline1: TextStyles.headline1,
          headline2: TextStyles.headline2,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          overline: TextStyles.overline
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        elevation: 0.0,
        color: GreyTheme.primary,
        textTheme: TextTheme(
            caption: TextStyles.caption,
            headline1: TextStyles.headline1,
            headline2: TextStyles.headline2,
            bodyText1: TextStyles.bodyText1,
            bodyText2: TextStyles.bodyText2,
            button: TextStyles.button,
            overline: TextStyles.overline
        ),
      ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
          labelStyle: TextStyles.caption,
          unselectedLabelStyle: TextStyles.caption
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Theme.of(context).primaryColor,
        primaryContrastingColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class ThemeConstants {
  static const String currentTheme = 'currentTheme';
  static const String isActive = 'isActive';
}

class ThemeNames {
  static const String Purple = 'Purple';
  static const String Blue = 'Blue';
  static const String Teal = 'Teal';
  static const String Red = 'Red';
  static const String Grey = 'Grey';
  static const String Orange = 'Orange';
}


