import 'package:cached_network_image/cached_network_image.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/album_dtl.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';

import '../app_data.dart';
import 'fullscreen_img_page.dart';

class AlbumPhotoPage extends StatefulWidget {
  List<AlbumDtls> albumDtls=[];

  AlbumPhotoPage({this.albumDtls});

  @override
  _AlbumPhotoPageState createState() => _AlbumPhotoPageState();
}

class _AlbumPhotoPageState extends State<AlbumPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                caption: AppTranslations.of(context).text("key_gallery_photo"),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: List<Widget>.generate(
                    widget.albumDtls.length??0,
                    (index) => getAlbumCard(widget.albumDtls[index], index),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getImageUrl({int album_id, int photo_id}) =>
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

  Widget getAlbumCard(AlbumDtls albumDtls, int index) {
    return FutureBuilder<String>(
        future: getImageUrl(
            album_id: albumDtls.album_id, photo_id: albumDtls.ent_no),
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
                      dynamicObjects:  widget.albumDtls,
                      imageType: 'Album',
                      photoIndex: index,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
