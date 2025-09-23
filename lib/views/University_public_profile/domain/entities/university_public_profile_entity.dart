import 'package:equatable/equatable.dart';

class UniversityPublicProfileEntity extends Equatable {
  final int? id;
  final String? universityLogoUrl;
  final String? pincode;
  final String? profilePic;
  final String? collegeName;
  final String? address;
  final String? websiteLink;
  final String? about;
  final String? socialMediaLink;
  final UserEntity? user; // Use UserEntity (domain)
  final List<CourseEntity>? courses;
  final List<dynamic>? activity;

  UniversityPublicProfileEntity({
    this.id,
    this.universityLogoUrl,
    this.pincode,
    this.profilePic,
    this.collegeName,
    this.address,
    this.websiteLink,
    this.about,
    this.socialMediaLink,
    this.user,
    this.courses,
    this.activity,
  });

  @override
  List<Object?> get props => [
    id,
    universityLogoUrl,
    pincode,
    profilePic,
    collegeName,
    address,
    websiteLink,
    about,
    socialMediaLink,
    user,
    courses,
    activity,
  ];

  factory UniversityPublicProfileEntity.fromJson(Map<String, dynamic> json) {
    return UniversityPublicProfileEntity(
      id: json['id'] as int?,
      universityLogoUrl: json['university_logo_url'] as String?,
      pincode: json['pincode'] as String?,
      profilePic: json['profile_pic'] as String?,
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      websiteLink: json['website_link'] as String?,
      about: json['about'] as String?,
      socialMediaLink: json['social_media_link'] as String?,
      user: json['User'] != null ? UserEntity.fromJson(json['User'] as Map<String, dynamic>) : null,
      courses: (json['courses'] as List?)?.map((e) => CourseEntity.fromJson(e as Map<String, dynamic>)).toList(),
      activity: json['activity'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_logo_url': universityLogoUrl,
      'pincode': pincode,
      'profile_pic': profilePic,
      'college_name': collegeName,
      'address': address,
      'website_link': websiteLink,
      'about': about,
      'social_media_link': socialMediaLink,
      'User': user?.toJson(),
      'courses': courses?.map((e) => e.toJson()).toList(),
      'activity': activity,
    };
  }
}

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? userRole;

  UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userRole,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phone, userRole];

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      userRole: json['user_role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'user_role': userRole,
    };
  }
}

class CourseEntity extends Equatable {
  final int? id;
  final String? name;

  CourseEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];

  factory CourseEntity.fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}