import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class RechargePlan {
  String rs,desc;

  RechargePlan({
    this.rs,
    this.desc,
  });

  RechargePlan.fromMap(Map<String, dynamic> map) {
    rs = map["rs"] ?? StringHandlers.NotAvailable;
    desc = map["desc"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "rs": rs,
    "desc": desc,
  };
}
