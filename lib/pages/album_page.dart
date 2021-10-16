import 'package:cached_network_image/cached_network_image.dart';
import 'package:softcoremobilebanking/api/galleryapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/models/album_master.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';

import 'album_photo_page.dart';

class AlbumsPage extends StatefulWidget {
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  bool isLoading;
  String loadingText;
  List<AlbumMaster> albumMasterList = [];

  @override
  void initState() {
    super.initState();
    this.isLoading = false;

    getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    this.loadingText = AppTranslations.of(context).text("key_loading");
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
                    onBackPressed: (){
                       Navigator.pop(context);
                    },
                    caption: AppTranslations.of(context).text("key_gallery"),
                  ),
                  Expanded(
                    child: albumMasterList != null && albumMasterList.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async{
                              getAlbums();
                            },
                            child: GridView.count(
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(3.0),
                              children: List<Widget>.generate(
                                albumMasterList.length,
                                (index) => getAlbumCard(albumMasterList[index]),
                              ),
                            ),
                          )
                        : CustomNotFoundWidget(
                            description: AppTranslations.of(context)
                                .text("key_album_not_available"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void getAlbums() {
    setState(() {
      isLoading = true;
    });
    GalleryAPI(context: this.context).getAlbums().then((res) {
      setState(() {
        isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        setState(() {
          albumMasterList.clear();
          albumMasterList =
              List<AlbumMaster>.from(data.map((i) => AlbumMaster.fromJson(i)));
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

  Future<String> getImageUrl(int album_id, int photo_id) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                "Gallery/GetAlbumPhoto",
          ).replace(queryParameters: {
            "ClientCode": AppData.current.ClientCode,
            "ConnectionString": AppData.current.ConnectionString,
            "album_id": album_id.toString(),
            "photo_id": photo_id.toString(),
          }).toString();
        }
      });

  Widget getAlbumCard(AlbumMaster albumMaster) {
    return FutureBuilder<String>(
        future: getImageUrl(
            albumMaster.album_id,
            albumMaster.albumDtls != null && albumMaster.albumDtls.length > 0
                ? albumMaster.albumDtls[0].ent_no
                : -1),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Card(
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
                        value: 20,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlbumPhotoPage(
                          albumDtls: albumMaster.albumDtls,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                  bottom: 4.0,
                  left: 3.0,
                  right: 3.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(albumMaster.album_desc,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.body2.copyWith(
                                          color: Colors.white,
                                        )),
                          )),
                    ],
                  )),
            ],
          );
        });
  }
}
