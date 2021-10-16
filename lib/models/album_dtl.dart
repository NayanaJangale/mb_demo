import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class AlbumDtls {
  int ent_no, album_id;
  String photo,photo_desc,content_type;

  AlbumDtls({
    this.ent_no,
    this.album_id,
    this.photo,
    this.photo_desc,
    this.content_type,
  });

  AlbumDtls.fromJson(Map<String, dynamic> map) {
    ent_no = map[AlbumDtlsNames.ent_no] ?? 0;
    album_id = map[AlbumDtlsNames.album_id] ?? 0;
    photo = map[AlbumDtlsNames.photo] ?? StringHandlers.NotAvailable;
    photo_desc = map[AlbumDtlsNames.photo_desc] ?? StringHandlers.NotAvailable;
    content_type = map[AlbumDtlsNames.content_type] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        AlbumDtlsNames.ent_no: ent_no,
        AlbumDtlsNames.album_id: album_id,
        AlbumDtlsNames.photo: photo,
        AlbumDtlsNames.photo_desc: photo_desc,
        AlbumDtlsNames.content_type: content_type,
      };
}

class AlbumDtlsNames {
  static const String ent_no = "ent_no";
  static const String album_id = "album_id";
  static const String photo = "photo";
  static const String photo_desc = "photo_desc";
  static const String content_type = "content_type";
}
