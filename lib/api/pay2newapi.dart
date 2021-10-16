import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/cupertino.dart';

class Pay2NewAPI {
  BuildContext context;

  Pay2NewAPI({this.context});

  Future<dynamic> getMNPOperatorFetch({String MobileNumber}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "MobileNumber": MobileNumber,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Pay2New/MNPOperatorFetch", params, '');

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

  Future<dynamic> getDTHCustInfo({String DTHNumber,String OperatorCode}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "DTHNumber": DTHNumber,
        "OperatorCode": OperatorCode,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Pay2New/DTHCustInfo", params, '');

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

  Future<dynamic> getElectricityBillFetch({String ConsumerNumber,String OperatorCode,String Validator,String MobileNumber}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "ConsumerNumber": ConsumerNumber,
        "OperatorCode": OperatorCode,
        "Validator": Validator,
        "MobileNumber": MobileNumber,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Pay2New/ElectricityBillFetch", params, '');

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

  Future<dynamic> getROffer({String Number,String OperatorCode}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "Number": Number,
        "OperatorCode": OperatorCode,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Pay2New/ROffer", params, '');

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

  Future<dynamic> postPrepaidRecharge({
    String RechargeType,
    String CustomerID,
    String CustomerBranchCode,
    String CustomerAccountNo,
    String SubscriberNo,
    String Amount,
    String ServiceType,
    String OperatorCode,
    String SMSAutoID,
    String CircleCode,
    String billingUnitNo,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "RechargeType": RechargeType,
        "CustomerID": CustomerID,
        "CustomerBranchCode": CustomerBranchCode,
        "CustomerAccountNo": CustomerAccountNo,
        "SubscriberNo": SubscriberNo,
        "Amount": Amount,
        "ServiceType": ServiceType,
        "OperatorCode": OperatorCode,
        "SMSAutoID": SMSAutoID,
        "CircleCode": CircleCode,
        "billingUnitNo": billingUnitNo??"0",
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "Pay2New/PrepaidRecharge",
          params,
          "");

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
