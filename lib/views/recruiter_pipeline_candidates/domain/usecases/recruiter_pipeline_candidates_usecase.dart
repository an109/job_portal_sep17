import 'package:job_portal/views/recruiter_pipeline_candidates/domain/repository/recruiter_pipeline_candidates_repository.dart';

import '../../data/models/recruiter_pipeline_candidates_response_model.dart';

class RecruiterPipelineCandidatesUseCase {
  final RecruiterPipelineCandidatesRepository _repository;

  RecruiterPipelineCandidatesUseCase(this._repository);

  Future<PipelineCandidateResponseModel> call() async {
    return await _repository.getPipelineCandidates();
  }
}