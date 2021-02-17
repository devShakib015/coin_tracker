import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  String url;

  NetworkHelper({this.url});

  Future<Map<String, dynamic>> getCoinRate() async {
    http.Response response = await http.get(url);

    Map<String, dynamic> decodedData = jsonDecode(response.body);

    return decodedData;
  }
}
