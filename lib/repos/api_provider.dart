import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:kisankonnect/models/base_model.dart';
import 'package:kisankonnect/repos/url_path.dart';
import 'package:kisankonnect/sharedprefs/shared_prefs.dart';

class ApiProvider {
  static Client _client;

  static Client get client {
    if (_client == null) {
      _client = Client();
    }
    return _client;
  }

  static get<T extends BaseModel>(String url,
      {Map<String, dynamic> params}) async {
    return _makeGETRequest<T>(url, params, false);
  }

  static getWithToken<T extends BaseModel>(String url,
      {Map<String, dynamic> params}) async {
    return _makeGETRequest<T>(url, params, true);
  }

  static _makeGETRequest<T extends BaseModel>(
      String url, Map<String, dynamic> params, bool authorization) async {
    final uri = Uri.http(UrlPath.BASE_URL, url, params);

    final headers = await _getHeader(authorization);
    final response = await ApiProvider.client.get(
      uri,
      headers: headers,
    );

    T t = BaseModel.create(T);
    final parsed = json.decode(response.body).cast<String, dynamic>();
    return t.fromJson(parsed, response.statusCode == HttpStatus.ok);
  }

  static post<T extends BaseModel>(String url,
      {Map<String, dynamic> body}) async {
    return _makePOSTRequest<T>(url, body, false);
  }

  static postWithToken<T extends BaseModel>(String url,
      {Map<String, dynamic> body}) async {
    return _makePOSTRequest<T>(url, body, true);
  }

  static _makePOSTRequest<T extends BaseModel>(
      String url, Map<String, dynamic> body, bool authorization) async {
    final uri = Uri.http(UrlPath.BASE_URL, url, null);

    final bodyData = body != null ? json.encode(body) : null;
    final headers = await _getHeader(authorization);
    var response = await ApiProvider.client.post(
      uri,
      headers: headers,
      body: bodyData,
    );

    T t = BaseModel.create(T);
    final parsed = json.decode(response.body).cast<String, dynamic>();
    return t.fromJson(parsed, response.statusCode == HttpStatus.ok);
  }

  static Future<Map<String, String>> _getHeader(bool authorization) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authorization)
      headers['Authorization'] =
          'Bearer ${await LocalCache.getInstance().getToken()}';
    return headers;
  }
}
