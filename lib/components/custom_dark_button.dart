import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/button_styles.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

class CustomDarkButton extends StatelessWidget {
  final String caption;
  final Function onPressed;

  const CustomDarkButton({
    this.caption,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44,
        decoration:  BoxDecoration(
          color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).buttonColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: const BorderRadius.all(
              Radius.circular(14.0)
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context).primaryColor
                    .withOpacity(0.2),
                offset: const Offset(8.0, 16.0),
                blurRadius: 16.0),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.transparent,
            onTap: onPressed,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24,right: 24,top: 10,bottom: 10),
                child: Text(
                  caption,
                  style: ButtonStyles.getDarkButtonTextStyle(context),
                ),
              ),
            ),
          ),
        )
    );
  }
}