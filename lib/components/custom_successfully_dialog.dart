import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSuccessfullyDialog extends StatelessWidget {
  final String message;
  final String actionName;
  final Function onActionTapped;

  CustomSuccessfullyDialog({
    @required this.actionName,
    this.message,
    @required this.onActionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      message: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            actionName,
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          onPressed: onActionTapped,
        )
      ],
    );
  }
}
