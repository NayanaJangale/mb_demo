import 'package:softcoremobilebanking/api/bbpsapi.dart';
import 'package:softcoremobilebanking/api/pay2newapi.dart';
import 'package:softcoremobilebanking/api/paymentapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/service_type_constant.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/circleCode.dart';
import 'package:softcoremobilebanking/models/dth_info.dart';
import 'package:softcoremobilebanking/models/operator.dart';
import 'package:softcoremobilebanking/pages/otp_verification_page.dart';
import 'package:softcoremobilebanking/pages/recent_bill_page.dart';
import 'package:softcoremobilebanking/pages/recharge_plan_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_data.dart';
import 'jio_plan_page.dart';
import 'menu_help_page.dart';

class MobileRechargePage extends StatefulWidget {
  String amount,
      planID,
      subscriberNo,
      serviceName,
      serviceType,
      menuType,
      operatorCode,
      circleCode,
      paymentStatus,
      menuFor;

  MobileRechargePage({
    this.subscriberNo,
    this.amount,
    this.serviceName,
    this.serviceType,
    this.menuType,
    this.operatorCode,
    this.circleCode,
    this.menuFor,
    this.paymentStatus,
    this.planID,
  });

  @override
  _MobileRechargePageState createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage> {
  bool _isLoading, isSelected = true;
  String _loadingText;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController amoutAccCntl = TextEditingController();
  TextEditingController mobileNoAccCntl = TextEditingController();

  FocusNode amoutFcsNode = FocusNode();
  FocusNode mobileNoAccFcsNode = FocusNode();
  List<Account> accountList = [];
  Account selectedAc;
  List<Operator> operatorList = [];
  Operator selectedOperator;
  List<CircleCode> circleList = [];
  DthInfo dthInfo;
  CircleCode selectedCircleCode;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    if (widget.amount != null && widget.amount != "") {
      amoutAccCntl.text = widget.amount;
    }
    if (widget.subscriberNo != null && widget.subscriberNo != "") {
      mobileNoAccCntl.text = widget.subscriberNo;
    }
    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      accountList = AppData.current.customerLogin.oAccounts
          .where((i) => i.AccountType == AccountTypeConst.TransactionalAccounts)
          .toList();

      if (accountList != null && accountList.length > 0) {
        selectedAc = accountList[0];
        for (int i = 0; i < accountList.length; i++) {
          accountList[i].isSelected = false;
        }
        accountList[0].isSelected = true;
      }
    }
    loadOperator();
    if (widget.menuType != MenuTypeConst.Cyberplat) {
      loadCircleCode(serviceID: "%");
    }

