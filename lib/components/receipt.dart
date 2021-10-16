import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:softcoremobilebanking/components/receipt_header.dart';
import 'package:softcoremobilebanking/components/receipt_item_row.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import '../app_data.dart';

class Receipt {
  BuildContext context;

  Receipt({this.context});

  void selfTranRecpt(
      {String debitAccountNo, String depositAmount, String creditAccountNo}) {
    var scr = GlobalKey();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Container(
            color: Colors.grey[350],
            child: RepaintBoundary(
              key: scr,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReceiptHeader(),
                  ReceiptItemRow(
                      title: AppTranslations.of(context).text("key_amount"),
                      value: depositAmount),
                  ReceiptItemRow(
                      title:
                          AppTranslations.of(context).text("key_debit_account"),
                      value: debitAccountNo),
                  ReceiptItemRow(
                      title: AppTranslations.of(context)
                          .text("key_credit_account"),
                      value: creditAccountNo),
                  ReceiptItemRow(
                      title: AppTranslations.of(context).text("key_status"),
                      value:
                          AppTranslations.of(context).text("key_successfully"),
                      color: Colors.green),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NavigationHomeScreen(),
                  ),
                );
              },
              child: Text(
                AppTranslations.of(context).text("key_ok"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () async {
                final directory = (await getExternalStorageDirectory()).path;
                RenderRepaintBoundary boundary =
                    scr.currentContext.findRenderObject();
                var image = await boundary.toImage();
                var byteData =
                    await image.toByteData(format: ImageByteFormat.png);
                var pngBytes = byteData.buffer.asUint8List();

                File imgFile = new File('$directory/selfTranRecpt.png');
                imgFile.writeAsBytes(pngBytes);
                Share.shareFiles(['${directory}/selfTranRecpt.png'],
                    text: AppTranslations.of(context).text("key_tran_status"));

                /* await Share.file('SelfTransfer', 'SelfTransfer.png',
                        pngBytes, 'image/png');*/
              },
              child: Text(
                AppTranslations.of(context).text("key_share"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  void interBankTranRecpt({
    String depositAmount,
    String charges,
    String debitAccountNo,
    String benfAcNo,
    String benfBankName,
    String benfName,
  }) {
    var scr = GlobalKey();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: Container(),
              content: Container(
                color: Colors.grey[350],
                child: RepaintBoundary(
                  key: scr,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReceiptHeader(),
                      ReceiptItemRow(
                          title: AppTranslations.of(context).text("key_amount"),
                          value: depositAmount),
                      ReceiptItemRow(
                          title:
                              AppTranslations.of(context).text("key_charges"),
                          value: charges),
                      ReceiptItemRow(
                          title: AppTranslations.of(context)
                              .text("key_debit_account"),
                          value: debitAccountNo),
                      ReceiptItemRow(
                          title: AppTranslations.of(context)
                              .text("key_benef_ac_no"),
                          value: benfAcNo),
                      ReceiptItemRow(
                          title: AppTranslations.of(context)
                              .text("key_benef_bank_name"),
                          value: benfBankName),
                      ReceiptItemRow(
                          title: AppTranslations.of(context)
                              .text("key_benef_name"),
                          value: benfName),
                      ReceiptItemRow(
                          title: AppTranslations.of(context).text("key_status"),
                          value: AppTranslations.of(context)
                              .text("key_successfully"),
                          color: Colors.green),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_ok"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final directory =
                        (await getExternalStorageDirectory()).path;
                    RenderRepaintBoundary boundary =
                        scr.currentContext.findRenderObject();
                    var image = await boundary.toImage();
                    var byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    var pngBytes = byteData.buffer.asUint8List();

                    File imgFile = new File('$directory/interBankTranRecpt.png');
                    imgFile.writeAsBytes(pngBytes);
                    Share.shareFiles(['${directory}/interBankTranRecpt.png'],
                        text: AppTranslations.of(context)
                            .text("key_tran_status"));
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_share"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void rechargeReceipt({
    String accountNo,
    String serviceName,
    String subscriberNo,
    String amount,
  }) {
    var scr = GlobalKey();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: Container(),
              content: Container(
                color: Colors.grey[350],
                child: RepaintBoundary(
                  key: scr,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReceiptHeader(),
                      ReceiptItemRow(
                          title: AppTranslations.of(context)
                              .text("key_account_no"),
                          value: accountNo),
                      ReceiptItemRow(
                          title: serviceName +" "+
                              AppTranslations.of(context).text("key_number"),
                          value: subscriberNo),
                      ReceiptItemRow(
                          title:
                              AppTranslations.of(context).text("key_amount"),
                          value: amount),
                      ReceiptItemRow(
                          title:                               AppTranslations.of(context).text("key_status"),
                          value: AppTranslations.of(context)
                              .text("key_successfully"),
                          color: Colors.green),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_ok"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final directory =
                        (await getExternalStorageDirectory()).path;
                    RenderRepaintBoundary boundary =
                        scr.currentContext.findRenderObject();
                    var image = await boundary.toImage();
                    var byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    var pngBytes = byteData.buffer.asUint8List();

                    File imgFile = new File('$directory/rechargeReceipt.png');
                    imgFile.writeAsBytes(pngBytes);
                    Share.shareFiles(['${directory}/rechargeReceipt.png'],
                        text: AppTranslations.of(context)
                            .text("key_tran_status"));
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_share"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
