// university_profile_response.dart
import 'package:equatable/equatable.dart';

class UniversityProfileResponse extends Equatable {
  final String? collegeName;
  final String? address;
  final String? pincode;
  final String? websiteLink;
  final String? about;
  final String? profilePic;
  final String? universityLogoUrl;
  final String? socialMediaLink;
  final bool? emailIdVerified;
  final bool? aadharVerified;
  final bool? phoneVerified;
  final String? phone;
  final String? email;
  final List<int>? courseIds;

  const UniversityProfileResponse({
    this.collegeName,
    this.address,
    this.pincode,
    this.websiteLink,
    this.about,
    this.profilePic,
    this.universityLogoUrl,
    this.socialMediaLink,
    this.emailIdVerified,
    this.aadharVerified,
    this.phoneVerified,
    this.phone,
    this.email,
    this.courseIds,
  });

  @override
  List<Object?> get props => [
    collegeName,
    address,
    pincode,
    websiteLink,
    about,
    profilePic,
    universityLogoUrl,
    socialMediaLink,
    emailIdVerified,
    aadharVerified,
    phoneVerified,
    phone,
    email,
    courseIds,
  ];

  factory UniversityProfileResponse.fromJson(Map<String, dynamic> json) {
    return UniversityProfileResponse(
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      pincode: json['pincode'] as String?,
      websiteLink: json['website_link'] as String?,
      about: json['about'] as String?,
      profilePic: json['profile_pic'] as String?,
      universityLogoUrl: json['university_logo_url'] as String?,
      socialMediaLink: json['social_media_link'] as String?,
      emailIdVerified: json['email_id_verified'] as bool?,
      aadharVerified: json['aadhar_verified'] as bool?, // Correct key
      phoneVerified: json['phone_verified'] as bool?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      courseIds: json['course_ids'] != null
          ? List<int>.from(json['course_ids'] as List)
          : null, // Plural key
    );
  }
}