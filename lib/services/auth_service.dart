
import 'package:rubidya/authentication_page/forgot_password.dart';

import '../networking/constant.dart';
import '../support/dio_helper.dart';

class AuthService {


  static Future Login(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/login',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future registration(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/add-user-by-refferal',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future otpverification(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/verify-otp',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future forgotpassword(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/send-forget-otp',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future forgotpasswordotp(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/forget-password-otp',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  static Future newpassword(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.put('$baseURL/api/users/change-password',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



}
