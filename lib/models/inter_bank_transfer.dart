import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class InterBankTransfer {
  String PaymentIndicator, CustName,CustBrCode,CustAcNo,BenefAcNo,BenefName,IFSCCode,BenefBankNo,BeneEmail,BeneMobile,BeneAddr1,Narration,benfBankName;
  double Amount,Charge;


  InterBankTransfer({
    this.PaymentIndicator,
    this.CustName,
    this.CustBrCode,
    this.CustAcNo,
    this.BenefAcNo,
    this.BenefName,
    this.IFSCCode,
    this.BenefBankNo,
    this.BeneEmail,
    this.BeneMobile,
    this.BeneAddr1,
    this.Amount,
    this.Charge,
    this.Narration,
    this.benfBankName,
  });

  InterBankTransfer.fromMap(Map<String, dynamic> map) {
    PaymentIndicator = map["PaymentIndicator"] ?? StringHandlers.NotAvailable;
    CustName = map["CustName"] ?? StringHandlers.NotAvailable;
    CustBrCode = map["CustBrCode"] ?? StringHandlers.NotAvailable;
    CustAcNo = map["CustAcNo"] ?? StringHandlers.NotAvailable;
    BenefAcNo = map["BenefAcNo"] ?? StringHandlers.NotAvailable;
    BenefName = map["BenefName"] ?? StringHandlers.NotAvailable;
    IFSCCode = map["IFSCCode"] ?? StringHandlers.NotAvailable;
    BenefBankNo = map["BenefBankNo"] ?? StringHandlers.NotAvailable;
    BeneEmail = map["BeneEmail"] ?? StringHandlers.NotAvailable;
    BeneMobile = map["BeneMobile"] ?? StringHandlers.NotAvailable;
    BeneAddr1 = map["BeneAddr1"] ?? StringHandlers.NotAvailable;
    Amount = map["BeneAddr1"] ?? 0;
    Charge = map["Charge"] ?? 0;
    Narration = map["Narration"] ?? StringHandlers.NotAvailable;
    benfBankName = map["benfBankName"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "PaymentIndicator": PaymentIndicator,
        "CustName": CustName,
        "CustBrCode": CustBrCode,
        "CustAcNo": CustAcNo,
        "BenefAcNo": BenefAcNo,
        "BenefName": BenefName,
        "IFSCCode": IFSCCode,
        "BenefBankNo": BenefBankNo,
        "BeneEmail": BeneEmail,
        "BeneMobile": BeneMobile,
        "BeneAddr1": BeneAddr1,
        "Amount": Amount,
        "Charge": Charge,
        "Narration": Narration,
        "benfBankName": benfBankName,
      };
}
