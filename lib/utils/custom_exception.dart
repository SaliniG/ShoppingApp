import 'dart:convert';

import 'package:http/http.dart';

class CustomException implements Exception {
  String description;
  int? errorCode;
  Response? response;

  CustomException({
    required this.description,
    this.errorCode,
    this.response,
  });
  @override
  String toString() {
    
    return jsonEncode({"description":description,"errorCode":errorCode,"serverStatus":response?.statusCode??0,"response":response?.body??""});
  }
}
class SessionExpired implements Exception {
  String description;
  int? errorCode;
  Response? response;

  SessionExpired({
    required this.description,
    this.errorCode,
    this.response,
  });
  @override
  String toString() {
    return jsonEncode({"description":description,"errorCode":errorCode,"serverStatus":response?.statusCode??0,"response":response?.body??""});
  }
}
class NotFoundException implements Exception{
  String message;
  NotFoundException(this.message):super();
  @override
  String toString() {
    return message;
  }
}
class FileNotSelectedException implements Exception {
  String? message;
  FileNotSelectedException([this.message]);
  @override
  String toString() {
    return message??"";
  }
}

class ImageSizeException implements Exception {
  String? message;
  ImageSizeException([this.message]);
  @override
  String toString() {
    return message??"";
  }
}
class RedirectHomeException implements Exception{
  RedirectHomeException():super();
}
class UnProcessableEntityException implements Exception{
  String description;
  int? errorCode;
  Response? response;
  UnProcessableEntityException({required this.description,this.errorCode,this.response}):super();

  @override
  String toString() {

    return jsonEncode({"description":description,"errorCode":errorCode,"serverStatus":response?.statusCode??0,"response":response?.body??""});
  }
}