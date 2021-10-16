import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class Operator {
  int  AccountNoLength;
  String Provider,OperatorName,ServiceType,ServiceName,AccountNoCaption,OpCode,
  AccountNoParam;

  Operator({
    this.Provider,
    this.OperatorName,
    this.ServiceType,
    this.ServiceName,
    this.AccountNoCaption,
    this.AccountNoLength,
    this.OpCode,
    this.AccountNoParam,
  });

  Operator.fromMap(Map<String, dynamic> map) {
    Provider = map["Provider"] ?? StringHandlers.NotAvailable;
    OperatorName = map["OperatorName"] ?? StringHandlers.NotAvailable;
    ServiceType = map["ServiceType"] ?? StringHandlers.NotAvailable;
    ServiceName = map["ServiceName"] ?? StringHandlers.NotAvailable;
    AccountNoCaption = map["AccountNoCaption"] ??StringHandlers.NotAvailable;
    AccountNoLength = map["AccountNoLength"] ?? 0;
    OpCode = map["OpCode"] ??StringHandlers.NotAvailable;
    AccountNoParam = map["AccountNoParam"] ??StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "Provider": Provider,
    "OperatorName": OperatorName,
    "ServiceType": ServiceType,
    "ServiceName": ServiceName,
    "AccountNoCaption": AccountNoCaption,
    "AccountNoLength": AccountNoLength,
    "OpCode": OpCode,
    "AccountNoParam": AccountNoParam,
  };
}
