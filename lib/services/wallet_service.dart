
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/transaction_History.dart';

import '../networking/constant.dart';
import '../support/dio_helper.dart';

class WalletService {


  static Future marketvalue() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURLwallet/api/endPoint1/RBD_INR');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future walletbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/api/endPoint1/RBD_INR',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




  static Future getrubidiumbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/basic/getBalance',data:data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingallpointsthismonth(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-transaction-history/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future TransactionHistory(id, {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-transaction-history/$id?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


}
