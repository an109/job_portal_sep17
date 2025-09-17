import 'package:dio/dio.dart';
import '../../domain/entities/recruiter_schedule_interview_entity.dart';
import '../../domain/repository/recruiter_schedule_interview_repository.dart';
import '../data_sources/recruiter_schedule_interview_api_service.dart';
import '../models/recruiter_schedule_interview_response_model.dart';

class RecruiterScheduleInterviewRepositoryImpl implements RecruiterScheduleInterviewRepository {
  final RecruiterScheduleInterviewApiService _apiService;

  RecruiterScheduleInterviewRepositoryImpl(this._apiService);

  @override
  Future<RecruiterScheduleInterviewResponseModel> scheduleInterview({
    required int applicantId,
    required RecruiterScheduleInterviewEntity entity,
  }) async {
    try {
      final response = await _apiService.scheduleInterview(
        applicantId,
        entity.message,
        entity.interviewType,
        entity.interviewDate,
        entity.startTime,
        entity.endTime,
        entity.videoLink,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to schedule interview');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}