import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:retrofit/retrofit.dart';

part 'university_signup_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversitySignupApiService {
  factory UniversitySignupApiService(Dio dio, {String? baseUrl}) =
      _UniversitySignupApiService;

  @GET(Urls.getCourses)
  Future<HttpResponse<CourseListModel>> getCourses();
}

// List<dynamic>
