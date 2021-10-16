import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:softcoremobilebanking/api/branchapi.dart';
import 'package:softcoremobilebanking/api/loanrecoveryapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_alert_dialog.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action.dart';
import 'package:softcoremobilebanking/components/custom_cupertino_action_message.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/custom_spinner_item.dart';
import 'package:softcoremobilebanking/components/custom_successfully_dialog.dart';
import 'package:softcoremobilebanking/components/custom_text_field.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/document.dart';
import 'package:softcoremobilebanking/models/loan_type.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';

import 'loan_history_page.dart';
import 'menu_help_page.dart';
import 'navigation_home_screen.dart';

class LoanRequestPage extends StatefulWidget {
  @override
  _LoanRequestPageState createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  bool _isLoading;
  String _loadingText;
  final GlobalKey<ScaffoldState> loanRequestScafoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController amountTxtCntl = TextEditingController();
  TextEditingController expDurationTxtCntl = TextEditingController();
  FocusNode amountFcsNode = FocusNode();
  FocusNode expDurationFcsNode = FocusNode();
  String _rdDurationValue = 'Months';

  List<LoanType> loanTypeList;
  List<Document> documentList;
  LoanType selectedLoanType;
  ImagePicker imagePicker = ImagePicker();
  PickedFile compressedImage;
  bool isDocumentAvalbl = true;

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = false;
    BranchAPI(context: context)
        .GetAccountDocuments(
            ACTPNAME: "LAC",
            brcode: AppData.current.customerLogin.user.BranchCode)
        .then((res) {
      var data = res["Data"];
      setState(() {
        documentList =
            List<Document>.from(data.map((i) => Document.fromMap(i)));
      });
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
            key: loanRequestScafoldKey,
            body: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomAppbar(
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  onIconPressed: () async {
                    String connectionServerMsg = await NetworkHandler
                        .getServerWorkingUrl();
                    if (connectionServerMsg != "key_check_internet") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MenuHelpPage(
                                menuName: AppTranslations.of(context).text(
                                    "key_loan_request"),
                                pdfURL:connectionServerMsg + "/CustCommonAppApi/help/AddLoanReq.pdf",
                              ),
                        ),
                      );
                    }else{
                      FlushbarMessage.show(
                        context,
                        connectionServerMsg,
                        MessageTypes.WARNING,
                      );
                    }
                  },
                  icon: Icons.help_outline_outlined,
                  caption: AppTranslations.of(context).text("key_loan_request"),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      CustomSpinnerItem(
                                          onPressed: () async {
                                            if (loanTypeList != null &&
                                                loanTypeList.length > 0) {
                                              showLoanType();
                                            } else {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              var res = await LoanRecoveryAPI(
                                                      context: context)
                                                  .GetLoanTypes();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              var data = res["Data"];
                                              loanTypeList = List<LoanType>.from(
                                                  data.map(
                                                      (i) => LoanType.fromJson(i)));
                                              if (loanTypeList != null &&
                                                  loanTypeList.length > 0) {
                                                showLoanType();
                                              }
                                            }
                                          },
                                          caption: AppTranslations.of(context)
                                              .text("key_loan_type"),
                                          selectedItem: selectedLoanType != null
                                              ? selectedLoanType.LoanName
                                              : AppTranslations.of(context)
                                                  .text("key_select_type")),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      CustomTextField(
                                        keyboardType: TextInputType.number,
                                        autofoucus: false,
                                        isIcon: false,
                                        textEditingController: amountTxtCntl,
                                        focusNode: amountFcsNode,
                                        borderRadius: 10,
                                        onFieldSubmitted: (value) {
                                          this.amountFcsNode.unfocus();
                                          FocusScope.of(context).requestFocus(
                                              this.expDurationFcsNode);
                                        },
                                        icon: Icons.monetization_on_outlined,
                                        hint: AppTranslations.of(context)
                                            .text("key_entr_amt"),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorsConst.white,
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                AppTranslations.of(context)
                                                    .text("key_exptd_dur"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.grey,
                                                      //fontWeight: FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                            Theme(
                                              data: ThemeData.dark().copyWith(
                                                brightness: Brightness.dark,
                                                colorScheme: ColorScheme.dark(
                                                  primary: Theme.of(context)
                                                      .primaryColor,
                                                  onPrimary: Colors.deepPurple,
                                                ),
                                                unselectedWidgetColor:
                                                    Theme.of(context)
                                                        .secondaryHeaderColor,
                                              ),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  new Radio(
                                                    value: "Months",
                                                    groupValue: _rdDurationValue,
                                                    activeColor: Theme.of(context)
                                                        .primaryColorDark,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _rdDurationValue = value;
                                                      });
                                                    },
                                                  ),
                                                  new Text(
                                                    AppTranslations.of(context)
                                                        .text("key_months"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(),
                                                  ),
                                                  new Radio(
                                                    value: "Years",
                                                    groupValue: _rdDurationValue,
                                                    activeColor: Theme.of(context)
                                                        .primaryColorDark,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _rdDurationValue = value;
                                                      });
                                                    },
                                                  ),
                                                  new Text(
                                                    AppTranslations.of(context)
                                                        .text("key_years"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(),
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
                                        textEditingController: expDurationTxtCntl,
                                        focusNode: expDurationFcsNode,
                                        borderRadius: 10,
                                        onFieldSubmitted: (value) {
                                          this.expDurationFcsNode.unfocus();
                                        },
                                        icon: Icons.monetization_on_outlined,
                                        hint: AppTranslations.of(context)
                                            .text("key_entr_dur"),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        AppTranslations.of(context)
                                            .text("key_reqr_doc"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                //   color: Theme.of(context).primaryColorDark,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      ListView.builder(
                                        itemCount: documentList != null
                                            ? documentList.length
                                            : 0,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 8),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              selectImg(documentList[index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorsConst.white,
                                                border: Border.all(
                                                  color:
                                                      Colors.grey.withOpacity(0.5),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(10.0),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      documentList != null
                                                          ? documentList[index]
                                                              .DOCNAME
                                                          : "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                            color: Colors.grey,
                                                            //fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                  documentList[index].CDOC ==
                                                          StringHandlers
                                                              .NotAvailable
                                                      ? Container(
                                                          width: 70,
                                                          height: 70,
                                                          color: Theme.of(context)
                                                              .secondaryHeaderColor
                                                              .withOpacity(0.3),
                                                          child: Center(
                                                            child: Text(
                                                              AppTranslations.of(
                                                                      context)
                                                                  .text(
                                                                      "key_select_image"),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style:
                                                                  Theme.of(context)
                                                                      .textTheme
                                                                      .bodyText2
                                                                      .copyWith(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .primaryColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                      ),
                                                            ),
                                                          ),
                                                        )
                                                      : Image.memory(
                                                          base64Decode(
                                                              documentList[index]
                                                                  .CDOC),
                                                          width: 70,
                                                          height: 70,
                                                          fit: BoxFit.cover,
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
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 15),
                  child: CustomDarkButton(
                    caption: AppTranslations.of(context).text("key_submit"),
                    onPressed: () {
                      validation().then((valMsg) {
                        if (valMsg == '') {
                          isDocumentAvalbl =
                              documentList.where((x) => x.docImg != null).isEmpty;
                          if (documentList.length > 0 && isDocumentAvalbl) {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CustomActionDialog(
                                actionName:
                                    AppTranslations.of(context).text("key_yes"),
                                onActionTapped: () {
                                  insertLoanReq();
                                  Navigator.pop(context);
                                },
                                actionColor: Colors.red,
                                message: AppTranslations.of(context).text(
                                    "key_do_you_want_to_loan_req_without_doc"),
                                onCancelTapped: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          } else {
                            insertLoanReq();
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertLoanReq() {
    setState(() {
      _isLoading = true;
    });
    List<Document> docList = [];
    for (int i = 0; i < documentList.length; i++) {
      if (documentList[i].CDOC != StringHandlers.NotAvailable) {
        docList.add(documentList[i]);
      }
    }
    String strDocList = json.encode(docList);
    LoanRecoveryAPI(context: this.context)
        .InsertLoanRequest(
            Amount: amountTxtCntl.text,
            aStatus: "P",
            brcode: AppData.current.customerLogin.user.BranchCode,
            custid: AppData.current.customerLogin.user.CustomerID,
            expDur: expDurationTxtCntl.text,
            reqDate: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            l_type: selectedLoanType.loanTp,
            loanDocList: strDocList)
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
            message: AppTranslations.of(context)
                .text("key_ur_loan_req_successfully"),
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

  Future<void> showLoanType() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_loan_type"),
        ),
        actions: List<Widget>.generate(
          loanTypeList.length,
          (i) => CustomCupertinoAction(
            actionText: loanTypeList[i].LoanName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedLoanType = loanTypeList[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectImg(Document document) async {
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
              onTap: () async {
                compressedImage = await imagePicker.getImage(
                  source: ImageSource.camera,
                  imageQuality: 100,
                );
                setState(() {
                  document.docImg = File(compressedImage.path);
                  document.CDOC = base64Encode(
                      File(compressedImage.path).readAsBytesSync());
                });
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
              onTap: () async {
                compressedImage = await imagePicker.getImage(
                  source: ImageSource.gallery,
                  imageQuality: 100,
                );
                setState(() {
                  document.docImg = File(compressedImage.path);
                  document.CDOC = base64Encode(
                      File(compressedImage.path).readAsBytesSync());
                });
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

  Future<String> validation() async {
    if (selectedLoanType == null) {
      return AppTranslations.of(context).text("key_loan_type_mand");
    }
    if (amountTxtCntl.text == null || amountTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_loan_amt_mand");
    }
    if (expDurationTxtCntl.text == null ||
        expDurationTxtCntl.text.toString() == '') {
      return AppTranslations.of(context).text("key_loan_dur_mand");
    }

    return "";
  }
}
