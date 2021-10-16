import 'dart:math';

import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:softcoremobilebanking/pages/welcome_page.dart';

class EMICalculatorPage extends StatefulWidget {
  @override
  _EMICalculatorPageState createState() => _EMICalculatorPageState();
}

class _EMICalculatorPageState extends State<EMICalculatorPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> EMICalculatorKey = new GlobalKey<ScaffoldState>();

  TextEditingController principalAmtController;
  TextEditingController intrRateController;
  TextEditingController yrController;

  FocusNode principalAmtFocusNode;
  FocusNode intrRateFocusNode;
  FocusNode yrFocusNode;
  double i,
      y,
      Principal,
      Rate,
      Months,
      Dvdnt,
      FD,
      D,
      emi=00.00000,
      totalAmt = 00.00000,
      totalIntr = 00.00000;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;

    principalAmtController = TextEditingController();
    intrRateController = TextEditingController();
    yrController = TextEditingController();

    principalAmtFocusNode = FocusNode();
    intrRateFocusNode = FocusNode();
    yrFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child:Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
            key: EMICalculatorKey,
            backgroundColor: Theme.of(context).backgroundColor,
            body:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CustomAppbar(
                    backButtonVisibility: true,
                    onBackPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WelcomePage(
                          ),
                        ),
                      );
                    },
                    caption: AppTranslations.of(context).text("key_emi_calculator"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          autofoucus: false,
                          isIcon: false,
                          textEditingController: principalAmtController,
                          focusNode: principalAmtFocusNode,
                          borderRadius: 20,
                          onFieldSubmitted: (value) {
                            this.principalAmtFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(this.intrRateFocusNode);
                          },
                          hint: AppTranslations.of(context).text("key_principal_amt"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          autofoucus: false,
                          isIcon: false,
                          textEditingController: intrRateController,
                          focusNode: intrRateFocusNode,
                          borderRadius: 20,
                          onFieldSubmitted: (value) {
                            this.intrRateFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(this.yrFocusNode);
                          },
                          hint: AppTranslations.of(context)
                              .text("key_interest_rate_per_yr"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          autofoucus: false,
                          isIcon: false,
                          textEditingController: yrController,
                          focusNode: yrFocusNode,
                          borderRadius: 20,
                          onFieldSubmitted: (value) {
                            this.yrFocusNode.unfocus();
                            /* FocusScope.of(context)
                            .requestFocus(this._passwordFocusNode);*/
                          },
                          hint: AppTranslations.of(context).text("key_how_many_yr"),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: CustomDarkButton(
                              caption: AppTranslations.of(context).text("key_calculate"),
                              onPressed: () {
                                validation().then((valMsg) {
                                  if (valMsg == '') {
                                    /*
                      float Principal = calPric(p);
                      float Rate = calInt(i);
                      float Months = calMonth(y);
                                 */

                                    Principal = double.parse(principalAmtController.text);
                                    i = double.parse(intrRateController.text);
                                    y = double.parse(yrController.text);
                                    Rate = (i / 12 / 100) as double;
                                    Months = (y * 12) as double;
                                    Dvdnt = (pow(1 + Rate, Months)) as double;
                                    FD = (Principal * Rate * Dvdnt) as double;
                                    D = (Dvdnt - 1) as double;

                                    setState(() {
                                      emi = (FD / D) as double;
                                      totalAmt = (emi * Months) as double;
                                      totalIntr = (totalAmt - Principal) as double;
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          AppTranslations.of(context).text("key_emi"),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          emi.toStringAsFixed(4)??"",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppTranslations.of(context).text("key_total_intr_for_loan"),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          totalIntr.toStringAsFixed(4)??"",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            //color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            )
            ,
          ),
        ),
      )
      ,
    );
  }

  Future<String> validation() async {
    if (principalAmtController.text == null ||
        principalAmtController.text.toString() == '') {
      return AppTranslations.of(context).text("key_entr_amt");
    }

    if (intrRateController.text == null || intrRateController.text == '') {
      return AppTranslations.of(context).text("key_entr_intr_rate");
    }

    if (yrController.text == null || yrController.text == '') {
      return AppTranslations.of(context).text("key_entr_years");
    }

    return "";
  }
}




















