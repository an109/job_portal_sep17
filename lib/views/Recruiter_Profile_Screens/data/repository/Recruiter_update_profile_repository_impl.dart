import 'package:dio/dio.dart';

import '../../domain/entities/Recruiter_update_profile_entity.dart';
import '../../domain/repository/Recruiter_update_profile_repository.dart';
import '../data_sources/Recruiter_update_profile_api_service.dart';
import '../models/Recruiter_update_profile_response_model.dart';


class RecruiterUpdateProfileRepositoryImpl implements RecruiterUpdateProfileRepository {
  final RecruiterUpdateProfileApiService _apiService;

  RecruiterUpdateProfileRepositoryImpl(this._apiService);

  @override
  Future<RecruiterUpdateProfileResponse> updateProfile(RecruiterUpdateProfileEntity entity) async {
    final body = <String, dynamic>{
      if (entity.designationId != null) 'designation_id': entity.designationId,
      if (entity.companyName != null) 'company_name': entity.companyName,
      if (entity.industryId != null) 'industry_id': entity.industryId,
      if (entity.companyLocationId != null) 'company_location_id': entity.companyLocationId,
      if (entity.about != null) 'about': entity.about,
      if (entity.logoUrl != null) 'logo_url': entity.logoUrl,
      if (entity.profilePic != null) 'profile_pic': entity.profilePic,
      if (entity.hiringPreferences != null) 'hiring_preferences': entity.hiringPreferences,
      if (entity.isEmailVerified != null) 'is_email_verified': entity.isEmailVerified,
      if (entity.isPhoneVerified != null) 'is_phone_verified': entity.isPhoneVerified,
      if (entity.isGstVerified != null) 'is_gst_verified': entity.isGstVerified,
      if (entity.languageIds != null) 'language_ids': entity.languageIds,
    };

    try {
      final response = await _apiService.updateProfile(body);
      return response;
    } on DioError catch (e) {
      throw Exception("Failed to update profile: ${e.response?.data ?? e.message}");
    }
  }
}