import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

class DioHelper {
  static Future<Dio> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token') ?? "");
    log.i(token);
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    dio.options.headers["Accept"] = "application/json";
    // dio.options.headers[''];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.d(
              'API call - ' + options.method + ' - ' + options.uri.toString());
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response != null) {
            log.d(
                'API Error - ${e.response!.statusCode} - ${e.response!.statusMessage}');
            log.d(e.response!.data);
          }
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}
