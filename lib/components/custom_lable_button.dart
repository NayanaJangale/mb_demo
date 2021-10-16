import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/button_styles.dart';

class CustomLableButton extends StatelessWidget {
  final String caption;
  final Function onPressed;

  const CustomLableButton({
    this.caption,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: this.onPressed,
        constraints: BoxConstraints(), // optional, in order to add additional space around text if needed
        child: Text(
          caption,
          style:
          Theme.of(context).textTheme.bodyText2.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12),
          textAlign: TextAlign.center,

        ));
  }
}
