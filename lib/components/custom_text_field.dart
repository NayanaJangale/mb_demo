import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  bool enable=true;
  bool autofoucus;
  bool isIcon;
  final int maxLength;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final Function validation;
  final double borderRadius;
  final Color borderColor;

  CustomTextField(
      {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.autofoucus,
      this.isIcon= false,
      this.validation,
      this.focusNode,
      this.onFieldSubmitted,
      this.obscureText = false,
      this.enable,
      this.maxLength,
      this.borderRadius = 20,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        color:  Colors.white,
        borderRadius: BorderRadius.circular(borderRadius) ?? 20,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 15.0),
        child: Row(
          children: [
            Visibility(
              visible: isIcon,
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colors.grey.withOpacity(0.5),
                    margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                  ),

                ],
              ),
            ),
            new Expanded(
              child: TextField(
                enabled: enable,
                controller: textEditingController,
                maxLength: maxLength,
                focusNode: focusNode,
                autofocus: autofoucus,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  counter: Container(),
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey,
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(),
                ),
                style:Theme.of(context).textTheme.bodyText1.copyWith(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
