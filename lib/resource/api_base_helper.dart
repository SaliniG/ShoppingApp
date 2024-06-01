import 'dart:developer';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/utils/app_api_constants.dart';

class ApiBaseHelper {
  //initialize http client
  static final client = http.Client();

  //function return response using http get request
  static Future<Response> httpGetRequest(String endPoint) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${AppApiConstants.baseUrl}${AppApiConstants.productDetailsApi}'),
          headers: {"Content-Type": "application/json"});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
