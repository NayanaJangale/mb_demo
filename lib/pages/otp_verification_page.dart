import 'dart:io';
import 'dart:ui';

import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/api/fixeddepositapi.dart';
import 'package:softcoremobilebanking/api/pay2newapi.dart';
import 'package:softcoremobilebanking/api/paymentapi.dart';
import 'package:softcoremobilebanking/api/recurringdepositapi.dart';
import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_successfully_dialog.dart';
import 'package:softcoremobilebanking/components/receipt.dart';
import 'package:softcoremobilebanking/constants/beneficiary_type.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/cyberplatRecharge.dart';
import 'package:softcoremobilebanking/models/inter_bank_transfer.dart';
import 'package:softcoremobilebanking/pages/change_pswd_page.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_fund_tran_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../app_data.dart';
import '../components/custom_progress_handler.dart';
import '../components/flushbar_message.dart';
import '../constants/message_types.dart';
import 'confirm_access_pin_page.dart';
import 'login_page.dart';
import 'navigation_home_screen.dart';

class OTPVerificationPage extends StatefulWidget {
  String transactionType,
      customerID,
      smsAutoID,
      mobileNo,
      branchCode,
      debitAccountNo,
      fdTypeCode,
      accountNo,
      name,
      intrCode,
      depositAmount,
      duration,
      durationType,
      interestRate,
      interestAmount,
      maturityAmount,
      maturityDate,
      rdTypeCode,
      creditBranchCode,
      debitBranchCode,
      creditAccountNo,
      ifscCode,
      entNo,
      bankName,
      city,
      paymentIndicator,
      benefName,
      bankNo,
      subscriberNo,
      amount,
      operatorCode,
      circleCode,
      billingUnitNo,
      Authenticator3,
      serviceName,
      PlanOffer,
      remark;
  InterBankTransfer interBankTransfer;

