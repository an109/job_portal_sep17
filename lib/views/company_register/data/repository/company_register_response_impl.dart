import 'package:dio/dio.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/company_register_entity.dart';
import '../../domain/repository/company_register_repository.dart';
import '../data_sources/company_register_api_service.dart';

class CompanyRegisterRepositoryImpl implements CompanyRegisterRepository {
  final CompanyRegisterApiService _apiService;

  CompanyRegisterRepositoryImpl(this._apiService);

  @override
  Future<DataState<CompanyRegisterEntity>> registerCompany(CompanyRegisterEntity entity) async {
    try {
      final response = await _apiService.registerCompany(entity.toJson());

      if (response.success) {
        return DataSuccess<CompanyRegisterEntity>(entity);
      } else {
        return DataFailed<CompanyRegisterEntity>(
          DioException(
            error: response.message,
            requestOptions: RequestOptions(path: Urls.registerCompany),
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed<CompanyRegisterEntity>(e);
    } catch (e) {
      return DataFailed<CompanyRegisterEntity>(
        DioException(
          error: e,
          requestOptions: RequestOptions(path: Urls.registerCompany),
        ),
      );
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> getMasterData() async {
    try {
      final response = await _apiService.getMasterAllData();

      if (response.success) {
        return DataSuccess<Map<String, dynamic>>(response.data!);
      } else {
        return DataFailed<Map<String, dynamic>>(
          DioException(
            error: response.message,
            requestOptions: RequestOptions(path: Urls.getMasterAllData),
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed<Map<String, dynamic>>(e);
    } catch (e) {
      return DataFailed<Map<String, dynamic>>(
        DioException(
          error: e,
          requestOptions: RequestOptions(path: Urls.getMasterAllData),
        ),
      );
    }
  }
}