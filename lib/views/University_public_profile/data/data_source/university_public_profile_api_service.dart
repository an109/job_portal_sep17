import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/university_public_profile_model.dart';

part 'university_public_profile_api_service.g.dart';

@RestApi()
abstract class UniversityPublicProfileApiService {
  factory UniversityPublicProfileApiService(Dio dio, {String baseUrl}) = _UniversityPublicProfileApiService;

  @GET(Urls.unipublicprofile)
  Future<UniversityPublicProfileResponse> getUniversityPublicProfile(@Path('user_id') int userId);
}