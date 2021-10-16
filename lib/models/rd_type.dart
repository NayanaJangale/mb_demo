import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class RDType {

  String rdtpcode,rdtpname,rdduration;

  RDType({
    this.rdtpcode,
    this.rdtpname,
    this.rdduration,
  });

  RDType.fromMap(Map<String, dynamic> map) {
    rdtpcode = map["rdtpcode"] ?? StringHandlers.NotAvailable;
    rdtpname = map["rdtpname"] ?? StringHandlers.NotAvailable;
    rdduration = map["rdduration"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "rdtpcode": rdtpcode,
        "rdtpname": rdtpname,
        "rdduration": rdduration,
      };
}
