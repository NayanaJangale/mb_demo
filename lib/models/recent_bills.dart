import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class RecentBills {
  String SrNo,PaymentAutoID,CustomerID,TransactionID,CustomerAccountNo,SubscriberNo,OpName,ServiceName,
      AliasName,Account,Authenticator3,OperatorCode,CircleCode,ServiceType,DebitAmount,PaymentStatus,TransDate,LName,CircleName,PlanName,BrName;

  RecentBills({
    this.SrNo,
    this.PaymentAutoID,
    this.CustomerID,
    this.TransactionID,
    this.CustomerAccountNo,
    this.SubscriberNo,
    this.OpName,
    this.ServiceName,
    this.AliasName,
    this.Account,
    this.Authenticator3,
    this.OperatorCode,
    this.CircleCode,
    this.ServiceType,
    this.DebitAmount,
    this.PaymentStatus,
    this.TransDate,
    this.LName,
    this.CircleName,
    this.PlanName,
    this.BrName,
  });

  RecentBills.fromMap(Map<String, dynamic> map) {
    SrNo = map["SrNo"] ?? StringHandlers.NotAvailable;
    PaymentAutoID = map["PaymentAutoID"] ?? StringHandlers.NotAvailable;
    CustomerID = map["CustomerID"] ?? StringHandlers.NotAvailable;
    TransactionID = map["TransactionID"] ?? StringHandlers.NotAvailable;
    CustomerAccountNo = map["CustomerAccountNo"] ?? StringHandlers.NotAvailable;
    SubscriberNo = map["SubscriberNo"] ??StringHandlers.NotAvailable;
    OpName = map["OpName"] ??StringHandlers.NotAvailable;
    ServiceName = map["ServiceName"] ??StringHandlers.NotAvailable;
    AliasName = map["AliasName"] ??StringHandlers.NotAvailable;
    Account = map["Account"] ??StringHandlers.NotAvailable;
    Authenticator3 = map["Authenticator3"] ??StringHandlers.NotAvailable;
    OperatorCode = map["OperatorCode"] ??StringHandlers.NotAvailable;
    CircleCode = map["CircleCode"] ??StringHandlers.NotAvailable;
    ServiceType = map["ServiceType"] ??StringHandlers.NotAvailable;
    DebitAmount = map["DebitAmount"] ??StringHandlers.NotAvailable;
    PaymentStatus = map["PaymentStatus"] ??StringHandlers.NotAvailable;
    TransDate = map["TransDate"] ??StringHandlers.NotAvailable;
    LName = map["LName"] ??StringHandlers.NotAvailable;
    CircleName = map["CircleName"] ??StringHandlers.NotAvailable;
    PlanName = map["PlanName"] ??StringHandlers.NotAvailable;
    BrName = map["BrName"] ??StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "SrNo": SrNo,
    "PaymentAutoID": PaymentAutoID,
    "CustomerID": CustomerID,
    "TransactionID": TransactionID,
    "CustomerAccountNo": CustomerAccountNo,
    "SubscriberNo": SubscriberNo,
    "OpName": OpName,
    "ServiceName": ServiceName,
    "AliasName": AliasName,
    "Account": Account,
    "Authenticator3": Authenticator3,
    "OperatorCode": OperatorCode,
    "CircleCode": CircleCode,
    "ServiceType": ServiceType,
    "DebitAmount": DebitAmount,
    "PaymentStatus": PaymentStatus,
    "TransDate": TransDate,
    "LName": LName,
    "CircleName": CircleName,
    "PlanName": PlanName,
    "BrName": BrName,
  };
}
