import 'package:job_portal/views/recruiter_pipeline_candidates/domain/repository/recruiter_pipeline_candidates_repository.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/data/data_source/recruiter_pipeline_candidates_api_service.dart';

import '../models/recruiter_pipeline_candidates_response_model.dart';

class RecruiterPipelineCandidatesRepositoryImpl implements RecruiterPipelineCandidatesRepository {
  final RecruiterPipelineCandidatesApiService _apiService;

  RecruiterPipelineCandidatesRepositoryImpl(this._apiService);

  @override
  Future<PipelineCandidateResponseModel> getPipelineCandidates() async {
    final response = await _apiService.getPipelineCandidates();
    return response;
  }
}