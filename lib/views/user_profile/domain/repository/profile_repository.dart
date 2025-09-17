import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/user_profile/data/models/public_profile_model.dart';
import 'package:job_portal/views/user_profile/domain/entities/all_job_applications_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/raise_ticket_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/terms_and_conditions_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_email_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';

abstract class ProfileRepository {
  Future<DataState<UserProfileModel>> getPublicProfile(String id);

  Future<DataState<UserDetailEntity>> getUserDetails(String id);

  Future<DataState<TermsAndConditionEntity>> getTermsAndConditions();

  Future<DataState<UpdateUserProfileEntity>> updateUserDetailsById(
      String id, Map<String, dynamic> params);

  Future<DataState<UpdateUserEmailEntity>> changeUserEmail(
      Map<String, dynamic> params);

  Future<DataState<AllJobApplicationsEntity>> getJobApplications();

  Future<DataState<FollowersEntity>> getFollowers(String id);

  Future<DataState<FollowingEntity>> getFollowings(String id);

  Future<DataState<RaiseTicketResponseEntity>> raiseTicket(
      Map<String, dynamic> params);

}
