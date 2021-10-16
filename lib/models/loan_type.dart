import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class LoanType {

  String loanTp,LoanName;

  LoanType({
    this.loanTp,
    this.LoanName,
  });

  LoanType.fromJson(Map<String, dynamic> map) {
    loanTp = map[LoanTypeNames.loanTp] ?? StringHandlers.NotAvailable;
    LoanName = map[LoanTypeNames.LoanName] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    LoanTypeNames.loanTp: loanTp,
    LoanTypeNames.LoanName: LoanName,
      };
}

class LoanTypeNames {
  static const String loanTp = "l_type";
  static const String LoanName = "l_tpnm";
}

class LoanTypeUrls {
  static const String GetLoanTypes = 'LoanRecovery/GetLoanTypes';
}
