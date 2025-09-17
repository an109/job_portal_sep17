import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/entities/upload_file_entity.dart';

abstract class UploadFileRepository {
  Future<DataState<UploadFileEntity>> uploadFileGetUrl(FormData data);
}
