import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class DthInfo {
  int monthly_plan;
  String account_balance,customer_name,next_due,last_recharge_date,last_recharge,plan_details;

  DthInfo({
    this.monthly_plan,
    this.account_balance,
    this.customer_name,
    this.next_due,
    this.last_recharge_date,
    this.last_recharge,
    this.plan_details,
  });

  DthInfo.fromJson(Map<String, dynamic> map) {
  monthly_plan = map[DthInfoNames.monthly_plan] ?? StringHandlers.NotAvailable;
  account_balance = map[DthInfoNames.account_balance] ?? StringHandlers.NotAvailable;
  customer_name = map[DthInfoNames.customer_name] ?? StringHandlers.NotAvailable;
  next_due = map[DthInfoNames.next_due] ?? StringHandlers.NotAvailable;
  last_recharge_date = map[DthInfoNames.last_recharge_date] ?? StringHandlers.NotAvailable;
  last_recharge = map[DthInfoNames.last_recharge] ?? StringHandlers.NotAvailable;
  plan_details = map[DthInfoNames.plan_details] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    DthInfoNames.monthly_plan: monthly_plan,
    DthInfoNames.account_balance: account_balance,
    DthInfoNames.customer_name: customer_name,
    DthInfoNames.next_due: next_due,
    DthInfoNames.last_recharge_date: last_recharge_date,
    DthInfoNames.last_recharge: last_recharge,
    DthInfoNames.plan_details: plan_details,
      };
}

class DthInfoNames {
  static const String monthly_plan = "monthly_plan";
  static const String account_balance = "account_balance";
  static const String customer_name = "customer_name";
  static const String next_due = "next_due";
  static const String last_recharge_date = "last_recharge_date";
  static const String last_recharge = "last_recharge";
  static const String plan_details = "plan_details";
}

