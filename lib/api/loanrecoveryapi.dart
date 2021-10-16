import 'dart:convert';

import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:softcoremobilebanking/models/loan_type.dart';
import 'package:flutter/cupertino.dart';

class LoanRecoveryAPI {
  BuildContext context;

  LoanRecoveryAPI({this.context});

  Future<dynamic> GetLoanTypes() async {
    var data;
    try {
      Map<String, dynamic> params = {};

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, LoanTypeUrls.GetLoanTypes, params, '');

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

  Future<dynamic> InsertLoanRequest({
    String custid,
    String l_type,
    String reqDate,
    String aStatus,
    String expDur,
    String Amount,
    String brcode,
    String loanDocList,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "custid": custid,
        "l_type": l_type,
        "reqDate": reqDate,
        "aStatus": aStatus,
        "expDur": expDur,
        "Amount": Amount,
        "brcode": brcode,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "LoanRecovery/InsertLoanRequest",
          params,
          loanDocList);

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

  Future<dynamic> GetLoanRequests() async {
    var data;
    try {
      Map<String, dynamic> params = {"CustomerID": AppData.current.customerLogin.user.CustomerID};

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "LoanRecovery/GetLoanRequests", params, '');

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
