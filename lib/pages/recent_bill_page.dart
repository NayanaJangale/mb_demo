import 'package:softcoremobilebanking/api/paymentapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/service_type_constant.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/recent_bills.dart';
import 'package:softcoremobilebanking/pages/landline_recharge_page.dart';
import 'package:softcoremobilebanking/pages/mobile_recharge_page.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/recharge_tran_detail_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'electricity_recharge_page.dart';
import 'menu_help_page.dart';

class RecentBillsPage extends StatefulWidget {
  String serviceName, serviceType, menuFor, paymentStatus, menuType;

  RecentBillsPage(
      {this.serviceName,
      this.serviceType,
      this.menuFor,
      this.paymentStatus,
      this.menuType});

  @override
  _RecentBillsPageState createState() => _RecentBillsPageState();
}

class _RecentBillsPageState extends State<RecentBillsPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _recentBillsPageGlobalKey =
      new GlobalKey<ScaffoldState>();
  AnimationController animationController;
  bool _isLoading;
  String _loadingText;
  List<RecentBills> recentBillsList = [];

  GlobalKey newRechargeKey = GlobalKey();
  BuildContext myContext;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    setState(() {
      _isLoading = true;
    });
    PaymentAPI(context: this.context)
        .getRecentBills(
            CustomerID: AppData.current.customerLogin.user.CustomerID,
            PaymentStatus: widget.paymentStatus ?? "SUCCESS",
            menuType: widget.menuType,
            ServiceName: widget.serviceName,
            ServiceType: widget.serviceType)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          recentBillsList =
              List<RecentBills>.from(data.map((i) => RecentBills.fromMap(i)));

          if (widget.menuFor != MenuName.RecentBills &&
              recentBillsList != null &&
              recentBillsList.length > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isFirstLaunch().then((result) {
                print(result);
                if (result)
                  ShowCaseWidget.of(myContext).startShowCase([newRechargeKey]);
              });
            });
          }
        });
      } else {
        callOnClick(
          serviceType: widget.serviceType,
          menuType: widget.menuType,
          serviceName: widget.serviceName,
          menuFor: widget.menuFor,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorsConst.backgroundColor,
            key: _recentBillsPageGlobalKey,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                CustomAppbar(
                  caption: AppTranslations.of(context).text("key_recent_bills"),
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  onIconPressed: () async {
                    String menuName, url;
                    String connectionServerMsg =
                        await NetworkHandler.getServerWorkingUrl();
                    if (connectionServerMsg != "key_check_internet") {
                      if (widget.menuType == MenuTypeConst.Cyberplat) {
                        switch (widget.serviceName) {
                          case ServiceNameConst.Mobile:
                            menuName = AppTranslations.of(context)
                                .text("key_mobile_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/CyberplatMobileRecharge.pdf";
                            break;
                          case ServiceNameConst.DataCard:
                            menuName = AppTranslations.of(context)
                                .text("key_dataCard_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/CyberplatDataCard.pdf";
                            break;
                          case ServiceNameConst.DTH:
                            menuName = AppTranslations.of(context)
                                .text("key_dth_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/CyberplatDTH.pdf";
                            break;
                          case ServiceNameConst.Landline:
                            menuName = AppTranslations.of(context)
                                .text("key_landline_phone_bills");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/CyberplatLandline.pdf";
                            break;
                          case ServiceNameConst.Electricity:
                            menuName = AppTranslations.of(context)
                                .text("key_electricity_bills");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/CyberplatElectricity.pdf";
                            break;
                        }
                      } else if (widget.menuType == MenuTypeConst.Pay2New) {
                        switch (widget.serviceName) {
                          case ServiceNameConst.Mobile:
                            menuName = AppTranslations.of(context)
                                .text("key_mobile_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/Pay2NewMobileRecharge.pdf";
                            break;
                          case ServiceNameConst.DataCard:
                            menuName = AppTranslations.of(context)
                                .text("key_dataCard_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/Pay2NewDataCard.pdf";
                            break;
                          case ServiceNameConst.DTH:
                            menuName = AppTranslations.of(context)
                                .text("key_dth_recharge");
                            url = connectionServerMsg +
                                "/CustCommonAppApi/help/Pay2NewDTH.pdf";
                            break;
                        }
                      }
                      if (menuName != null && url != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuHelpPage(
                              menuName: menuName,
                              pdfURL: url,
                            ),
                          ),
                        );
                      }
                    } else {
                      FlushbarMessage.show(
                        context,
                        connectionServerMsg,
                        MessageTypes.WARNING,
                      );
                    }
                  },
                  icon: Icons.help_outline_outlined,
                ),
                Expanded(
                  child: recentBillsList != null && recentBillsList.length > 0
                      ? ListView.builder(
                          itemCount: recentBillsList.length,
                          padding: const EdgeInsets.only(top: 5),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            String paymentStatus =
                                recentBillsList[index].PaymentStatus;
                            Color color;
                            if (paymentStatus == PaymentStatusType.Success) {
                              paymentStatus = PaymentStatusType.Success;
                              color = Colors.green;
                            } else if (paymentStatus ==
                                PaymentStatusType.Pending) {
                              paymentStatus = PaymentStatusType.Pending;
                              color = Colors.orange;
                            } else if (paymentStatus.contains("Fail")) {
                              paymentStatus = PaymentStatusType.Failure;
                              color = Colors.red;
                            } else {
                              paymentStatus = "Not Available";
                              color = Colors.blue;
                            }

                            final int count = recentBillsList.length;
                            final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                            animationController.forward();
                            return AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: Transform(
                                      transform: Matrix4.translationValues(0.0,
                                          50 * (1.0 - animation.value), 0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 10,
                                            top: 0),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            callOnClick(
                                              amount: recentBillsList[index]
                                                  .DebitAmount,
                                              subscriberNo:
                                                  recentBillsList[index]
                                                      .SubscriberNo,
                                              operatorCode:
                                                  recentBillsList[index]
                                                      .OperatorCode,
                                              circleCode: recentBillsList[index]
                                                  .CircleCode,
                                              serviceType: widget.serviceType,
                                              menuType: widget.menuType,
                                              connectionName:
                                                  recentBillsList[index]
                                                      .AliasName,
                                              serviceName: widget.serviceName,
                                              transactionID:
                                                  recentBillsList[index]
                                                      .TransactionID,
                                              opName:
                                                  recentBillsList[index].OpName,
                                              paymentStatus:
                                                  recentBillsList[index]
                                                      .PaymentStatus,
                                              accountNo: recentBillsList[index]
                                                  .CustomerAccountNo,
                                              transDate: recentBillsList[index]
                                                  .TransDate,
                                              custName:
                                                  recentBillsList[index].LName,
                                              menuFor: widget.menuFor,
                                              color: color,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 33),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            ColorsConst.white,
                                                        radius: 25,
                                                        child: Icon(
                                                          Icons.phone_android,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                recentBillsList[
                                                                        index]
                                                                    .OpName,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  recentBillsList[
                                                                          index]
                                                                      .SubscriberNo,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2
                                                                      .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        color: ColorsConst
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                              AppTranslations.of(
                                                                      context)
                                                                  .text(
                                                                      "key_last_recharge"),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        ColorsConst
                                                                            .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            fit: FlexFit.loose,
                                                            child: Text(
                                                              '\u{20B9}' +
                                                                  recentBillsList[
                                                                          index]
                                                                      .DebitAmount,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        ColorsConst
                                                                            .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                              "on" +
                                                                  " " +
                                                                  DateFormat(
                                                                          'dd MMM hh:mm aaa')
                                                                      .format(DateTime.parse(
                                                                          recentBillsList[index]
                                                                              .TransDate)),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        ColorsConst
                                                                            .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Text(
                                                                AppTranslations.of(
                                                                        context)
                                                                    .text(
                                                                        "key_payment_status"),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: ColorsConst
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            fit: FlexFit.loose,
                                                            child: Text(
                                                              paymentStatus,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        color,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 8.0,
                                                          bottom: 8.0,
                                                        ),
                                                        child: Container(
                                                          height: 1,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              },
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomNotFoundWidget(
                                description: AppTranslations.of(context)
                                    .text("key_recent_bill_not_available"),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            floatingActionButton: widget.menuFor != MenuName.RecentBills
                ? ShowCaseWidget(
                    builder: Builder(builder: (context) {
                      myContext = context;
                      return Showcase(
                        key: newRechargeKey,
                        title: AppTranslations.of(context)
                            .text("key_new_recharge"),
                        description: AppTranslations.of(context)
                            .text("key_clk_to_new_recharge"),
                        shapeBorder: CircleBorder(),
                        animationDuration: Duration(milliseconds: 1500),
                        overlayColor: Colors.blueGrey,
                        child: FloatingActionButton(
                          onPressed: () {
                            callOnClick(
                              serviceType: widget.serviceType,
                              menuType: widget.menuType,
                              serviceName: widget.serviceName,
                              menuFor: widget.menuFor,
                            );
                          },
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 18),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    }),
                    autoPlay: false,
                    autoPlayDelay: Duration(seconds: 3),
                    autoPlayLockEnable: false,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  void callOnClick(
      {String amount,
      String subscriberNo,
      String serviceName,
      String menuType,
      String serviceType,
      String operatorCode,
      String connectionName,
      String circleCode,
      String transactionID,
      String opName,
      String paymentStatus,
      String accountNo,
      String transDate,
      String custName,
      String menuFor,
      Color color}) {
    switch (widget.menuFor.toUpperCase()) {
      case MenuName.MobileRecharge:
      case MenuName.DataCardRecharge:
      case MenuName.PostpaidMobileBills:
      case MenuName.DTHRecharge:
        if (recentBillsList != null && recentBillsList.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MobileRechargePage(
                amount: amount,
                subscriberNo: subscriberNo,
                serviceName: serviceName,
                menuType: menuType,
                serviceType: serviceType,
                operatorCode: operatorCode,
                circleCode: circleCode,
                menuFor: menuFor,
                paymentStatus: paymentStatus,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MobileRechargePage(
                amount: amount,
                subscriberNo: subscriberNo,
                serviceName: serviceName,
                menuType: menuType,
                serviceType: serviceType,
                operatorCode: operatorCode,
                circleCode: circleCode,
                menuFor: menuFor,
                paymentStatus: paymentStatus,
              ),
            ),
          );
        }

        break;
      case MenuName.LandlinePhoneBills:
        if (recentBillsList != null && recentBillsList.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LandlineRechargePage(
                      amount: amount,
                      subscriberNo: subscriberNo,
                      serviceName: serviceName,
                      menuType: menuType,
                      serviceType: serviceType,
                      operatorCode: operatorCode,
                      circleCode: circleCode,
                      accountType: connectionName,
                      menuFor: menuFor,
                      paymentStatus: paymentStatus,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LandlineRechargePage(
                amount: amount,
                subscriberNo: subscriberNo,
                serviceName: serviceName,
                menuType: menuType,
                serviceType: serviceType,
                operatorCode: operatorCode,
                circleCode: circleCode,
                accountType: connectionName,
                menuFor: menuFor,
                paymentStatus: paymentStatus,
              ),
            ),
          );
        }
        break;
      case MenuName.ElectricityBills:
        if (recentBillsList != null && recentBillsList.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ElectricityRechargePage(
                    amount: amount,
                    subscriberNo: subscriberNo,
                    serviceName: serviceName,
                    menuType: menuType,
                    serviceType: serviceType,
                    operatorCode: operatorCode,
                    circleCode: circleCode,
                    connectionName: connectionName,
                    menuFor: menuFor,
                    paymentStatus: paymentStatus)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ElectricityRechargePage(
                    amount: amount,
                    subscriberNo: subscriberNo,
                    serviceName: serviceName,
                    menuType: menuType,
                    serviceType: serviceType,
                    operatorCode: operatorCode,
                    circleCode: circleCode,
                    connectionName: connectionName,
                    menuFor: menuFor,
                    paymentStatus: paymentStatus)),
          );
        }
        break;
      case MenuName.RecentBills:
        if (recentBillsList != null && recentBillsList.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RechargeTranDetailPage(
                    amount: amount,
                    subscriberNo: subscriberNo,
                    serviceName: serviceName,
                    transactionID: transactionID,
                    opName: opName,
                    paymentStatus: paymentStatus,
                    accountNo: accountNo,
                    transDate: transDate,
                    custName: custName,
                    color: color)),
          );
        }

        break;
    }
  }

  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch =
        AppData.current.preferences.getBool(FirstLaunchConst.NewRecharge) ??
            true;
    if (isFirstLaunch)
      AppData.current.preferences.setBool(FirstLaunchConst.NewRecharge, false);
    return isFirstLaunch;
  }
}
