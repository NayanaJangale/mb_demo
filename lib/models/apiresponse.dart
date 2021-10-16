
import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class ApiResponse {
  int Status;
  String Message;
  var Data;

  ApiResponse({this.Status,this.Message, this.Data});

  ApiResponse.fromMap(Map<String, dynamic> map) {
    Status = map[Status] ?? 0;
    Message = map[Message]?? StringHandlers.NotAvailable;
    Data = map[Data]?? 0;
  }
  factory ApiResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ApiResponse(
      Status: parsedJson['Status'],
      Message: parsedJson['Message'],
      Data: parsedJson['Data'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "Status": Status,
    "Message": Message,
    "Data": Data
  };

}
