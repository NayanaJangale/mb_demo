import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/internet_connection.dart';
import 'package:softcoremobilebanking/models/live_server_urls.dart';
import 'package:http/http.dart';
import '../constants/project_settings.dart';

class NetworkHandler {

  static Map<String, String> getHeader() {
    return {
      "CheckSum": ProjectSettings.AppKey,
    };
  }

  static Future<String> checkInternetConnection() async {
    String status;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        status = InternetConnection.CONNECTED;
      } else {
        // I am connected to no network.
        status = InternetConnection.NOT_CONNECTED;
      }
    } catch (e) {
      status = InternetConnection.NOT_CONNECTED;
      status = 'Exception: ' + e.toString();
    }
    return status;
  }

  static Future<String> getServerWorkingUrl() async {
    String connectionStatus = await NetworkHandler.checkInternetConnection();
    if (connectionStatus == InternetConnection.CONNECTED) {
      //Uncomment following to test local api
      //return ProjectSettings.LocalApiUrl;

      Map<String, dynamic> commonParams = {
        'asStp': 'CUST',
        "aiClientID": AppData.current.ClientCode,
      };
//
      List<LiveServer> liveServers = [];

      Uri getLiveUrlsUri = Uri.parse(
        LiveServerUrls.serviceUrl,
      ).replace(
        queryParameters: commonParams,
      );

      http.Response response = await http.get(getLiveUrlsUri);

      if (response.statusCode == HttpStatusCodes.OK) {
        var data = json.decode(response.body);

        var parsedJson = data["Data"];

        List responseData = parsedJson;
        liveServers =
            responseData.map((item) => LiveServer.fromMap(item)).toList();

        String url;
        if (liveServers.length != 0 && liveServers.isNotEmpty) {
          for (var server in liveServers) {
            try {
              Uri checkUrl = Uri.parse(
                server.ipurl,
              );
              http.Response checkResponse = await http.get(checkUrl).timeout(
                    Duration(seconds: 10),
                  );

              if (checkResponse.statusCode == HttpStatusCodes.OK) {
                return server.ipurl;
              }
            } on TimeoutException catch (_) {}
          }
          return "key_no_server";
        } else {
          return "key_no_server";
        }
      } else {
        return "key_no_server";
      }
    } else {
      return "key_check_internet";
    }
  }

  static Future<ApiResponse> callAPI(String reqType, String apiName,
      Map<String, dynamic> params, String jsonBody) async {
    ApiResponse apiResponse = new ApiResponse();

    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      try {
        CustomerLogin customerLogin = AppData.current.customerLogin;
        Map<String, dynamic> commonParams = {
          'ApplicationType': 'MobileBanking',
          'SessionAutoID': customerLogin == null
              ? "0"
              : customerLogin.SessionAutoID.toString(),
          'UserNo': customerLogin != null && customerLogin.user != null
              ? customerLogin.user.UserNo.toString()
              : AppData.current.userNo,
          'ConnectionString': AppData.current.ConnectionString??"",
          "ClientCode": AppData.current.ClientCode,
          "MacAddress": AppData.current.MacAddress,
        };
        commonParams.addAll(params);

        Uri uri = Uri.parse(
          connectionServerMsg + ProjectSettings.rootUrl + apiName,
        ).replace(
          queryParameters: commonParams,
        );

        Response response;
        if (HttpRequestMethods.GET == reqType) {
          response = await get(uri);
        } else {
          response = await post(
            uri,
            headers: {
              "Accept": "application/json",
              "content-type": "application/json"
            },
            body: jsonBody,
            encoding: Encoding.getByName("utf-8"),
          );
        }

        if (response.statusCode != HttpStatusCodes.OK) {
          apiResponse.Message = response.body ;
          return apiResponse;
        } else {
          apiResponse.Data = response.body;
          apiResponse.Status = HttpStatusCodes.OK;
          return apiResponse;
        }
      } catch (e) {
        apiResponse.Message = 'Please check your wifi or mobile data is active.';
        return apiResponse;
      }
    } else {
      apiResponse.Message = 'Please check your wifi or mobile data is active.';
      return apiResponse;
    }
  }

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? '1'; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId ?? ''; // unique ID on Android
    }
  }
}
