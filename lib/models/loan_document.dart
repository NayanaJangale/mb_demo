import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class LoanDocument {
  int entno,docno,doctpcode,doccode;
  String Doctpname,DOCNAME;

  LoanDocument({
    this.entno,
    this.docno,
    this.doctpcode,
    this.doccode,
    this.Doctpname,
    this.DOCNAME,
  });

  LoanDocument.fromJson(Map<String, dynamic> map) {
    entno = map[LoanDocumentNames.entno] ?? 0;
    docno = map[LoanDocumentNames.docno] ?? 0;
    doctpcode = map[LoanDocumentNames.doctpcode] ?? 0;
    doccode = map[LoanDocumentNames.doccode] ?? 0;
    Doctpname = map[LoanDocumentNames.Doctpname] ?? StringHandlers.NotAvailable;
    DOCNAME = map[LoanDocumentNames.DOCNAME] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    LoanDocumentNames.entno: entno,
    LoanDocumentNames.docno: docno,
    LoanDocumentNames.doctpcode: doctpcode,
    LoanDocumentNames.doccode: doccode,
    LoanDocumentNames.Doctpname: Doctpname,
    LoanDocumentNames.DOCNAME: DOCNAME,
  };
}

class LoanDocumentNames {
  static const String entno = "entno";
  static const String docno = "docno";
  static const String doctpcode = "doctpcode";
  static const String doccode = "doccode";
  static const String Doctpname = "Doctpname";
  static const String DOCNAME = "DOCNAME";
}