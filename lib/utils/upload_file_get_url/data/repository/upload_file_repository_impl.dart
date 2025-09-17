import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/upload_file_get_url/data/data_source/upload_file_api_service.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/entities/upload_file_entity.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/repository/upload_file_repository.dart';

class UploadFileRepositoryImpl extends UploadFileRepository {
  final UploadFileApiService _apiService;

  UploadFileRepositoryImpl(this._apiService);

  @override
  Future<DataState<UploadFileEntity>> uploadFileGetUrl(FormData data) async {
    try {
      final res = await _apiService.uploadFileGetUrl(data);
      if (res.response.statusCode == HttpStatus.ok) {
        developer.log('.checkk response in repository : ${res.data}');
        return DataSuccess(res.data);
      } else {
        developer.log('..checkk response in repository : ${res.data}');
        return DataFailed(DioException(
            error: res.response.statusMessage,
            response: res.response,
            type: DioExceptionType.badResponse,
            requestOptions: res.response.requestOptions));
      }
    } on DioException catch (e) {
      final error = e.type;
      developer.log('....checkk  : $error');
      return DataFailed(e);
    }
  }
}
