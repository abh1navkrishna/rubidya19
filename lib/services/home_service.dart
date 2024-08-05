import '../networking/constant.dart';
import '../support/dio_helper.dart';

class HomeService {


  // static Future refferalhistory() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/users/get-direct-refferals');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //

  static Future<Map<String, dynamic>> getDirectReferrals({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-direct-refferals?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }



  static Future usersuggetionlistfollow() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-suggestions');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future follow(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/follow',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future unfollow(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/unfollow',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // static Future followingList() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/users/get-following');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }



  static Future getfollowerinner(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-followers-list/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getfollowinginner(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-following-list/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  // static Future<Map<String, dynamic>> getfollowinginner({int page = 1, int limit = 3,id}) async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/posts/get-latest-posts/$id?page=$page&limit=$limit');
  //     return response.data;
  //   } catch (e) {
  //     // Handle error appropriately, e.g., log the error or throw it further
  //     throw e;
  //   }
  // }



  static Future<Map<String, dynamic>> followingList({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-following?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }


  static Future<Map<String, dynamic>> followersList({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-followers?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  // static Future followersList() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/users/get-followers');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  // static Future getFeed() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/posts/get-latest-posts');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future<Map<String, dynamic>> getFeed({int page = 1, int limit = 7}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-latest-posts?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }



  static Future like(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/like',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future save(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/save-unsave-post',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future postlikecomment(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/like-comment',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  static Future comment(String id, {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-comment-details/$id', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getStories({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-latest-stories');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  static Future singlepost(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-post-details/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future commentreplay(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-reply-of-comment/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future postcomment(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/post-comment',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future postreplaycomment(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/reply-comment',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // static Future<Map<String, dynamic>> getActivityNotification({int page = 1, int limit = 10}) async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/message/get-activity-notifications');
  //     return response.data;
  //   } catch (e) {
  //     // Handle error appropriately, e.g., log the error or throw it further
  //     throw e;
  //   }
  // }


  static Future<Map<String, dynamic>> getActivityNotification({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/message/get-activity-notifications', queryParameters: {'page': page, 'limit': limit});
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }


  static Future deletemycomment(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.delete('$baseURL/api/posts/delete-comment/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future<Map<String, dynamic>> getReferalNotification({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/message/get-referal-notifications');
      return response.data;
    } catch (e) {

      throw e;
    }
  }


  static Future likelist(String id, {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio
          .get('$baseURL/api/posts/get-details-of-like/$id', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  static Future deletemypost(id) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.delete('$baseURL/api/users/delete-image?imageId=$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



}