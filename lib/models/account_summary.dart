import 'package:softcoremobilebanking/handlers/string_handlers.dart';

import 'nominee_detail.dart';

class AccountSummary {

  String LoanAmount,
      WithdrawalLimit,
      BalanceType,
      AccountNo,
      InterestRate,
      OpeningDate,
      RDInstallmentAmount,
      LoanInstallmentAmount,
      RDMaturityAmount,
      NextInstallmentDate,
      FixedDepositAmount,
      FDMaturityAmount,
      LoanType,
      ClosingDate,
      NoOfLoanInstallments,
      LoanLimit,
      AccountName,
      Balance;

  AccountSummary({
    this.LoanAmount,
    this.WithdrawalLimit,
    this.BalanceType,
    this.AccountNo,
    this.InterestRate,
    this.OpeningDate,
    this.RDInstallmentAmount,
    this.LoanInstallmentAmount,
    this.RDMaturityAmount,
    this.NextInstallmentDate,
    this.FixedDepositAmount,
    this.FDMaturityAmount,
    this.LoanType,
    this.ClosingDate,
    this.NoOfLoanInstallments,
    this.LoanLimit,
    this.AccountName,
    this.Balance,
  });

  AccountSummary.fromMap(Map<String, dynamic> map) {
    LoanAmount = map[AccountSummaryNames.LoanAmount] ?? StringHandlers.NotAvailable;
    WithdrawalLimit = map[AccountSummaryNames.WithdrawalLimit] ?? StringHandlers.NotAvailable;
    BalanceType = map[AccountSummaryNames.BalanceType] ?? StringHandlers.NotAvailable;
    AccountNo = map[AccountSummaryNames.AccountNo] ?? StringHandlers.NotAvailable;
    InterestRate = map[AccountSummaryNames.InterestRate] ?? StringHandlers.NotAvailable;
    OpeningDate = map[AccountSummaryNames.OpeningDate] ?? StringHandlers.NotAvailable;
    RDInstallmentAmount = map[AccountSummaryNames.RDInstallmentAmount] ?? StringHandlers.NotAvailable;
    LoanInstallmentAmount = map[AccountSummaryNames.LoanInstallmentAmount] ?? StringHandlers.NotAvailable;
    RDMaturityAmount = map[AccountSummaryNames.RDMaturityAmount] ?? StringHandlers.NotAvailable;
    NextInstallmentDate = map[AccountSummaryNames.NextInstallmentDate] ?? StringHandlers.NotAvailable;
    FixedDepositAmount = map[AccountSummaryNames.FixedDepositAmount] ?? StringHandlers.NotAvailable;
    FDMaturityAmount = map[AccountSummaryNames.FDMaturityAmount] ?? StringHandlers.NotAvailable;
    LoanType = map[AccountSummaryNames.LoanType] ?? StringHandlers.NotAvailable;
    ClosingDate = map[AccountSummaryNames.ClosingDate] ?? StringHandlers.NotAvailable;
    NoOfLoanInstallments = map[AccountSummaryNames.NoOfLoanInstallments] ?? StringHandlers.NotAvailable;
    LoanLimit = map[AccountSummaryNames.LoanLimit] ?? StringHandlers.NotAvailable;
    AccountName = map[AccountSummaryNames.AccountName] ?? StringHandlers.NotAvailable;
    Balance = map[AccountSummaryNames.Balance] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AccountSummaryNames.LoanAmount: LoanAmount,
    AccountSummaryNames.WithdrawalLimit: WithdrawalLimit,
    AccountSummaryNames.BalanceType: BalanceType,
    AccountSummaryNames.AccountNo: AccountNo,
    AccountSummaryNames.InterestRate: InterestRate,
    AccountSummaryNames.OpeningDate: OpeningDate,
    AccountSummaryNames.RDInstallmentAmount: RDInstallmentAmount,
    AccountSummaryNames.LoanInstallmentAmount: LoanInstallmentAmount,
    AccountSummaryNames.RDMaturityAmount: RDMaturityAmount,
    AccountSummaryNames.NextInstallmentDate: NextInstallmentDate,
    AccountSummaryNames.FixedDepositAmount: FixedDepositAmount,
    AccountSummaryNames.FDMaturityAmount: FDMaturityAmount,
    AccountSummaryNames.LoanType: LoanType,
    AccountSummaryNames.ClosingDate: ClosingDate,
    AccountSummaryNames.NoOfLoanInstallments: NoOfLoanInstallments,
    AccountSummaryNames.LoanLimit: LoanLimit,
    AccountSummaryNames.AccountName: AccountName,
    AccountSummaryNames.Balance: Balance,
  };
}

class AccountSummaryNames {
  static const String LoanAmount = "LoanAmount";
  static const String WithdrawalLimit = "WithdrawalLimit";
  static const String BalanceType = "BalanceType";
  static const String AccountNo = "AccountNo";
  static const String InterestRate = "InterestRate";
  static const String OpeningDate = "OpeningDate";
  static const String RDInstallmentAmount = "RDInstallmentAmount";
  static const String LoanInstallmentAmount = "LoanInstallmentAmount";
  static const String RDMaturityAmount = "RDMaturityAmount";
  static const String NextInstallmentDate = "NextInstallmentDate";
  static const String FixedDepositAmount = "FixedDepositAmount";
  static const String FDMaturityAmount = "FDMaturityAmount";
  static const String LoanType = "LoanType";
  static const String ClosingDate = "ClosingDate";
  static const String NoOfLoanInstallments = "NoOfLoanInstallments";
  static const String LoanLimit = "LoanLimit";
  static const String AccountName = "AccountName";
  static const String Balance = "Balance";
}
class AccountSummaryUrls {
  static const String GET_ACCOUNTSUMMARY = "Customer/GetAccountSummary";
}
