import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:softcoremobilebanking/models/user.dart';

class FDMatInstr {

  String IntrCode,Descr;

  FDMatInstr({
    this.IntrCode,
    this.Descr,
  });

  FDMatInstr.fromMap(Map<String, dynamic> map) {
    IntrCode = map[FDMatInstrNames.IntrCode] ?? StringHandlers.NotAvailable;
    Descr = map[FDMatInstrNames.Descr] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    FDMatInstrNames.IntrCode: IntrCode,
    FDMatInstrNames.Descr: Descr,
  };
}

class FDMatInstrNames {
  static const String IntrCode = "IntrCode";
  static const String Descr = "Descr";
}
