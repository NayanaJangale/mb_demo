import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class AccountStatement {
  String RNO,
      AccountNo,
      VoucherDate,
      Narration,
      DebitAmount,
      CreditAmount,
      ClosingBalance,
      BalanceType;

  AccountStatement({
    this.RNO,
    this.AccountNo,
    this.VoucherDate,
    this.Narration,
    this.DebitAmount,
    this.CreditAmount,
    this.ClosingBalance,
    this.BalanceType,
  });

  AccountStatement.fromJson(Map<String, dynamic> map) {
    RNO = map[DthInfoNames.RNO] ?? StringHandlers.NotAvailable;
    AccountNo = map[DthInfoNames.AccountNo] ?? StringHandlers.NotAvailable;
    VoucherDate = map[DthInfoNames.VoucherDate] ?? StringHandlers.NotAvailable;
    Narration = map[DthInfoNames.Narration] ?? StringHandlers.NotAvailable;
    DebitAmount = map[DthInfoNames.DebitAmount] ?? StringHandlers.NotAvailable;
    CreditAmount =
        map[DthInfoNames.CreditAmount] ?? StringHandlers.NotAvailable;
    ClosingBalance =
        map[DthInfoNames.ClosingBalance] ?? StringHandlers.NotAvailable;
    BalanceType = map[DthInfoNames.BalanceType] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        DthInfoNames.RNO: RNO,
        DthInfoNames.AccountNo: AccountNo,
        DthInfoNames.VoucherDate: VoucherDate,
        DthInfoNames.Narration: Narration,
        DthInfoNames.DebitAmount: DebitAmount,
        DthInfoNames.CreditAmount: CreditAmount,
        DthInfoNames.ClosingBalance: ClosingBalance,
        DthInfoNames.BalanceType: BalanceType,
      };
}

class DthInfoNames {
  static const String RNO = "RNO";
  static const String AccountNo = "AccountNo";
  static const String VoucherDate = "VoucherDate";
  static const String Narration = "Narration";
  static const String DebitAmount = "DebitAmount";
  static const String CreditAmount = "CreditAmount";
  static const String ClosingBalance = "ClosingBalance";
  static const String BalanceType = "BalanceType";
}
