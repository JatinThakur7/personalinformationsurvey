import 'package:dio/dio.dart';

import 'information.dart';

class ApiClient {
  ApiClient._private();

  static final ApiClient _instance = ApiClient._private();

  static ApiClient get instance => _instance;

  factory ApiClient() {
    return _instance;
  }

  /*API details

    GET - https://getx-todo-server.herokuapp.com

    POST - https://getx-todo-server.herokuapp.com

    Post request format:

    [

         {

               field_id: "XXXXXXXXXX",

               field_data: "XXXXXXXX"

          }

    ]
*/

  var _baseUrl = 'https://getx-todo-server.herokuapp.com';

  Dio getInstance() {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=utf-8',
    };
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: headers,
        connectTimeout: 90 * 1000,
        receiveTimeout: 60 * 1000,
      ),
    );
  }

  Future<Information> get() async {
    var response = await getInstance().get('');
    print('Personal Info Survey => $response');
    return Information.fromJson(response.data);
  }

  Future<dynamic> post(params) async {
    var response = await getInstance().post('', data: params);
    print('Personal Info Survey => $response');
    return response.data;
  }
}
