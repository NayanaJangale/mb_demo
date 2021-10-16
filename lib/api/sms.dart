import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/cupertino.dart';

class SMSAPI {
  BuildContext context;

  SMSAPI({this.context});

  Future<dynamic> GeterateOTP({
      String TransactionType,
      String RegenerateSMS,
      String OldSMSAutoID,
      String AccountNumber,
      String Amount,
      String CustomerID,
      String brcode,
      String PaymentIndicator}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "TransactionType": TransactionType,
        "RecipientType": "Customer",
        "RegenerateSMS": RegenerateSMS,
        "OldSMSAutoID": OldSMSAutoID,
        "CustomerID": CustomerID,
        "UserType": "Customer",
        "AccountNumber": AccountNumber,
        "Amount": Amount,
        "brcode": brcode,
        "PaymentIndicator": PaymentIndicator,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "SMS/GenerateOTP", params, '');

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

  Future<dynamic> ValidateOTPForAccessPIN(
    String CustomerID,
    String SMSAutoID,
    String OTP,
  ) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "SMS/ValidateOTPForAccessPIN", params, '');

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
