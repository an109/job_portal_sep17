import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../utils/constants/urls.dart';
import '../models/recruiter_pipeline_candidates_response_model.dart';

part 'recruiter_pipeline_candidates_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterPipelineCandidatesApiService {
  factory RecruiterPipelineCandidatesApiService(Dio dio, {String? baseUrl}) = _RecruiterPipelineCandidatesApiService;

  @GET(Urls.getPipelineCandidates)
  Future<PipelineCandidateResponseModel> getPipelineCandidates();
}