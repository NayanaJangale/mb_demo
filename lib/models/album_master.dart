import 'package:softcoremobilebanking/handlers/string_handlers.dart';

import 'album_dtl.dart';

class AlbumMaster {
  int album_id;
  String album_desc,album_status,Brcode;
  List<AlbumDtls> albumDtls;

  AlbumMaster({
    this.album_id,
    this.album_desc,
    this.album_status,
    this.Brcode,
    this.albumDtls,
  });

  AlbumMaster.fromJson(Map<String, dynamic> map) {
    album_id = map[AlbumMasterNames.album_id] ?? 0;
    album_desc = map[AlbumMasterNames.album_desc] ?? StringHandlers.NotAvailable;
    album_status = map[AlbumMasterNames.album_status] ?? StringHandlers.NotAvailable;
    Brcode = map[AlbumMasterNames.Brcode] ?? StringHandlers.NotAvailable;

    var albumDtlData = map[AlbumMasterNames.album_Details];
    albumDtls = List<AlbumDtls>.from(albumDtlData.map((i) => AlbumDtls.fromJson(i)))?? [];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AlbumMasterNames.album_id: album_id,
    AlbumMasterNames.album_desc: album_desc,
    AlbumMasterNames.album_status: album_status,
    AlbumMasterNames.Brcode: Brcode,
    AlbumMasterNames.album_Details: albumDtls,
      };
}

class AlbumMasterNames {
  static const String album_id = "album_id";
  static const String album_desc = "album_desc";
  static const String album_status = "album_status";
  static const String Brcode = "Brcode";
  static const String album_Details = "album_Details";
}

