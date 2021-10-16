import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ConfigurationAPI {
  BuildContext context;

  ConfigurationAPI({this.context});

  Future<dynamic> getConfiguration() async {
    var data;
    try {
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> commonParams = {
          'ApplicationType': 'Customer',
        };
        Uri uri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.clientInfoUrl +
              "Clientmaster/getProductVersion",
        ).replace(
          queryParameters: commonParams,
        );
        Response response = await get(uri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          data = json.decode(response.body);
        }
      } else {
        FlushbarMessage.show(
          context,
          'Please check your wifi or mobile data is active.',
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      data["Message"] = e.toString();
    } finally {
      return data;
    }
  }
}
