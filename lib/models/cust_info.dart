import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:softcoremobilebanking/models/user.dart';

class CustInfo {

  String cust_id, name,bdate,adharID,pan_no,emailid,phoneNo,addr;

  CustInfo({
    this.cust_id,
    this.name,
    this.bdate,
    this.adharID,
    this.pan_no,
    this.emailid,
    this.phoneNo,
    this.addr,
  });

  CustInfo.fromMap(Map<String, dynamic> map) {
    cust_id = map[CustInfoNames.cust_id] ?? StringHandlers.NotAvailable;
    name = map[CustInfoNames.name] ?? StringHandlers.NotAvailable;
    bdate = map[CustInfoNames.bdate] ?? StringHandlers.NotAvailable;
    adharID = map[CustInfoNames.adharID] ?? StringHandlers.NotAvailable;
    pan_no = map[CustInfoNames.pan_no] ?? StringHandlers.NotAvailable;
    emailid = map[CustInfoNames.emailid] ?? StringHandlers.NotAvailable;
    phoneNo = map[CustInfoNames.phoneNo] ?? StringHandlers.NotAvailable;
    addr = map[CustInfoNames.addr] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        CustInfoNames.cust_id: cust_id,
        CustInfoNames.name: name,
        CustInfoNames.bdate: bdate,
        CustInfoNames.adharID: adharID,
        CustInfoNames.pan_no: pan_no,
        CustInfoNames.emailid: emailid,
        CustInfoNames.phoneNo: phoneNo,
        CustInfoNames.addr: addr,
      };
}

class CustInfoNames {
  static const String cust_id = "cust_id";
  static const String name = "name";
  static const String bdate = "bdate";
  static const String adharID = "adharID";
  static const String pan_no = "pan_no";
  static const String emailid = "emailid";
  static const String phoneNo = "phoneNo";
  static const String addr = "addr";
}
