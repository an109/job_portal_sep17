import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/usecase/usecases.dart';
import 'package:job_portal/views/user_profile/data/models/public_profile_model.dart';
import 'package:job_portal/views/user_profile/data/models/user_details_response.dart';
import 'package:job_portal/views/user_profile/domain/entities/all_job_applications_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/raise_ticket_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/terms_and_conditions_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_email_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/domain/repository/profile_repository.dart';

class ProfileUsecase
    implements UseCase<DataState<UserProfileModel>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  ProfileUsecase(this._repository);

  @override
  Future<DataState<UserProfileModel>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getPublicProfile(params!['id']);
  }
}

class UserDetailUsecase
    implements UseCase<DataState<UserDetailEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  UserDetailUsecase(this._repository);

  @override
  Future<DataState<UserDetailEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getUserDetails(params!['id']);
  }
}

class TermsAndConditionsUsecase
    implements
        UseCase<DataState<TermsAndConditionEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  TermsAndConditionsUsecase(this._repository);

  @override
  Future<DataState<TermsAndConditionEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getTermsAndConditions();
  }
}

class UpdateUserProfileUsecase
    implements
        UseCase<DataState<UpdateUserProfileEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  UpdateUserProfileUsecase(this._repository);

  @override
  Future<DataState<UpdateUserProfileEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.updateUserDetailsById(params!['id'], params['params']);
  }
}

class UpdateUserEmailUsecase
    implements UseCase<DataState<UpdateUserEmailEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  UpdateUserEmailUsecase(this._repository);

  @override
  Future<DataState<UpdateUserEmailEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.changeUserEmail(params!);
  }
}

class AllJobApplicationsUsecase
    implements
        UseCase<DataState<AllJobApplicationsEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  AllJobApplicationsUsecase(this._repository);

  @override
  Future<DataState<AllJobApplicationsEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getJobApplications();
  }
}

class GetFollowersUsecase
    implements UseCase<DataState<FollowersEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  GetFollowersUsecase(this._repository);

  @override
  Future<DataState<FollowersEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getFollowers(params!['id']);
  }
}

class GetFollowingUsecase
    implements UseCase<DataState<FollowingEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  GetFollowingUsecase(this._repository);

  @override
  Future<DataState<FollowingEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.getFollowings(params!['id']);
  }
}

class RaiseTicketUsecase
    implements
        UseCase<DataState<RaiseTicketResponseEntity>, Map<String, dynamic>> {
  final ProfileRepository _repository;
  RaiseTicketUsecase(this._repository);

  @override
  Future<DataState<RaiseTicketResponseEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.raiseTicket(params!);
  }
}
