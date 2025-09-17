import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/recruiter_send_assignment_response_model.dart';

part 'recruiter_send_assignment_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterSendAssignmentApiService {
  factory RecruiterSendAssignmentApiService(Dio dio, {String? baseUrl}) = _RecruiterSendAssignmentApiService;

  @POST(Urls.sendAssignment)
  Future<RecruiterSendAssignmentResponseModel> sendAssignment(
      @Path("applicantId") int applicantId,
      @Field('message') String message,
      @Field('deadline') String deadline,
      );
}