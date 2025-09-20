import 'package:equatable/equatable.dart';

class UniversityProfileEntity extends Equatable {
  final String collegeName;
  final String address;
  final String pincode;
  final String websiteLink;
  final String about;
  final String profilePic;
  final String universityLogoUrl;
  final String socialMediaLink;
  final bool emailIdVerified;
  final bool adharVerified;
  final bool phoneVerified;
  final String phone;
  final String email;
  final List<int> courseIds;

  const UniversityProfileEntity({
    required this.collegeName,
    required this.address,
    required this.pincode,
    required this.websiteLink,
    required this.about,
    required this.profilePic,
    required this.universityLogoUrl,
    required this.socialMediaLink,
    required this.emailIdVerified,
    required this.adharVerified,
    required this.phoneVerified,
    required this.phone,
    required this.email,
    required this.courseIds,
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
    adharVerified,
    phoneVerified,
    phone,
    email,
    courseIds,
  ];
  Map<String, dynamic> toJson() {
    return {
      'college_name': collegeName,
      'address': address,
      'pincode': pincode,
      'website_link': websiteLink,
      'about': about,
      'profile_pic': profilePic,
      'university_logo_url': universityLogoUrl,
      'social_media_link': socialMediaLink,
      'email_id_verified': emailIdVerified,
      'aadhar_verified': adharVerified,
      'phone_verified': phoneVerified,
      'phone': phone,
      'email': email,
      'course_ids': courseIds,
    };
  }
}