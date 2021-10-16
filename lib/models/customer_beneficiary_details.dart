import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class CustomerBeneficiaryDetails {
  /*
  "BeneficiaryMobileNo":null,"BeneficiaryBranchName":"PACHORA"}
   */
  String CustomerID, BeneficiaryType,BeneficiaryBranchCode,BeneficiaryAccountNo,BeneficiaryNickName,BeneficiaryBankName;
  String IFSCCode,BeneficiaryCity,BeneficiaryStatus,BeneficiaryBankNo,BeneficiaryMobileNo,BeneficiaryBranchName;

  CustomerBeneficiaryDetails({
    this.CustomerID,
    this.BeneficiaryType,
    this.BeneficiaryBranchCode,
    this.BeneficiaryAccountNo,
    this.BeneficiaryNickName,
    this.BeneficiaryBankName,
    this.IFSCCode,
    this.BeneficiaryCity,
    this.BeneficiaryStatus,
    this.BeneficiaryBankNo,
    this.BeneficiaryMobileNo,
    this.BeneficiaryBranchName,
  });

  CustomerBeneficiaryDetails.fromMap(Map<String, dynamic> map) {
    CustomerID = map["CustomerID"] ?? StringHandlers.NotAvailable;
    BeneficiaryType = map["BeneficiaryType"] ?? StringHandlers.NotAvailable;
    BeneficiaryBranchCode = map["BeneficiaryBranchCode"] ?? StringHandlers.NotAvailable;
    BeneficiaryAccountNo = map["BeneficiaryAccountNo"] ?? StringHandlers.NotAvailable;
    BeneficiaryNickName = map["BeneficiaryNickName"] ?? StringHandlers.NotAvailable;
    BeneficiaryBankName = map["BeneficiaryBankName"] ?? StringHandlers.NotAvailable;
    IFSCCode = map["IFSCCode"] ?? StringHandlers.NotAvailable;
    BeneficiaryCity = map["BeneficiaryCity"] ?? StringHandlers.NotAvailable;
    BeneficiaryStatus = map["BeneficiaryStatus"] ?? StringHandlers.NotAvailable;
    BeneficiaryBankNo = map["BeneficiaryBankNo"] ?? StringHandlers.NotAvailable;
    BeneficiaryMobileNo = map["BeneficiaryMobileNo"] ?? StringHandlers.NotAvailable;
    BeneficiaryBranchName = map["BeneficiaryBranchName"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "CustomerID": CustomerID,
        "BeneficiaryType": BeneficiaryType,
        "BeneficiaryBranchCode": BeneficiaryBranchCode,
        "BeneficiaryAccountNo": BeneficiaryAccountNo,
        "BeneficiaryNickName": BeneficiaryNickName,
        "BeneficiaryBankName": BeneficiaryBankName,
        "IFSCCode": IFSCCode,
        "BeneficiaryCity": BeneficiaryCity,
        "BeneficiaryStatus": BeneficiaryStatus,
        "BeneficiaryBankNo": BeneficiaryBankNo,
        "BeneficiaryMobileNo": BeneficiaryMobileNo,
        "BeneficiaryBranchName": BeneficiaryBranchName,
      };
}
