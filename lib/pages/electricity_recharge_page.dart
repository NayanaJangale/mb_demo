import 'package:softcoremobilebanking/api/bbpsapi.dart';
import 'package:softcoremobilebanking/api/pay2newapi.dart';
import 'package:softcoremobilebanking/api/paymentapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_spinner_item.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/account_type_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/service_type_constant.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/circleCode.dart';
import 'package:softcoremobilebanking/models/operator.dart';
import 'package:softcoremobilebanking/pages/otp_verification_page.dart';
import 'package:softcoremobilebanking/pages/recent_bill_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu_help_page.dart';

class ElectricityRechargePage extends StatefulWidget {
  String amount,
      subscriberNo,
      serviceName,
      serviceType,
      menuType,
      operatorCode,
      circleCode,
      connectionName,
      paymentStatus,
      menuFor;

  ElectricityRechargePage({
    this.subscriberNo,
    this.amount,
    this.serviceName,
    this.serviceType,
    this.menuType,
    this.operatorCode,
    this.circleCode,
    this.connectionName,
    this.menuFor,
    this.paymentStatus,
  });

  @override
  _ElectricityRechargePageState createState() =>
      _ElectricityRechargePageState();
}

class _ElectricityRechargePageState extends State<ElectricityRechargePage> {
  bool _isLoading, isSelected = true;
  String _loadingText, selectedConnection;
  List<Account> accountList = [];
  Account selectedAc;
  final GlobalKey<ScaffoldState> electricityRechargeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController amoutAccCntl = TextEditingController();
  TextEditingController billingUnitAccCntl = TextEditingController();
  TextEditingController processingCycleAccCntl = TextEditingController();
  TextEditingController consumerNoAccCntl = TextEditingController();

