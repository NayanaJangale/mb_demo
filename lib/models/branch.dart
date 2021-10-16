import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class Branch {
  String Brcode, Brname, Blocation, brfullname;

  Branch({
    this.Brcode,
    this.Brname,
    this.Blocation,
    this.brfullname,
  });

  Branch.fromMap(Map<String, dynamic> map) {
    Brcode = map["Brcode"] ?? StringHandlers.NotAvailable;
    Brname = map["Brname"] ?? StringHandlers.NotAvailable;
    Blocation = map["Blocation"] ?? StringHandlers.NotAvailable;
    brfullname = map["brfullname"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "Brcode": Brcode,
        "Brname": Brname,
        "Blocation": Blocation,
        "brfullname": brfullname,
      };
}
