import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class Slabcharges {

  int Cirno,entno;
  double startamt,endamt,commamt;
  String comm_tp;

  Slabcharges({
    this.Cirno,
    this.entno,
    this.startamt,
    this.endamt,
    this.commamt,
    this.comm_tp,
  });

  Slabcharges.fromMap(Map<String, dynamic> map) {
    Cirno = map["Cirno"] ?? 0;
    entno = map["entno"] ?? 0;
    startamt = map["startamt"] ?? 0;
    endamt = map["endamt"] ?? 0;
    commamt = map["commamt"] ?? 0;
    comm_tp = map["comm_tp"] ??StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "Cirno": Cirno,
        "entno": entno,
        "startamt": startamt,
        "endamt": endamt,
        "commamt": commamt,
        "comm_tp": comm_tp,
      };
}
