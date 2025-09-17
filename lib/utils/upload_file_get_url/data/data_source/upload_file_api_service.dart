import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/utils/upload_file_get_url/data/models/upload_file_model.dart';
import 'package:retrofit/retrofit.dart';

part 'upload_file_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UploadFileApiService {
  factory UploadFileApiService(Dio dio, {String? baseUrl}) =
      _UploadFileApiService;

  @POST(Urls.uploadFileGetUrl)
  @MultiPart()
  Future<HttpResponse<UploadFileModel>> uploadFileGetUrl(@Body() FormData data);
}
