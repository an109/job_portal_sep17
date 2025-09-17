// company_profile_models.dart

class CompanyProfileRequest {
  final int designationId;
  final String companyName;
  final int industryId;
  final int companyLocationId;
  final String about;
  final String logoUrl;
  final String profilePic;
  final String? hiringPreferences;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isGstVerified;
  final List<int> languageIds;

  CompanyProfileRequest({
    required this.designationId,
    required this.companyName,
    required this.industryId,
    required this.companyLocationId,
    required this.about,
    required this.logoUrl,
    required this.profilePic,
    this.hiringPreferences,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isGstVerified,
    required this.languageIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "designation_id": designationId,
      "company_name": companyName,
      "industry_id": industryId,
      "company_location_id": companyLocationId,
      "about": about,
      "logo_url": logoUrl,
      "profile_pic": profilePic,
      "hiring_preferences": hiringPreferences ?? "",
      "is_email_verified": isEmailVerified,
      "is_phone_verified": isPhoneVerified,
      "is_gst_verified": isGstVerified,
      "language_ids": languageIds,
    };
  }
}


class CompanyProfileResponse {
  final String message;
  final CompanyProfile profile;

  CompanyProfileResponse({required this.message, required this.profile});

  factory CompanyProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompanyProfileResponse(
      message: json["message"],
      profile: CompanyProfile.fromJson(json["profile"]),
    );
  }
}

class CompanyProfile {
  final int id;
  final int userId;
  final int designationId;
  final String companyName;
  final int industryId;
  final int companyLocationId;
  final String about;
  final String logoUrl;
  final String profilePicUrl;
  final String? hiringPreferences;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isGstVerified;

  CompanyProfile({
    required this.id,
    required this.userId,
    required this.designationId,
    required this.companyName,
    required this.industryId,
    required this.companyLocationId,
    required this.about,
    required this.logoUrl,
    required this.profilePicUrl,
    this.hiringPreferences,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isGstVerified,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json["id"],
      userId: json["user_id"],
      designationId: json["designation_id"],
      companyName: json["company_name"],
      industryId: json["industry_id"],
      companyLocationId: json["company_location_id"],
      about: json["about"],
      logoUrl: json["logo_url"],
      profilePicUrl: json["profile_picUrl"],
      hiringPreferences: json["hiring_preferences"],
      isEmailVerified: json["is_email_verified"],
      isPhoneVerified: json["is_phone_verified"],
      isGstVerified: json["is_gst_verified"],
    );
  }
}
