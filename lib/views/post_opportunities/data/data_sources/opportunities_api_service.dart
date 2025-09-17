import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/post_opportunities/data/models/internship_metadata_response.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'opportunities_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class OpportunitiesApiService {
  factory OpportunitiesApiService(Dio dio, {String? baseUrl}) =
  _OpportunitiesApiService;

  @GET(Urls.getInternshipFormMetadata)
  Future<HttpResponse<InternshipMetadataResponseModel>>
  getOpportunityFormMetadata();

  @POST(Urls.createJobPost)
  Future<HttpResponse<InternshipMetadataResponseModel>> createJobPost(
      @Body() Map<String, dynamic> params);

  @GET(Urls.getMasterAllData)
  Future<HttpResponse<dynamic>> getMasterAllData();
}
