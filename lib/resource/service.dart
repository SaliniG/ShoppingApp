import 'package:http/http.dart';
import 'package:shopping_app/resource/api_base_helper.dart';
import 'package:shopping_app/utils/app_api_constants.dart';
import 'package:shopping_app/utils/common_methods.dart';
import 'package:shopping_app/utils/custom_exception.dart';

class Service {
  // function to return api response
  static Future<Response> fetchProductDetailsData() async {
    try {
      Response response = await ApiBaseHelper.httpGetRequest(
          '${AppApiConstants.baseUrl}${AppApiConstants.productDetailsApi}');
      return response;
    } on CustomException catch (error) {
      CommonMethods.showToastMessage(error.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
