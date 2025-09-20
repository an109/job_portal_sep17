// data/data_source/university_registration_api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/university_registration_response.dart';

part 'university_registration_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversityRegistrationApiService {
  factory UniversityRegistrationApiService(Dio dio, {String? baseUrl}) = _UniversityRegistrationApiService;

  @POST(Urls.registerUniversity)
  Future<UniversityRegistrationResponse> registerUniversity(@Body() Map<String, dynamic> body);
}