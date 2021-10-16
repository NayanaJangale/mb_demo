import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AutoUpdateDialog extends StatefulWidget {
  String message;
  Function onOkayPressed;

  AutoUpdateDialog({
    this.message,
    this.onOkayPressed,
  });

  @override
  _AutoUpdateDialogState createState() => new _AutoUpdateDialogState();
}

class _AutoUpdateDialogState extends State<AutoUpdateDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_warning"),
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w600,
                fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.message,
            style:  Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: (){
            widget.onOkayPressed();
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20,bottom: 15),
            child: Text(
              "Ok",
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
