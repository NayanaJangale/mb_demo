import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/cupertino.dart';

class DepositAPI {
  BuildContext context;

  DepositAPI({this.context});

  Future<dynamic> getMaturityDetails({
  String CustomerID,
  String DepositType,
  String DepositCode,
  String Amount,
  String Duration,
  String DurationType,
}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID":CustomerID,
        "DepositType":DepositType,
        "DepositCode":DepositCode,
        "Amount":Amount,
        "Duration":Duration,
        "DurationType":DurationType,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Deposit/GetMaturityDetails", params, '');

      if (apiResponse.Status != HttpStatusCodes.OK) {
        FlushbarMessage.show(
          context,
          apiResponse.Message,
          MessageTypes.WARNING,
        );
      } else {
        data = json.decode(apiResponse.Data);
      }
    } catch (e) {
      data["Message"] = e.toString();
    } finally {
      return data;
    }
  }
}
