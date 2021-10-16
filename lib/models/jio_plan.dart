import 'package:softcoremobilebanking/handlers/string_handlers.dart';
class JioPlan {
  double price;
  String id,description,Validity;

  JioPlan({
    this.id,
    this.price,
    this.description,
  });

  JioPlan.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? StringHandlers.NotAvailable;
    price = map["price"] ?? 0.0;
    description = map["description"] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "price": price,
    "description": description,
  };
}
