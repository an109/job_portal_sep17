import 'package:equatable/equatable.dart';

class UniversityRegistrationEntity extends Equatable {
  final String collegeName;
  final int? id;
  final List<int> courseIds;
  final String profilePic;
  final String universityLogoUrl;
  final String address;
  final String pincode;
  final String websiteLink;
  final String about;
  final String socialMediaLink;

  const UniversityRegistrationEntity({
    required this.collegeName,
    this.id,
    required this.courseIds,
    required this.profilePic,
    required this.universityLogoUrl,
    required this.address,
    required this.pincode,
    required this.websiteLink,
    required this.about,
    required this.socialMediaLink,
  });

  factory UniversityRegistrationEntity.fromJson(Map<String, dynamic> json) {
    return UniversityRegistrationEntity(
      collegeName: json['college_name'] ?? '',
      id: json['id'] as int?,
      courseIds: List<int>.from(json['course_ids'] ?? []),
      profilePic: json['profile_pic'] ?? '',
      universityLogoUrl: json['university_logo_url'] ?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? '',
      websiteLink: json['website_link'] ?? '',
      about: json['about'] ?? '',
      socialMediaLink: json['social_media_link'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    collegeName,
    courseIds,
    profilePic,
    universityLogoUrl,
    address,
    pincode,
    websiteLink,
    about,
    socialMediaLink,
  ];

  Map<String, dynamic> toJson() {
    return {
      'college_name': collegeName,
      'course_id': courseIds,
      'profile_pic': profilePic,
      'university_logo_url': universityLogoUrl,
      'address': address,
      'pincode': pincode,
      'website_link': websiteLink,
      'about': about,
      'social_media_link': socialMediaLink,
    };
  }
}