  OTPVerificationPage({
    this.transactionType,
    this.customerID,
    this.smsAutoID,
    this.mobileNo,
    this.branchCode,
    this.debitAccountNo,
    this.fdTypeCode,
    this.intrCode,
    this.depositAmount,
    this.duration,
    this.durationType,
    this.interestRate,
    this.interestAmount,
    this.maturityAmount,
    this.maturityDate,
    this.rdTypeCode,
    this.creditAccountNo,
    this.creditBranchCode,
    this.debitBranchCode,
    this.remark,
    this.accountNo,
    this.name,
    this.ifscCode,
    this.bankName,
    this.city,
    this.entNo,
    this.paymentIndicator,
    this.benefName,
    this.bankNo,
    this.subscriberNo,
    this.amount,
    this.operatorCode,
    this.circleCode,
    this.billingUnitNo,
    this.Authenticator3,
    this.serviceName,
    this.PlanOffer,
    this.interBankTransfer,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  bool _isLoading, isTimerEnd = false;
  String _loadingText;
  TextEditingController otpController = TextEditingController();
  FocusNode _otpFocusNode = FocusNode();
  int timerSec = 180;
  final GlobalKey<ScaffoldState> _otpScaffoldKey =
      new GlobalKey<ScaffoldState>();
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
    return WillPopScope(
      onWillPop: () {
        onBackPressedAlert(context);
      },
      child: CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Container(
          color: Colors.grey[100],
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              key: _otpScaffoldKey,
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomAppbar(
                      backButtonVisibility: true,
                      onBackPressed: () {
                        onBackPressedAlert(context);
                      },
                      caption:
                          AppTranslations.of(context).text("key_otp_verification"),
                    ),
                    SizedBox(
                      height: 90,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppTranslations.of(context)
                                  .text("key_plz_entr_otp_on_mobileno") +
                              (widget.mobileNo != null
                                  ? widget.mobileNo
                                      .substring(widget.mobileNo.length - 4)
                                  : ''),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    buildTimer(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: PinInputTextFormField(
                              pinLength: 6,
                              decoration: BoxLooseDecoration(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(),
                                strokeColorBuilder: PinListenColorBuilder(
                                    Theme.of(context).primaryColorDark,
                                    Colors.grey[400]),
                                bgColorBuilder: true
                                    ? PinListenColorBuilder(
                                        Colors.white.withOpacity(0.5),
                                        Colors.white.withOpacity(0.5))
                                    : null,
                              ),
                              controller: otpController,
                              textInputAction: TextInputAction.done,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              focusNode: _otpFocusNode,
                              onSubmit: (pin) {},
                              onChanged: (pin) {},
                              onSaved: (pin) {},
                              validator: (pin) {},
                              cursor: Cursor(
                                width: 2,
                                color: Theme.of(context).primaryColorDark,
                                radius: Radius.circular(1),
                                enabled: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: CustomDarkButton(
                                    caption: AppTranslations.of(context)
                                        .text("key_continue"),
                                    onPressed: () {
                                      if (otpController.text.length != 0) {
                                        if (!isTimerEnd) {
                                          callOTPVerfication();
                                        } else {
                                          FlushbarMessage.show(
                                            context,
                                            AppTranslations.of(context).text(
                                                "key_otp_expired_clck_resend"),
                                            MessageTypes.WARNING,
                                          );
                                        }
                                      } else {
                                        FlushbarMessage.show(
                                          context,
                                          AppTranslations.of(context)
                                              .text("key_otp_mandatory"),
                                          MessageTypes.WARNING,
                                        );
                                      }
                                    }),
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: CustomDarkButton(
                                      caption: AppTranslations.of(context)
                                          .text("key_resend"),
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        SMSAPI(context: context)
                                            .GeterateOTP(
                                          TransactionType: widget.transactionType,
                                          RegenerateSMS: "true",
                                          OldSMSAutoID: widget.smsAutoID,
                                          AccountNumber: "xxxx",
                                          Amount: "-1",
                                          CustomerID: AppData.current.customerLogin
                                              .user.CustomerID,
                                          brcode: AppData.current.customerLogin.user
                                              .BranchCode,
                                          PaymentIndicator: "",
                                        )
                                            .then((res) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          if (res != null &&
                                              HttpStatusCodes.CREATED ==
                                                  res['Status']) {
                                            var data = res["Data"];
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => OTPVerificationPage(
                                                  transactionType:
                                                      widget.transactionType,
                                                  customerID: AppData
                                                      .current
                                                      .customerLogin
                                                      .user
                                                      .CustomerID,
                                                  branchCode: widget.branchCode,
                                                  debitAccountNo:
                                                      widget.debitAccountNo,
                                                  fdTypeCode: widget.fdTypeCode,
                                                  intrCode: widget.intrCode,
                                                  depositAmount:
                                                      widget.depositAmount,
                                                  duration: widget.duration,
                                                  durationType: widget.durationType,
                                                  interestRate: widget.interestRate,
                                                  interestAmount:
                                                      widget.interestAmount,
                                                  maturityAmount:
                                                      widget.maturityAmount,
                                                  maturityDate: widget.maturityDate,
                                                  rdTypeCode: widget.rdTypeCode,
                                                  creditAccountNo:
                                                      widget.creditAccountNo,
                                                  creditBranchCode:
                                                      widget.creditBranchCode,
                                                  debitBranchCode:
                                                      widget.debitBranchCode,
                                                  remark: widget.remark,
                                                  accountNo: widget.accountNo,
                                                  name: widget.name,
                                                  ifscCode: widget.ifscCode,
                                                  bankName: widget.bankName,
                                                  city: widget.city,
                                                  entNo: widget.entNo,
                                                  paymentIndicator:
                                                      widget.paymentIndicator,
                                                  benefName: widget.benefName,
                                                  bankNo: widget.bankNo,
                                                  amount: widget.amount,
                                                  Authenticator3:
                                                      widget.Authenticator3,
                                                  billingUnitNo:
                                                      widget.billingUnitNo,
                                                  circleCode: widget.circleCode,
                                                  operatorCode: widget.operatorCode,
                                                  PlanOffer: widget.PlanOffer,
                                                  serviceName: widget.serviceName,
                                                  subscriberNo: widget.subscriberNo,
                                                  interBankTransfer:
                                                      widget.interBankTransfer,
                                                  smsAutoID: data["SMSAutoID"],
                                                  mobileNo: data["MobileNo"],
                                                ),
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
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppTranslations.of(context).text("key_code_expr_in"),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: timerSec, end: 0.0),
          duration: Duration(seconds: timerSec),
          builder: (_, value, child) => Text(
            "${value.toInt()}",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
                fontSize: 12),
          ),
          onEnd: () {
            isTimerEnd = true;
          },
        ),
      ],
    );
  }

  void callOTPVerfication() {
    switch (widget.transactionType) {
      case TransactionType.AccessPINRegistration:
        setState(() {
          _isLoading = true;
        });
        SMSAPI(context: context)
            .ValidateOTPForAccessPIN(widget.customerID, widget.smsAutoID,
                otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.OK == res['Status']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmAccessPINPage(
                  CustomerID: widget.customerID,
                  OTP: otpController.text.toString(),
                  SMSAutoID: widget.smsAutoID,
                ),
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
        break;
      case TransactionType.ForgotPassword:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePasswordPage(
              smsAutoID: widget.smsAutoID,
              customerID: widget.customerID,
              transactionType: widget.transactionType,
              otp: otpController.text.toString(),
            ),
          ),
        );
        break;
      case TransactionType.FDAccountOpening:
        setState(() {
          _isLoading = true;
        });

        FixedDepositAPI(context: context)
            .OpenAccount(
                CustomerID: widget.customerID,
                BranchCode: widget.branchCode,
                DebitAccountNo: widget.debitAccountNo,
                FDTypeCode: widget.fdTypeCode,
                IntrCode: widget.intrCode,
                DepositAmount: widget.depositAmount,
                Duration: widget.duration,
                DurationType: widget.durationType,
                InterestRate: widget.interestRate,
                MaturityAmount: widget.maturityAmount,
                MaturityDate: widget.maturityDate,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.OK == res['Status']) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CustomSuccessfullyDialog(
                actionName: AppTranslations.of(context).text("key_ok"),
                onActionTapped: () {
                  AppData.current.customerLogin.oAccounts = [];
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationHomeScreen(),
                    ),
                  );
                },
                message: res["Message"] ?? "",
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
        break;
      case TransactionType.RDAccountOpening:
        setState(() {
          _isLoading = true;
        });
        RecurringDepositAPI(context: context)
            .OpenAccount(
                CustomerID: widget.customerID,
                BranchCode: widget.branchCode,
                DebitAccountNo: widget.debitAccountNo,
                RDTypeCode: widget.rdTypeCode,
                DepositAmount: widget.depositAmount,
                Duration: widget.duration,
                InterestRate: widget.interestRate,
                MaturityAmount: widget.maturityAmount,
                MaturityDate: widget.maturityDate,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CustomSuccessfullyDialog(
                actionName: AppTranslations.of(context).text("key_ok"),
                onActionTapped: () {
                  AppData.current.customerLogin.oAccounts = [];
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationHomeScreen(),
                    ),
                  );
                },
                message: res["Message"] ?? "",
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
        break;
      case TransactionType.SelfAccountTransfer:
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .transferAmount(
                CreditBranchCode: widget.creditBranchCode,
                CreditAccountNo: widget.creditAccountNo,
                Amount: widget.depositAmount,
                DebitAccountNo: widget.debitAccountNo,
                DebitBranchCode: widget.debitBranchCode,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
            AppData.current.customerLogin.oAccounts = [];
            Receipt(context: context).selfTranRecpt(
                creditAccountNo: widget.creditAccountNo,
                debitAccountNo: widget.debitAccountNo,
                depositAmount: widget.depositAmount);
          } else {
            FlushbarMessage.show(
              context,
              res["Message"],
              MessageTypes.WARNING,
            );
          }
        });
        break;
      case TransactionType.AddIntraBankBeneficiaryRequest:
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .addIntraBankBeneficiary(
                CustomerID: widget.customerID,
                BeneficiaryAccountNo: widget.accountNo,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString(),
                BeneficiaryBranchCode: widget.branchCode,
                BeneficiaryNickName: widget.name)
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.CREATED == res['Status']) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CustomSuccessfullyDialog(
                actionName: AppTranslations.of(context).text("key_ok"),
                onActionTapped: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SelectAccountForFundTransferPage(
                        beneficiaryType:
                            BeneficiaryTypeConst.IntraBankBeneficiary,
                      ),
                    ),
                    (route) => false,
                  );
                },
                message: res["Message"] ?? "",
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
        break;
      case TransactionType.AddInterBankBeneficiaryRequest:
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .addInterBankBeneficiary(
          CustomerID: widget.customerID,
          BenefAcNo: widget.accountNo,
          BenefBankName: widget.bankName,
          BenefBankNo: widget.entNo,
          BenefCity: widget.city,
          BenefMobileNo: widget.mobileNo,
          BenefName: widget.name,
          IFSCCode: widget.ifscCode,
          SMSAutoID: widget.smsAutoID,
          OTP: otpController.text.toString(),
        )
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.CREATED == res['Status']) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CustomSuccessfullyDialog(
                actionName: AppTranslations.of(context).text("key_ok"),
                onActionTapped: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SelectAccountForFundTransferPage(
                        beneficiaryType:
                            BeneficiaryTypeConst.InterBankBeneficiary,
                      ),
                    ),
                    (route) => false,
                  );
                },
                message: res["Message"] ?? "",
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
        break;
      case TransactionType.InterBankTransfer:
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .interBankTransfer(
                interBankTransfer: widget.interBankTransfer,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
            AppData.current.customerLogin.oAccounts = [];
            Receipt(context: context).interBankTranRecpt(
              depositAmount: widget.interBankTransfer.Amount.toString(),
              debitAccountNo: widget.interBankTransfer.CustAcNo,
              benfAcNo: widget.interBankTransfer.BenefAcNo,
              benfBankName: widget.interBankTransfer.benfBankName,
              benfName: widget.interBankTransfer.BenefName,
              charges: widget.interBankTransfer.Charge.toString(),
            );
          } else {
            FlushbarMessage.show(
              context,
              res["Message"],
              MessageTypes.WARNING,
            );
          }
        });
        break;
      case TransactionType.IntraBankTransfer:
        setState(() {
          _isLoading = true;
        });
        CustomerAPI(context: context)
            .transferAmount(
                CreditBranchCode: widget.creditBranchCode,
                CreditAccountNo: widget.creditAccountNo,
                Amount: widget.depositAmount,
                DebitAccountNo: widget.debitAccountNo,
                DebitBranchCode: widget.debitBranchCode,
                SMSAutoID: widget.smsAutoID,
                OTP: otpController.text.toString())
            .then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res != null && HttpStatusCodes.ACCEPTED == res['Status']) {
            AppData.current.customerLogin.oAccounts = [];
            Receipt(context: context).selfTranRecpt(
                creditAccountNo: widget.creditAccountNo,
                debitAccountNo: widget.debitAccountNo,
                depositAmount: widget.depositAmount);
          } else {
            FlushbarMessage.show(
              context,
              res["Message"],
              MessageTypes.WARNING,
            );
          }
        });
        break;
      case TransactionType.Pay2NewPrepaidRecharge:
      case TransactionType.Pay2NewPostpaidBills:
        postPay2NewRecharge();
        break;
      case TransactionType.PrepaidRecharge:
      case TransactionType.PostpaidBills:
        postCyberRecharge();
        break;
    }
  }

  void onBackPressedAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return new CupertinoAlertDialog(
              title: new Text(
                AppTranslations.of(context).text("key_alert_msg"),
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
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    AppTranslations.of(context)
                        .text("key_do_you_want_cancel_trans"),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    onBackPressed(context);
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_yes"),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppTranslations.of(context).text("key_no"),
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

  void onBackPressed(BuildContext context) {
    if (widget.transactionType != TransactionType.AccessPINRegistration ||
        widget.transactionType != TransactionType.ForgotPassword ||
        widget.transactionType != TransactionType.SignUP) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavigationHomeScreen(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  void postPay2NewRecharge() {
    setState(() {
      _isLoading = true;
    });
    Pay2NewAPI(context: this.context)
        .postPrepaidRecharge(
            RechargeType: widget.serviceName,
            CustomerID: widget.customerID,
            CustomerBranchCode: widget.branchCode,
            CustomerAccountNo: widget.accountNo,
            SubscriberNo: widget.subscriberNo,
            ServiceType: widget.transactionType,
            OperatorCode: widget.operatorCode,
            SMSAutoID: widget.smsAutoID,
            CircleCode: widget.circleCode,
            billingUnitNo: widget.billingUnitNo ?? "",
            Amount: widget.amount,
            OTP: otpController.text.toString())
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        AppData.current.customerLogin.oAccounts = [];
        Receipt(context: context).rechargeReceipt(
            accountNo: widget.accountNo,
            amount: widget.amount,
            serviceName: widget.serviceName,
            subscriberNo: widget.subscriberNo);
      } else {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            message: Text(
              res["Message"],
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationHomeScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        );
      }
    });
  }

  void postCyberRecharge() {
    setState(() {
      _isLoading = true;
    });

    CyberplatRecharge cyberplatRecharge = CyberplatRecharge();
    cyberplatRecharge.DebitAmount = double.parse(widget.amount);
    cyberplatRecharge.CustomerAccountNo = widget.accountNo;
    cyberplatRecharge.AliasName = widget.name ?? "";
    cyberplatRecharge.ServiceID = widget.operatorCode;
    cyberplatRecharge.SubscriberNo = widget.subscriberNo;
    cyberplatRecharge.CustomerID = widget.customerID;
    cyberplatRecharge.Account = widget.billingUnitNo ?? "";
    cyberplatRecharge.Charges = "0";
    cyberplatRecharge.Authenticator3 = widget.Authenticator3 ?? "";
    cyberplatRecharge.OTP = otpController.text.toString();
    cyberplatRecharge.CustomerBranchCode = widget.branchCode;
    cyberplatRecharge.PlanID = widget.circleCode;
    cyberplatRecharge.PlanOffer = widget.PlanOffer ?? "1";
    cyberplatRecharge.SaveSubscriberNo = "true";
    cyberplatRecharge.SMSAutoID = widget.smsAutoID;

    PaymentAPI(context: this.context)
        .postCyberRecharge(cyberplatRecharge: cyberplatRecharge)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        AppData.current.customerLogin.oAccounts = [];
        Receipt(context: context).rechargeReceipt(
            accountNo: widget.accountNo,
            amount: widget.amount,
            serviceName: widget.serviceName,
            subscriberNo: widget.subscriberNo);
      } else {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            message: Text(
              res["Message"],
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationHomeScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        );
      }
    });
  }
}
