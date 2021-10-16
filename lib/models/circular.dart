import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class Circular {

  /*
  "UserNo":1,"Brcode":"001"}
   */
  int ent_no,UserNo;
  String entry_date,circular_title,circular_desc,Brcode;

  Circular({
    this.ent_no,
    this.entry_date,
    this.circular_title,
    this.circular_desc,
    this.UserNo,
    this.Brcode,
  });

  Circular.fromJson(Map<String, dynamic> map) {
    ent_no = map[CircularNames.ent_no] ?? 0;
    entry_date = map[CircularNames.entry_date] ?? StringHandlers.NotAvailable;
    circular_title = map[CircularNames.circular_title] ?? StringHandlers.NotAvailable;
    circular_desc = map[CircularNames.circular_desc] ?? StringHandlers.NotAvailable;
    UserNo = map[CircularNames.UserNo] ?? 0;
    Brcode = map[CircularNames.Brcode] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    CircularNames.ent_no: ent_no,
    CircularNames.entry_date: entry_date,
    CircularNames.circular_title: circular_title,
    CircularNames.circular_desc: circular_desc,
    CircularNames.UserNo: UserNo,
    CircularNames.Brcode: Brcode,
      };
}

class CircularNames {
  static const String ent_no = "ent_no";
  static const String entry_date = "entry_date";
  static const String circular_title = "circular_title";
  static const String circular_desc = "circular_desc";
  static const String UserNo = "UserNo";
  static const String Brcode = "Brcode";
}

