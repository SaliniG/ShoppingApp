import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/utils/colors.dart';

class CommonMethods {
  //showing toast message
  static showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16.0,
      backgroundColor: brandColor,
      timeInSecForIosWeb: 5,
      textColor: kTextColor,
      webShowClose: true,
    );
  }
}
