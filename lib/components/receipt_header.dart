import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_data.dart';

class ReceiptHeader extends StatefulWidget {
   @override
   _ReceiptHeaderState createState() => _ReceiptHeaderState();
}

class _ReceiptHeaderState extends State<ReceiptHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppData.current.bytesLogoImg == null
                ? Container()
                : Image.memory(
              AppData.current.bytesLogoImg,
              height: 40,
              width: 40,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                AppData.current.customerLogin.ClientName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            DateFormat('dd/MM/yyyy hh:mm:ss a')
                .format(DateTime.now()),
            style: Theme.of(context).textTheme.caption.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey[600]),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
