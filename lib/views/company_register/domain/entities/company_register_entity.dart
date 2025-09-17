class CompanyRegisterEntity {
  final String? designation;
  final String? companyName;
  final String? industry;
  final String? location;
  final String? about;
  final String? logoUrl;
  final String? profilePic;
  final Map<String, dynamic>? hiringPreferences;
  final List<String> languagesKnown;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isGstVerified;

  const CompanyRegisterEntity({
    this.designation,
    this.companyName,
    this.industry,
    this.location,
    this.about,
    this.logoUrl,
    this.profilePic,
    this.hiringPreferences,
    this.languagesKnown = const [],
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isGstVerified = false,
  });

  Map<String, dynamic> toJson() => {
    'designation': designation,
    'companyName': companyName,
    'industry': industry,
    'location': location,
    'about': about,
    'logoUrl': logoUrl,
    'profilePic': profilePic,
    'hiringPreferences': hiringPreferences,
    'languagesKnown': languagesKnown,
    'isEmailVerified': isEmailVerified,
    'isPhoneVerified': isPhoneVerified,
    'isGstVerified': isGstVerified,
  };
}