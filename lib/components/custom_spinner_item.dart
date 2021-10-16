import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/themes/button_styles.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

class CustomSpinnerItem extends StatelessWidget {
  final String caption;
  final String selectedItem;
  final Function onPressed;

  const CustomSpinnerItem({
    this.caption,
    this.selectedItem,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsConst.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                caption,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey
                ),
              ),
            ),
            Text(
              selectedItem,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
              ),
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
    );
  }
}
