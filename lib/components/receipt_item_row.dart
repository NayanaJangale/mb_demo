import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReceiptItemRow extends StatefulWidget {
  final String title;
  final String value;
  Color color ;

  ReceiptItemRow({
    this.title,
    this.value,
    this.color,
  });

  @override
  _ReceiptItemRowState createState() => _ReceiptItemRowState();
}

class _ReceiptItemRowState extends State<ReceiptItemRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Divider(
            height: 1.0,
            color: Colors.grey[400],
          ),
        ),
        Row(
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
              textAlign: TextAlign.right,
            ),
            Expanded(
              child: Text(
                widget.value,
                style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: widget.color??Colors.grey[600]),
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
      ],
    );
  }
}
