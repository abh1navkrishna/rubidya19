import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ProfileService {


  static Future verificationimage(data) async {
    // print(username);
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/upload-image',data:data);
    return response;
  }


  static Future deductbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/basic/deductBalanceAuto',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future fetchbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/basic/creditBalanceAuto',data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  // static Future getProfileimage() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/users/get-media');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  static Future<Map<String, dynamic>> getProfileimage({int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-media?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  static Future<Map<String, dynamic>> getSaved({int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-saved-posts?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  static Future<Map<String, dynamic>> getProfileVideo({int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-all-videos?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }


  static Future getProfile() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/profile');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future addAmountTopUP(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/wallet/credit-wallet',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  static Future syncwallet() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/sync-wallet');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getpackage() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-packages');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  // static Future verification(data) async {
  //   var dio = await DioHelper.getInstance();
  //   var response = await dio.post('$baseURLwallet/basic/checkPayIdExist',data:data);
  //   return response;
  // }


  static Future checkpayid(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/add-pay-id',data:data);
    return response.data;
  }

  static Future verifyuser(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/verify-user',data:data);
    return response.data;
  }

  // static Future deductrubideum(data) async {
  //   var dio = await DioHelper.getInstance();
  //   var response = await dio.post('$baseURL/api/users/deduct-rubideum',data:data);
  //   return response.data;
  // }


  static Future addSubscription(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/wallet/add-subscription',data:data);
    return response.data;
  }


  static Future withdraw(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/wallet/withdraw',data:data);
    return response.data;
  }

  static Future sendmoney(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/wallet/pay-to-rubideum',data:data);
    return response.data;
  }

  static Future convertinr(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/convert-inr',data:data);
    return response.data;
  }

  static Future verifyaccountrubidia(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURLwallet/basic/checkPayIdExist',data:data);
    return response.data;
  }



  static Future premiuminner(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/get-package-by-id',data:data);
    return response.data;
  }



  static Future profilestatus() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/users/get-stats');
    return response.data;
  }

  static Future TeamPerformance() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/rank/view-all-ranks');
    return response.data;
  }



  static Future ProfileEditing(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.put('$baseURL/api/users/edit-profile',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future ProfileImageUpload(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/add-profile-pic',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future ProfileImageget() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-profile-pic');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future Profileinnerpage(id, {int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-user/$id?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future blockuser(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$baseURL/api/users/block-user',
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }


  static Future reportuser(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$baseURL/api/users/report-user',
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future unblockuser(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$baseURL/api/users/unblock-user',
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getBlockedUsers({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-all-blockedusers?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      throw e;
    }
  }

}