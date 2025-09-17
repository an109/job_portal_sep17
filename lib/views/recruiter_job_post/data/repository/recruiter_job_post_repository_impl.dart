import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import '../../../../injection_container.dart';
import '../../../../utils/constants/urls.dart';
import '../../../recruiter_application/data/data_source/recruiter_application_api_service.dart';
import '../../domain/entities/recruiter_job_post_entity.dart';
import '../../domain/repository/recruiter_job_post_repository.dart';
import '../data_source/recruiter_job_post_api_service.dart';
import '../models/recruiter_job_post_response_model.dart';

class RecruiterJobPostRepositoryImpl implements RecruiterJobPostRepository {
  final RecruiterJobPostApiService apiService;

  RecruiterJobPostRepositoryImpl(this.apiService);

  @override
  Future<DataState<List<RecruiterJobPostEntity>>> getAllJobPosts() async {
    try {
      final response = await apiService.getAllJobPosts();

      if (response.response.statusCode == 200 && response.data != null) {
        final model = response.data;
        final List<JobPostData> jobPosts = model.jobPosts ?? [];

        // === STEP 1: Fetch counts FIRST ===
        for (var job in jobPosts) {
          if (job.jobId != null) {
            try {
              final countResponse = await apiService.getAllApplicantsCount(job.jobId!);

              if (countResponse.response.statusCode == 200 && countResponse.data != null) {
                job.totalApplications = countResponse.data!.data; // ✅ Assign count
              } else {
                job.totalApplications = 0;
              }
            } on DioException catch (e) {
              print("Count API error for jobId ${job.jobId}: ${e.message}");
              job.totalApplications = 0;
            } catch (e) {
              print("Parse error for count ${job.jobId}: $e");
              job.totalApplications = 0;
            }
          }
        }

        // === STEP 2: NOW map to entities ===
        final List<RecruiterJobPostEntity> entities = jobPosts
            .map((job) => job.toEntity()) // ✅ Now `totalApplications` is set
            .toList();

        return DataSuccess(entities);
      } else {
        return DataFailed(
          DioException(
            requestOptions: RequestOptions(path: Urls.totalJobPost),
            message: response.response.statusMessage ?? 'Failed to load jobs',
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: Urls.totalJobPost),
          message: 'Unexpected error: $e',
        ),
      );
    }
  }
}