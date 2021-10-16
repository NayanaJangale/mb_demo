import 'dart:convert';
import 'dart:typed_data';

import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:http/http.dart';

import '../app_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Uint8List bytesCustImg;
  bool _isLoading;
  String _loadingText,
      name = "",
      mobileNo = "",
      emailID = "",
      address = "",
      adharNo = "",
      panNo = "",
      DOB;

  @override
  void initState() {
    super.initState();

    loadCustInfo();
    getClientLogoImgUrl().then((res) {
      if (res != '') {
        setState(() {
          bytesCustImg = Base64Decoder().convert(res);
        });
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
              key: scaffoldKey,
              body: RefreshIndicator(
                onRefresh: () async {
                  loadCustInfo();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    CustomAppbar(
                      backButtonVisibility: true,
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                      caption: AppTranslations.of(context).text("key_my_profile"),
                    ),
                    Expanded(
                      child: new ListView(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: ClipOval(
                                    child: bytesCustImg == null
                                        ? Image.asset(
                                            'assets/images/logo.png',
                                            height: 120,
                                            width: 120,
                                          )
                                        : Image.memory(
                                            bytesCustImg,
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.fitWidth,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    AppTranslations.of(context)
                                        .text("key_personal_info"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColorDark,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                CustomText(
                                  labelText:
                                      AppTranslations.of(context).text("key_name"),
                                ),
                                CustomTextField(
                                  labelText: name,
                                ),
                                CustomText(
                                  labelText: AppTranslations.of(context)
                                      .text("key_mobile_no"),
                                ),
                                CustomTextField(
                                  labelText: mobileNo,
                                ),
                                CustomText(
                                  labelText:
                                      AppTranslations.of(context).text("key_dob"),
                                ),
                                CustomTextField(
                                    labelText: DOB != null &&
                                            DOB != StringHandlers.NotAvailable
                                        ? DateFormat('dd-MMM-yyyy')
                                            .format(DateTime.parse(DOB))
                                        : StringHandlers.NotAvailable),
                                //shridhar nidhadhi kyc
                                CustomText(
                                  labelText: AppTranslations.of(context)
                                      .text("key_email_id"),
                                ),
                                CustomTextField(
                                  labelText: emailID,
                                ),
                                CustomText(
                                  labelText: AppTranslations.of(context)
                                      .text("key_address"),
                                ),
                                CustomTextField(
                                  labelText: address,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(AppTranslations.of(context).text("key_kyc"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColorDark,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                CustomText(
                                  labelText: AppTranslations.of(context)
                                      .text("key_adhar_card_no"),
                                ),
                                CustomTextField(
                                  labelText: 'X' *
                                          (adharNo != null && adharNo.length >= 4
                                              ? adharNo.length - 4
                                              : 1) +
                                      (adharNo != null && adharNo.length >= 4
                                          ? adharNo.substring(adharNo.length - 4)
                                          : ""),
                                ),
                                CustomText(
                                  labelText: AppTranslations.of(context)
                                      .text("key_pan_card_no"),
                                ),
                                CustomTextField(
                                  labelText: 'X' *
                                          (panNo != null && panNo.length >= 4
                                              ? panNo.length - 4
                                              : 1) +
                                      (panNo != null && panNo.length >= 4
                                          ? panNo.substring(panNo.length - 4)
                                          : ""),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void loadCustInfo() {
    _isLoading = true;
    CustomerAPI(context: context)
        .getCustInfo(
            CustomerID: AppData.current.customerLogin.user.CustomerID,
            BranchCode: AppData.current.customerLogin.user.BranchCode)
        .then((res) {
      Map<String, dynamic> custInfo = res["Data"];
      setState(() {
        _isLoading = false;
        name = custInfo["name"] ?? StringHandlers.NotAvailable;
        DOB = custInfo["bdate"] ?? StringHandlers.NotAvailable;
        adharNo = custInfo["adharID"] ?? StringHandlers.NotAvailable;
        panNo = custInfo["pan_no"] ?? StringHandlers.NotAvailable;
        emailID = custInfo["emailid"] ?? StringHandlers.NotAvailable;
        mobileNo = custInfo["phoneNo"] ?? StringHandlers.NotAvailable;
        address = custInfo["addr"] ?? StringHandlers.NotAvailable;
      });
    });
  }

  Future<String> getClientLogoImgUrl() async {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri uri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            CustomerLoginUrls.GET_GetCustomerPhoto,
      ).replace(queryParameters: {
        "ClientCode": AppData.current.ClientCode,
        "ConnectionString": AppData.current.ConnectionString,
        "CustomerID": AppData.current.customerLogin.user.CustomerID,
      });

      Response response = await get(
        uri,
      );
      if (response.statusCode != HttpStatusCodes.OK) {
        return '';
      } else {
        return base64Encode(response.bodyBytes);
      }
    }
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final int hintMaxLines;

  const CustomTextField({this.labelText, this.hintMaxLines});

  @override
  Widget build(BuildContext context) {
    return new TextField(
      decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.w400,
              ),
          hintMaxLines: hintMaxLines ?? 1,
          hintText: labelText.toUpperCase(),
          enabled: false),
    );
  }
}

class CustomText extends StatelessWidget {
  final String labelText;

  const CustomText({
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: new Text(
        labelText,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
