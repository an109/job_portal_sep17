import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/entities/upload_file_entity.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/repository/upload_file_repository.dart';
import 'package:job_portal/utils/usecase/usecases.dart';

class UploadFileUsecase
    implements UseCase<DataState<UploadFileEntity>, Map<String, dynamic>> {
  final UploadFileRepository _repository;
  UploadFileUsecase(this._repository);

  @override
  Future<DataState<UploadFileEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.uploadFileGetUrl(params!['formdata']);
  }
}
