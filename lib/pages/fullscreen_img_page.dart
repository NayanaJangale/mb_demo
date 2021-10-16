import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/models/loan_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<dynamic> dynamicObjects;
  final String imageType;
  final int photoIndex;

  const FullScreenImagePage({this.dynamicObjects,this.imageType, this.photoIndex});

  @override
  _FullScreenImagePageState createState() =>
      _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomAppbar(
                backButtonVisibility: true,
                onBackPressed: () {
                  Navigator.pop(context);
                },
                caption: AppTranslations.of(context).text("key_gallery_photo"),
              ),
              Expanded(
                child: Swiper(
                  itemBuilder: (c, i) {
                    return FutureBuilder<String>(
                        future: getImageUrl(widget.dynamicObjects[i],widget.imageType),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                            child: PhotoView(
                              imageProvider: new NetworkImage(snapshot.data.toString()),
                            ),
                          );
                        });
                  },
                  loop: widget.dynamicObjects.length > 1 ? true : false,
                  pagination: new SwiperPagination(
                    margin: new EdgeInsets.all(5.0),
                  ),
                  itemCount: widget.dynamicObjects.length,
                  index: widget.photoIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(dynamic dynamicObj,String imageType) => NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
    if (connectionServerMsg != "key_check_internet") {
      CustomerLogin customerLogin = AppData.current.customerLogin;

      if(imageType == 'LoanDoc'){
        return Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              LoanRequestUrls.GetLoanDocument,
        ).replace(queryParameters: {
          "BranchCode": customerLogin==null ?"001":AppData.current.customerLogin.user.BranchCode,
          "CustomerID": customerLogin==null ?"0":AppData.current.customerLogin.user.CustomerID,
          "docno": dynamicObj.docno.toString(),
          "doccode": dynamicObj.doccode.toString(),
          "doctpcode": dynamicObj.doctpcode.toString(),
          "EntNo": dynamicObj.entno.toString(),
          'ApplicationType': 'MobileBanking',
          'SessionAutoID': customerLogin==null ?"0": customerLogin.SessionAutoID.toString(),
          'UserNo': customerLogin==null || customerLogin.user ==null ?"-1":customerLogin.user.UserNo.toString(),
          'ConnectionString': AppData.current.ConnectionString,
          //'ConnectionString': '',
          "ClientCode": AppData.current.ClientCode,
          "MacAddress": AppData.current.MacAddress,
        }).toString();
      }else if(imageType == 'Album'){
        return Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              "Gallery/GetAlbumPhoto",
        ).replace(queryParameters: {
          "ClientCode": AppData.current.ClientCode,
          "ConnectionString": AppData.current.ConnectionString,
          "album_id": dynamicObj.album_id.toString(),
          "photo_id": dynamicObj.ent_no.toString(),
        }).toString();
      }
    }
  });
}
