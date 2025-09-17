import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import '../../../../injection_container.dart';
import '../../../../utils/constants/urls.dart';
import '../../data/data_sources/recruiter_full_view_application_api_service.dart';
import '../../domain/entities/recruiter_full_view_application_entity.dart';
import '../../domain/repository/recruiter_full_view_application_repository.dart';
// import '../../models/recruiter_full_view_application_response_model.dart';

class RecruiterFullViewApplicationRepositoryImpl implements RecruiterFullViewApplicationRepository {
  final RecruiterFullViewApplicationApiService _apiService;

  RecruiterFullViewApplicationRepositoryImpl(this._apiService);

  @override
  Future<DataState<FullApplicantEntity>> getFullApplicantDetails(int jobId, int applicantId) async {
    try {

      final response = await _apiService.getFullApplicantDetails(jobId, applicantId);


      if (response.response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data == null) {
          return DataFailed(
            DioException(
              requestOptions: RequestOptions(path: Urls.getFullApplicantDetails),
              message: 'Applicant data is missing',
            ),
          );
        }


        final entity = FullApplicantEntity(
          applicationId: data.applicationId,
          userId: data.userId,
          jobId: data.jobId,
          status: data.status,
          // applicantName: data.applicantName,
          applicationDetails: data.applicationDetails,
          applicantName: '',
        );

        return DataSuccess(entity);
      } else {

        return DataFailed(
          DioException(
            requestOptions: RequestOptions(path: Urls.getFullApplicantDetails),
            message: response.response.statusMessage ?? 'Failed to load applicant details',
          ),
        );
      }
    } on DioException catch (e) {
      print("DioException in getFullApplicantDetails: ${e.message}");
      return DataFailed(e);
    } catch (e) {
      print("Unexpected error in getFullApplicantDetails: $e");
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: Urls.getFullApplicantDetails),
          message: 'Unexpected error: $e',
        ),
      );
    }
  }
}