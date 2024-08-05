import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ChatService {
  static Future<Map<String, dynamic>> getChatHistory(
      {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
          '$baseURL/api/message/get-all-conversation?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
// Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  static Future<Map<String, dynamic>> getMessages(String conversationId,
      {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response =
      await dio.get('$baseURL/api/message/get-messages', queryParameters: {
        'limit': limit,
        'page': page
      }, data: {
        'conversationId': conversationId,
      });
      return response.data;
    } catch (e) {
// Handle error appropriately
      throw e;
    }
  }

  static Future<Map<String, dynamic>> sendMessage(
      String senderId, String message, String userId) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$baseURL/api/message/send-messages',
        data: {
          "senderId": senderId,
          "message": message,
          "recieverId": userId,
        },
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}