    if (widget.menuType != MenuTypeConst.Cyberplat) {
      mobileNoAccCntl.addListener(() {
        if (mobileNoAccCntl.text.length == 10) {
          fetchMNPOperator();
        }
      });
    }
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
            key: scaffoldKey,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        CustomAppbar(
                          backButtonVisibility: true,
                          onBackPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.help_outline_outlined,
                          caption: widget.menuFor,
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
                                }
                              } else if (widget.menuType ==
                                  MenuTypeConst.Pay2New) {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MenuHelpPage(
                                    menuName: menuName,
                                    pdfURL: url,
                                  ),
                                ),
                              );
                            } else {
                              FlushbarMessage.show(
                                context,
                                connectionServerMsg,
                                MessageTypes.WARNING,
                              );
                            }
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        CustomTextField(
                                          keyboardType: TextInputType.number,
                                          autofoucus: false,
                                          isIcon: false,
                                          textEditingController:
                                              mobileNoAccCntl,
                                          focusNode: mobileNoAccFcsNode,
                                          borderRadius: 10,
                                          maxLength: widget.menuFor ==
                                                  MenuName.MobileRecharge
                                              ? 10
                                              : null,
                                          onFieldSubmitted: (value) {
                                            this.mobileNoAccFcsNode.unfocus();
                                          },
                                          icon: Icons.monetization_on_outlined,
                                          hint: getSubcNoTitle(),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (operatorList != null &&
                                                      operatorList.length > 0) {
                                                    showOperatorList();
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorsConst.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          selectedOperator !=
                                                                  null
                                                              ? selectedOperator
                                                                  .OperatorName
                                                              : AppTranslations
                                                                      .of(
                                                                          context)
                                                                  .text(
                                                                      "key_select_opertor"),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (circleList != null &&
                                                      circleList.length > 0) {
                                                    showCircleList();
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorsConst.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          selectedCircleCode !=
                                                                  null
                                                              ? widget.menuType ==
                                                                      MenuTypeConst
                                                                          .Cyberplat
                                                                  ? selectedCircleCode
                                                                      .PlanName
                                                                  : selectedCircleCode
                                                                      .CircleName
                                                              : widget.menuType ==
                                                                          MenuTypeConst
                                                                              .Cyberplat &&
                                                                      widget.menuFor ==
                                                                          MenuName
                                                                              .MobileRecharge
                                                                  ? AppTranslations.of(
                                                                          context)
                                                                      .text(
                                                                          "key_recharge_type")
                                                                  : AppTranslations.of(
                                                                          context)
                                                                      .text(
                                                                          "key_select_circle"),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              width: 1.0,
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10) ?? 10,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Row(
                                              children: [
                                                new Expanded(
                                                  child: TextField(
                                                    controller: amoutAccCntl,
                                                    focusNode: amoutFcsNode,
                                                    autofocus: false,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: AppTranslations
                                                              .of(context)
                                                          .text("key_entr_amt"),
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                      labelStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontSize: 12),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: isPlanOfferVisible(),
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      validationForPlan()
                                                          .then((valMsg) {
                                                        if (valMsg == '') {
                                                          if (widget.menuType ==
                                                              MenuTypeConst
                                                                  .Cyberplat) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) => JioPlanPage(
                                                                      subscriberNo:
                                                                          mobileNoAccCntl
                                                                              .text,
                                                                      OpCode: selectedOperator
                                                                          .OpCode,
                                                                      menuFor:
                                                                          widget
                                                                              .menuFor,
                                                                      circleCode:
                                                                          widget
                                                                              .circleCode,
                                                                      paymentStatus:
                                                                          widget
                                                                              .paymentStatus,
                                                                      operatorCode:
                                                                          widget
                                                                              .operatorCode,
                                                                      amount: widget
                                                                          .amount,
                                                                      serviceType:
                                                                          widget
                                                                              .serviceType,
                                                                      serviceName:
                                                                          widget
                                                                              .serviceName,
                                                                      menuType:
                                                                          widget
                                                                              .menuType)),
                                                            );
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      RechargePlanPage(
                                                                        subscriberNo:
                                                                            mobileNoAccCntl.text,
                                                                        OpCode:
                                                                            selectedOperator.OpCode,
                                                                        menuFor:
                                                                            widget.menuFor,
                                                                        circleCode:
                                                                            widget.circleCode,
                                                                        paymentStatus:
                                                                            widget.paymentStatus,
                                                                        operatorCode:
                                                                            widget.operatorCode,
                                                                        amount:
                                                                            widget.amount,
                                                                        serviceType:
                                                                            widget.serviceType,
                                                                        serviceName:
                                                                            widget.serviceName,
                                                                        menuType:
                                                                            widget.menuType,
                                                                      )),
                                                            );
                                                          }
                                                        } else {
                                                          FlushbarMessage.show(
                                                            context,
                                                            valMsg,
                                                            MessageTypes
                                                                .WARNING,
                                                          );
                                                        }
                                                      });
                                                    },
                                                    child: Text(
                                                      AppTranslations.of(
                                                              context)
                                                          .text(
                                                              "key_view_plan"),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .overline
                                                          .copyWith(
                                                              fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Visibility(
                                              visible: widget.menuType !=
                                                      MenuTypeConst.Cyberplat &&
                                                  widget.menuFor ==
                                                      MenuName.DTHRecharge,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  validationForPlan()
                                                      .then((valMsg) {
                                                    if (valMsg == '') {
                                                      if (dthInfo != null) {
                                                        _showDTHCustInfo(
                                                            context, dthInfo);
                                                      }
                                                    } else {
                                                      FlushbarMessage.show(
                                                        context,
                                                        valMsg,
                                                        MessageTypes.WARNING,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_dth_info"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline
                                                      .copyWith(fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.3), //Colors.grey[200],
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                                AppTranslations.of(context)
                                    .text("key_debit_from"),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListView.builder(
                          itemCount: accountList.length,
                          padding: const EdgeInsets.only(top: 0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  for (int i = 0; i < accountList.length; i++) {
                                    accountList[i].isSelected = false;
                                  }
                                  accountList[index].isSelected = true;
                                  selectedAc = accountList[index];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_balance_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                accountList[index]
                                                        .AccountName ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(fontSize: 14),
                                                textAlign: TextAlign.start),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                accountList[index].AccountNo ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        // color: ColorsConst.grey
                                                        ),
                                                textAlign: TextAlign.start),
                                          ],
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          accountList[index].isSelected
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: this.isSelected
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context)
                                                  .secondaryHeaderColor,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Divider(
                                        height: 1.0,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 5, top: 5),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_recharge"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
                            setState(() {
                              _isLoading = true;
                            });
                            SMSAPI(context: context)
                                .GeterateOTP(
                              TransactionType: widget.serviceType,
                              //TransactionType.Pay2NewPrepaidRecharge,
                              RegenerateSMS: "false",
                              OldSMSAutoID: "-1",
                              AccountNumber: "xxxx",
                              Amount: "-1",
                              CustomerID:
                                  AppData.current.customerLogin.user.CustomerID,
                              brcode:
                                  AppData.current.customerLogin.user.BranchCode,
                              PaymentIndicator: "",
                            )
                                .then((res) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (res != null &&
                                  HttpStatusCodes.CREATED == res['Status']) {
                                var data = res["Data"];
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OTPVerificationPage(
                                        customerID: AppData.current
                                            .customerLogin.user.CustomerID,
                                        branchCode: AppData.current
                                            .customerLogin.user.BranchCode,
                                        accountNo: selectedAc.AccountNo,
                                        subscriberNo:
                                            mobileNoAccCntl.text.toString(),
                                        amount: amoutAccCntl.text.toString(),
                                        operatorCode: selectedOperator.OpCode,
                                        //serviceid
                                        circleCode: selectedCircleCode
                                            .circleCode
                                            .toString(),
                                        //PlanID
                                        PlanOffer: widget.planID,
                                        transactionType: widget.serviceType,
                                        //TransactionType.Pay2NewPrepaidRecharge,
                                        smsAutoID: data["SMSAutoID"],
                                        mobileNo: data["MobileNo"],
                                        serviceName: widget.serviceName),
                                  ),
                                );
                              } else {
                                FlushbarMessage.show(
                                  context,
                                  res["Message"],
                                  MessageTypes.WARNING,
                                );
                              }
                            });
                          } else {
                            FlushbarMessage.show(
                              context,
                              valMsg,
                              MessageTypes.WARNING,
                            );
                          }
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getSubcNoTitle() {
    String title = "";
    switch (widget.menuFor) {
      case MenuName.MobileRecharge:
      case MenuName.PostpaidMobileBills:
        title = AppTranslations.of(context).text("key_mobile_no");
        break;
      case MenuName.DataCardRecharge:
        title = AppTranslations.of(context).text("key_data_card_no");
        break;
      case MenuName.DTHRecharge:
        title = AppTranslations.of(context).text("key_dth_no");
        break;
    }
    return title;
  }

  bool isPlanOfferVisible() {
    if (widget.menuType == MenuTypeConst.Cyberplat) {
      if (selectedCircleCode != null && selectedCircleCode.isPlanOffer) {
        return true;
      }
    } else if (widget.menuType == MenuTypeConst.Pay2NewIn &&
        widget.serviceType == ServiceTypeConst.Pay2NewPrepaidRecharge) {
      return true;
    }
    return false;
  }

  Future<void> showOperatorList() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: "Select Operator",
        ),
        actions: List<Widget>.generate(
          operatorList.length,
          (i) => CustomCupertinoAction(
            actionText: operatorList[i].OperatorName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedOperator = operatorList[i];
                widget.operatorCode = selectedOperator.OpCode;
                selectedCircleCode = null;
                widget.circleCode = null;
                if (widget.menuType == MenuTypeConst.Cyberplat) {
                  loadCircleCode(serviceID: selectedOperator.OpCode.toString());
                }
                if (widget.menuType != MenuTypeConst.Cyberplat &&
                    widget.menuFor == MenuName.DTHRecharge &&
                    selectedOperator != null) {
                  if (mobileNoAccCntl.text != null &&
                      mobileNoAccCntl.text != "") {
                    fetchDTHCustInfo();
                  }
                }
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> showCircleList() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: widget.menuType == MenuTypeConst.Cyberplat &&
                  widget.menuFor == MenuName.MobileRecharge
              ? "Recharge Type"
              : "Select Circle",
        ),
        actions: List<Widget>.generate(
          circleList.length,
          (i) => CustomCupertinoAction(
            actionText: widget.menuType == MenuTypeConst.Cyberplat
                ? circleList[i].PlanName
                : circleList[i].CircleName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedCircleCode = circleList[i];
                widget.circleCode = selectedCircleCode.circleCode;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<String> validation() async {
    if (mobileNoAccCntl.text == null || mobileNoAccCntl.text.toString() == '') {
      return getSubcNoTitle() +
          " " +
          AppTranslations.of(context).text("key_is_mand");
    }
    if (widget.menuFor == MenuName.MobileRecharge &&
        mobileNoAccCntl.text.length != 10) {
      return AppTranslations.of(context).text("key_enter_10digit_mobile_no");
    }
    if (selectedOperator == null) {
      return AppTranslations.of(context).text("key_operator_mand");
    }

    if (selectedCircleCode == null) {
      if (widget.menuFor == MenuName.MobileRecharge &&
          widget.menuType == MenuTypeConst.Cyberplat) {
        return AppTranslations.of(context).text("key_recharge_is_required");
      } else {
        return AppTranslations.of(context).text("key_circle_code_mand");
      }
    }
    if (amoutAccCntl.text == null || amoutAccCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_amt_mand");
    }
    if (selectedAc == null) {
      return AppTranslations.of(context).text("key_acc_no_mand");
    }
    return "";
  }

  Future<String> validationForPlan() async {
    if (mobileNoAccCntl.text == null || mobileNoAccCntl.text.toString() == '') {
      return getSubcNoTitle() +
          " " +
          AppTranslations.of(context).text("key_is_mand");
    }
    if (selectedOperator == null) {
      return AppTranslations.of(context).text("key_operator_mand");
    }
    return "";
  }

  void loadOperator() {
    BBPSAPI(context: this.context)
        .getOperatorCode(
            menuType: widget.menuType,
            ServiceType: widget.menuType == MenuTypeConst.Cyberplat
                ? widget.serviceType
                : P2NServiceTypeConst.PrepaidMobile,
            ServiceName: widget.serviceName)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          try {
            operatorList =
                List<Operator>.from(data.map((i) => Operator.fromMap(i)));
            if (widget.operatorCode != null && widget.operatorCode != "") {
              selectedOperator = operatorList
                  .where((i) => i.OpCode == widget.operatorCode)
                  .first;
              if (widget.menuType == MenuTypeConst.Cyberplat) {
                loadCircleCode(serviceID: selectedOperator.OpCode.toString());
              }
              if (widget.menuType != MenuTypeConst.Cyberplat &&
                  widget.menuFor == MenuName.DTHRecharge &&
                  selectedOperator != null) {
                if (mobileNoAccCntl.text != null &&
                    mobileNoAccCntl.text != "") {
                  fetchDTHCustInfo();
                }
              }
            }
          } catch (e) {
            print(e);
          }
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

  void loadCircleCode({String serviceID}) {
    BBPSAPI(context: this.context)
        .getCircleCode(menuType: widget.menuType, ServiceID: serviceID)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          circleList =
              List<CircleCode>.from(data.map((i) => CircleCode.fromMap(i)));

          if (widget.circleCode != null && widget.circleCode != "") {
            if (widget.menuType != MenuTypeConst.Cyberplat) {
              selectedCircleCode = circleList
                  .where((i) => i.circleCode == widget.circleCode)
                  .first;
            } else {
              selectedCircleCode = circleList
                  .where((i) =>
                      i.ServiceID.toString() == widget.operatorCode &&
                      i.circleCode == widget.circleCode)
                  .first;
            }
          }
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

  void _showDTHCustInfo(BuildContext context, DthInfo dthInfo) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new CupertinoAlertDialog(
            title: new Text(
              AppTranslations.of(context).text("key_dth_info"),
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_customer_name"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.customer_name,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_monthly_plan"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.monthly_plan.toString(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_account_balance"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.account_balance,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_next_due"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.next_due,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_last_recharge_date"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.last_recharge_date ?? '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                  child: Divider(
                    height: 1.0,
                    color: Colors.grey[400],
                  ),
                ),
                Text(AppTranslations.of(context).text("key_last_recharge"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.start),
                Text(dthInfo.last_recharge,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.start),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void fetchMNPOperator() {
    Pay2NewAPI(context: this.context)
        .getMNPOperatorFetch(MobileNumber: mobileNoAccCntl.text.toString())
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        var opdata = data["data"];

        if (opdata != null) {
          setState(() {
            selectedOperator = operatorList
                .where((i) => i.OpCode == opdata["operator_code"])
                .first;

            selectedCircleCode = circleList
                .where((i) => i.circleCode == opdata["circle_code"])
                .first;
          });
        }
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }

  void fetchDTHCustInfo() {
    Pay2NewAPI(context: this.context)
        //.getDTHCustInfo(DTHNumber: mobileNoAccCntl.text.toString(),OperatorCode :selectedOperator.OpCode)
        .getDTHCustInfo(DTHNumber: "1304557679", OperatorCode: "TSD")
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          dthInfo = DthInfo.fromJson(data);
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
}
