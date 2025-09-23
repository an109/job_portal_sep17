import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../utils/constants/urls.dart';
import '../models/university_followers_following_model.dart';

part 'university_followers_following_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversityFollowersFollowingApiService {
  factory UniversityFollowersFollowingApiService(Dio dio) = _UniversityFollowersFollowingApiService;

  @GET(Urls.getFollowers)
  Future<List<UniversityFollowerFollowingModel>> getFollowers(@Path('user_id') int userId);

  @GET(Urls.getFollowing)
  Future<List<UniversityFollowerFollowingModel>> getFollowing(@Path('user_id') int userId);
}