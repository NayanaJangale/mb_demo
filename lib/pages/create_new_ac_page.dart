import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:softcoremobilebanking/pages/welcome_page.dart';

class CreateNewAcPage extends StatefulWidget {
  @override
  _CreateNewAcPageState createState() => _CreateNewAcPageState();
}

class _CreateNewAcPageState extends State<CreateNewAcPage> {
  bool _isLoading, _isGuardian = false;
  String _loadingText;
  final GlobalKey<ScaffoldState> _createAccountScafoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController bankRegTxtCntl = TextEditingController();
  TextEditingController adharNoTxtCntl = TextEditingController();
  TextEditingController pancardNoTxtCntl = TextEditingController();
  TextEditingController voatCardNoTxtCntl = TextEditingController();
  TextEditingController drivingLicNoTxtCntl = TextEditingController();
  TextEditingController nameTxtCntl = TextEditingController();
  TextEditingController addrTxtCntl = TextEditingController();
  TextEditingController cityTxtCntl = TextEditingController();
  TextEditingController talukaTxtCntl = TextEditingController();
  TextEditingController districtTxtCntl = TextEditingController();
  TextEditingController pincodeTxtCntl = TextEditingController();
  TextEditingController mobilenoTxtCntl = TextEditingController();
  TextEditingController eduQualTxtCntl = TextEditingController();

  TextEditingController nNameTxtCntl = TextEditingController();
  TextEditingController nRelationTxtCntl = TextEditingController();
  TextEditingController nAddrTxtCntl = TextEditingController();
  TextEditingController nCityTxtCntl = TextEditingController();
  TextEditingController nTalukaTxtCntl = TextEditingController();
  TextEditingController nDistrictTxtCntl = TextEditingController();
  TextEditingController nPinCodeTxtCntl = TextEditingController();

  TextEditingController gNameTxtCntl = TextEditingController();
  TextEditingController gRelationTxtCntl = TextEditingController();
  TextEditingController gAddrTxtCntl = TextEditingController();
  TextEditingController gCityTxtCntl = TextEditingController();
  TextEditingController gTalukaTxtCntl = TextEditingController();
  TextEditingController gDistrictTxtCntl = TextEditingController();
  TextEditingController gPinCodeTxtCntl = TextEditingController();

  FocusNode bankRegFcsNode = FocusNode();
  FocusNode adharNoFcsNode = FocusNode();
  FocusNode pancardNoFcsNode = FocusNode();
  FocusNode voatCardNoFcsNode = FocusNode();
  FocusNode drivingLicNoFcsNode = FocusNode();
  FocusNode nameFcsNode = FocusNode();
  FocusNode addrFcsNode = FocusNode();
  FocusNode cityFcsNode = FocusNode();
  FocusNode talukaFcsNode = FocusNode();
  FocusNode districtFcsNode = FocusNode();
  FocusNode pincodeFcsNode = FocusNode();
  FocusNode mobilenoFcsNode = FocusNode();
  FocusNode eduQualFcsNode = FocusNode();

  FocusNode nNameFcsNode = FocusNode();
  FocusNode nRelationFcsNode = FocusNode();
  FocusNode nAddrFcsNode = FocusNode();
  FocusNode nCityFcsNode = FocusNode();
  FocusNode nTalukaFcsNode = FocusNode();
  FocusNode nDistrictFcsNode = FocusNode();
  FocusNode nPinCodeFcsNode = FocusNode();

  FocusNode gNameFcsNode = FocusNode();
  FocusNode gRelationFcsNode = FocusNode();
  FocusNode gAddrFcsNode = FocusNode();
  FocusNode gCityFcsNode = FocusNode();
  FocusNode gTalukaFcsNode = FocusNode();
  FocusNode gDistrictFcsNode = FocusNode();
  FocusNode gPinCodeFcsNode = FocusNode();

  DateTime DOB;
  DateTime NDOB;
  DateTime GDOB;

  String _rdSMSValue = 'Yes';
  String _rdMarriedValue = 'Married';

