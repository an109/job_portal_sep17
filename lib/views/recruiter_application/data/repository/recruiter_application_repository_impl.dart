import 'package:dio/dio.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/recruiter_application_entity.dart';
import '../../domain/repository/recruiter_application_repository.dart';
import '../data_source/recruiter_application_api_service.dart';

class RecruiterApplicationRepositoryImpl implements RecruiterApplicationRepository {
  final RecruiterApplicationApiService apiService;

  RecruiterApplicationRepositoryImpl(this.apiService);

  @override
  Future<DataState<List<RecruiterApplicationEntity>>> getApplications(int jobPostId) async {
    try {
      final response = await apiService.getApplications(jobPostId);

      final entities = response.applicants.map((applicant) {
        String resumeMatch = "Low";
        if (applicant.matchPercentage > 70) {
          resumeMatch = "High";
        } else if (applicant.matchPercentage > 40) {
          resumeMatch = "Moderate";
        }

        return RecruiterApplicationEntity(
          applicationId: applicant.applicationId,
          userId: applicant.userId,
          matchPercentage: applicant.matchPercentage,
          applicantName: applicant.applicantName ?? "Not provided",
          location: applicant.applicationDetails.location,
          experience: applicant.applicationDetails.experience,
          appliedDate: applicant.appliedDate,
          skills: [],
        );
      }).toList();

      return DataSuccess(entities);
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      final error = DioException(
        requestOptions: RequestOptions(path: 'jobpost/$jobPostId/allapplicant'),
        message: 'Failed to parse or map applicant data: $e',
      );
      return DataFailed(error);
    }
  }
}