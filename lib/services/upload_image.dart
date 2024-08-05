import '../networking/constant.dart';
import '../support/dio_helper.dart';

class UploadService {


  static Future uploadimage(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/upload-image',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future uploadvideo(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/upload-videos',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future uploadstory(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/upload-story',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




  static Future<Map<String, dynamic>> getUploadMostlike({int page = 1, int limit = 15}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-most-loved-posts?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }




}