import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class FDType {

  String fdtpcode, fddesc,dur_unit,inttp;
      int dur_from,dur_upto;

  FDType({
    this.fdtpcode,
    this.fddesc,
    this.dur_from,
    this.dur_upto,
    this.dur_unit,
    this.inttp,
  });

  FDType.fromMap(Map<String, dynamic> map) {
    fdtpcode = map[FDTypeNames.fdtpcode] ?? StringHandlers.NotAvailable;
    fddesc = map[FDTypeNames.fddesc] ?? StringHandlers.NotAvailable;
    dur_from = map[FDTypeNames.dur_from] ?? 0;
    dur_upto = map[FDTypeNames.dur_upto] ?? 0;
    dur_unit = map[FDTypeNames.dur_unit] ?? "M";
    inttp = map[FDTypeNames.inttp] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FDTypeNames.fdtpcode: fdtpcode,
        FDTypeNames.fddesc: fddesc,
        FDTypeNames.dur_from: dur_from,
        FDTypeNames.dur_upto: dur_upto,
        FDTypeNames.dur_unit: dur_unit,
        FDTypeNames.inttp: inttp,
      };
}

class FDTypeNames {
  static const String fdtpcode = "fdtpcode";
  static const String fddesc = "fddesc";
  static const String dur_from = "dur_from";
  static const String dur_upto = "dur_upto";
  static const String dur_unit = "dur_unit";
  static const String inttp = "inttp";
  static const String FDMatInstr = "FDMatInstr";
}
