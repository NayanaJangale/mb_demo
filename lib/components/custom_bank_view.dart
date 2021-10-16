import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

class CustomBankView extends StatelessWidget {
  final String accountName;
  final String accountNo;
  final Function onTap;

  CustomBankView({
    this.accountName,
    this.accountNo,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsConst.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Padding(
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
                      Text(
                          accountName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                          ),
                          textAlign:TextAlign.start
                      ),
                      Text(
                          accountNo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                              color: ColorsConst.grey
                          ),
                          textAlign:TextAlign.start
                      ),
                    ],)
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


