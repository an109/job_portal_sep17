import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/company_register_response_model.dart';

part 'company_register_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class CompanyRegisterApiService {
  factory CompanyRegisterApiService(Dio dio, {String? baseUrl}) = _CompanyRegisterApiService;

  @POST(Urls.registerCompany)
  Future<CompanyRegisterResponseModel> registerCompany(@Body() Map<String, dynamic> body);

  @GET(Urls.getMasterAllData)
  Future<CompanyRegisterResponseModel> getMasterAllData();
}