import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/models/loan_document.dart';
import 'package:softcoremobilebanking/models/loan_request.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';

import '../app_data.dart';
import 'fullscreen_img_page.dart';

class LoanDocPage extends StatefulWidget {
  List<LoanDocument> loanDocList = [];

  LoanDocPage({this.loanDocList});

  @override
  _LoanDocPageState createState() => _LoanDocPageState();
}

class _LoanDocPageState extends State<LoanDocPage> {
  bool isLoading;
  String loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                CustomAppbar(
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  caption: AppTranslations.of(context).text("key_loan_req_doc"),
                  icon: Icons.help_outline_outlined,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: widget.loanDocList != null &&
                            widget.loanDocList.length > 0
                        ? GridView.count(
                            crossAxisCount: 2,
                            padding: EdgeInsets.all(3.0),
                            children: List<Widget>.generate(
                              widget.loanDocList.length,
                              (index) =>
                                  getAlbumCard(widget.loanDocList[index], index),
                            ),
                          )
                        : CustomNotFoundWidget(
                            description: AppTranslations.of(context)
                                .text("key_document_not_available"),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(LoanDocument loanDocument) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        CustomerLogin customerLogin = AppData.current.customerLogin;
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                LoanRequestUrls.GetLoanDocument,
          ).replace(queryParameters: {
            "BranchCode": customerLogin == null
                ? "001"
                : AppData.current.customerLogin.user.BranchCode,
            "CustomerID": customerLogin == null
                ? "0"
                : AppData.current.customerLogin.user.CustomerID,
            "docno": loanDocument.docno.toString(),
            "doccode": loanDocument.doccode.toString(),
            "doctpcode": loanDocument.doctpcode.toString(),
            "EntNo": loanDocument.entno.toString(),
            'ApplicationType': 'MobileBanking',
            'SessionAutoID': customerLogin == null
                ? "0"
                : customerLogin.SessionAutoID.toString(),
            'UserNo': customerLogin == null || customerLogin.user == null
                ? "-1"
                : customerLogin.user.UserNo.toString(),
            'ConnectionString': AppData.current.ConnectionString,
            "ClientCode": AppData.current.ClientCode,
            "MacAddress": AppData.current.MacAddress,
          }).toString();
        }
      });

  Widget getAlbumCard(LoanDocument loanDocument, int index) {
    return FutureBuilder<String>(
      future: getImageUrl(loanDocument),
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: CachedNetworkImage(
              imageUrl: snapshot.data.toString(),
              imageBuilder: (context, imageProvider) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    snapshot.data.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Padding(
                padding: const EdgeInsets.only(
                    left: 50.0, right: 60.0, top: 60.0, bottom: 60.0),
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              errorWidget: (context, url, error) => Container(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImagePage(
                    dynamicObjects: widget.loanDocList,
                    imageType: 'LoanDoc',
                    photoIndex: index,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
