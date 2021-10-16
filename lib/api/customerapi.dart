import 'dart:convert';
import 'dart:math';

import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/account_summary.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/models/inter_bank_transfer.dart';
import 'package:flutter/material.dart';

class CustomerAPI {
  BuildContext context;

  CustomerAPI({this.context});

  Future<dynamic> CustomerLogout() async {
    var data;
    try {
      Map<String, dynamic> params = {};

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "Customer/CustomerLogout", params, '');

      Set<int> setOfInts = Set();
      setOfInts.add(Random().nextInt(5));

      if (apiResponse.Status != HttpStatusCodes.OK) {
        FlushbarMessage.show(
          context,
          apiResponse.Message,
          MessageTypes.WARNING,
        );
      } else {
        data = json.decode(apiResponse.Data);
        AppData.current.ConnectionString ='';
      }
    } catch (e) {
      data["Message"] = e.toString();
    } finally {
      return data;
    }
  }

  Future<dynamic> GetAccountSummary({
    String BranchCode,
    String AccountNo,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "BranchCode": BranchCode,
        "AccountNo": AccountNo,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET,
          AccountSummaryUrls.GET_ACCOUNTSUMMARY,
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

  Future<dynamic> fetchUserData({
    String CustomerID,
    String LoginPassword,
    String AccessPIN,
    String LoginType,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "UserID": CustomerID,
        "LoginPassword": LoginPassword,
        "AccessPIN": AccessPIN,
        "LoginType": LoginType,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET,
          CustomerLoginUrls.GET_CustomerLogin,
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

  Future<dynamic> getAccounts({
    String CustomerID,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET,
          CustomerLoginUrls.GET_GetAccountsByCustID,
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

  Future<dynamic> getMenus() async {
    var data;
    try {
      Map<String, dynamic> params = {
        "menuFor": "Mobile Banking",
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, CustomerLoginUrls.GET_GetMenus, params, '');

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

  Future<dynamic> transferAmount({
    String DebitBranchCode,
    String DebitAccountNo,
    String CreditBranchCode,
    String CreditAccountNo,
    String Amount,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "DebitBranchCode": DebitBranchCode,
        "DebitAccountNo": DebitAccountNo,
        "CreditBranchCode": CreditBranchCode,
        "CreditAccountNo": CreditAccountNo,
        "Amount": Amount,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "Customer/TransferAmount", params, '');

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

  Future<dynamic> getActiveBeneficiaries({
    String CustomerID,
    String BeneficiaryType,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BeneficiaryType": BeneficiaryType,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET,
          "Customer/GetActiveBeneficiaries",
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

  Future<dynamic> deleteBeneficiary({
    String CustomerID,
    String BeneficiaryAccountNo,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BeneficiaryAccountNo": BeneficiaryAccountNo,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST, "Customer/DeleteBeneficiary", params, '');

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

  Future<dynamic> addIntraBankBeneficiary({
    String CustomerID,
    String BeneficiaryBranchCode,
    String BeneficiaryAccountNo,
    String BeneficiaryNickName,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BeneficiaryBranchCode": BeneficiaryBranchCode,
        "BeneficiaryAccountNo": BeneficiaryAccountNo,
        "BeneficiaryNickName": BeneficiaryNickName,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "Customer/AddIntraBankBeneficiary",
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

  Future<dynamic> getIFSCCodes({
    String searchText,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "searchText": searchText,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Customer/GetIFSCCodes", params, '');

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

  Future<dynamic> addInterBankBeneficiary({
    String CustomerID,
    String BenefAcNo,
    String BenefName,
    String BenefBankNo,
    String BenefBankName,
    String IFSCCode,
    String BenefCity,
    String BenefMobileNo,
    String SMSAutoID,
    String OTP,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BenefAcNo": BenefAcNo,
        "BenefName": BenefName,
        "BenefBankNo": BenefBankNo,
        "BenefBankName": BenefBankName,
        "IFSCCode": IFSCCode,
        "BenefCity": BenefCity,
        "BenefMobileNo": BenefMobileNo,
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "Customer/AddInterBankBeneficiary",
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

  Future<dynamic> getSlabwiseCharges({
    String PaymentIndicator,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "PaymentIndicator": PaymentIndicator,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Customer/GetSlabwiseCharges", params, '');

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

  Future<dynamic> interBankTransfer(
      {String SMSAutoID,
      String OTP,
      InterBankTransfer interBankTransfer}) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "SMSAutoID": SMSAutoID,
        "OTP": OTP,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.POST,
          "Customer/InterBankTransfer",
          params,
          json.encode(interBankTransfer));

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

  Future<dynamic> getCustInfo({
    String CustomerID,
    String BranchCode,
  }) async {
    var data;
    try {
      Map<String, dynamic> params = {
        "CustomerID": CustomerID,
        "BranchCode": BranchCode,
      };

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Customer/GetCustInfo", params, '');

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