  FocusNode amoutFcsNode = FocusNode();
  FocusNode billingUnitFcsNode = FocusNode();
  FocusNode processingCycleNode = FocusNode();
  FocusNode consumerNoNode = FocusNode();
  List<String> connection = ['Home', 'Office'];
  List<Operator> operatorList = [];
  Operator selectedOperator;
  List<CircleCode> circleList = [];
  CircleCode selectedCircleCode;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
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
    if (widget.connectionName != null && widget.connectionName != "") {
      if (connection.where((i) => i == widget.connectionName).isNotEmpty) {
        selectedConnection =
            connection.where((i) => i == widget.connectionName).first;
      } else {
        selectedConnection = connection[0];
      }
    }
    if (widget.amount != null && widget.amount != "") {
      amoutAccCntl.text = widget.amount;
    }
    if (widget.subscriberNo != null && widget.subscriberNo != "") {
      setState(() {
        consumerNoAccCntl.text = widget.subscriberNo;
      });
    }
    if (widget.menuType != MenuTypeConst.Cyberplat) {
      billingUnitAccCntl.addListener(() {
        if (billingUnitAccCntl.text.length == 4 &&
            consumerNoAccCntl.text != null &&
            consumerNoAccCntl.text != "" &&
            selectedOperator != null) {
          fetchElectricityBillFetch();
        }
      });
    }
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
            key: electricityRechargeScaffoldKey,
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
                            String connectionServerMsg = await NetworkHandler
                                .getServerWorkingUrl();
                            if (connectionServerMsg != "key_check_internet") {
                              String url;
                              if (widget.menuType == MenuTypeConst.Cyberplat) {
                                url =connectionServerMsg + "/CustCommonAppApi/help/CyberplatElectricity.pdf";
                              }else if (widget.menuType == MenuTypeConst.Pay2New) {
                                url =connectionServerMsg + "/CustCommonAppApi/help/Pay2NewElectricity.pdf";
                              }
                              if(url != null){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MenuHelpPage(
                                          menuName: AppTranslations.of(context).text(
                                              "key_electricity_bills"),
                                          pdfURL:url,
                                        ),
                                  ),
                                );
                              }
                            }else{
                              FlushbarMessage.show(
                                context,
                                connectionServerMsg,
                                MessageTypes.WARNING,
                              );
                            }
                          },
                        ),
                        getInputWidgetOfPaytoNewAndCyberplat(context),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.3), //Colors.grey[200],
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                                AppTranslations.of(context).text("key_debit_from"),
                                style: Theme.of(context).textTheme.caption.copyWith(
                                    color: Theme.of(context).primaryColorDark,
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
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                accountList[index].AccountName ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(fontSize: 14),
                                                textAlign: TextAlign.start),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(accountList[index].AccountNo ?? '',
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
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_payment"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
                            setState(() {
                              _isLoading = true;
                            });
                            SMSAPI(context: context)
                                .GeterateOTP(
                              TransactionType: TransactionType.Pay2NewPostpaidBills,
                              RegenerateSMS: "false",
                              OldSMSAutoID: "-1",
                              AccountNumber: "xxxx",
                              Amount: "-1",
                              CustomerID:
                                  AppData.current.customerLogin.user.CustomerID,
                              brcode: AppData.current.customerLogin.user.BranchCode,
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
                                        customerID: AppData
                                            .current.customerLogin.user.CustomerID,
                                        branchCode: AppData
                                            .current.customerLogin.user.BranchCode,
                                        accountNo: selectedAc.AccountNo,
                                        subscriberNo:
                                            consumerNoAccCntl.text.toString(),
                                        amount: amoutAccCntl.text.toString(),
                                        operatorCode: selectedOperator.OpCode,
                                        //serviceid
                                        circleCode: selectedCircleCode.circleCode
                                            .toString(),
                                        //PlanID
                                        transactionType: widget.serviceType,
                                        //TransactionType.Pay2NewPrepaidRecharge,
                                        smsAutoID: data["SMSAutoID"],
                                        mobileNo: data["MobileNo"],
                                        billingUnitNo:
                                            billingUnitAccCntl.text.toString(),
                                        Authenticator3:
                                            processingCycleAccCntl.text.toString(),
                                        name: selectedConnection,
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

  getInputWidgetOfPaytoNewAndCyberplat(BuildContext context) {
    return Padding(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      autofoucus: false,
                      isIcon: false,
                      textEditingController: consumerNoAccCntl,
                      focusNode: consumerNoNode,
                      borderRadius: 10,
                      onFieldSubmitted: (value) {
                        this.consumerNoNode.unfocus();
                      },
                      icon: Icons.monetization_on_outlined,
                      hint: AppTranslations.of(context).text("key_customer_no"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      selectedOperator != null
                                          ? selectedOperator.OperatorName
                                          : AppTranslations.of(context)
                                              .text("key_select_opertor"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(color: Colors.grey),
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
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.menuType == MenuTypeConst.Cyberplat
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showConnectionList();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorsConst.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            selectedConnection != null
                                                ? selectedConnection
                                                : AppTranslations.of(context)
                                                    .text("key_connection"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(color: Colors.grey),
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
                                ),
                              )
                            : Expanded(
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
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            selectedCircleCode != null
                                                ? selectedCircleCode.CircleName
                                                : AppTranslations.of(context)
                                                    .text("key_circle_name"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(color: Colors.grey),
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
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      autofoucus: false,
                      isIcon: false,
                      textEditingController: billingUnitAccCntl,
                      focusNode: billingUnitFcsNode,
                      borderRadius: 10,
                      onFieldSubmitted: (value) {
                        this.billingUnitFcsNode.unfocus();
                      },
                      icon: Icons.monetization_on_outlined,
                      hint:
                          AppTranslations.of(context).text("key_billing_unit"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10) ?? 10,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            new Expanded(
                              child: TextField(
                                controller: amoutAccCntl,
                                focusNode: amoutFcsNode,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppTranslations.of(context)
                                      .text("key_entr_amt"),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Colors.grey, fontSize: 12),
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 12),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: widget.menuType == MenuTypeConst.Cyberplat,
                      child: CustomTextField(
                        keyboardType: TextInputType.number,
                        autofoucus: false,
                        isIcon: false,
                        textEditingController: processingCycleAccCntl,
                        focusNode: processingCycleNode,
                        borderRadius: 10,
                        onFieldSubmitted: (value) {
                          this.processingCycleNode.unfocus();
                        },
                        icon: Icons.monetization_on_outlined,
                        hint: AppTranslations.of(context)
                            .text("key_processing_cycle"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> showConnectionList() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_connection"),
        ),
        actions: List<Widget>.generate(
          connection.length,
          (i) => CustomCupertinoAction(
            actionText: connection[i],
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedConnection = connection[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void loadOperator() {
    BBPSAPI(context: this.context)
        .getOperatorCode(
            menuType: widget.menuType,
            ServiceType: widget.serviceType,
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
              if (widget.menuType != MenuTypeConst.Cyberplat) {
                if (billingUnitAccCntl.text.length == 4 &&
                    consumerNoAccCntl.text != null &&
                    consumerNoAccCntl.text != "") {
                  fetchElectricityBillFetch();
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

  Future<void> showOperatorList() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_opertor"),
        ),
        actions: List<Widget>.generate(
          operatorList.length,
          (i) => CustomCupertinoAction(
            actionText: operatorList[i].OperatorName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedOperator = operatorList[i];
                selectedCircleCode = null;
                if (widget.menuType == MenuTypeConst.Cyberplat) {
                  loadCircleCode(serviceID: selectedOperator.OpCode.toString());
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
          message: AppTranslations.of(context).text("key_select_circle"),
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
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<String> validation() async {
    if (selectedOperator == null) {
      return AppTranslations.of(context).text("key_operator_mand");
    }
    if (amoutAccCntl.text == null || amoutAccCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_amt_mand");
    }
    if (selectedAc == null) {
      return AppTranslations.of(context).text("key_loan_type_mand");
    }
    if (widget.menuType == MenuTypeConst.Cyberplat) {
      if (selectedConnection == null) {
        return AppTranslations.of(context).text("key_select_acc_type");
      }
      if (processingCycleAccCntl.text == null) {
        return AppTranslations.of(context)
            .text("key_processing_cycle_is_required");
      }
    } else {
      if (selectedCircleCode == null) {
        return AppTranslations.of(context).text("key_circle_code_mand");
      }
    }
    if (billingUnitAccCntl.text == null ||
        billingUnitAccCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_bill_unit_is_required");
    }
    return "";
  }

  void fetchElectricityBillFetch() {
    Pay2NewAPI(context: this.context)
        .getElectricityBillFetch(
            ConsumerNumber: consumerNoAccCntl.text.toString(),
            MobileNumber: "1234567890",
            OperatorCode: "MSEDCL", //selectedOperator.OpCode,
            Validator: billingUnitAccCntl.text)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        var billdata = data["bill"];

        if (billdata != null &&
            billdata["amount"] != null &&
            billdata["amount"] != "") {
          setState(() {
            amoutAccCntl.text = billdata["amount"];
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
}
