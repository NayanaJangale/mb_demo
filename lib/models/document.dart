import 'dart:io';

import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class Document {
  String ENTNO,
      DOCNO,
      CDOC,
      DOCTPCODE,
      DOCCODE,
      DOCTPNAME,
      DOCNAME,
      MIN_DOCS,
      ACATNO,
      MUSTFLAG,
      SELFLAG,
      ACODE,
      ReqType;
  File docImg;

  Document({
    this.ENTNO,
    this.DOCNO,
    this.CDOC,
    this.DOCTPCODE,
    this.DOCCODE,
    this.DOCTPNAME,
    this.DOCNAME,
    this.MIN_DOCS,
    this.ACATNO,
    this.MUSTFLAG,
    this.SELFLAG,
    this.ACODE,
    this.ReqType,
  });

  Document.fromMap(Map<String, dynamic> map) {
    ENTNO = map[DocumentNames.ENTNO] ?? StringHandlers.NotAvailable;
    DOCNO = map[DocumentNames.DOCNO] ?? StringHandlers.NotAvailable;
    CDOC = map[DocumentNames.CDOC] ?? StringHandlers.NotAvailable;
    DOCTPCODE = map[DocumentNames.DOCTPCODE] ?? StringHandlers.NotAvailable;
    DOCCODE = map[DocumentNames.DOCCODE] ?? StringHandlers.NotAvailable;
    DOCTPNAME = map[DocumentNames.DOCTPNAME] ?? StringHandlers.NotAvailable;
    DOCNAME = map[DocumentNames.DOCNAME] ?? StringHandlers.NotAvailable;
    MIN_DOCS = map[DocumentNames.MIN_DOCS] ?? StringHandlers.NotAvailable;
    ACATNO = map[DocumentNames.ACATNO] ?? StringHandlers.NotAvailable;
    MUSTFLAG = map[DocumentNames.MUSTFLAG] ?? StringHandlers.NotAvailable;
    SELFLAG = map[DocumentNames.SELFLAG] ?? StringHandlers.NotAvailable;
    ACODE = map[DocumentNames.ACODE] ?? StringHandlers.NotAvailable;
    ReqType = map[DocumentNames.ReqType] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        DocumentNames.ENTNO: ENTNO,
        DocumentNames.DOCNO: DOCNO,
        DocumentNames.CDOC: CDOC,
        DocumentNames.DOCTPCODE: DOCTPCODE,
        DocumentNames.DOCCODE: DOCCODE,
        DocumentNames.DOCTPNAME: DOCTPNAME,
        DocumentNames.DOCNAME: DOCNAME,
        DocumentNames.MIN_DOCS: MIN_DOCS,
        DocumentNames.ACATNO: ACATNO,
        DocumentNames.MUSTFLAG: MUSTFLAG,
        DocumentNames.SELFLAG: SELFLAG,
        DocumentNames.ACODE: ACODE,
        DocumentNames.ReqType: ReqType,
      };
}

class DocumentNames {
  static const String ENTNO = "ENTNO";
  static const String DOCNO = "DOCNO";
  static const String CDOC = "CDOC";
  static const String DOCTPCODE = "DOCTPCODE";
  static const String DOCCODE = "DOCCODE";
  static const String DOCTPNAME = "DOCTPNAME";
  static const String DOCNAME = "DOCNAME";
  static const String MIN_DOCS = "MIN_DOCS";
  static const String ACATNO = "ACATNO";
  static const String MUSTFLAG = "MUSTFLAG";
  static const String SELFLAG = "SELFLAG";
  static const String ACODE = "ACODE";
  static const String ReqType = "ReqType";
}