  File photoImgFile, IDImgFile, AddressImgFile;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child:SafeArea(
          child: Scaffold(
            key: _createAccountScafoldKey,
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
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
                          caption: "Create New A/c",
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15,right: 15),
                            child : Column(children: [
                              ExpansionTile(
                                leading: Icon(
                                    Icons.person,
                                    color :Theme.of(context).primaryColor
                                ),
                                collapsedBackgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                                backgroundColor: ColorsConst.white,
                                title: Row(
                                  children: [
                                    new Text(
                                      AppTranslations.of(context)
                                          .text("key_personal_details"),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                initiallyExpanded: true,
                                children: <Widget>[
                                  getPersonalDtlsWidgets(context),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.person_add_alt_1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                collapsedBackgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                                backgroundColor: ColorsConst.white,
                                title: new Text(
                                  AppTranslations.of(context).text("key_nominee_dtls"),
                                  style:  Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                initiallyExpanded: false,
                                children: <Widget>[
                                  getNomineeDtlsWidgets(context),
                                ],
                              ),
                              Visibility(
                                visible: _isGuardian,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ExpansionTile(
                                    leading: Icon(
                                      Icons.account_box_outlined,
                                        color :Theme.of(context).primaryColor
                                    ),
                                    collapsedBackgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                                    backgroundColor: ColorsConst.white,
                                    title: new Text(
                                      AppTranslations.of(context).text("key_guardian_dtls"),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    initiallyExpanded: false,
                                    children: <Widget>[
                                      getGuardianDtlsWidgets(context),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                collapsedBackgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                                backgroundColor: ColorsConst.white,
                                title: new Text(
                                  AppTranslations.of(context).text("key_documents"),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                initiallyExpanded: false,
                                children: <Widget>[
                                  getDocumentWidgets(context),
                                ],
                              ),
                            ],)
                        )

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 15),
                  child: CustomDarkButton(
                      caption: AppTranslations.of(context).text("key_submit"),
                      onPressed: () {
                        validation().then((valMsg) {
                          if (valMsg == '') {
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

  Widget getPersonalDtlsWidgets(BuildContext context) {
    return Container(
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
              textEditingController: bankRegTxtCntl,
              focusNode: bankRegFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.bankRegFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.adharNoFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_bank_reg_code"),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showBranch();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConst.white.withOpacity(0.5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        AppTranslations.of(context).text("key_branch"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color:  Colors.grey
                        ),
                      ),
                    ),
                    Text(
                      "Pachora HO",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(

                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showBranch();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConst.white.withOpacity(0.5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        AppTranslations.of(context).text("key_account_type"),
                   style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color:  Colors.grey
              ),
                      ),
                    ),
                    Text(
                      "Select A/c Type",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(

                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              autofoucus: false,
              isIcon: false,
              textEditingController: adharNoTxtCntl,
              focusNode: adharNoFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.adharNoFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.pancardNoFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_adhar_card_no"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: pancardNoTxtCntl,
              focusNode: pancardNoFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.pancardNoFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.voatCardNoFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_pan_card_no"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: voatCardNoTxtCntl,
              focusNode: voatCardNoFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.voatCardNoFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.drivingLicNoFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_voating_card_no"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: drivingLicNoTxtCntl,
              focusNode: drivingLicNoFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.drivingLicNoFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.nameFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_driving_lic_no"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: nameTxtCntl,
              focusNode: nameFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.nameFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.addrFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_name"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: addrTxtCntl,
              focusNode: addrFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.addrFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.cityFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_permanent_address"),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: cityTxtCntl,
                    focusNode: cityFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.cityFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.talukaFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_city"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: talukaTxtCntl,
                    focusNode: talukaFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.talukaFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.districtFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_taluka"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: districtTxtCntl,
                    focusNode: districtFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.districtFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.pincodeFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_district"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: pincodeTxtCntl,
                    focusNode: pincodeFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.pincodeFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.mobilenoFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_pin_code"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsConst.white.withOpacity(0.5),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppTranslations.of(context).text("key_dob"),
                     style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color:  Colors.grey
            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDOB(context, 'DOB');
                    },
                    child: Row(
                      children: [
                        Text(
                          DOB != null
                              ? DateFormat('dd-MMM-yyyy').format(DOB)
                              : DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(

                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              autofoucus: false,
              isIcon: false,
              textEditingController: mobilenoTxtCntl,
              focusNode: mobilenoFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.mobilenoFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.eduQualFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_mobile_no"),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsConst.white.withOpacity(0.5),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppTranslations.of(context).text("key_sms"),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey,
                        //fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark().copyWith(
                      brightness: Brightness.dark,
                      colorScheme: ColorScheme.dark(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.deepPurple,

                      ),

                      unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
                    ),
                    child:    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Radio(
                          value: AppTranslations.of(context).text("key_yes"),
                          groupValue: _rdSMSValue,
                          activeColor: Theme.of(context).primaryColorDark ,
                          onChanged: (value) {
                            setState(() {
                              _rdSMSValue = value;
                            });
                          },
                        ),
                        new Text(
                          AppTranslations.of(context).text("key_yes"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(

                          ),
                        ),
                        new Radio(
                          value: AppTranslations.of(context).text("key_no"),
                          groupValue: _rdSMSValue,
                          activeColor: Theme.of(context).primaryColorDark ,
                          onChanged: (value) {
                            setState(() {
                              _rdSMSValue = value;
                            });
                          },
                        ),
                        new Text(
                          AppTranslations.of(context).text("key_no"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsConst.white.withOpacity(0.5),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppTranslations.of(context).text("key_marital_status"),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                     color:  Colors.grey

                      ),
                    ),
                  ),
      Theme(
        data: ThemeData.dark().copyWith(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Theme.of(context).primaryColor,
            onPrimary: Colors.deepPurple,

          ),

          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Radio(
              value: AppTranslations.of(context).text("key_married"),
              activeColor: Theme.of(context).primaryColorDark ,
              groupValue: _rdMarriedValue,
              focusColor: Theme.of(context).primaryColorDark,
              onChanged: (value) {
                setState(() {
                  _rdMarriedValue = value;
                });
              },
            ),
            new Text(
              AppTranslations.of(context).text("key_married"),
              style: Theme.of(context).textTheme.bodyText1.copyWith(

              ),
            ),
            new Radio(
              value:
              AppTranslations.of(context).text("key_unmarried"),
              groupValue: _rdMarriedValue,
              activeColor: Theme.of(context).primaryColorDark,

              onChanged: (value) {
                setState(() {
                  _rdMarriedValue = value;
                });
              },
            ),
            new Text(
              AppTranslations.of(context).text("key_unmarried"),
              style: Theme.of(context).textTheme.bodyText1.copyWith(

              ),
            ),
          ],
        ),
      ),

                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: eduQualTxtCntl,
              focusNode: eduQualFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.eduQualFcsNode.unfocus();
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_edu_qual"),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showBranch();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConst.white.withOpacity(0.5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        AppTranslations.of(context).text("key_occupation"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    Text(
                      "Pachora HO",
                      style: Theme.of(context).textTheme.body1.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getNomineeDtlsWidgets(BuildContext context) {
    return Container(
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
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: nNameTxtCntl,
              focusNode: nNameFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.nNameFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.nRelationFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_name"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: nRelationTxtCntl,
              focusNode: nRelationFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.nRelationFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.nAddrFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_relation"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: nAddrTxtCntl,
              focusNode: nAddrFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.nAddrFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.nCityFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_nominee_add"),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: nCityTxtCntl,
                    focusNode: nCityFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.nCityFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.nTalukaFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_city"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: nTalukaTxtCntl,
                    focusNode: nTalukaFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.nTalukaFcsNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(this.nDistrictFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_taluka"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: nDistrictTxtCntl,
                    focusNode: nDistrictFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.nDistrictFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.nPinCodeFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_district"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: nPinCodeTxtCntl,
                    focusNode: nPinCodeFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.nPinCodeFcsNode.unfocus();
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_pin_code"),
                  ),
                ),
              ],
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
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppTranslations.of(context).text("key_dob"),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDOB(context, 'NDOB');
                    },
                    child: Row(
                      children: [
                        Text(
                          NDOB != null
                              ? DateFormat('dd-MMM-yyyy').format(NDOB)
                              : '',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                           color: Theme.of(context).primaryColor
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getGuardianDtlsWidgets(BuildContext context) {
    return Container(
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
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: gNameTxtCntl,
              focusNode: gNameFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.gNameFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.gRelationFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_name"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: gRelationTxtCntl,
              focusNode: gRelationFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.gRelationFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.gAddrFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_relation"),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              keyboardType: TextInputType.text,
              autofoucus: false,
              isIcon: false,
              textEditingController: gAddrTxtCntl,
              focusNode: gAddrFcsNode,
              borderRadius: 20,
              onFieldSubmitted: (value) {
                this.gAddrFcsNode.unfocus();
                FocusScope.of(context).requestFocus(this.gCityFcsNode);
              },
              icon: Icons.person_outline_outlined,
              hint: AppTranslations.of(context).text("key_guardian_add"),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: gCityTxtCntl,
                    focusNode: gCityFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.gCityFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.gTalukaFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_city"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: gTalukaTxtCntl,
                    focusNode: gTalukaFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.gTalukaFcsNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(this.gDistrictFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_taluka"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.text,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: gDistrictTxtCntl,
                    focusNode: gDistrictFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.gDistrictFcsNode.unfocus();
                      FocusScope.of(context).requestFocus(this.gPinCodeFcsNode);
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_district"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    autofoucus: false,
                    isIcon: false,
                    textEditingController: gPinCodeTxtCntl,
                    focusNode: gPinCodeFcsNode,
                    borderRadius: 20,
                    onFieldSubmitted: (value) {
                      this.gPinCodeFcsNode.unfocus();
                    },
                    icon: Icons.person_outline_outlined,
                    hint: AppTranslations.of(context).text("key_pin_code"),
                  ),
                ),
              ],
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
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppTranslations.of(context).text("key_dob"),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDOB(context, 'GDOB');
                    },
                    child: Row(
                      children: [
                        Text(
                          GDOB != null
                              ? DateFormat('dd-MMM-yyyy').format(GDOB)
                              : '',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(

                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDocumentWidgets(BuildContext context) {
    return Container(
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
            GestureDetector(
                onTap: () {
                  selectImg("Photo");
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTranslations.of(context).text("key_photo"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.grey,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      photoImgFile == null
                          ? Container(
                        width: 70,
                        height: 70,
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                        child: Center(
                          child: Text(
                            AppTranslations.of(context)
                                .text("key_select_image"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
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
              height: 10.0,
            ),
            GestureDetector(
                onTap: () {
                  selectImg("ID");
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTranslations.of(context).text("key_id_proof"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.grey,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IDImgFile == null
                          ? Container(
                        width: 70,
                        height: 70,
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                        child: Center(
                          child: Text(
                            AppTranslations.of(context)
                                .text("key_select_image"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          : Image.file(
                        IDImgFile,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
                onTap: () {
                  selectImg("Address");
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTranslations.of(context).text("key_addr_proof"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.grey,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      AddressImgFile == null
                          ? Container(
                        width: 70,
                        height: 70,
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                        child: Center(
                          child: Text(
                            AppTranslations.of(context)
                                .text("key_select_image"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          : Image.file(
                        AddressImgFile,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void showBranch() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: "Select Purpose",
        ),
        actions: List<Widget>.generate(
          7,
              (i) => CustomCupertinoAction(
            actionText: "Test",
            actionIndex: i,
            onActionPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectImg(String imgFor) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            AppTranslations.of(context).text("key_select_img_from"),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.camera, imgFor);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        AppTranslations.of(context).text("key_camera"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery, imgFor);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.photo,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        AppTranslations.of(context).text("key_gallery"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(
              AppTranslations.of(context).text("key_cancel"),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future _pickImage(ImageSource iSource, String imgFor) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: iSource,
      imageQuality: 100,
    );
    switch (imgFor) {
      case 'Photo':
        setState(() {
          this.photoImgFile = File(compressedImage.path);
        });
        break;
      case 'ID':
        setState(() {
          this.IDImgFile = File(compressedImage.path);
        });
        break;
      case 'Address':
        setState(() {
          this.AddressImgFile = File(compressedImage.path);
        });
        break;
    }
  }

  Future<Null> _selectDOB(BuildContext context, String dateFor) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: this.DOB,
      firstDate: DateTime(1980, 8),
      lastDate: DateTime(2025, 8),
    );
    if (picked != null) {
      switch (dateFor) {
        case 'DOB':
          setState(() {
            DOB = picked;
            _isGuardian = calculateAge(DOB) < 18;
          });
          break;
        case 'NDOB':
          setState(() {
            NDOB = picked;
          });
          break;
        case 'GDOB':
          setState(() {
            GDOB = picked;
          });
          break;
      }
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<String> validation() async {
    if (bankRegTxtCntl.text == null || bankRegTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_bank_reg_mand");
    }

    //Branch Val
    //A/c Type Val
    if (adharNoTxtCntl.text == null || adharNoTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_adhar_card_mand");
    }
    if (pancardNoTxtCntl.text == null ||
        pancardNoTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_pan_card_mand");
    }
    if (voatCardNoTxtCntl.text == null ||
        voatCardNoTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_voating_card_mand");
    }
    if (nameTxtCntl.text == null || nameTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_name_mand");
    }

    if (addrTxtCntl.text == null || addrTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_addr_mand");
    }

    if (DOB == null) {
      return AppTranslations.of(context).text("key_select_dob");
    }

    if (mobilenoTxtCntl.text == null || mobilenoTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_mobile_no_mand");
    }
    if (mobilenoTxtCntl.text.length != 10) {
      return AppTranslations.of(context).text("key_enter_10digit_mobile_no");
    }
    if (eduQualTxtCntl.text == null || eduQualTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_edu_qual_mand");
    }

    if (photoImgFile == null) {
      return AppTranslations.of(context).text("key_select_pass_photo");
    }

    if (IDImgFile == null) {
      return AppTranslations.of(context).text("key_select_id_prrof_photo");
    }

    if (AddressImgFile == null) {
      return AppTranslations.of(context).text("key_select_addr_proof_photo");
    }

    //accu val

    return "";
  }
}


















