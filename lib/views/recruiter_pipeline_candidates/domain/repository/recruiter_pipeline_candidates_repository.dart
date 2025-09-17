import '../../data/models/recruiter_pipeline_candidates_response_model.dart';

abstract class RecruiterPipelineCandidatesRepository {
  Future<PipelineCandidateResponseModel> getPipelineCandidates();
}