import 'dart:io';

import 'package:softcoremobilebanking/api/sms.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/transaction_type.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../app_data.dart';
import '../components/custom_progress_handler.dart';
import '../components/custom_text_field.dart';
import '../components/flushbar_message.dart';
import '../constants/message_types.dart';
import 'otp_verification_page.dart';

class SignUpPage extends StatefulWidget {
  String transactionType;

  SignUpPage({this.transactionType});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading;
  String _loadingText;
  String deviceId = "";
  TextEditingController customerIDController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  FocusNode _customerIDFocusNode = FocusNode();
  FocusNode _bankCodeFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _signupScaffoldKey =
      new GlobalKey<ScaffoldState>();
  File photoImgFile;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    NetworkHandler.getId().then((res) {
      setState(() {
        deviceId = res;
        AppData.current.MacAddress = deviceId;
      });
    });
    _isLoading = false;
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
                backgroundColor: Theme.of(context).backgroundColor,
                key: _signupScaffoldKey,
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 240,
                        child:  Image.asset(
                          "assets/images/banner.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppTranslations.of(context)
                              .text("key_confirm_custid_bankregcode"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              autofoucus: false,
                              maxLength: 10,
                              isIcon: true,
                              borderRadius: 10,
                              textEditingController: customerIDController,
                              focusNode: _customerIDFocusNode,
                              onFieldSubmitted: (value) {
                                this._customerIDFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(this._bankCodeFocusNode);
                              },
                              icon: Icons.person_outline_outlined,
                              hint: AppTranslations.of(context)
                                  .text("key_customer_id"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              autofoucus: false,
                              isIcon: true,
                              borderRadius: 10,
                              textEditingController: bankCodeController,
                              focusNode: _bankCodeFocusNode,
                              onFieldSubmitted: (value) {
                                this._bankCodeFocusNode.unfocus();
                              },
                              icon: Icons.account_balance_outlined,
                              hint: AppTranslations.of(context)
                                  .text("key_bank_reg_code"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible:
                                  widget.transactionType == TransactionType.SignUP,
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        PickedFile compressedImage =
                                            await imagePicker.getImage(
                                          source: ImageSource.camera,
                                          imageQuality: 100,
                                        );
                                        setState(() {
                                          this.photoImgFile =
                                              File(compressedImage.path);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorsConst.white.withOpacity(0.5),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                AppTranslations.of(context)
                                                    .text("key_photo"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.grey,
                                                      //fontWeight: FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                            photoImgFile == null
                                                ? Container(
                                                    width: 70,
                                                    height: 70,
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor
                                                        .withOpacity(0.3),
                                                    child: Center(
                                                      child: Text(
                                                        AppTranslations.of(context)
                                                            .text(
                                                                "key_select_image"),
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                              color:
                                                                  Theme.of(context)
                                                                      .primaryColor,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                      ),
                                                    ),
                                                  )
                                                : Image.file(
                                                    photoImgFile,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10),
                              child: CustomDarkButton(
                                  caption: AppTranslations.of(context)
                                      .text("key_confirm"),
                                  onPressed: () {
                                    String valMsg = getValidationMessage();
                                    if (valMsg != '') {
                                      FlushbarMessage.show(
                                        context,
                                        valMsg,
                                        MessageTypes.WARNING,
                                      );
                                    } else {
                                      AppData.current.ClientCode =
                                          bankCodeController.text.toString();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      SMSAPI(context: this.context)
                                          .GeterateOTP(
                                        TransactionType:widget.transactionType,
                                        RegenerateSMS: "false",
                                        OldSMSAutoID:"-1",
                                        AccountNumber :"xxxx",
                                        Amount :"-1",
                                        CustomerID :customerIDController.text.toString(),
                                        brcode: AppData.current.customerLogin ==null ? '':AppData.current.customerLogin.user.BranchCode,
                                        PaymentIndicator :"",
                                      ).then((res) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (res != null &&
                                            HttpStatusCodes.CREATED ==
                                                res['Status']) {
                                          var data = res["Data"];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => OTPVerificationPage(
                                                transactionType:
                                                    widget.transactionType,
                                                customerID: customerIDController
                                                    .text
                                                    .toString(),
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
                                    }
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  String getValidationMessage() {
    if (customerIDController.text.length == 0 ||
        customerIDController.text.length != 10) {
      return AppTranslations.of(context).text("key_plz_entr10_digit_custid");
    }
    if (bankCodeController.text.length == 0) {
      return AppTranslations.of(context).text("key_plz_entr_bank_reg_code");
    }
    if (widget.transactionType == TransactionType.SignUP) {
      if (photoImgFile == null) {
        return AppTranslations.of(context).text("key_selfie_mandatory");
      }
    }
    return '';
  }
}
