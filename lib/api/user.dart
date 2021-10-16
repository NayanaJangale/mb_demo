import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/material.dart';

class UserAPI {
  BuildContext context;

  UserAPI({this.context});

  Future<dynamic> RegisterAccessPIN({
    String CustomerID,
    String AccessPIN,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "AccessPIN": AccessPIN,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "User/RegisterAccessPIN", params, '');

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

  Future<dynamic> ForgotCustomerPassword({
    String CustomerID,
    String NewPassword,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "NewPassword": NewPassword,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
        "UserType": "Customer",
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "User/ForgotCustomerPassword", params, '');

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

  Future<dynamic> changeCustomerPassword({
    String UserNo,
    String OldPassword,
    String NewPassword,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "UserNo": UserNo,
        "OldPassword": OldPassword,
        "NewPassword": NewPassword,
        "UserType": "Customer",
        "ChangeLoginPasswordReason": "Customer",
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "User/ChangeCustomerPassword", params, '');

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
