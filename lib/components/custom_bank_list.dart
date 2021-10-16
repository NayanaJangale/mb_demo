import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

class CustomBankList extends StatefulWidget {
  final String name;
  final String acNo;
  final String branchName;
  final Function onItemTap;
  final Function onItemLongPress;

  CustomBankList(
      {this.name,
      this.acNo,
      this.branchName,
      this.onItemTap,
      this.onItemLongPress});

  @override
  _CustomBankListState createState() => _CustomBankListState();
}

class _CustomBankListState extends State<CustomBankList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onItemTap,
      onLongPress: widget.onItemLongPress,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Icon(
                      Icons.account_balance_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
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
                      Text(StringUtils.capitalize(widget.name, allWords: true),
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                          textAlign: TextAlign.start),
                      Text(widget.acNo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: ColorsConst.grey),
                          textAlign: TextAlign.start),
                      Text(StringUtils.capitalize(widget.branchName, allWords: true),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: ColorsConst.grey),
                          textAlign: TextAlign.start),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
