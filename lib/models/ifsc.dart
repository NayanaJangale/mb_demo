import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class IFSCCode {
  int ent_no;
  String  bank_name,ifsc_code,branch_name,brcode,city;

  IFSCCode({
    this.ent_no,
    this.bank_name,
    this.ifsc_code,
    this.branch_name,
    this.brcode,
    this.city,
  });

  IFSCCode.fromMap(Map<String, dynamic> map) {
    ent_no = map["ent_no"] ?? 0;
    bank_name = map["bank_name"] ?? StringHandlers.NotAvailable;
    ifsc_code = map["ifsc_code"] ?? StringHandlers.NotAvailable;
    branch_name = map["branch_name"] ?? StringHandlers.NotAvailable;
    brcode = map["brcode"] ?? StringHandlers.NotAvailable;
    city = map["city"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "ent_no": ent_no,
        "bank_name": bank_name,
        "ifsc_code": ifsc_code,
        "branch_name": branch_name,
        "brcode": brcode,
        "city": city,
      };
}
