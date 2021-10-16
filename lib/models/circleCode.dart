import 'dart:convert';

import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class CircleCode {
  int ServiceID, SeqNo,CircleNo;
  bool Deleted, isPlanOffer = false;
  String PlanName,
      ServiceUrlType,
      ServiceUrl,
      ValidationDescription,
      AdditionalParameters,
      CircleName,
      circleCode,
      Validations;

  CircleCode(
      {this.ServiceID,
      this.SeqNo,
      this.PlanName,
      this.ServiceUrlType,
      this.ServiceUrl,
      this.ValidationDescription,
      this.AdditionalParameters,
      this.Deleted,
      this.CircleNo,
      this.CircleName,
      this.circleCode,
      this.Validations});

  CircleCode.fromMap(Map<String, dynamic> map) {
    ServiceID = map["ServiceID"] ?? 0;
    SeqNo = map["SeqNo"] ?? 0;
    PlanName = map["PlanName"] ?? StringHandlers.NotAvailable;
    ServiceUrlType = map["ServiceUrlType"] ?? StringHandlers.NotAvailable;
    ServiceUrl = map["ServiceUrl"] ?? StringHandlers.NotAvailable;
    Validations = map["Validations"] ?? StringHandlers.NotAvailable;
    if (Validations != null && Validations != "" && Validations != StringHandlers.NotAvailable) {
      Map<String, dynamic> valdMap = json.decode(Validations.trim());
      isPlanOffer = valdMap["PlanOfferings"] != null ? true : false;
    }
    ValidationDescription =
        map["ValidationDescription"] ?? StringHandlers.NotAvailable;
    AdditionalParameters =
        map["AdditionalParameters"] ?? StringHandlers.NotAvailable;
    Deleted = map["Deleted"] ?? false;
    CircleNo = map["CircleNo"] ?? 0;
    CircleName = map["CircleName"] ?? StringHandlers.NotAvailable;
    circleCode = map["CircleCode"] ?? StringHandlers.NotAvailable;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        "ServiceID": ServiceID,
        "SeqNo": SeqNo,
        "PlanName": PlanName,
        "ServiceUrlType": ServiceUrlType,
        "ServiceUrl": ServiceUrl,
        "ValidationDescription": ValidationDescription,
        "AdditionalParameters": AdditionalParameters,
        "Deleted": Deleted,
        "CircleNo": CircleNo,
        "CircleName": CircleName,
        "CircleCode": circleCode,
      };
}
