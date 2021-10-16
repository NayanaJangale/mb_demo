import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:softcoremobilebanking/models/user.dart';

class NomineeDetail {
  String CUST_ID,
      ACODE,
      NNAME,
      AGE,
      RELATION,
      NDATE,
      addres,
      BDATE,
      EMAILID,
      MARITALSTATU,
      HANDICAP,
      ADHARID,
      PAN_NO,
      RELIGION,
      CONTACT;

  NomineeDetail({
    this.CUST_ID,
    this.ACODE,
    this.NNAME,
    this.AGE,
    this.RELATION,
    this.NDATE,
    this.addres,
    this.BDATE,
    this.EMAILID,
    this.MARITALSTATU,
    this.HANDICAP,
    this.ADHARID,
    this.PAN_NO,
    this.RELIGION,
    this.CONTACT,});

  NomineeDetail.fromMap(Map<String, dynamic> map) {
    CUST_ID = map[NomineeDetailNames.CUST_ID ] ?? StringHandlers.NotAvailable;
    ACODE = map[NomineeDetailNames.ACODE ] ?? StringHandlers.NotAvailable;
    NNAME = map[NomineeDetailNames.NNAME ] ?? StringHandlers.NotAvailable;
    AGE = map[NomineeDetailNames.AGE ] ?? StringHandlers.NotAvailable;
    RELATION = map[NomineeDetailNames.RELATION ] ?? StringHandlers.NotAvailable;
    NDATE = map[NomineeDetailNames.NDATE ] ?? StringHandlers.NotAvailable;
    addres = map[NomineeDetailNames.addres ] ?? StringHandlers.NotAvailable;
    BDATE = map[NomineeDetailNames.BDATE ] ?? StringHandlers.NotAvailable;
    EMAILID = map[NomineeDetailNames.EMAILID ] ?? StringHandlers.NotAvailable;
    MARITALSTATU =
        map[NomineeDetailNames.MARITALSTATUS] ?? StringHandlers.NotAvailable;
    HANDICAP = map[NomineeDetailNames.HANDICAP ] ?? StringHandlers.NotAvailable;
    ADHARID = map[NomineeDetailNames.ADHARID ] ?? StringHandlers.NotAvailable;
    PAN_NO = map[NomineeDetailNames.PAN_NO ] ?? StringHandlers.NotAvailable;
    RELIGION = map[NomineeDetailNames.RELIGION ] ?? StringHandlers.NotAvailable;
    CONTACT = map[NomineeDetailNames.CONTACT ] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        NomineeDetailNames.CUST_ID  :CUST_ID,
        NomineeDetailNames.ACODE  :ACODE,
        NomineeDetailNames.NNAME  :NNAME,
        NomineeDetailNames.AGE  :AGE,
        NomineeDetailNames.RELATION  :RELATION,
        NomineeDetailNames.NDATE  :NDATE,
        NomineeDetailNames.addres  :addres,
        NomineeDetailNames.BDATE  :BDATE,
        NomineeDetailNames.EMAILID  :EMAILID,
        NomineeDetailNames.MARITALSTATUS  :MARITALSTATU,
        NomineeDetailNames.HANDICAP  :HANDICAP,
        NomineeDetailNames.ADHARID  :ADHARID,
        NomineeDetailNames.PAN_NO  :PAN_NO,
        NomineeDetailNames.RELIGION  :RELIGION,
        NomineeDetailNames.CONTACT  :CONTACT,

      };
}

class NomineeDetailNames {

  static const String CUST_ID = "CUST_ID";
  static const String ACODE = "ACODE";
  static const String NNAME = "NNAME";
  static const String AGE = "AGE";
  static const String RELATION = "RELATION";
  static const String NDATE = "NDATE";
  static const String addres = "addres";
  static const String BDATE = "BDATE";
  static const String EMAILID = "EMAILID";
  static const String MARITALSTATUS = "MARITALSTATUS";
  static const String HANDICAP = "HANDICAP";
  static const String ADHARID = "ADHARID";
  static const String PAN_NO = "PAN_NO";
  static const String RELIGION = "RELIGION";
  static const String CONTACT = "CONTACT";
}