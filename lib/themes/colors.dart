import 'package:flutter/material.dart';

class PurpleTheme {
  /*static const Color primary = Color(0xff311b92);
  static const Color primaryDark = Color(0xff000063);
  static const Color primaryLight = Color(0xff6746c3);
  static const Color primaryExtraLight1 = Color(0xffb39ddb);
  static const Color primaryExtraLight2 = Color(0xffc7a4ff);*/
  static const Color primary = Color(0xff2633c5);
  static const Color primaryDark = Color(0xff000b93);
  static const Color primaryLight = Color(0xff6a5ef9);
  static const Color primaryExtraLight1 = Color(0xff8187ff);
  static const Color primaryExtraLight2 = Color(0xff8f9bff);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color textColor =  Color(0xFFffffff);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#6A88E5');
}

class RedTheme {
  static const Color primary = Color(0xffad1457);
  static const Color primaryDark = Color(0xff78002e);
  static const Color primaryLight = Color(0xffe35183);
  static const Color primaryExtraLight1 = Color(0xffff77a9);
  static const Color primaryExtraLight2 = Color(0xffff94c2);
  static const Color textColor =  Color(0xFFffffff);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#e36da1');

}

class BlueTheme {
  static const Color primary = Color(0xff01579b);
  static const Color primaryDark = Color(0xff002f6c);
  static const Color primaryLight = Color(0xff4f83cc);
  static const Color primaryExtraLight1 = Color(0xff58a5f0);
  static const Color primaryExtraLight2 = Color(0xff90CAF9);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color textColor =  Color(0xFFffffff);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#6cafe4');
}

class TealTheme {
  static const Color primaryDark = Color(0xff00695C);
  static const Color primary = Color(0xff00796B);
  static const Color primaryLight = Color(0xff00897B);
  static const Color primaryExtraLight1 = Color(0xff26A69A);
  static const Color primaryExtraLight2 = Color(0xffB2DFDB);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color textColor =  Color(0xFFffffff);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#6ce4d6');
}

class OrangeTheme {
  static const Color primaryDark = Color(0xffc41c00);
  static const Color primary = Color(0xffff5722);
  static const Color primaryLight = Color(0xffff8a50);
  static const Color primaryExtraLight1 = Color(0xffffa270);
  static const Color primaryExtraLight2 = Color(0xffffbb93);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color textColor =  Color(0xFF000000);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#e4896c');
}
class GreyTheme {
  static const Color primaryDark = Color(0xFF17262A);
  static const Color primary = Color(0xFF253840);
  static const Color primaryLight = Color(0xFF4A6572);
  static const Color primaryExtraLight1 = Color(0xFF4e626b);
  static const Color primaryExtraLight2 = Color(0xFF78909c);
  static const Color textColor =  Color(0xFFffffff);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static  Color decorationHexColor =   HexColor('#6ec0e2');

}

class ColorsConst {
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white =  Colors.white ;//Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF3A5160);
 // static  Color backgroundColor = HexColor('#E2EDF8');
  static  Color backgroundColor =  Color(0xFFF2F3F8);
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}