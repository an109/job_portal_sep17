import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../utils/constants/urls.dart';
import '../models/university_profile_response.dart';

part 'university_profile_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversityProfileApiService {
  factory UniversityProfileApiService(Dio dio) = _UniversityProfileApiService;

  @PUT(Urls.registerUniversity)
  Future<UniversityProfileResponse> updateUniversityProfile(@Body() UniversityProfileResponse body);
}