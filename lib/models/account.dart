import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:flutter/material.dart';

import 'nominee_detail.dart';

class Account {
  String AccountNo='',
      AccountName='',
      AccountType,
      AcType,
      LoanType,
      OpeningDate,
      BranchCode,
      BranchDisplayName,
      IFSCCode,
      vacode;
  double Balance, WithdrawalLimit;
  List<NomineeDetail> NomineeDetails;
  bool isACVisible = false;
  bool isSelected = false ;

  Account({
    this.AccountNo,
    this.AccountName,
    this.AccountType,
    this.AcType,
    this.LoanType,
    this.OpeningDate,
    this.BranchCode,
    this.BranchDisplayName,
    this.IFSCCode,
    this.vacode,
    this.Balance,
    this.WithdrawalLimit,
    this.NomineeDetails,
  });

  Account.fromMap(Map<String, dynamic> map) {
    AccountNo = map[AccountNames.AccountNo] ?? StringHandlers.NotAvailable;
    AccountName = map[AccountNames.AccountName] ?? StringHandlers.NotAvailable;
    AccountType = map[AccountNames.AccountType] ?? StringHandlers.NotAvailable;
    AcType = map[AccountNames.AcType] ?? StringHandlers.NotAvailable;
    LoanType = map[AccountNames.LoanType] ?? StringHandlers.NotAvailable;
    OpeningDate = map[AccountNames.OpeningDate] ?? StringHandlers.NotAvailable;
    BranchCode = map[AccountNames.BranchCode] ?? StringHandlers.NotAvailable;
    BranchDisplayName = map[AccountNames.BranchDisplayName] ?? StringHandlers.NotAvailable;
    IFSCCode = map[AccountNames.IFSCCode] ?? StringHandlers.NotAvailable;
    vacode = map[AccountNames.vacode] ?? StringHandlers.NotAvailable;
    Balance = map[AccountNames.Balance] ?? 0;
    WithdrawalLimit = map[AccountNames.WithdrawalLimit] ?? 0;
    var userData = map[AccountNames.NomineeDetails];
    NomineeDetails = List<NomineeDetail>.from(userData.map((i) => NomineeDetail.fromMap(i)))?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        AccountNames.AccountNo: AccountNo,
        AccountNames.AccountName: AccountName,
        AccountNames.AccountType: AccountType,
        AccountNames.AcType: AcType,
        AccountNames.LoanType: LoanType,
        AccountNames.OpeningDate: OpeningDate,
        AccountNames.BranchCode: BranchCode,
        AccountNames.BranchDisplayName: BranchDisplayName,
        AccountNames.IFSCCode: IFSCCode,
        AccountNames.vacode: vacode,
        AccountNames.Balance: Balance,
        AccountNames.WithdrawalLimit: WithdrawalLimit,
        AccountNames.NomineeDetails: NomineeDetails,
      };
}

class AccountNames {
  static const String AccountNo = "AccountNo";
  static const String AccountName = "AccountName";
  static const String AccountType = "AccountType";
  static const String AcType = "AcType";
  static const String LoanType = "LoanType";
  static const String OpeningDate = "OpeningDate";
  static const String BranchCode = "BranchCode";
  static const String BranchDisplayName = "BranchDisplayName";
  static const String vacode = "vacode";
  static const String Balance = "Balance";
  static const String WithdrawalLimit = "WithdrawalLimit";
  static const String NomineeDetails = "NomineeDetails";
  static const String IFSCCode = "IFSCCode";
}

class AccountType {
  static const String TransactionalAccounts = "Transactional Accounts";
  static const String DepositAccounts = "Deposit Accounts";
  static const String LoanAccounts = "Loan Accounts";
  static const String FixedDepositAccount = "Fixed Deposit Account";
  static const String RecurringDepositAccount = "Recurring Deposit Account";
  static const String DailyRecurringDepositAccount = "Daily Recurring Deposit Account";
}
class LoanType{
  static const String Installment = "Installment";
  static const String DateType = "Date Type";
}