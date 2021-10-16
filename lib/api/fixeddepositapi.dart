import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class FixedDepositAPI {
  BuildContext context;

  FixedDepositAPI({this.context});

  Future<dynamic> getFDMaster() async {
    var data;
    try {
      Map<String, dynamic> params = {};

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "FixedDeposit/GetFDMaster", params, '');

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

  Future<dynamic> OpenAccount({
    String CustomerID,
    String BranchCode,
    String DebitAccountNo,
    String FDTypeCode,
    String IntrCode,
    String DepositAmount,
    String Duration,
    String DurationType,
    String InterestRate,
    String MaturityAmount,
    String MaturityDate,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BranchCode": BranchCode,
        "DebitAccountNo": DebitAccountNo,
        "FDTypeCode": FDTypeCode,
        "IntrCode": IntrCode,
        "DepositAmount": DepositAmount,
        "Duration": Duration,
        "DurationType": DurationType,
        "InterestRate": InterestRate,
        "MaturityAmount": MaturityAmount,
        "MaturityDate": MaturityDate,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "FixedDeposit/OpenAccount",
          params,
          '');

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