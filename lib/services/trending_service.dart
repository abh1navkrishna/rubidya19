import '../networking/constant.dart';
import '../support/dio_helper.dart';

class TrendingService {


  static Future tendingapi() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-pricemoney');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

////pagination listview Api


  static Future tendingcard({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$baseURL/api/posts/this-day-all-users',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future trendingapiThisweekcard({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-week-all-users', queryParameters: {
        'page': page,
        'limit': limit,
      },);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future trendingapicardThismonth({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-month-all-users',
        queryParameters: {
          'page': page,
          'limit': limit,
        },);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future TrendingtopSix(String status) async {
    try {
      var queryParameters = {
        'type': status
      };
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/top-six', queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      print('Error occurred: $e');
      // Handle the error appropriately here
      throw e; // Or handle it in another way
    }
  }






  static Future trendingapiThisweek({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-week-all-users', queryParameters: {
        'page': page,
        'limit': limit,
      },);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThismonth({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-month-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThisday({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




  static Future trendingapiThisall() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/all-time-all-users', );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future trendingapiThisallmore({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/all-time-all-users',queryParameters: {
        'page': page,
        'limit': limit,
      },);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




  static Future trendingallpointsthisday(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future trendingallpointsthisall(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/all-time/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingallpointsthisweek(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-week/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future trendingallpointsthismonth(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-month/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future tendingprofile() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/points-and-details');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }





  static Future TrendingDayinnerpage(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


///Top 3 In Listview

  static Future trendingapiThisweekthree({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-week-all-users', queryParameters: {
        'page': page,
        'limit': limit,
      },);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThismonththree({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-month-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThisdaythree({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




}