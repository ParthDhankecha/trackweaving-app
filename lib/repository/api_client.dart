import 'dart:developer';

import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum ApiType { get, post, put, delete }

class ApiClient extends GetxService {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<dynamic> request(
    String endPoint, {
    ApiType method = ApiType.get,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');
    http.Response response;

    try {
      switch (method) {
        case ApiType.post:
          response = await http.post(url, body: body, headers: headers);
          break;

        case ApiType.put:
          response = await http.put(url, body: body, headers: headers);
          break;

        case ApiType.delete:
          response = await http.delete(url, body: body, headers: headers);
          break;
        default:
          response = await http.get(url, headers: headers);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          return response.body;

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }
}
