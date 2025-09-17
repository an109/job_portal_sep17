import 'package:job_portal/utils/usecase/usecases.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/repository/change_password_repository.dart';

class ChangePasswordUsecase
    implements UseCase<DataState<String>, Map<String, dynamic>> {
  final ChangePasswordRepository _repository;

  ChangePasswordUsecase(this._repository);

  @override
  Future<DataState<String>> call({Map<String, dynamic>? params}) async {
    return _repository.changePassword(
      oldPassword: params!['oldPassword'],
      newPassword: params!['newPassword'],
    );
  }
}