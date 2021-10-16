import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/models/loan_document.dart';

import '../handlers/string_handlers.dart';

class LoanRequest {

  int entno;
  double Amount;
  String custid,l_type,reqDate,aStatus,expDur,brcode,ApproveDate,l_tpnm,Brname;
  List<LoanDocument> loanDocuments;

  LoanRequest({
    this.entno,
    this.custid,
    this.l_type,
    this.reqDate,
    this.aStatus,
    this.expDur,
    this.Amount,
    this.brcode,
    this.ApproveDate,
    this.l_tpnm,
    this.Brname,
    this.loanDocuments,
  });

  LoanRequest.fromJson(Map<String, dynamic> map) {

    var loanDocData = map[LoanRequestConst.loanDocuments];

    entno = map[LoanRequestConst.entno] ?? 0;
    custid = map[LoanRequestConst.custid] ?? StringHandlers.NotAvailable;
    l_type = map[LoanRequestConst.l_type] ?? StringHandlers.NotAvailable;
    reqDate = map[LoanRequestConst.reqDate] ?? StringHandlers.NotAvailable;
    aStatus = map[LoanRequestConst.aStatus] ?? StringHandlers.NotAvailable;
    expDur = map[LoanRequestConst.expDur] ?? StringHandlers.NotAvailable;
    Amount = map[LoanRequestConst.Amount] ?? 0;
    brcode = map[LoanRequestConst.brcode] ?? StringHandlers.NotAvailable;
    ApproveDate = map[LoanRequestConst.ApproveDate] ?? StringHandlers.NotAvailable;
    l_tpnm = map[LoanRequestConst.l_tpnm] ?? StringHandlers.NotAvailable;
    Brname = map[LoanRequestConst.Brname] ?? StringHandlers.NotAvailable;
    loanDocuments = List<LoanDocument>.from(loanDocData.map((i) => LoanDocument.fromJson(i)))?? [];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        LoanRequestConst.entno: entno,
        LoanRequestConst.custid: custid,
        LoanRequestConst.l_type: l_type,
        LoanRequestConst.reqDate: reqDate,
        LoanRequestConst.aStatus: aStatus,
        LoanRequestConst.expDur: expDur,
        LoanRequestConst.Amount: Amount,
        LoanRequestConst.brcode: brcode,
        LoanRequestConst.ApproveDate: ApproveDate,
        LoanRequestConst.l_tpnm: l_tpnm,
        LoanRequestConst.Brname: Brname,
        LoanRequestConst.loanDocuments: loanDocuments,
      };
}

class LoanRequestConst {
  static const String entno = "entno";
  static const String custid = "custid";
  static const String l_type = "l_type";
  static const String reqDate = "reqDate";
  static const String aStatus = "aStatus";
  static const String expDur = "expDur";
  static const String Amount = "Amount";
  static const String brcode = "brcode";
  static const String ApproveDate = "ApproveDate";
  static const String l_tpnm = "l_tpnm";
  static const String Brname = "Brname";
  static const String loanDocuments = "LoanDocuments";
}

class LoanRequestUrls {
  static const String GetLoanRequests = "LoanRecovery/GetLoanRequests";
  static const String GetLoanDocument = "LoanRecovery/GetLoanDocument";
}
