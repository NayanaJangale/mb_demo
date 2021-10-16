class CyberplatRecharge {
  double DebitAmount;
  String CustomerID,
      CustomerBranchCode,
      CustomerAccountNo,
      SubscriberNo,
      Account,
      Authenticator3,
      AliasName,
      PlanID,
      ServiceID,
      SaveSubscriberNo,
      PlanOffer,
      Charges,
      SMSAutoID,
      OTP;

  CyberplatRecharge(
      {this.CustomerID,
        this.CustomerBranchCode,
        this.CustomerAccountNo,
        this.SubscriberNo,
        this.Account,
        this.Authenticator3,
        this.AliasName,
        this.PlanID,
        this.ServiceID,
        this.SaveSubscriberNo,
        this.PlanOffer,
        this.SMSAutoID,
        this.OTP,
        this.DebitAmount,
        this.Charges});

  Map<String, dynamic> toJson() => <String, dynamic>{
    "CustomerID": CustomerID ?? 0,
    "CustomerBranchCode": CustomerBranchCode,
    "CustomerAccountNo": CustomerAccountNo,
    "SubscriberNo": SubscriberNo,
    "Account": Account,
    "Authenticator3": Authenticator3,
    "AliasName": AliasName,
    "PlanID": PlanID,
    "ServiceID": ServiceID,
    "SaveSubscriberNo": SaveSubscriberNo,
    "PlanOffer": PlanOffer,
    "SMSAutoID": SMSAutoID,
    "OTP": OTP,
    "DebitAmount": DebitAmount,
    "Charges": Charges,
  };
}
