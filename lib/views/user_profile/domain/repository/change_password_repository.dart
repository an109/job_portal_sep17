import '../../../../utils/resourses/data_state.dart';

abstract class ChangePasswordRepository {
  Future<DataState<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}