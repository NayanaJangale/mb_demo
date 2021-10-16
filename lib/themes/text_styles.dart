import 'package:flutter/material.dart';

class TextStyles {
  static const String fontName = 'WorkSans';
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);



  static const TextStyle headline1 = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight:  FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.27,
    color: darkerText,
  );
//app bar subheading
  static const TextStyle headline2 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle bodyText1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.05,
    color: darkText,
  );
// for user Input hint
  static const TextStyle bodyText2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );
  // title
  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkerText, // was lightText
  );
  static const TextStyle button = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );
  static const TextStyle overline = TextStyle(
    decoration: TextDecoration.underline,// body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.2,
    color: Color(0xff1565c0),
  );

}
