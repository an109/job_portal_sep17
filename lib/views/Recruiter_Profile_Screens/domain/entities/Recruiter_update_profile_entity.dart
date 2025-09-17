import 'package:equatable/equatable.dart';

class RecruiterUpdateProfileEntity extends Equatable {
  final int? designationId;
  final String? companyName;
  final int? industryId;
  final int? companyLocationId;
  final String? about;
  final String? logoUrl;
  final String? profilePic;
  final String? hiringPreferences;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final bool? isGstVerified;
  final List<int>? languageIds;

  const RecruiterUpdateProfileEntity({
    this.designationId,
    this.companyName,
    this.industryId,
    this.companyLocationId,
    this.about,
    this.logoUrl,
    this.profilePic,
    this.hiringPreferences,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.isGstVerified,
    this.languageIds,
  });

  @override
  List<Object?> get props => [
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
}