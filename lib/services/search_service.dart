
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class SearchService {


  static Future searchpage() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




}
