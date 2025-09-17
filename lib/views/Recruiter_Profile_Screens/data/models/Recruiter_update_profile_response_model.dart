import 'package:equatable/equatable.dart';

class RecruiterUpdateProfileResponse extends Equatable {
  final String message;
  final ProfileData profile;

  const RecruiterUpdateProfileResponse({
    required this.message,
    required this.profile,
  });

  @override
  List<Object?> get props => [message, profile];

  factory RecruiterUpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return RecruiterUpdateProfileResponse(
      message: json['message'] as String,
      profile: ProfileData.fromJson(json['profile'] as Map<String, dynamic>),
    );
  }
}

class ProfileData extends Equatable {
  final int id;
  final int userId;
  final int designationId;
  final String companyName;
  final int industryId;
  final int companyLocationId;
  final String about;
  final String logoUrl;
  final String profilePic;
  final String hiringPreferences;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isGstVerified;
  final List<int> languageIds;

  const ProfileData({
    required this.id,
    required this.userId,
    required this.designationId,
    required this.companyName,
    required this.industryId,
    required this.companyLocationId,
    required this.about,
    required this.logoUrl,
    required this.profilePic,
    required this.hiringPreferences,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isGstVerified,
    required this.languageIds,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    designationId,
    companyName,
    industryId,
    companyLocationId,
    about,
    logoUrl,
    profilePic,
    hiringPreferences,
    isEmailVerified,
    isPhoneVerified,
    isGstVerified,
    languageIds,
  ];

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      designationId: json['designation_id'] as int,
      companyName: json['company_name'] as String,
      industryId: json['industry_id'] as int,
      companyLocationId: json['company_location_id'] as int,
      about: json['about'] as String,
      logoUrl: json['logo_url'] as String,
      profilePic: json['profile_pic'] as String,
      hiringPreferences: json['hiring_preferences'] as String,
      isEmailVerified: json['is_email_verified'] as bool,
      isPhoneVerified: json['is_phone_verified'] as bool,
      isGstVerified: json['is_gst_verified'] as bool,
      languageIds: (json['language_ids'] as List).map((e) => e as int).toList(),
    );
  }
}