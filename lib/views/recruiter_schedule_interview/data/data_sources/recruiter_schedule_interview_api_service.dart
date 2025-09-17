import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/recruiter_schedule_interview_response_model.dart';

part 'recruiter_schedule_interview_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterScheduleInterviewApiService {
  factory RecruiterScheduleInterviewApiService(Dio dio, {String? baseUrl}) =
  _RecruiterScheduleInterviewApiService;

  @POST(Urls.scheduleInterview)
  @FormUrlEncoded()
  Future<RecruiterScheduleInterviewResponseModel> scheduleInterview(
      @Path("applicantId") int applicantId,
      @Field("message") String message,
      @Field("interview_type") String interviewType,
      @Field("interview_date") String interviewDate,
      @Field("start_time") String startTime,
      @Field("end_time") String endTime,
      @Field("video_link") String? videoLink,
      );
}