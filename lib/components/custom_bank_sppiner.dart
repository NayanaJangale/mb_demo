import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBankSpinner extends StatefulWidget {
  final String accountName;
  final String accountNo;
  final Function onPressed;

  CustomBankSpinner({
    this.accountName,
    this.accountNo,
    @required this.onPressed,
  });

  @override
  _CustomBankSpinnerState createState() => _CustomBankSpinnerState();
}

class _CustomBankSpinnerState extends State<CustomBankSpinner> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.account_balance_outlined,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 30.0,
              width: 1.0,
              color: Colors.grey.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 00.0, right: 10.0),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.accountName,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                      textAlign: TextAlign.start),
                  Text(widget.accountNo,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: ColorsConst.grey),
                      textAlign: TextAlign.start),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.navigate_next,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
