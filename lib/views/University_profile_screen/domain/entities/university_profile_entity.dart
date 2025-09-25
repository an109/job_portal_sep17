// university_profile_entity.dart
import 'package:equatable/equatable.dart';

class UniversityProfileEntity extends Equatable {
  final String? collegeName;
  // final int? userId;
  final String? address;
  final String? pincode;
  final String? websiteLink;
  final String? about;
  final String? profilePic;
  final String? universityLogoUrl;
  final String? socialMediaLink;
  final bool? emailIdVerified;
  final bool? aadharVerified; // Fixed spelling: "aadhar"
  final bool? phoneVerified;
  final String? phone;
  final String? email;
  final List<int>? courseIds;

  const UniversityProfileEntity({
    this.collegeName,
    // this.userId,
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

  Map<String, dynamic> toJson() {
    return {
      'college_name': collegeName,
      // 'user_id': userId,
      'address': address,
      'pincode': pincode,
      'website_link': websiteLink,
      'about': about,
      'profile_pic': profilePic,
      'university_logo_url': universityLogoUrl,
      'social_media_link': socialMediaLink,
      'email_id_verified': emailIdVerified,
      'aadhar_verified': aadharVerified, // Correct key
      'phone_verified': phoneVerified,
      'phone': phone,
      'email': email,
      'course_ids': courseIds, // Plural key
    };
  }
}