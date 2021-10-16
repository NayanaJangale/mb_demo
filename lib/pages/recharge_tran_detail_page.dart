import 'dart:io';
import 'dart:ui';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import '../components/custom_progress_handler.dart';

class RechargeTranDetailPage extends StatefulWidget {
  String transactionID,
      subscriberNo,
      opName,
      paymentStatus,
      serviceName,
      accountNo,
      amount,
      transDate,
      custName;
      Color color;

  RechargeTranDetailPage(
      {this.transactionID,
      this.subscriberNo,
      this.opName,
      this.paymentStatus,
      this.serviceName,
      this.accountNo,
      this.amount,
      this.transDate,
      this.color,
      this.custName});

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<RechargeTranDetailPage> {
  bool _isLoading;
  String _loadingText;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldSCKey = new GlobalKey<ScaffoldState>();
  File photoImgFile;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    Size size = MediaQuery.of(context).size;
    return CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Container(
          color: Colors.grey[100],
          child: SafeArea(
            child: Scaffold(
                backgroundColor: widget.color,
                key: scaffoldKey,
                resizeToAvoidBottomInset: true,
                body: RepaintBoundary(
                  key: scaffoldSCKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomAppbar(
                        backButtonVisibility: true,
                        onBackPressed: () {
                          Navigator.pop(context);
                        },
                        caption: AppTranslations.of(context).text("key_recharge_tran_Detail"),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppTranslations.of(context).text("key_payment_status"),
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorsConst.white,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppTranslations.of(context).text("key_your_tran") + " :- " + widget.paymentStatus + ".",
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorsConst.white,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(  DateFormat(
                                  'dd MMM hh:mm aaa')
                                  .format(DateTime.parse(widget.transDate)),
                                  style: Theme.of(context).textTheme.caption.copyWith(
                                      fontWeight: FontWeight.w400,
                                       color:  ColorsConst.white,
                                      fontSize: 12)),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(AppTranslations.of(context).text("key_trans_id"),
                                  style: Theme.of(context).textTheme.caption.copyWith(
                                      fontWeight: FontWeight.w500,
                                      // color:  ColorsConst.white,
                                      fontSize: 14)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(widget.transactionID,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontSize: 14,
                                          color: ColorsConst.white,
                                          fontWeight: FontWeight.w400)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(widget.serviceName,
                                  style: Theme.of(context).textTheme.caption.copyWith(
                                      //   color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                      color: Theme.of(context).primaryColor,
                                      size: 23,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 1.0,
                                      color: Colors.grey.withOpacity(0.5),
                                      margin: const EdgeInsets.only(
                                          left: 00.0, right: 10.0),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.opName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start),
                                        Text(widget.subscriberNo,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(color: ColorsConst.grey),
                                            textAlign: TextAlign.start),

                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                RenderRepaintBoundary boundary =
                                scaffoldSCKey.currentContext.findRenderObject();
                                var image = await boundary.toImage();
                                var byteData =
                                    await image.toByteData(format: ImageByteFormat.png);
                                var pngBytes = byteData.buffer.asUint8List();
                              /*  await Share.file('RechargeTransfer', 'RechargeTransfer.jpg',
                                    pngBytes, 'image/jpg');*/
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(AppTranslations.of(context).text("key_share"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                            color: ColorsConst.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(AppTranslations.of(context).text("key_debit_from"),
                                  style: Theme.of(context).textTheme.caption.copyWith(
                                      //   color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
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
                                      margin: const EdgeInsets.only(
                                          left: 00.0, right: 10.0),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.custName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start),
                                        Text(widget.accountNo,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(color: ColorsConst.grey),
                                            textAlign: TextAlign.start),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
