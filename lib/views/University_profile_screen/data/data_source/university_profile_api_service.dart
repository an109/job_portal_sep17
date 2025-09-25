// university_profile_api_service.dart
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../utils/constants/urls.dart';
import '../models/university_profile_response.dart';
import '../../domain/entities/university_profile_entity.dart';

part 'university_profile_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversityProfileApiService {
  factory UniversityProfileApiService(Dio dio) = _UniversityProfileApiService;

  @GET(Urls.universityDetail)
  Future<UniversityProfileResponse> getUniversityProfile();

  @PUT(Urls.universityDetail)
  @Headers({'Content-Type': 'application/json'})
  Future<UniversityProfileResponse> updateUniversityProfile(
      @Body() UniversityProfileEntity body,
      );
}