import 'package:softcoremobilebanking/api/paymentapi.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/jio_plan.dart';
import 'package:softcoremobilebanking/models/recharge_plan.dart';
import 'package:softcoremobilebanking/pages/mobile_recharge_page.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation_home_screen.dart';

class JioPlanPage extends StatefulWidget {
  String amount,planID,
      subscriberNo,
      serviceName,
      serviceType,
      menuType,
      operatorCode,
      circleCode,
      paymentStatus,
      OpCode,
      menuFor;
  JioPlanPage({
    this.subscriberNo,
    this.amount,
    this.serviceName,
    this.serviceType,
    this.menuType,
    this.operatorCode,
    this.circleCode,
    this.menuFor,
    this.paymentStatus,
    this.OpCode,
    this.planID
  });

  @override
  _JioPlanPageState createState() => _JioPlanPageState();
}

class _JioPlanPageState extends State<JioPlanPage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _JioPlanPageGlobalKey =
  new GlobalKey<ScaffoldState>();
  bool _isLoading;
  String _loadingText;
  AnimationController animationController;
  List<JioPlan>rechargePlanList=[];

  @override
  void initState() {
    super.initState();
    _isLoading = true ;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    PaymentAPI(context: this.context)
        .getJioPlans(
        Amount: widget.amount,
        SubscriberNo: widget.subscriberNo)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        //var offerdata = data["records"];
        setState(() {
          rechargePlanList =
          List<JioPlan>.from(data.map((i) => JioPlan.fromMap(i)));
        });
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
              backgroundColor: ColorsConst.backgroundColor,
              key: _JioPlanPageGlobalKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  CustomAppbar(
                    backButtonVisibility: true,
                    onBackPressed: () {
                       Navigator.pop(context);
                    },
                    caption: AppTranslations.of(context).text("key_recharge_plan"),
                    icon: Icons.help_outline_outlined,
                  ),
                  Expanded(
                      child:  rechargePlanList != null && rechargePlanList.length > 0
                          ? ListView.builder(
                        itemCount: rechargePlanList.length,
                        padding: const EdgeInsets.only(top: 5),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = rechargePlanList.length;
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
                                  transform: Matrix4.translationValues(
                                      0.0, 50 * (1.0 - animation.value), 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,

                                      child:Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 60,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 10),
                                                      child: Text( '\u{20B9}' + rechargePlanList[index].price.toString(),style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                          color: Theme.of(context).primaryColorDark,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                          textAlign:TextAlign.start),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50.0,
                                                    width: 1.0,
                                                    color: Colors.grey.withOpacity(0.5),
                                                    margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              rechargePlanList[index].description,
                                                              style:   Theme.of(context).textTheme.bodyText2.copyWith(
                                                                // color: Theme.of(context).primaryColorDark,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 12),
                                                              textAlign:TextAlign.justify

                                                          ),
                                                        ],)
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
                                      ) ,
                                      onTap: (){
                                        switch (widget.menuFor){
                                          case MenuName.MobileRecharge:
                                          case MenuName.DataCardRecharge:
                                          case MenuName.PostpaidMobileBills:
                                          case MenuName.DTHRecharge:
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => MobileRechargePage(subscriberNo: widget.subscriberNo,menuFor: widget.menuFor,circleCode: widget.circleCode,paymentStatus: widget.paymentStatus,operatorCode: widget.operatorCode,amount: rechargePlanList[index].price.toString(),serviceType: widget.serviceType,serviceName:widget.serviceName,menuType: widget.menuType,planID: rechargePlanList[index].id,)
                                              ),
                                            );
                                            break;
                                        }
                                      },
                                    ),
                                  ),
                                ),
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
                              description:AppTranslations.of(context).text("key_recharge_plan_not_available"),

                            );
                          },
                        ),
                      )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
