import 'dart:convert';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:softcoremobilebanking/models/cyberplatRecharge.dart';
import 'package:flutter/cupertino.dart';
class PaymentAPI {
  BuildContext context;
  PaymentAPI({this.context});

  Future<dynamic> getRecentBills({String CustomerID, String PaymentStatus,String ServiceType,String menuType,String ServiceName}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "PaymentStatus": PaymentStatus,
        "ServiceType": ServiceType,
        "RechargeType": menuType,
        "ServiceName": ServiceName,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Payment/GetRecentBills", params, '');

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

  Future<dynamic> getJioPlans({String SubscriberNo,String Amount}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "SubscriberNo": SubscriberNo,
        "Amount": Amount,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Payment/GetJioPlans", params, '');

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

  Future<dynamic> postCyberRecharge({
   CyberplatRecharge cyberplatRecharge,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
      };
      String jsonBody = json.encode(cyberplatRecharge);
      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "Payment/CyberPlatBillPayment",
          params,
          jsonBody);

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
