import 'dart:convert';

import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_request_methods.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/models/apiresponse.dart';
import 'package:flutter/cupertino.dart';

class GalleryAPI {
  BuildContext context;

  GalleryAPI({this.context});

  Future<dynamic> getAlbums() async {
    var data;
    try {
      Map<String, dynamic> params = {};

      ApiResponse apiResponse = await NetworkHandler.callAPI(
          HttpRequestMethods.GET, "Gallery/GetAlbums", params, '');

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
